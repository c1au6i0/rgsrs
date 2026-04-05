# gsrs_codes: Retrieve all external codes/identifiers for a GSRS substance

#' Retrieve external codes and identifiers for GSRS substances
#'
#' For each supplied UNII, calls `GET /api/v1/substances(<UNII>)/codes` and
#' returns all registered cross-references as a tidy data frame. These include
#' CAS numbers, PubChem CIDs, ChEMBL IDs, WHO-ATC codes, NDF-RT codes,
#' DrugBank IDs, and many more.
#'
#' @param unii Character vector of one or more UNII codes.
#' @param code_system Character vector of code systems to filter on
#'   (e.g., `c("CAS", "PUBCHEM")`). Case-insensitive matching. Pass `NULL`
#'   (default) to return all code systems.
#' @param verbose Logical. If `TRUE`, emit progress messages. Default `TRUE`.
#' @param delay Numeric. Seconds to wait between individual lookups when
#'   `unii` has multiple entries. Default `0.5`.
#'
#' @return A data frame with columns:
#'   \describe{
#'     \item{code_system}{External database / code system name
#'       (e.g., `"CAS"`, `"PUBCHEM"`, `"ChEMBL"`, `"WHO-ATC"`).}
#'     \item{code}{The identifier in that system.}
#'     \item{type}{`"PRIMARY"` or `"ALTERNATIVE"`.}
#'     \item{url}{URL to the external record (when available).}
#'     \item{comments}{Additional context for the code (e.g., ATC path).}
#'     \item{is_classification}{Logical; `TRUE` for classification codes.}
#'     \item{uuid}{Internal GSRS UUID for the code record.}
#'     \item{date_retrieved}{Date the response was received.}
#'     \item{query}{The UNII supplied by the caller.}
#'   }
#'   Returns `NULL` on error (with a warning).
#'
#' @seealso [gsrs_substance()], [gsrs_names()], [gsrs_search()]
#' @export
#' @examples
#' \donttest{
#'   Sys.sleep(2)
#'   # All codes for aspirin
#'   out <- gsrs_codes("R16CO5Y76E")
#'   if (!is.null(out)) print(head(out))
#'
#'   Sys.sleep(2)
#'   # Only CAS and PubChem codes
#'   out_cas <- gsrs_codes("R16CO5Y76E", code_system = c("CAS", "PUBCHEM"))
#'   if (!is.null(out_cas)) print(out_cas)
#' }
gsrs_codes <- function(unii,
                        code_system = NULL,
                        verbose = TRUE,
                        delay = 0.5) {
  with_graceful_exit(
    gsrs_codes_out,
    unii = unii,
    code_system = code_system,
    verbose = verbose,
    delay = delay,
    what = "GSRS codes lookup"
  )
}

#' @keywords internal
#' @noRd
gsrs_codes_out <- function(unii,
                             code_system = NULL,
                             verbose = TRUE,
                             delay = 0.5) {
  check_internet(verbose = FALSE)
  unii <- check_ids(unii, "unii")

  base <- gsrs_base_url()

  results <- lapply(seq_along(unii), function(i) {
    id <- unii[[i]]

    if (i > 1L) Sys.sleep(delay)

    if (isTRUE(verbose)) {
      cli::cli_alert_info("Fetching codes for UNII: {.field {id}} ...")
    }

    resp <- httr2::request(base) |>
      httr2::req_url_path_append(paste0("substances(", id, ")/codes")) |>
      httr2::req_retry(max_tries = 5L, backoff = httr2_backoff) |>
      httr2::req_perform()

    check_status_code(resp, verbose = FALSE)
    parse_codes_response(resp, query = id)
  })

  out <- do.call(rbind, results)

  # Filter by code_system if requested
  if (!is.null(code_system) && nrow(out) > 0L) {
    pattern <- paste(toupper(code_system), collapse = "|")
    keep <- grepl(pattern, toupper(out[["code_system"]]))
    out <- out[keep, , drop = FALSE]
  }

  if (nrow(out) == 0L && isTRUE(verbose)) {
    cli::cli_warn("No codes found for supplied UNII(s).")
  } else if (isTRUE(verbose)) {
    cli::cli_alert_info("Retrieved {nrow(out)} code record(s).")
  }

  out
}
