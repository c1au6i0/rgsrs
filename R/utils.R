# Utility and infrastructure helpers for rgsrs
# Functions: gsrs_base_url, httr2_backoff, with_graceful_exit,
#            write_dataframes_to_excel

# ---- Base URL ---------------------------------------------------------------

#' Return the GSRS API base URL
#'
#' @keywords internal
#' @noRd
gsrs_base_url <- function() {
  "https://gsrs.ncats.nih.gov/api/v1"
}

# ---- Retry back-off ---------------------------------------------------------

#' Jittered exponential back-off for httr2 retry
#'
#' @param i Integer retry attempt number.
#' @return Numeric seconds to wait before next attempt.
#' @keywords internal
#' @noRd
httr2_backoff <- function(i) {
  min(30, 1 * 2^(i - 1)) * stats::runif(1, 0.8, 1.2)
}

# ---- Graceful error handling ------------------------------------------------

#' Run a function and return NULL on error, with a warning
#'
#' @param .f Function to call.
#' @param ... Arguments forwarded to `.f`.
#' @param what Character string describing the operation (used in warning).
#' @return Result of `.f(...)` or `NULL` if an error is caught.
#' @keywords internal
#' @noRd
with_graceful_exit <- function(.f, ..., what = NULL) {
  if (is.null(what)) what <- deparse(substitute(.f))
  tryCatch(
    .f(...),
    error = function(e) {
      cli::cli_warn(
        "{what} failed. Returning NULL. The error was: {e$message}"
      )
      NULL
    }
  )
}

# ---- Parse substance list response ------------------------------------------

#' Parse a GSRS paged substances JSON response into a data frame
#'
#' Extracts the flat fields from the `content` array returned by
#' `GET /api/v1/substances?q=...`.  Nested sub-objects (structure, codes,
#' names) are intentionally excluded here; use dedicated helpers instead.
#'
#' @param resp An `httr2_response` object.
#' @return A data frame (may have 0 rows when the query matched nothing).
#' @keywords internal
#' @noRd
parse_substances_response <- function(resp) {
  body <- httr2::resp_body_json(resp, simplifyVector = FALSE)
  content <- body[["content"]]

  if (is.null(content) || length(content) == 0L) {
    return(
      data.frame(
        uuid = character(0),
        approval_id = character(0),
        preferred_name = character(0),
        substance_class = character(0),
        status = character(0),
        definition_type = character(0),
        definition_level = character(0),
        version = character(0),
        names_url = character(0),
        codes_url = character(0),
        self_url = character(0),
        date_retrieved = character(0),
        stringsAsFactors = FALSE
      )
    )
  }

  date_retrieved <- format(httr2::resp_date(resp))

  rows <- lapply(content, function(s) {
    data.frame(
      uuid = s[["uuid"]] %||% NA_character_,
      approval_id = s[["approvalID"]] %||% NA_character_,
      preferred_name = s[["_name"]] %||% NA_character_,
      substance_class = s[["substanceClass"]] %||% NA_character_,
      status = s[["status"]] %||% NA_character_,
      definition_type = s[["definitionType"]] %||% NA_character_,
      definition_level = s[["definitionLevel"]] %||% NA_character_,
      version = s[["version"]] %||% NA_character_,
      names_url = s[["_names"]][["url"]] %||% NA_character_,
      codes_url = s[["_codes"]][["url"]] %||% NA_character_,
      self_url = s[["_self"]] %||% NA_character_,
      date_retrieved = date_retrieved,
      stringsAsFactors = FALSE
    )
  })

  out <- do.call(rbind, rows)
  janitor::clean_names(out)
}

# ---- Parse names sub-resource -----------------------------------------------

