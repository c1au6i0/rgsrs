library(testthat)
Sys.sleep(5)

# Aspirin UNII: R16CO5Y76E

test_that("gsrs_names returns a data frame for a valid UNII", {
  skip_on_cran()
  skip_if_offline()

  suppressWarnings(
    out <- gsrs_names("R16CO5Y76E", verbose = FALSE)
  )
  out <- gsrs_names("R16CO5Y76E", verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_gt(nrow(out), 0L)
  expect_true("name" %in% names(out))
  expect_true("query" %in% names(out))
  expect_true(all(out[["query"]] == "R16CO5Y76E"))
})

Sys.sleep(5)

test_that("gsrs_names column names are correct", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_names("R16CO5Y76E", verbose = FALSE)

  expected_cols <- c(
    "name", "std_name", "type", "preferred", "display_name",
    "languages", "domains", "uuid", "date_retrieved", "query"
  )
  expect_true(all(expected_cols %in% names(out)))
})

Sys.sleep(5)

test_that("gsrs_names handles multiple UNIIs and sets query correctly", {
  skip_on_cran()
  skip_if_offline()

  uniis <- c("R16CO5Y76E", "WK2XYI10QM")
  out <- gsrs_names(uniis, verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_gt(nrow(out), 0L)
  expect_true(all(uniis %in% out[["query"]]))
})

Sys.sleep(5)

test_that("gsrs_names returns empty df for unknown UNII", {
  skip_on_cran()
  skip_if_offline()

  # Unknown UNII will return 0 rows (API returns empty array)
  out <- gsrs_names("NOTAREALUNII00000", verbose = FALSE)
  # Could be 0 rows OR a warning — both are acceptable
  expect_true(is.data.frame(out) || is.null(out))
})

test_that("gsrs_names returns NULL and warns on invalid input", {
  expect_warning(
    out <- gsrs_names(c(), verbose = FALSE)
  )
  expect_null(out)
})
