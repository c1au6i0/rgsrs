# gsrs_hierarchy: Retrieve the relationship hierarchy for a GSRS substance

#' Retrieve the relationship hierarchy for GSRS substances
#'
#' For each supplied UNII, calls `GET /api/v1/substances(<UNII>)/@hierarchy`
#' and returns the flat parent/child relationship tree as a tidy data frame.
#' This is useful for navigating relationships such as salt forms to free base,
#' active metabolites, or component substances.
#'
#' @param unii Character vector of one or more UNII codes.
#' @param verbose Logical. If `TRUE`, emit progress messages. Default `TRUE`.
#' @param delay Numeric. Seconds to wait between individual lookups when
#'   `unii` has multiple entries. Default `0.5`.
#'
#' @return A data frame with columns:
#'   \describe{
#'     \item{node_id}{Node identifier within the hierarchy tree (string index).}
#'     \item{parent_id}{Parent node identifier (`"#"` for root nodes).}
#'     \item{depth}{Depth in the tree (0 = root).}
#'     \item{type}{Node type (e.g., `"ROOT"`, `"ACTIVE MOIETY"`,
#'       `"SALT/SOLVATE"`).}
#'     \item{text}{Human-readable label including UNII and name.}
#'     \item{expandable}{Logical; `TRUE` if node has children.}
#'     \item{approval_id}{UNII of the substance at this node.}
#'     \item{name}{Preferred name at this node.}
#'     \item{ref_uuid}{Internal GSRS UUID of the related substance.}
#'     \item{substance_class}{Substance class at this node.}
#'     \item{deprecated}{Logical; `TRUE` if the node substance is deprecated.}
#'     \item{date_retrieved}{Date the response was received.}
#'     \item{query}{The UNII supplied by the caller.}
#'   }
#'   Returns `NULL` on error (with a warning).
#'
#' @seealso [gsrs_substance()], [gsrs_all()]
#' @export
#' @examples
#' \donttest{
#'   Sys.sleep(2)
#'   out <- gsrs_hierarchy("R16CO5Y76E")  # aspirin
#'   if (!is.null(out)) print(out[, c("depth", "type", "approval_id", "name")])
#' }
gsrs_hierarchy <- function(unii, verbose = TRUE, delay = 0.5) {
  with_graceful_exit(
    gsrs_hierarchy_out,
    unii = unii,
    verbose = verbose,
    delay = delay,
    what = "GSRS hierarchy lookup"
  )
}

#' @keywords internal
#' @noRd
gsrs_hierarchy_out <- function(unii, verbose = TRUE, delay = 0.5) {
  check_internet(verbose = FALSE)
  unii <- check_ids(unii, "unii")

  base <- gsrs_base_url()

  results <- lapply(seq_along(unii), function(i) {
    id <- unii[[i]]

    if (i > 1L) Sys.sleep(delay)

    if (isTRUE(verbose)) {
      cli::cli_alert_info("Fetching hierarchy for UNII: {.field {id}} ...")
    }

    resp <- httr2::request(base) |>
      httr2::req_url_path_append(paste0("substances(", id, ")/@hierarchy")) |>
      httr2::req_retry(max_tries = 5L, backoff = httr2_backoff) |>
      httr2::req_perform()

    check_status_code(resp, verbose = FALSE)
    parse_hierarchy_response(resp, query = id)
  })

  out <- do.call(rbind, results)

  if (nrow(out) == 0L && isTRUE(verbose)) {
    cli::cli_warn("No hierarchy data found for supplied UNII(s).")
  } else if (isTRUE(verbose)) {
    cli::cli_alert_info("Retrieved {nrow(out)} hierarchy node(s).")
  }

  out
}
