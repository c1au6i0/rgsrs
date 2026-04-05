# gsrs_all: Umbrella wrapper that combines substance metadata, names, and codes

#' Retrieve comprehensive GSRS data for a set of UNIIs
#'
#' Convenience wrapper that calls [gsrs_substance()], [gsrs_names()], and
#' [gsrs_codes()] in sequence and returns a named list containing all three
#' data frames. Each sub-function uses `with_graceful_exit` internally, so
#' partial failures return `NULL` for that element without aborting the whole
#' call.
#'
#' @param unii Character vector of one or more UNII codes.
#' @param verbose Logical. If `TRUE`, emit progress messages. Default `TRUE`.
#' @param delay Numeric. Seconds to wait between individual lookups.
#'   Default `0.5`.
#'
#' @return A named list with three elements:
#'   \describe{
#'     \item{substance}{Data frame from [gsrs_substance()].}
#'     \item{names}{Data frame from [gsrs_names()].}
#'     \item{codes}{Data frame from [gsrs_codes()].}
#'   }
#'   Returns `NULL` on error (with a warning).
#'
#' @seealso [gsrs_substance()], [gsrs_names()], [gsrs_codes()]
#' @export
#' @examples
#' \donttest{
#'   Sys.sleep(2)
#'   out <- gsrs_all("R16CO5Y76E")  # aspirin
#'   if (!is.null(out)) {
#'     print(out$substance)
#'     print(head(out$names))
#'     print(head(out$codes))
#'   }
#' }
gsrs_all <- function(unii, verbose = TRUE, delay = 0.5) {
  with_graceful_exit(
    gsrs_all_out,
    unii = unii,
    verbose = verbose,
    delay = delay,
    what = "GSRS comprehensive lookup"
  )
}

#' @keywords internal
#' @noRd
gsrs_all_out <- function(unii, verbose = TRUE, delay = 0.5) {
  substance_dat <- gsrs_substance(unii, verbose = verbose, delay = delay)
  names_dat <- gsrs_names(unii, verbose = verbose, delay = delay)
  codes_dat <- gsrs_codes(unii, verbose = verbose, delay = delay)

  list(
    substance = substance_dat,
    names = names_dat,
    codes = codes_dat
  )
}
