library(testthat)
Sys.sleep(5)

test_that("gsrs_browse returns a data frame", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_browse(top = 5, verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_gt(nrow(out), 0L)
})

Sys.sleep(2)

test_that("gsrs_browse respects top parameter", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_browse(top = 3, verbose = FALSE)

  expect_lte(nrow(out), 3L)
})

Sys.sleep(2)

test_that("gsrs_browse column names are correct", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_browse(top = 2, verbose = FALSE)

  expected_cols <- c(
    "uuid", "approval_id", "preferred_name", "substance_class",
    "status", "definition_type", "definition_level", "version",
    "names_url", "codes_url", "self_url", "date_retrieved"
  )
  expect_true(all(expected_cols %in% names(out)))
})

Sys.sleep(2)

test_that("gsrs_browse skip parameter offsets results", {
  skip_on_cran()
  skip_if_offline()

  out_a <- gsrs_browse(top = 2, skip = 0, verbose = FALSE)
  out_b <- gsrs_browse(top = 2, skip = 2, verbose = FALSE)

  # First record of page 2 should differ from first record of page 1
  expect_false(
    identical(out_a[["uuid"]][[1]], out_b[["uuid"]][[1]]),
    label = "skip should return different records"
  )
})
