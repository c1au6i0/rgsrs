# gsrs_chem_info: Retrieve chemical structure info by name or CAS number

#' Retrieve chemical structure information by substance name or CAS number
#'
#' A convenience wrapper that resolves one or more substance identifiers to
#' GSRS UNIIs and then fetches the embedded chemical structure data for each
#' substance. The result is one wide row per input identifier containing both
#' the resolved metadata and the full structure record.
#'
#' @param identifiers Character vector of substance identifiers.
#' @param type Character scalar. The identifier type. One of:
#'   \describe{
#'     \item{`"name"`}{Common or systematic substance name (default).}
#'     \item{`"cas"`}{CAS Registry Number (e.g., `"50-78-2"`).}
#'     \item{`"unii"`}{FDA UNII / approval ID (e.g., `"R16CO5Y76E"`). Skips
#'       the search step and fetches the structure directly.}
#'     \item{`"inchikey"`}{Standard InChIKey (e.g.,
#'       `"BSYNRYMUTXBXSQ-UHFFFAOYSA-N"`).}
#'     \item{`"smiles"`}{SMILES string. Uses an exact structure search to
#'       resolve to a UNII before fetching the structure record.}
#'   }
#' @param verbose Logical. If `TRUE`, emit progress messages. Default `TRUE`.
#' @param delay Numeric. Seconds to wait between individual API calls.
#'   Default `0.5`.
#'
#' @return A data frame with one row per input identifier and columns:
#'   \describe{
#'     \item{query}{The identifier supplied by the caller.}
#'     \item{type}{The identifier type (`"name"` or `"cas"`).}
#'     \item{unii}{Resolved UNII / approval ID.}
#'     \item{preferred_name}{Preferred display name in GSRS.}
#'     \item{substance_class}{Substance class (e.g., `"chemical"`).}
#'     \item{smiles}{Canonical SMILES string.}
#'     \item{formula}{Molecular formula (e.g., `"C9H8O4"`).}
#'     \item{mwt}{Molecular weight (numeric).}
#'     \item{inchi_key}{Standard InChIKey.}
#'     \item{inchi}{Full InChI string.}
#'     \item{stereochemistry}{Stereochemistry descriptor.}
#'     \item{optical_activity}{Optical activity descriptor.}
#'     \item{charge}{Formal charge (integer).}
#'     \item{stereo_centers}{Number of stereocenters.}
#'     \item{defined_stereo}{Number of defined stereocenters.}
#'     \item{ez_centers}{Number of E/Z double-bond stereocenters.}
#'     \item{molfile}{MDL molfile as a string.}
#'     \item{date_retrieved}{Date the structure response was received.}
#'   }
#'   Unresolved identifiers or non-chemical substances produce a row of `NA`s
#'   with `query` and `type` set. Returns `NULL` on error (with a warning).
#'
#' @seealso [gsrs_structure()], [gsrs_unii_from_name()], [gsrs_codes()],
#'   [gsrs_structure_search()]
#' @export
#' @examples
#' \donttest{
#'   Sys.sleep(2)
#'   out <- gsrs_chem_info(c("aspirin", "ibuprofen"), type = "name")
#'   if (!is.null(out)) print(out[, c("query", "unii", "formula", "mwt")])
#'
#'   Sys.sleep(2)
#'   out_cas <- gsrs_chem_info(c("50-78-2", "15687-27-1"), type = "cas")
#'   if (!is.null(out_cas)) print(out_cas[, c("query", "unii", "formula", "mwt")])
#'
#'   Sys.sleep(2)
#'   out_unii <- gsrs_chem_info("R16CO5Y76E", type = "unii")
#'   if (!is.null(out_unii)) print(out_unii[, c("query", "formula", "mwt")])
#'
#'   Sys.sleep(2)
#'   out_ik <- gsrs_chem_info("BSYNRYMUTXBXSQ-UHFFFAOYSA-N", type = "inchikey")
#'   if (!is.null(out_ik)) print(out_ik[, c("query", "unii", "formula")])
#'
#'   Sys.sleep(2)
#'   out_smi <- gsrs_chem_info("CC(=O)Oc1ccccc1C(=O)O", type = "smiles")
#'   if (!is.null(out_smi)) print(out_smi[, c("query", "unii", "formula")])
#' }
gsrs_chem_info <- function(identifiers,
                            type = c("name", "cas", "unii", "inchikey", "smiles"),
                            verbose = TRUE,
                            delay = 0.5) {
  with_graceful_exit(
    gsrs_chem_info_out,
    identifiers = identifiers,
    type = type,
    verbose = verbose,
    delay = delay,
    what = "GSRS chemical info lookup"
  )
}

