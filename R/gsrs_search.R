# gsrs_search: Search GSRS substances by free-text or field query

#' Search the GSRS substance database
#'
#' Searches the FDA Global Substance Registration System (GSRS) using a
#' free-text or Lucene-style field query. Returns a tidy data frame of
#' matching substance records with key metadata fields.
#'
#' @param query Character string. The search query. Supports:
#'   - Free text (e.g., `"aspirin"`)
#'   - Lucene field syntax (e.g., `"root_names:aspirin"`,
#'     `"root_approvalID:R16CO5Y76E"`)
#'   - Wildcards (`*`, `?`) as per GSRS documentation.
#' @param top Integer. Maximum number of records to return per request.
#'   Default `10`. Use `NULL` or `Inf` to attempt to retrieve all records
#'   (paginates automatically; large result sets may be slow).
#' @param skip Integer. Number of records to skip (offset). Default `0`.
#' @param verbose Logical. If `TRUE`, emit progress messages. Default `TRUE`.
#' @param delay Numeric. Seconds to wait between paginated requests.
#'   Default `0.5`.
#'
#' @return A data frame with columns:
#'   \describe{
#'     \item{uuid}{Internal GSRS UUID of the substance.}
#'     \item{approval_id}{FDA UNII / approval ID.}
#'     \item{preferred_name}{Preferred display name.}
#'     \item{substance_class}{Substance class (e.g., `"chemical"`,
#'       `"structurallyDiverse"`).}
#'     \item{status}{Record status (e.g., `"approved"`).}
#'     \item{definition_type}{`"PRIMARY"` or `"ALTERNATIVE"`.}
#'     \item{definition_level}{`"COMPLETE"` or `"INCOMPLETE"`.}
#'     \item{version}{Record version string.}
#'     \item{names_url}{URL to retrieve all names for this substance.}
#'     \item{codes_url}{URL to retrieve all codes for this substance.}
#'     \item{self_url}{Full URL for this substance record.}
#'     \item{date_retrieved}{Date the response was received from the server.}
#'   }
#'   Returns `NULL` on error (with a warning).
#'
#' @seealso [gsrs_substance()], [gsrs_names()], [gsrs_codes()]
#' @export
#' @examples
#' \donttest{
#'   Sys.sleep(2)
#'   out <- gsrs_search("aspirin", top = 5)
#'   if (!is.null(out)) print(head(out))
#' }
gsrs_search <- function(query,
                         top = 10L,
                         skip = 0L,
                         verbose = TRUE,
                         delay = 0.5) {
  with_graceful_exit(
    gsrs_search_out,
    query = query,
    top = top,
    skip = skip,
    verbose = verbose,
    delay = delay,
    what = "GSRS substance search"
  )
}

#' @keywords internal
#' @noRd
gsrs_search_out <- function(query,
                              top = 10L,
                              skip = 0L,
                              verbose = TRUE,
                              delay = 0.5) {
  check_internet(verbose = FALSE)

  if (!is.character(query) || length(query) != 1L || nchar(trimws(query)) == 0L) {
    cli::cli_abort("{.arg query} must be a single non-empty character string.")
  }

  # Resolve total
  fetch_all <- isTRUE(is.null(top)) || isTRUE(is.infinite(top))
  if (fetch_all) {
    top_per_page <- 100L
  } else {
    top_per_page <- as.integer(top)
  }

  base <- gsrs_base_url()
  current_skip <- as.integer(skip)
  all_rows <- list()
  total_available <- Inf

  repeat {
    if (isTRUE(verbose)) {
      cli::cli_alert_info(
        "Fetching records {current_skip + 1} - {current_skip + top_per_page} ..."
      )
    }

    resp <- httr2::request(base) |>
      httr2::req_url_path_append("substances") |>
      httr2::req_url_query(q = query, top = top_per_page, skip = current_skip) |>
      httr2::req_retry(max_tries = 5L, backoff = httr2_backoff) |>
      httr2::req_perform()

    check_status_code(resp, verbose = FALSE)

    body <- httr2::resp_body_json(resp, simplifyVector = FALSE)
    total_available <- body[["total"]] %||% 0L

    chunk <- parse_substances_response(resp)
    all_rows <- c(all_rows, list(chunk))

    fetched_so_far <- current_skip + nrow(chunk)

    if (!fetch_all) break
    if (fetched_so_far >= total_available) break
    if (nrow(chunk) == 0L) break

    current_skip <- fetched_so_far
    Sys.sleep(delay)
  }

  out <- do.call(rbind, all_rows)

  if (nrow(out) == 0L && isTRUE(verbose)) {
    cli::cli_warn("No records found for query: {.field {query}}")
  } else if (isTRUE(verbose)) {
    cli::cli_alert_info("Retrieved {nrow(out)} record(s).")
  }

  out
}
