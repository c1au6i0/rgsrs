library(testthat)
Sys.sleep(5)

test_that("gsrs_unii_from_name resolves a known substance name", {
  skip_on_cran()
  skip_if_offline()

  suppressWarnings(
    out <- gsrs_unii_from_name("aspirin", verbose = FALSE)
  )
  out <- gsrs_unii_from_name("aspirin", verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_equal(nrow(out), 1L)
  expect_false(is.na(out[["unii"]]))
  expect_equal(out[["query"]], "aspirin")
})

Sys.sleep(5)

test_that("gsrs_unii_from_name column names are correct", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_unii_from_name("aspirin", verbose = FALSE)

  expected_cols <- c(
    "unii", "preferred_name", "substance_class",
    "status", "uuid", "date_retrieved", "query"
  )
  expect_equal(names(out), expected_cols)
})

Sys.sleep(5)

test_that("gsrs_unii_from_name handles multiple names", {
  skip_on_cran()
  skip_if_offline()

  nms <- c("aspirin", "ibuprofen")
  out <- gsrs_unii_from_name(nms, verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_equal(nrow(out), 2L)
  expect_equal(out[["query"]], nms)
  expect_true(all(!is.na(out[["unii"]])))
})

Sys.sleep(5)

test_that("gsrs_unii_from_name returns NA row for unresolvable name", {
  skip_on_cran()
  skip_if_offline()

  expect_warning(
    out <- gsrs_unii_from_name("XYZNOTAREALSUBSTANCE9999", verbose = TRUE),
    regexp = "No results found"
  )
  expect_true(is.data.frame(out))
  expect_equal(nrow(out), 1L)
  expect_true(is.na(out[["unii"]]))
  expect_equal(out[["query"]], "XYZNOTAREALSUBSTANCE9999")
})

test_that("gsrs_unii_from_name returns NULL and warns on invalid input", {
  expect_warning(
    out <- gsrs_unii_from_name(c(), verbose = FALSE)
  )
  expect_null(out)
})
