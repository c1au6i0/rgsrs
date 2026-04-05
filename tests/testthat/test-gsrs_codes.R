library(testthat)
Sys.sleep(5)

# Aspirin UNII: R16CO5Y76E

test_that("gsrs_codes returns a data frame for a valid UNII", {
  skip_on_cran()
  skip_if_offline()

  suppressWarnings(
    out <- gsrs_codes("R16CO5Y76E", verbose = FALSE)
  )
  out <- gsrs_codes("R16CO5Y76E", verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_gt(nrow(out), 0L)
  expect_true("code_system" %in% names(out))
  expect_true("code" %in% names(out))
  expect_true("query" %in% names(out))
  expect_true(all(out[["query"]] == "R16CO5Y76E"))
})

Sys.sleep(5)

test_that("gsrs_codes column names are correct", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_codes("R16CO5Y76E", verbose = FALSE)

  expected_cols <- c(
    "code_system", "code", "type", "url", "comments",
    "is_classification", "uuid", "date_retrieved", "query"
  )
  expect_true(all(expected_cols %in% names(out)))
})

Sys.sleep(5)

test_that("gsrs_codes filters by code_system correctly", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_codes("R16CO5Y76E", code_system = "CAS", verbose = FALSE)

  expect_true(is.data.frame(out))
  if (nrow(out) > 0L) {
    expect_true(all(toupper(out[["code_system"]]) == "CAS"))
  }
})

Sys.sleep(5)

test_that("gsrs_codes handles multiple UNIIs", {
  skip_on_cran()
  skip_if_offline()

  uniis <- c("R16CO5Y76E", "WK2XYI10QM")
  out <- gsrs_codes(uniis, verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_gt(nrow(out), 0L)
  expect_true(all(uniis %in% out[["query"]]))
})

test_that("gsrs_codes returns NULL and warns on invalid input", {
  expect_warning(
    out <- gsrs_codes(123, verbose = FALSE)
  )
  expect_null(out)
})
