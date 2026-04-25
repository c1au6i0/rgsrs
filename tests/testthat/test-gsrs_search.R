library(testthat)
Sys.sleep(5)

# Known good: aspirin search
test_that("gsrs_search returns a data frame for a valid query", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_search("aspirin", top = 5, verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_gt(nrow(out), 0L)
  expect_true("approval_id" %in% names(out))
  expect_true("preferred_name" %in% names(out))
  expect_true("uuid" %in% names(out))
})

Sys.sleep(2)

test_that("gsrs_search results match the query - aspirin", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_search("aspirin", top = 5, verbose = FALSE)

  # At least one result should be aspirin itself (UNII R16CO5Y76E)
  expect_true(
    "R16CO5Y76E" %in% out[["approval_id"]],
    label = "Aspirin UNII R16CO5Y76E should appear in search results"
  )
  # Results should contain aspirin-related names
  names_lower <- tolower(out[["preferred_name"]])
  expect_true(any(grepl("aspirin", names_lower)))
})

Sys.sleep(2)

test_that("gsrs_search results match the query - nicotine", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_search("nicotine", top = 5, verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_gt(nrow(out), 0L)
  names_lower <- tolower(out[["preferred_name"]])
  expect_true(any(grepl("nicotine", names_lower)))
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

test_that("gsrs_search aborts on invalid query argument", {
  expect_warning(
    out <- gsrs_search(123, top = 1, verbose = FALSE)
  )
  expect_null(out)
})
