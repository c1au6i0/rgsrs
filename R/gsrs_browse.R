# gsrs_browse: Page through all substance records in GSRS

#' Browse all substance records in GSRS
#'
#' Retrieves a paginated list of all substance records from
#' `GET /api/v1/substances`. Useful for bulk workflows or building a local
#' catalogue. Use `top` and `skip` to page through the ~170,000 available
#' records, or set `top = Inf` to fetch all (slow — use with care).
#'
#' @param top Integer. Maximum number of records to return per request.
#'   Default `10`. Set to `NULL` or `Inf` to fetch all records (paginates
#'   automatically; large result sets will be slow).
#' @param skip Integer. Number of records to skip (offset). Default `0`.
#' @param verbose Logical. If `TRUE`, emit progress messages. Default `TRUE`.
#' @param delay Numeric. Seconds to wait between paginated requests when
#'   `top = Inf`. Default `0.5`.
#'
#' @return A data frame with the same columns as [gsrs_search()].
#'   Returns `NULL` on error (with a warning).
#'
#' @seealso [gsrs_search()], [gsrs_substance()]
#' @export
#' @examples
#' \donttest{
#'   Sys.sleep(2)
#'   # Fetch the first 5 substance records
#'   out <- gsrs_browse(top = 5, verbose = FALSE)
#'   if (!is.null(out)) print(out[, c("approval_id", "preferred_name",
#'                                     "substance_class")])
#' }
gsrs_browse <- function(top     = 10L,
                         skip    = 0L,
                         verbose = TRUE,
                         delay   = 0.5) {
  with_graceful_exit(
    gsrs_browse_out,
    top     = top,
    skip    = skip,
    verbose = verbose,
    delay   = delay,
    what    = "GSRS browse"
  )
}

#' @keywords internal
#' @noRd
gsrs_browse_out <- function(top     = 10L,
                              skip    = 0L,
                              verbose = TRUE,
                              delay   = 0.5) {
  check_internet(verbose = FALSE)

  fetch_all <- isTRUE(is.null(top)) || isTRUE(is.infinite(top))
  top_per_page <- if (fetch_all) 100L else as.integer(top)

  base <- gsrs_base_url()
  current_skip <- as.integer(skip)
  all_rows <- list()
  total_available <- Inf

  repeat {
    if (isTRUE(verbose)) {
      cli::cli_alert_info(
        "Fetching records {current_skip + 1} - \\
        {current_skip + top_per_page} ..."
      )
    }

    resp <- httr2::request(base) |>
      httr2::req_url_path_append("substances") |>
      httr2::req_url_query(top = top_per_page, skip = current_skip) |>
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

  if (isTRUE(verbose)) {
    cli::cli_alert_info(
      "Retrieved {nrow(out)} of {total_available} total substance record(s)."
    )
  }

  out
}
