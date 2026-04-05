# Validation and check helpers for rgsrs

#' Check for internet connectivity
#'
#' @param verbose Logical. If `TRUE`, emit an info message when online.
#' @return Invisible `TRUE` if online.
#' @keywords internal
#' @noRd
check_internet <- function(verbose = TRUE) {
  online <- isTRUE(pingr::is_online())
  if (!online) {
    cli::cli_abort(
      "No internet connection detected. Please check your network."
    )
  }
  if (isTRUE(verbose)) {
    cli::cli_alert_info("Internet connection detected.")
  }
  invisible(TRUE)
}

#' Validate HTTP response status code
#'
#' Aborts if the status code is not 200. Emits an info message if verbose.
#'
#' @param resp An `httr2_response` object.
#' @param verbose Logical.
#' @return Invisible `resp`.
#' @keywords internal
#' @noRd
check_status_code <- function(resp, verbose = TRUE) {
  code <- httr2::resp_status(resp)
  if (code != 200L) {
    cli::cli_abort(
      "GSRS API returned HTTP {code}. URL: {.url {httr2::resp_url(resp)}}"
    )
  }
  if (isTRUE(verbose)) {
    cli::cli_alert_info("HTTP 200 OK.")
  }
  invisible(resp)
}

#' Warn if any key column contains NA values
#'
#' @param dat A data frame.
#' @param col_to_check Character name of the column to inspect.
#' @param verbose Logical.
#' @return Invisible character vector of `query` values that have NA in
#'   `col_to_check`, or `character(0)`.
#' @keywords internal
#' @noRd
check_na_warn <- function(dat, col_to_check, verbose = TRUE) {
  if (!col_to_check %in% names(dat)) {
    return(invisible(character(0)))
  }
  missing_rows <- is.na(dat[[col_to_check]])
  if (any(missing_rows) && isTRUE(verbose)) {
    ids_not_found <- dat[["query"]][missing_rows]
    ids_not_found <- ids_not_found[!is.na(ids_not_found)]
    if (length(ids_not_found) > 0L) {
      cli::cli_warn(
        "No results found for: {.field {ids_not_found}}"
      )
    }
  }
  invisible(dat[["query"]][missing_rows])
}

#' Validate that `ids` is a non-empty character vector
#'
#' @param ids Object to validate.
#' @param arg_name Character string; the argument name used in error messages.
#' @return Invisible `ids` (trimmed and de-duplicated).
#' @keywords internal
#' @noRd
check_ids <- function(ids, arg_name = "ids") {
  if (!is.character(ids) || length(ids) == 0L) {
    cli::cli_abort(
      "{.arg {arg_name}} must be a non-empty character vector."
    )
  }
  ids <- trimws(ids)
  ids <- ids[nchar(ids) > 0L]
  if (length(ids) == 0L) {
    cli::cli_abort(
      "{.arg {arg_name}} contains only empty strings after trimming."
    )
  }
  invisible(ids)
}
