# gsrs_structure: Retrieve chemical structure data for GSRS substances

#' Retrieve chemical structure data for GSRS substances
#'
#' For each supplied UNII, fetches the full substance record from
#' `GET /api/v1/substances(<UNII>)` and extracts the embedded `structure`
#' object, returning chemical identifiers and properties as a tidy data frame.
#'
#' @param unii Character vector of one or more UNII codes.
#' @param verbose Logical. If `TRUE`, emit progress messages. Default `TRUE`.
#' @param delay Numeric. Seconds to wait between individual lookups when
#'   `unii` has multiple entries. Default `0.5`.
#'
#' @return A data frame with columns:
#'   \describe{
#'     \item{smiles}{Canonical SMILES string.}
#'     \item{formula}{Molecular formula (e.g., `"C9H8O4"`).}
#'     \item{mwt}{Molecular weight (numeric).}
#'     \item{inchi_key}{Standard InChIKey.}
#'     \item{inchi}{Full InChI string.}
#'     \item{stereochemistry}{Stereochemistry descriptor (e.g., `"ACHIRAL"`,
#'       `"RACEMIC"`, `"ABSOLUTE"`).}
#'     \item{optical_activity}{Optical activity (e.g., `"UNSPECIFIED"`, `"(+)"`,
#'       `"(-)"`).}
#'     \item{charge}{Formal charge (integer).}
#'     \item{stereo_centers}{Number of stereocenters.}
#'     \item{defined_stereo}{Number of defined stereocenters.}
#'     \item{ez_centers}{Number of E/Z double-bond stereocenters.}
#'     \item{molfile}{MDL molfile as a string.}
#'     \item{date_retrieved}{Date the response was received.}
#'     \item{query}{The UNII supplied by the caller.}
#'   }
#'   Non-chemical substances (proteins, polymers, etc.) return a row of `NA`s
#'   with `query` set. Returns `NULL` on error (with a warning).
#'
#' @seealso [gsrs_substance()], [gsrs_structure_search()], [gsrs_names()],
#'   [gsrs_codes()]
#' @export
#' @examples
#' \donttest{
#'   Sys.sleep(2)
#'   out <- gsrs_structure("R16CO5Y76E")  # aspirin
#'   if (!is.null(out)) print(out[, c("smiles", "formula", "mwt", "inchi_key")])
#' }
gsrs_structure <- function(unii, verbose = TRUE, delay = 0.5) {
  with_graceful_exit(
    gsrs_structure_out,
    unii = unii,
    verbose = verbose,
    delay = delay,
    what = "GSRS structure lookup"
  )
}

#' @keywords internal
#' @noRd
gsrs_structure_out <- function(unii, verbose = TRUE, delay = 0.5) {
  check_internet(verbose = FALSE)
  unii <- check_ids(unii, "unii")

  base <- gsrs_base_url()

  results <- lapply(seq_along(unii), function(i) {
    id <- unii[[i]]

    if (i > 1L) Sys.sleep(delay)

    if (isTRUE(verbose)) {
      cli::cli_alert_info("Fetching structure for UNII: {.field {id}} ...")
    }

    resp <- httr2::request(base) |>
      httr2::req_url_path_append(paste0("substances(", id, ")")) |>
      httr2::req_retry(max_tries = 5L, backoff = httr2_backoff) |>
      httr2::req_perform()

    check_status_code(resp, verbose = FALSE)
    parse_structure_response(resp, query = id)
  })

  out <- do.call(rbind, results)

  if (isTRUE(verbose)) {
    n_missing <- sum(is.na(out[["smiles"]]))
    if (n_missing > 0L) {
      cli::cli_warn(
        "{n_missing} UNII(s) returned no structure data \\
        (non-chemical substance or unknown UNII)."
      )
    } else {
      cli::cli_alert_info("Retrieved structure for {nrow(out)} substance(s).")
    }
  }

  out
}
