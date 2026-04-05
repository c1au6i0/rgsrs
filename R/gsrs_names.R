# gsrs_names: Retrieve all synonyms/names for a GSRS substance

#' Retrieve all names (synonyms) for GSRS substances
#'
#' For each supplied UNII, calls `GET /api/v1/substances(<UNII>)/names` and
#' returns every registered name record as a tidy data frame row.
#'
#' @param unii Character vector of one or more UNII codes.
#' @param verbose Logical. If `TRUE`, emit progress messages. Default `TRUE`.
#' @param delay Numeric. Seconds to wait between individual lookups when
#'   `unii` has multiple entries. Default `0.5`.
#'
#' @return A data frame with columns:
#'   \describe{
#'     \item{name}{The name string.}
#'     \item{std_name}{Standardised (uppercased) name.}
#'     \item{type}{Name type code (e.g., `"bn"` brand name, `"cn"` common name,
#'       `"sys"` systematic name, `"of"` official name).}
#'     \item{preferred}{Logical; `TRUE` when this is the preferred name.}
#'     \item{display_name}{Logical; `TRUE` when this name is shown by default.}
#'     \item{languages}{Semicolon-separated language codes.}
#'     \item{domains}{Semicolon-separated domain tags.}
#'     \item{uuid}{Internal GSRS UUID for the name record.}
#'     \item{date_retrieved}{Date the response was received.}
#'     \item{query}{The UNII supplied by the caller.}
#'   }
#'   Returns `NULL` on error (with a warning).
#'
#' @seealso [gsrs_substance()], [gsrs_codes()], [gsrs_search()]
#' @export
#' @examples
#' \donttest{
#'   Sys.sleep(2)
#'   out <- gsrs_names("R16CO5Y76E")  # aspirin
#'   if (!is.null(out)) print(head(out))
#' }
gsrs_names <- function(unii, verbose = TRUE, delay = 0.5) {
  with_graceful_exit(
    gsrs_names_out,
    unii = unii,
    verbose = verbose,
    delay = delay,
    what = "GSRS names lookup"
  )
}

#' @keywords internal
#' @noRd
gsrs_names_out <- function(unii, verbose = TRUE, delay = 0.5) {
  check_internet(verbose = FALSE)
  unii <- check_ids(unii, "unii")

  base <- gsrs_base_url()

  results <- lapply(seq_along(unii), function(i) {
    id <- unii[[i]]

    if (i > 1L) Sys.sleep(delay)

    if (isTRUE(verbose)) {
      cli::cli_alert_info("Fetching names for UNII: {.field {id}} ...")
    }

    resp <- httr2::request(base) |>
      httr2::req_url_path_append(paste0("substances(", id, ")/names")) |>
      httr2::req_retry(max_tries = 5L, backoff = httr2_backoff) |>
      httr2::req_perform()

    check_status_code(resp, verbose = FALSE)
    parse_names_response(resp, query = id)
  })

  out <- do.call(rbind, results)

  if (nrow(out) == 0L && isTRUE(verbose)) {
    cli::cli_warn("No names found for supplied UNII(s).")
  } else if (isTRUE(verbose)) {
    cli::cli_alert_info("Retrieved {nrow(out)} name record(s).")
  }

  out
}