#' Parse a GSRS substance /names JSON array into a data frame
#'
#' @param resp An `httr2_response` object from `GET .../substances(<id>)/names`.
#' @param query The original identifier used in the lookup (for the `query` col).
#' @return A data frame with name records, or a 0-row template on empty results.
#' @keywords internal
#' @noRd
parse_names_response <- function(resp, query = NA_character_) {
  body <- httr2::resp_body_json(resp, simplifyVector = FALSE)

  if (!is.list(body) || length(body) == 0L) {
    return(empty_names_df())
  }

  date_retrieved <- format(httr2::resp_date(resp))

  rows <- lapply(body, function(n) {
    data.frame(
      name = n[["name"]] %||% NA_character_,
      std_name = n[["stdName"]] %||% NA_character_,
      type = n[["type"]] %||% NA_character_,
      preferred = isTRUE(n[["preferred"]]),
      display_name = isTRUE(n[["displayName"]]),
      languages = paste(unlist(n[["languages"]]), collapse = "; "),
      domains = paste(unlist(n[["domains"]]), collapse = "; "),
      uuid = n[["uuid"]] %||% NA_character_,
      date_retrieved = date_retrieved,
      query = query,
      stringsAsFactors = FALSE
    )
  })

  out <- do.call(rbind, rows)
  janitor::clean_names(out)
}

#' @keywords internal
#' @noRd
empty_names_df <- function() {
  data.frame(
    name = character(0),
    std_name = character(0),
    type = character(0),
    preferred = logical(0),
    display_name = logical(0),
    languages = character(0),
    domains = character(0),
    uuid = character(0),
    date_retrieved = character(0),
    query = character(0),
    stringsAsFactors = FALSE
  )
}

# ---- Parse codes sub-resource -----------------------------------------------

#' Parse a GSRS substance /codes JSON array into a data frame
#'
#' @param resp An `httr2_response` object from `GET .../substances(<id>)/codes`.
#' @param query The original identifier used in the lookup (for the `query` col).
#' @return A data frame with code records, or a 0-row template on empty results.
#' @keywords internal
#' @noRd
parse_codes_response <- function(resp, query = NA_character_) {
  body <- httr2::resp_body_json(resp, simplifyVector = FALSE)

  if (!is.list(body) || length(body) == 0L) {
    return(empty_codes_df())
  }

  date_retrieved <- format(httr2::resp_date(resp))

  rows <- lapply(body, function(c_item) {
    data.frame(
      code_system = c_item[["codeSystem"]] %||% NA_character_,
      code = c_item[["code"]] %||% NA_character_,
      type = c_item[["type"]] %||% NA_character_,
      url = c_item[["url"]] %||% NA_character_,
      comments = c_item[["comments"]] %||% NA_character_,
      is_classification = isTRUE(c_item[["_isClassification"]]),
      uuid = c_item[["uuid"]] %||% NA_character_,
      date_retrieved = date_retrieved,
      query = query,
      stringsAsFactors = FALSE
    )
  })

  out <- do.call(rbind, rows)
  janitor::clean_names(out)
}

#' @keywords internal
#' @noRd
empty_codes_df <- function() {
  data.frame(
    code_system = character(0),
    code = character(0),
    type = character(0),
    url = character(0),
    comments = character(0),
    is_classification = logical(0),
    uuid = character(0),
    date_retrieved = character(0),
    query = character(0),
    stringsAsFactors = FALSE
  )
}

# ---- Parse structure sub-resource -------------------------------------------