#' @keywords internal
#' @noRd
gsrs_chem_info_out <- function(identifiers,
                                type = c("name", "cas", "unii", "inchikey", "smiles"),
                                verbose = TRUE,
                                delay = 0.5) {
  check_internet(verbose = FALSE)
  identifiers <- check_ids(identifiers, "identifiers")
  type <- match.arg(type)

  base <- gsrs_base_url()

  # ---- Step 1: resolve identifiers to UNIIs ----------------------------------

  resolved <- lapply(seq_along(identifiers), function(i) {
    id <- identifiers[[i]]

    if (i > 1L) Sys.sleep(delay)

    # UNII: skip search entirely — structure fetch handles it directly
    if (type == "unii") {
      if (isTRUE(verbose)) {
        cli::cli_alert_info("Using UNII directly: {.field {id}} ...")
      }
      return(data.frame(
        query           = id,
        type            = type,
        unii            = id,
        preferred_name  = NA_character_,
        substance_class = NA_character_,
        stringsAsFactors = FALSE
      ))
    }

    # Build the search query string for text-based lookups
    if (type == "name") {
      if (isTRUE(verbose)) cli::cli_alert_info("Resolving name: {.field {id}} ...")
      q_str <- paste0("root_names_name:\"", id, "\"")

    } else if (type == "cas") {
      if (isTRUE(verbose)) cli::cli_alert_info("Resolving CAS: {.field {id}} ...")
      q_str <- paste0(
        "root_codes_code:\"", id, "\"",
        " AND root_codes_codeSystem:CAS"
      )

    } else if (type == "inchikey") {
      if (isTRUE(verbose)) cli::cli_alert_info("Resolving InChIKey: {.field {id}} ...")

      # InChIKey is not a Lucene-indexed field; use quoted free-text search and
      # pull the exact match from the `exactMatches` array in the response body.
      resp <- httr2::request(base) |>
        httr2::req_url_path_append("substances/search") |>
        httr2::req_url_query(q = paste0("\"", id, "\""), top = 1L) |>
        httr2::req_retry(max_tries = 5L, backoff = httr2_backoff) |>
        httr2::req_perform()

      check_status_code(resp, verbose = FALSE)
      body <- httr2::resp_body_json(resp, simplifyVector = FALSE)

      # Prefer exactMatches; fall back to first content hit
      exact <- body[["exactMatches"]]
      if (!is.null(exact) && length(exact) > 0L) {
        hit <- exact[[1L]]
      } else {
        content <- body[["content"]]
        if (is.null(content) || length(content) == 0L) {
          return(data.frame(
            query = id, type = type,
            unii = NA_character_, preferred_name = NA_character_,
            substance_class = NA_character_, stringsAsFactors = FALSE
          ))
        }
        hit <- content[[1L]]
      }

      return(data.frame(
        query           = id,
        type            = type,
        unii            = hit[["approvalID"]] %||% NA_character_,
        preferred_name  = hit[["_name"]]      %||% NA_character_,
        substance_class = hit[["substanceClass"]] %||% NA_character_,
        stringsAsFactors = FALSE
      ))

    } else if (type == "smiles") {
      if (isTRUE(verbose)) cli::cli_alert_info("Resolving SMILES (exact): {.field {id}} ...")

      # Use the dedicated structureSearch endpoint for SMILES exact match
      resp <- httr2::request(base) |>
        httr2::req_url_path_append("substances/structureSearch") |>
        httr2::req_url_query(q = id, type = "exact", sync = "true", top = 1L) |>
        httr2::req_retry(max_tries = 5L, backoff = httr2_backoff) |>
        httr2::req_perform()

      check_status_code(resp, verbose = FALSE)
      chunk <- parse_substances_response(resp)

      if (nrow(chunk) == 0L) {
        return(data.frame(
          query = id, type = type,
          unii = NA_character_, preferred_name = NA_character_,
          substance_class = NA_character_, stringsAsFactors = FALSE
        ))
      }
      return(data.frame(
        query           = id,
        type            = type,
        unii            = chunk[["approval_id"]][[1L]],
        preferred_name  = chunk[["preferred_name"]][[1L]],
        substance_class = chunk[["substance_class"]][[1L]],
        stringsAsFactors = FALSE
      ))
    }

    # Text-based search (name, cas) — inchikey and smiles have already returned above
    resp <- httr2::request(base) |>
      httr2::req_url_path_append("substances/search") |>
      httr2::req_url_query(q = q_str, top = 1L) |>
      httr2::req_retry(max_tries = 5L, backoff = httr2_backoff) |>
      httr2::req_perform()

    check_status_code(resp, verbose = FALSE)
    chunk <- parse_substances_response(resp)

    if (nrow(chunk) == 0L) {
      return(data.frame(
        query = id, type = type,
        unii = NA_character_, preferred_name = NA_character_,
        substance_class = NA_character_, stringsAsFactors = FALSE
      ))
    }

    data.frame(
      query           = id,
      type            = type,
      unii            = chunk[["approval_id"]][[1L]],
      preferred_name  = chunk[["preferred_name"]][[1L]],
      substance_class = chunk[["substance_class"]][[1L]],
      stringsAsFactors = FALSE
    )
  })

  meta <- do.call(rbind, resolved)

  # ---- Step 2: fetch structure for each resolved UNII ------------------------

  structure_rows <- lapply(seq_len(nrow(meta)), function(i) {
    uid <- meta[["unii"]][[i]]
    qry <- meta[["query"]][[i]]

    if (i > 1L) Sys.sleep(delay)

    if (is.na(uid)) {
      return(empty_structure_df(query = qry))
    }

    if (isTRUE(verbose)) {
      cli::cli_alert_info("Fetching structure for UNII: {.field {uid}} ...")
    }

    resp <- httr2::request(base) |>
      httr2::req_url_path_append(paste0("substances(", uid, ")")) |>
      httr2::req_retry(max_tries = 5L, backoff = httr2_backoff) |>
      httr2::req_perform()

    check_status_code(resp, verbose = FALSE)
    parse_structure_response(resp, query = qry)
  })

  struct <- do.call(rbind, structure_rows)

  # ---- Step 3: merge metadata + structure ------------------------------------

  # Drop the redundant `query` from struct (already in meta), then cbind
  struct_cols <- setdiff(names(struct), "query")
  out <- cbind(
    meta,
    struct[, struct_cols, drop = FALSE],
    stringsAsFactors = FALSE
  )
  rownames(out) <- NULL

  # ---- Warnings --------------------------------------------------------------

  if (isTRUE(verbose)) {
    n_unresolved <- sum(is.na(out[["unii"]]))
    n_no_struct  <- sum(!is.na(out[["unii"]]) & is.na(out[["smiles"]]))

    if (n_unresolved > 0L) {
      cli::cli_warn(
        "{n_unresolved} identifier(s) could not be resolved to a UNII."
      )
    }
    if (n_no_struct > 0L) {
      cli::cli_warn(
        "{n_no_struct} UNII(s) returned no structure data \\
        (non-chemical substance or unknown UNII)."
      )
    }
    if (n_unresolved == 0L && n_no_struct == 0L) {
      cli::cli_alert_success(
        "Retrieved chemical info for {nrow(out)} substance(s)."
      )
    }
  }

  out
}
