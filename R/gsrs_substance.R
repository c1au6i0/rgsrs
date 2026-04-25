# gsrs_substance: Fetch a single substance record by UNII

#' Fetch a GSRS substance record by UNII
#'
#' Retrieves the top-level metadata for a single substance identified by its
#' UNII (Unique Ingredient Identifier / approval ID). Internally this performs
#' a filtered search using `root_approvalID:<unii>`.
#'
#' @param unii Character vector of one or more UNII codes
#'   (e.g., `"R16CO5Y76E"` for aspirin).
#' @param verbose Logical. If `TRUE`, emit progress messages. Default `TRUE`.
#' @param delay Numeric. Seconds to wait between individual lookups when
#'   `unii` has multiple entries. Default `0.5`.
#'
#' @return A data frame with the same columns as [gsrs_search()], with one row
#'   per input UNII.  Rows for unrecognised UNIIs will contain `NA` except for
#'   the `query` column (which is always set to the input UNII).  Returns
#'   `NULL` on error (with a warning).
#'
#' @seealso [gsrs_search()], [gsrs_names()], [gsrs_codes()]
#' @export
#' @examples
#' \donttest{
#'   Sys.sleep(2)
#'   out <- gsrs_substance("R16CO5Y76E")  # aspirin
#'   if (!is.null(out)) print(out)
#' }
gsrs_substance <- function(unii, verbose = TRUE, delay = 0.5) {
  with_graceful_exit(
    gsrs_substance_out,
    unii = unii,
    verbose = verbose,
    delay = delay,
    what = "GSRS substance lookup"
  )
}

#' @keywords internal
#' @noRd
gsrs_substance_out <- function(unii, verbose = TRUE, delay = 0.5) {
  check_internet(verbose = FALSE)
  unii <- check_ids(unii, "unii")

  base <- gsrs_base_url()

  results <- lapply(seq_along(unii), function(i) {
    id <- unii[[i]]

    if (isTRUE(verbose)) {
      cli::cli_alert_info("Fetching substance for UNII: {.field {id}} ...")
    }

    resp <- httr2::request(base) |>
      httr2::req_url_path_append("substances/search") |>
      httr2::req_url_query(q = paste0("root_approvalID:", id), top = 1L) |>
      httr2::req_retry(max_tries = 5L, backoff = httr2_backoff) |>
      httr2::req_perform()

    check_status_code(resp, verbose = FALSE)

    chunk <- parse_substances_response(resp)

    if (nrow(chunk) == 0L) {
      na_row <- data.frame(
        uuid = NA_character_,
        approval_id = NA_character_,
        preferred_name = NA_character_,
        substance_class = NA_character_,
        status = NA_character_,
        definition_type = NA_character_,
        definition_level = NA_character_,
        version = NA_character_,
        names_url = NA_character_,
        codes_url = NA_character_,
        self_url = NA_character_,
        date_retrieved = format(httr2::resp_date(resp)),
        query = id,
        stringsAsFactors = FALSE
      )
      return(na_row)
    }

    chunk[["query"]] <- id
    chunk[1L, , drop = FALSE]
  })

  out <- do.call(rbind, results)

  if (isTRUE(verbose)) {
    check_na_warn(out, col_to_check = "preferred_name", verbose = verbose)
  }

  out
}
