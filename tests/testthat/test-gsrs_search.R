library(testthat)
Sys.sleep(5)

# Known good: aspirin search
test_that("gsrs_search returns a data frame for a valid query", {
  skip_on_cran()
  skip_if_offline()

  suppressWarnings(
    out <- gsrs_search("aspirin", top = 5, verbose = FALSE)
  )
  out <- gsrs_search("aspirin", top = 5, verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_gt(nrow(out), 0L)
  expect_true("approval_id" %in% names(out))
  expect_true("preferred_name" %in% names(out))
  expect_true("uuid" %in% names(out))
})

Sys.sleep(5)

test_that("gsrs_search column names are correct", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_search("aspirin", top = 3, verbose = FALSE)

  expected_cols <- c(
    "uuid", "approval_id", "preferred_name", "substance_class",
    "status", "definition_type", "definition_level", "version",
    "names_url", "codes_url", "self_url", "date_retrieved"
  )
  expect_true(all(expected_cols %in% names(out)))
})

Sys.sleep(5)

test_that("gsrs_search respects top parameter", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_search("aspirin", top = 2, verbose = FALSE)
  expect_lte(nrow(out), 2L)
})

Sys.sleep(5)

test_that("gsrs_search returns NULL and warns for bad query", {
  skip_on_cran()
  skip_if_offline()

  expect_warning(
    out <- gsrs_search("ZZZZNOTAREALSUBSTANCEXYZ9999", top = 1, verbose = FALSE),
    NA # no warning expected on NULL return, but 0-row DF is OK too
  )
  # Either NULL or a 0-row data frame is acceptable
  expect_true(is.null(out) || (is.data.frame(out) && nrow(out) == 0L))
})

test_that("gsrs_search aborts on invalid query argument", {
  expect_warning(
    out <- gsrs_search(123, top = 1, verbose = FALSE)
  )
  expect_null(out)
})