#' Parse the structure object from a full GSRS substance JSON into a data frame
#'
#' @param resp An `httr2_response` object from `GET .../substances(<id>)`.
#' @param query The original identifier used in the lookup (for the `query` col).
#' @return A one-row data frame with chemical structure fields.
#' @keywords internal
#' @noRd
parse_structure_response <- function(resp, query = NA_character_) {
  body <- httr2::resp_body_json(resp, simplifyVector = FALSE)
  s <- body[["structure"]]

  if (is.null(s)) {
    return(empty_structure_df(query))
  }

  date_retrieved <- format(httr2::resp_date(resp))

  out <- data.frame(
    smiles           = s[["smiles"]]           %||% NA_character_,
    formula          = s[["formula"]]          %||% NA_character_,
    mwt              = s[["mwt"]]              %||% NA_real_,
    inchi_key        = s[["_inchiKey"]]        %||% NA_character_,
    inchi            = s[["_inchi"]]           %||% NA_character_,
    stereochemistry  = s[["stereochemistry"]]  %||% NA_character_,
    optical_activity = s[["opticalActivity"]]  %||% NA_character_,
    charge           = s[["charge"]]           %||% NA_integer_,
    stereo_centers   = s[["stereoCenters"]]    %||% NA_integer_,
    defined_stereo   = s[["definedStereo"]]    %||% NA_integer_,
    ez_centers       = s[["ezCenters"]]        %||% NA_integer_,
    molfile          = s[["molfile"]]          %||% NA_character_,
    date_retrieved   = date_retrieved,
    query            = query,
    stringsAsFactors = FALSE
  )
  janitor::clean_names(out)
}

#' @keywords internal
#' @noRd
empty_structure_df <- function(query = NA_character_) {
  data.frame(
    smiles           = NA_character_,
    formula          = NA_character_,
    mwt              = NA_real_,
    inchi_key        = NA_character_,
    inchi            = NA_character_,
    stereochemistry  = NA_character_,
    optical_activity = NA_character_,
    charge           = NA_integer_,
    stereo_centers   = NA_integer_,
    defined_stereo   = NA_integer_,
    ez_centers       = NA_integer_,
    molfile          = NA_character_,
    date_retrieved   = NA_character_,
    query            = query,
    stringsAsFactors = FALSE
  )
}

# ---- Parse hierarchy response -----------------------------------------------

#' Parse a GSRS /@hierarchy JSON array into a data frame
#'
#' @param resp An `httr2_response` object from `GET .../substances(<id>)/@hierarchy`.
#' @param query The original identifier used in the lookup (for the `query` col).
#' @return A data frame with one row per hierarchy node.
#' @keywords internal
#' @noRd
parse_hierarchy_response <- function(resp, query = NA_character_) {
  body <- httr2::resp_body_json(resp, simplifyVector = FALSE)

  if (!is.list(body) || length(body) == 0L) {
    return(empty_hierarchy_df())
  }

  date_retrieved <- format(httr2::resp_date(resp))

  rows <- lapply(body, function(node) {
    v <- node[["value"]] %||% list()
    data.frame(
      node_id         = node[["id"]]              %||% NA_character_,
      parent_id       = node[["parent"]]          %||% NA_character_,
      depth           = node[["depth"]]           %||% NA_integer_,
      type            = node[["type"]]            %||% NA_character_,
      text            = node[["text"]]            %||% NA_character_,
      expandable      = isTRUE(node[["expandable"]]),
      approval_id     = v[["approvalID"]]         %||% NA_character_,
      name            = v[["name"]]               %||% NA_character_,
      ref_uuid        = v[["refuuid"]]            %||% NA_character_,
      substance_class = v[["substanceClass"]]     %||% NA_character_,
      deprecated      = isTRUE(v[["deprecated"]]),
      date_retrieved  = date_retrieved,
      query           = query,
      stringsAsFactors = FALSE
    )
  })

  out <- do.call(rbind, rows)
  janitor::clean_names(out)
}

#' @keywords internal
#' @noRd
empty_hierarchy_df <- function() {
  data.frame(
    node_id         = character(0),
    parent_id       = character(0),
    depth           = integer(0),
    type            = character(0),
    text            = character(0),
    expandable      = logical(0),
    approval_id     = character(0),
    name            = character(0),
    ref_uuid        = character(0),
    substance_class = character(0),
    deprecated      = logical(0),
    date_retrieved  = character(0),
    query           = character(0),
    stringsAsFactors = FALSE
  )
}

# ---- Parse vocabularies response --------------------------------------------

