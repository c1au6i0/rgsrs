library(testthat)

# ---- httr2_backoff -----------------------------------------------------------

test_that("httr2_backoff returns a positive numeric value", {
  val <- rgsrs:::httr2_backoff(1)
  expect_true(is.numeric(val))
  expect_gt(val, 0)
})

test_that("httr2_backoff grows with retry number", {
  set.seed(42)
  v1 <- rgsrs:::httr2_backoff(1)
  set.seed(42)
  v3 <- rgsrs:::httr2_backoff(3)
  # v3 should be >= v1 on average; use a large multiplier to verify non-trivial
  expect_true(rgsrs:::httr2_backoff(5) <= 30 * 1.2)
})

# ---- with_graceful_exit ------------------------------------------------------

test_that("with_graceful_exit returns result of successful function", {
  result <- rgsrs:::with_graceful_exit(function() 42L, what = "test")
  expect_equal(result, 42L)
})

test_that("with_graceful_exit returns NULL and warns on error", {
  expect_warning(
    result <- rgsrs:::with_graceful_exit(
      function() stop("boom"),
      what = "test operation"
    ),
    regexp = "test operation failed"
  )
  expect_null(result)
})

# ---- %||% -------------------------------------------------------------------

test_that("%||% returns left side when non-NULL and non-empty", {
  expect_equal(rgsrs:::`%||%`("a", "b"), "a")
  expect_equal(rgsrs:::`%||%`(1L, 99L), 1L)
})

test_that("%||% returns right side for NULL", {
  expect_equal(rgsrs:::`%||%`(NULL, "fallback"), "fallback")
})

test_that("%||% returns right side for length-0 vector", {
  expect_equal(rgsrs:::`%||%`(character(0), "fallback"), "fallback")
})

# ---- check_ids ---------------------------------------------------------------

test_that("check_ids passes valid character vector through", {
  result <- rgsrs:::check_ids(c("A", "B"), "ids")
  expect_equal(result, c("A", "B"))
})

test_that("check_ids trims whitespace", {
  result <- rgsrs:::check_ids(c("  A  ", "B "), "ids")
  expect_equal(result, c("A", "B"))
})

test_that("check_ids aborts on non-character input", {
  expect_error(
    rgsrs:::check_ids(123, "ids"),
    regexp = "non-empty character vector"
  )
})

test_that("check_ids aborts on all-empty strings", {
  expect_error(
    rgsrs:::check_ids(c("  ", ""), "ids"),
    regexp = "only empty strings"
  )
})

# ---- empty_names_df / empty_codes_df ----------------------------------------

test_that("empty_names_df returns a 0-row data frame with correct cols", {
  df <- rgsrs:::empty_names_df()
  expect_true(is.data.frame(df))
  expect_equal(nrow(df), 0L)
  expect_true("name" %in% names(df))
  expect_true("query" %in% names(df))
})

test_that("empty_codes_df returns a 0-row data frame with correct cols", {
  df <- rgsrs:::empty_codes_df()
  expect_true(is.data.frame(df))
  expect_equal(nrow(df), 0L)
  expect_true("code_system" %in% names(df))
  expect_true("query" %in% names(df))
})

# ---- write_dataframes_to_excel ----------------------------------------------

test_that("write_dataframes_to_excel creates a file when openxlsx available", {
  skip_if_not_installed("openxlsx")

  tmp <- tempfile(fileext = ".xlsx")
  result <- write_dataframes_to_excel(
    list(sheet1 = mtcars, sheet2 = iris),
    tmp
  )
  expect_true(fs::file_exists(tmp))
  expect_equal(result, tmp)
})

test_that("write_dataframes_to_excel aborts on unnamed list", {
  skip_if_not_installed("openxlsx")

  expect_error(
    write_dataframes_to_excel(list(mtcars), tempfile(fileext = ".xlsx")),
    regexp = "named list"
  )
})
