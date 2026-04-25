# gsrs_structure_search: Search GSRS by chemical structure (SMILES)

#' Search GSRS by chemical structure
#'
#' Searches the FDA Global Substance Registration System for substances matching
#' a chemical structure query supplied as a SMILES string. Supports
#' substructure, similarity, exact-match, and flexible (disconnected moiety)
#' search types.
#'
#' @param smiles Character string. A valid SMILES or SMARTS string describing
#'   the query structure (e.g., `"CC(=O)Oc1ccccc1C(=O)O"` for aspirin).
#' @param type Character string. Search type. One of:
#'   \describe{
#'     \item{`"sub"`}{Substructure search (default). Returns all substances
#'       whose structure contains the query as a substructure.}
#'     \item{`"sim"`}{Similarity search. Returns substances with Tanimoto
#'       similarity >= `cutoff`. Use `cutoff` to control threshold.}
#'     \item{`"exact"`}{Exact structure match (tautomer-aware, stereo-sensitive).}
#'     \item{`"flex"`}{Flexible (disconnected moiety) search; stereo-insensitive.}
#'   }
#' @param cutoff Numeric in `[0, 1]`. Tanimoto similarity cutoff for
#'   `type = "sim"`. Default `0.8`. Ignored for other search types.
#' @param top Integer. Maximum number of records to return. Default `10`.
#' @param verbose Logical. If `TRUE`, emit progress messages. Default `TRUE`.
#'
#' @return A data frame with the same columns as [gsrs_search()], plus a
#'   `query_smiles` column recording the input SMILES. Returns `NULL` on error
#'   (with a warning).
#'
#' @seealso [gsrs_structure()], [gsrs_search()]
#' @export
#' @examples
#' \donttest{
#'   Sys.sleep(2)
#'   # Exact match for aspirin
#'   out <- gsrs_structure_search("CC(=O)Oc1ccccc1C(=O)O", type = "exact")
#'   if (!is.null(out)) print(out[, c("approval_id", "preferred_name")])
#'
#'   Sys.sleep(2)
#'   # Similarity search
#'   out_sim <- gsrs_structure_search("CC(=O)Oc1ccccc1C(=O)O",
#'                                    type = "sim", cutoff = 0.7, top = 5)
#'   if (!is.null(out_sim)) print(out_sim[, c("approval_id", "preferred_name")])
#' }
gsrs_structure_search <- function(smiles,
                                   type   = c("sub", "sim", "exact", "flex"),
                                   cutoff = 0.8,
                                   top    = 10L,
                                   verbose = TRUE) {
  type <- match.arg(type)
  with_graceful_exit(
    gsrs_structure_search_out,
    smiles  = smiles,
    type    = type,
    cutoff  = cutoff,
    top     = top,
    verbose = verbose,
    what    = "GSRS structure search"
  )
}

#' @keywords internal
#' @noRd
gsrs_structure_search_out <- function(smiles,
                                       type    = "sub",
                                       cutoff  = 0.8,
                                       top     = 10L,
                                       verbose = TRUE) {
  check_internet(verbose = FALSE)

  if (!is.character(smiles) || length(smiles) != 1L ||
      nchar(trimws(smiles)) == 0L) {
    cli::cli_abort("{.arg smiles} must be a single non-empty character string.")
  }

  if (isTRUE(verbose)) {
    cli::cli_alert_info(
      "Running {type} structure search for: {.field {smiles}} ..."
    )
  }

  base <- gsrs_base_url()

  req <- httr2::request(base) |>
    httr2::req_url_path_append("substances/structureSearch") |>
    httr2::req_url_query(q = smiles, type = type, sync = "true",
                         top = as.integer(top))

  if (type == "sim") {
    req <- req |> httr2::req_url_query(cutoff = cutoff)
  }

  resp <- req |>
    httr2::req_retry(max_tries = 5L, backoff = httr2_backoff) |>
    httr2::req_perform()

  check_status_code(resp, verbose = FALSE)

  out <- parse_substances_response(resp)
  if (nrow(out) > top) out <- out[seq_len(top), , drop = FALSE]
  out[["query_smiles"]] <- smiles

  if (nrow(out) == 0L && isTRUE(verbose)) {
    cli::cli_warn("No structures matched the query.")
  } else if (isTRUE(verbose)) {
    cli::cli_alert_info("Retrieved {nrow(out)} matching substance(s).")
  }

  out
}
