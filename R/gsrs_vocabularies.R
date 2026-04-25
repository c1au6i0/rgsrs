# gsrs_vocabularies: Retrieve controlled vocabulary terms from GSRS

#' Retrieve controlled vocabulary terms from GSRS
#'
#' Fetches all (or a page of) controlled vocabulary entries from
#' `GET /api/v1/vocabularies`. The result is one row per vocabulary term,
#' with the parent domain and type attached to every row. This is useful for
#' understanding allowed values for fields such as name type, substance class,
#' relationship type, code system, and more.
#'
#' @param top Integer. Maximum number of vocabulary *domains* to return per
#'   request. Default `NULL` fetches all domains (paginates automatically).
#' @param verbose Logical. If `TRUE`, emit progress messages. Default `TRUE`.
#' @param delay Numeric. Seconds to wait between paginated requests.
#'   Default `0.5`.
#'
#' @return A data frame with columns:
#'   \describe{
#'     \item{domain}{Vocabulary domain name (e.g., `"NAME_TYPE"`,
#'       `"SUBSTANCE_CLASS"`, `"RELATIONSHIP_TYPE"`).}
#'     \item{term_type}{Vocabulary term type identifier.}
#'     \item{editable}{Logical; `TRUE` if the vocabulary can be extended.}
#'     \item{filterable}{Logical; `TRUE` if the vocabulary supports filtering.}
#'     \item{value}{The controlled term value (used in the API/data).}
#'     \item{display}{Human-readable display label for the term.}
#'     \item{hidden}{Logical; `TRUE` if the term is hidden from the UI.}
#'     \item{selected}{Logical; `TRUE` if the term is selected by default.}
#'     \item{date_retrieved}{Date the response was received.}
#'   }
#'   Returns `NULL` on error (with a warning).
#'
#' @seealso [gsrs_search()], [gsrs_codes()]
#' @export
#' @examples
#' \donttest{
#'   Sys.sleep(2)
#'   vocab <- gsrs_vocabularies(verbose = FALSE)
#'   if (!is.null(vocab)) {
#'     # See all name type values
#'     print(vocab[vocab$domain == "NAME_TYPE", c("value", "display")])
#'   }
#' }
gsrs_vocabularies <- function(top     = NULL,
                                verbose = TRUE,
                                delay   = 0.5) {
  with_graceful_exit(
    gsrs_vocabularies_out,
    top     = top,
    verbose = verbose,
    delay   = delay,
    what    = "GSRS vocabularies"
  )
}

#' @keywords internal
#' @noRd
gsrs_vocabularies_out <- function(top     = NULL,
                                   verbose = TRUE,
                                   delay   = 0.5) {
  check_internet(verbose = FALSE)

  fetch_all <- isTRUE(is.null(top)) || isTRUE(is.infinite(top))
  top_per_page <- if (fetch_all) 100L else as.integer(top)

  base <- gsrs_base_url()
  current_skip <- 0L
  all_rows <- list()
  total_available <- Inf

  repeat {
    if (isTRUE(verbose)) {
      cli::cli_alert_info(
        "Fetching vocabulary domains {current_skip + 1} - \\
        {current_skip + top_per_page} ..."
      )
    }

    resp <- httr2::request(base) |>
      httr2::req_url_path_append("vocabularies") |>
      httr2::req_url_query(top = top_per_page, skip = current_skip) |>
      httr2::req_retry(max_tries = 5L, backoff = httr2_backoff) |>
      httr2::req_perform()

    check_status_code(resp, verbose = FALSE)

    body <- httr2::resp_body_json(resp, simplifyVector = FALSE)
    total_available <- body[["total"]] %||% 0L

    chunk <- parse_vocabularies_response(resp)
    all_rows <- c(all_rows, list(chunk))

    fetched_domains <- current_skip + (body[["count"]] %||% 0L)

    if (!fetch_all) break
    if (fetched_domains >= total_available) break
    if ((body[["count"]] %||% 0L) == 0L) break

    current_skip <- fetched_domains
    Sys.sleep(delay)
  }

  out <- do.call(rbind, all_rows)

  if (isTRUE(verbose)) {
    n_domains <- length(unique(out[["domain"]]))
    cli::cli_alert_info(
      "Retrieved {nrow(out)} term(s) across {n_domains} vocabulary domain(s)."
    )
  }

  out
}
