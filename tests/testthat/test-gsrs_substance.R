library(testthat)
Sys.sleep(5)

# Aspirin UNII: R16CO5Y76E
# Ibuprofen UNII: WK2XYI10QM

test_that("gsrs_substance returns a data frame for a valid UNII", {
  skip_on_cran()
  skip_if_offline()

  suppressWarnings(
    out <- gsrs_substance("R16CO5Y76E", verbose = FALSE)
  )
  out <- gsrs_substance("R16CO5Y76E", verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_equal(nrow(out), 1L)
  expect_equal(out[["query"]], "R16CO5Y76E")
  expect_false(is.na(out[["approval_id"]]))
})

Sys.sleep(5)

test_that("gsrs_substance handles multiple UNIIs", {
  skip_on_cran()
  skip_if_offline()

  uniis <- c("R16CO5Y76E", "WK2XYI10QM")
  out <- gsrs_substance(uniis, verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_equal(nrow(out), 2L)
  expect_equal(out[["query"]], uniis)
})

Sys.sleep(5)

test_that("gsrs_substance returns NA row for unknown UNII", {
  skip_on_cran()
  skip_if_offline()

  expect_warning(
    out <- gsrs_substance("NOTAREALUNII00000", verbose = TRUE),
    regexp = "No results found"
  )
  expect_true(is.data.frame(out))
  expect_equal(nrow(out), 1L)
  expect_true(is.na(out[["approval_id"]]))
  expect_equal(out[["query"]], "NOTAREALUNII00000")
})

Sys.sleep(5)

test_that("gsrs_substance column names are correct", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_substance("R16CO5Y76E", verbose = FALSE)
  expected_cols <- c(
    "uuid", "approval_id", "preferred_name", "substance_class",
    "status", "definition_type", "definition_level", "version",
    "names_url", "codes_url", "self_url", "date_retrieved", "query"
  )
  expect_true(all(expected_cols %in% names(out)))
})

test_that("gsrs_substance returns NULL and warns on invalid input", {
  expect_warning(
    out <- gsrs_substance(123, verbose = FALSE)
  )
  expect_null(out)
})
