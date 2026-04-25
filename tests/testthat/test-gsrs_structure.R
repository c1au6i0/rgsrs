library(testthat)
Sys.sleep(5)

# Aspirin UNII: R16CO5Y76E  (MW ~180, formula C9H8O4)

test_that("gsrs_structure returns a data frame for a valid UNII", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_structure("R16CO5Y76E", verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_equal(nrow(out), 1L)
  expect_equal(out[["query"]], "R16CO5Y76E")
})

Sys.sleep(2)

test_that("gsrs_structure returns correct chemical data for aspirin", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_structure("R16CO5Y76E", verbose = FALSE)

  expect_false(is.na(out[["smiles"]]),    label = "SMILES should not be NA")
  expect_false(is.na(out[["formula"]]),   label = "formula should not be NA")
  expect_false(is.na(out[["mwt"]]),       label = "mwt should not be NA")
  expect_false(is.na(out[["inchi_key"]]), label = "InChIKey should not be NA")
  expect_false(is.na(out[["inchi"]]),     label = "InChI should not be NA")

  # Aspirin: C9H8O4, MW ~180
  expect_equal(out[["formula"]], "C9H8O4")
  expect_gt(out[["mwt"]], 179)
  expect_lt(out[["mwt"]], 181)

  # SMILES should contain the acetyl ester fragment
  expect_true(grepl("CC(=O)", out[["smiles"]], fixed = TRUE),
    label = "aspirin SMILES should contain acetyl group CC(=O)")
})

Sys.sleep(2)

test_that("gsrs_structure column names are correct", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_structure("R16CO5Y76E", verbose = FALSE)

  expected_cols <- c(
    "smiles", "formula", "mwt", "inchi_key", "inchi",
    "stereochemistry", "optical_activity", "charge",
    "stereo_centers", "defined_stereo", "ez_centers",
    "molfile", "date_retrieved", "query"
  )
  expect_true(all(expected_cols %in% names(out)))
})

Sys.sleep(2)

test_that("gsrs_structure handles multiple UNIIs", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_structure(c("R16CO5Y76E", "6M3C89ZY6R"), verbose = FALSE)

  expect_equal(nrow(out), 2L)
  expect_equal(out[["query"]], c("R16CO5Y76E", "6M3C89ZY6R"))
  expect_true(all(!is.na(out[["smiles"]])))
})

test_that("gsrs_structure returns NULL and warns on invalid input", {
  expect_warning(
    out <- gsrs_structure(123, verbose = FALSE)
  )
  expect_null(out)
})
