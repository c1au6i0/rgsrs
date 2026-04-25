library(testthat)
Sys.sleep(5)

test_that("gsrs_unii_from_name resolves a known substance name", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_unii_from_name("aspirin", verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_equal(nrow(out), 1L)
  expect_false(is.na(out[["unii"]]))
  expect_equal(out[["query"]], "aspirin")
})

Sys.sleep(2)

test_that("gsrs_unii_from_name returns the correct UNII for known substances", {
  skip_on_cran()
  skip_if_offline()

  # Aspirin has a well-known UNII
  asp <- gsrs_unii_from_name("aspirin", verbose = FALSE)
  expect_equal(asp[["unii"]], "R16CO5Y76E",
    label = "aspirin should resolve to UNII R16CO5Y76E")

  Sys.sleep(2)

  # Nicotine: top hit may not have a UNII (GSRS ranking returns a concept first),
  # but the preferred_name should relate to nicotine
  nic <- gsrs_unii_from_name("nicotine", verbose = FALSE)
  expect_true(grepl("nicotine", nic[["preferred_name"]], ignore.case = TRUE),
    label = "nicotine preferred_name should contain 'nicotine'")
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

test_that("gsrs_unii_from_name returns NULL and warns on invalid input", {
  expect_warning(
    out <- gsrs_unii_from_name(c(), verbose = FALSE)
  )
  expect_null(out)
})