#' Parse a GSRS /vocabularies paged JSON response into a data frame
#'
#' Each vocabulary has multiple terms; the result is one row per term.
#'
#' @param resp An `httr2_response` object from `GET /api/v1/vocabularies`.
#' @return A data frame (may have 0 rows).
#' @keywords internal
#' @noRd
parse_vocabularies_response <- function(resp) {
  body <- httr2::resp_body_json(resp, simplifyVector = FALSE)
  content <- body[["content"]]

  if (is.null(content) || length(content) == 0L) {
    return(empty_vocabularies_df())
  }

  date_retrieved <- format(httr2::resp_date(resp))

  rows <- lapply(content, function(vocab) {
    domain <- vocab[["domain"]] %||% NA_character_
    term_type <- vocab[["vocabularyTermType"]] %||% NA_character_
    editable <- isTRUE(vocab[["editable"]])
    filterable <- isTRUE(vocab[["filterable"]])
    terms <- vocab[["terms"]] %||% list()

    if (length(terms) == 0L) {
      return(data.frame(
        domain = domain, term_type = term_type,
        editable = editable, filterable = filterable,
        value = NA_character_, display = NA_character_,
        hidden = NA, selected = NA,
        date_retrieved = date_retrieved,
        stringsAsFactors = FALSE
      ))
    }

    term_rows <- lapply(terms, function(t) {
      data.frame(
        domain         = domain,
        term_type      = term_type,
        editable       = editable,
        filterable     = filterable,
        value          = t[["value"]]   %||% NA_character_,
        display        = t[["display"]] %||% NA_character_,
        hidden         = isTRUE(t[["hidden"]]),
        selected       = isTRUE(t[["selected"]]),
        date_retrieved = date_retrieved,
        stringsAsFactors = FALSE
      )
    })
    do.call(rbind, term_rows)
  })

  out <- do.call(rbind, rows)
  janitor::clean_names(out)
}

#' @keywords internal
#' @noRd
empty_vocabularies_df <- function() {
  data.frame(
    domain         = character(0),
    term_type      = character(0),
    editable       = logical(0),
    filterable     = logical(0),
    value          = character(0),
    display        = character(0),
    hidden         = logical(0),
    selected       = logical(0),
    date_retrieved = character(0),
    stringsAsFactors = FALSE
  )
}

# ---- NULL coalescing operator ------------------------------------------------

#' @keywords internal
#' @noRd
`%||%` <- function(x, y) if (is.null(x) || length(x) == 0L) y else x

# ---- write_dataframes_to_excel ----------------------------------------------

#' Write a named list of data frames to an Excel workbook
#'
#' Each element of `df_list` is written to its own sheet. Requires the
#' `openxlsx` package (listed in `Suggests`).
#'
#' @param df_list A named list of data frames.
#' @param filename Character string. Path to the output `.xlsx` file.
#' @return Invisible `filename`.
#' @export
#' @examples
#' \donttest{
#'   tmp <- tempfile(fileext = ".xlsx")
#'   write_dataframes_to_excel(list(sheet1 = mtcars, sheet2 = iris), tmp)
#' }
write_dataframes_to_excel <- function(df_list, filename) {
  if (!requireNamespace("openxlsx", quietly = TRUE)) {
    cli::cli_abort(
      "Package {.pkg openxlsx} is required. Install with:
       {.code install.packages('openxlsx')}"
    )
  }
  if (!is.list(df_list) || is.null(names(df_list))) {
    cli::cli_abort("{.arg df_list} must be a named list.")
  }
  wb <- openxlsx::createWorkbook()
  for (nm in names(df_list)) {
    openxlsx::addWorksheet(wb, sheetName = nm)
    openxlsx::writeData(wb, sheet = nm, x = df_list[[nm]])
  }
  openxlsx::saveWorkbook(wb, file = filename, overwrite = TRUE)
  invisible(filename)
}
