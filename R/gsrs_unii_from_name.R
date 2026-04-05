# gsrs_unii_from_name: Resolve substance name(s) to UNII

#' Look up UNII codes for substance names
#'
#' For each supplied name, queries GSRS using `root_names:<name>` and returns
#' the best-matching UNII together with the preferred substance name and
#' substance class. This is useful for converting common or systematic names
#' to the canonical FDA UNII identifier.
#'
#' @param names Character vector of substance names to resolve.
#' @param top Integer. Maximum number of candidate records to consider per
#'   name query. Default `1` returns only the top hit. Increase to inspect
#'   multiple candidates.
#' @param verbose Logical. If `TRUE`, emit progress messages. Default `TRUE`.
#' @param delay Numeric. Seconds to wait between individual lookups.
#'   Default `0.5`.
#'
#' @return A data frame with columns:
#'   \describe{
#'     \item{unii}{The UNII / approval ID of the matched substance.}
#'     \item{preferred_name}{Preferred display name in GSRS.}
#'     \item{substance_class}{Substance class (e.g., `"chemical"`).}
#'     \item{status}{Record status.}
#'     \item{uuid}{Internal GSRS UUID.}
#'     \item{date_retrieved}{Date the response was received.}
#'     \item{query}{The name supplied by the caller.}
#'   }
#'   Unresolved names produce a row of `NA`s with `query` set. Returns `NULL`
#'   on error (with a warning).
#'
#' @seealso [gsrs_substance()], [gsrs_search()], [gsrs_names()]
#' @export
#' @examples
#' \donttest{
#'   Sys.sleep(2)
#'   out <- gsrs_unii_from_name(c("aspirin", "ibuprofen"))
#'   if (!is.null(out)) print(out)
#' }
gsrs_unii_from_name <- function(names,
                                  top = 1L,
                                  verbose = TRUE,
                                  delay = 0.5) {
  with_graceful_exit(
    gsrs_unii_from_name_out,
    names = names,
    top = top,
    verbose = verbose,
    delay = delay,
    what = "GSRS UNII-from-name lookup"
  )
}

#' @keywords internal
#' @noRd
gsrs_unii_from_name_out <- function(names,
                                     top = 1L,
                                     verbose = TRUE,
                                     delay = 0.5) {
  check_internet(verbose = FALSE)
  names <- check_ids(names, "names")

  base <- gsrs_base_url()
  top <- as.integer(top)

  results <- lapply(seq_along(names), function(i) {
    nm <- names[[i]]

    if (i > 1L) Sys.sleep(delay)

    if (isTRUE(verbose)) {
      cli::cli_alert_info("Resolving name to UNII: {.field {nm}} ...")
    }

    resp <- httr2::request(base) |>
      httr2::req_url_path_append("substances") |>
      httr2::req_url_query(
        q = paste0("root_names:\"", nm, "\""),
        top = top
      ) |>
      httr2::req_retry(max_tries = 5L, backoff = httr2_backoff) |>
      httr2::req_perform()

    check_status_code(resp, verbose = FALSE)
    chunk <- parse_substances_response(resp)

    if (nrow(chunk) == 0L) {
      return(
        data.frame(
          unii = NA_character_,
          preferred_name = NA_character_,
          substance_class = NA_character_,
          status = NA_character_,
          uuid = NA_character_,
          date_retrieved = format(httr2::resp_date(resp)),
          query = nm,
          stringsAsFactors = FALSE
        )
      )
    }

    # Return up to `top` rows; rename approval_id -> unii for clarity
    rows <- chunk[seq_len(min(nrow(chunk), top)), , drop = FALSE]
    data.frame(
      unii = rows[["approval_id"]],
      preferred_name = rows[["preferred_name"]],
      substance_class = rows[["substance_class"]],
      status = rows[["status"]],
      uuid = rows[["uuid"]],
      date_retrieved = rows[["date_retrieved"]],
      query = nm,
      stringsAsFactors = FALSE
    )
  })

  out <- do.call(rbind, results)

  if (isTRUE(verbose)) {
    check_na_warn(out, col_to_check = "unii", verbose = verbose)
  }

  out
}
