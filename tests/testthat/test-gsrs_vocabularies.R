library(testthat)
Sys.sleep(5)

test_that("gsrs_vocabularies returns a data frame", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_vocabularies(verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_gt(nrow(out), 0L)
})

Sys.sleep(2)

test_that("gsrs_vocabularies column names are correct", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_vocabularies(verbose = FALSE)

  expected_cols <- c(
    "domain", "term_type", "editable", "filterable",
    "value", "display", "hidden", "selected", "date_retrieved"
  )
  expect_true(all(expected_cols %in% names(out)))
})

Sys.sleep(2)

test_that("gsrs_vocabularies contains expected domains", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_vocabularies(verbose = FALSE)
  domains <- unique(out[["domain"]])

  # NAME_TYPE is a core vocabulary domain that should always be present
  expect_true(
    "NAME_TYPE" %in% domains,
    label = "NAME_TYPE domain should be present in vocabularies"
  )
})

Sys.sleep(2)

test_that("gsrs_vocabularies NAME_TYPE contains known values", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_vocabularies(verbose = FALSE)
  name_types <- out[out[["domain"]] == "NAME_TYPE", "value"]

  # 'cn' (common name) and 'sys' (systematic) are standard GSRS name types
  expect_true("cn" %in% name_types,
    label = "'cn' (common name) should be a NAME_TYPE value")
  expect_true("sys" %in% name_types,
    label = "'sys' (systematic) should be a NAME_TYPE value")
})
