library(testthat)
Sys.sleep(5)

test_that("gsrs_chem_info resolves a name and returns structure data", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_chem_info("aspirin", type = "name", verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_equal(nrow(out), 1L)
  expect_equal(out[["query"]], "aspirin")
  expect_equal(out[["type"]], "name")
  expect_equal(out[["unii"]], "R16CO5Y76E")
  expect_false(is.na(out[["smiles"]]))
  expect_false(is.na(out[["formula"]]))
  expect_false(is.na(out[["mwt"]]))
})

Sys.sleep(5)

test_that("gsrs_chem_info resolves a CAS number and returns structure data", {
  skip_on_cran()
  skip_if_offline()

  # CAS 50-78-2 = aspirin
  out <- gsrs_chem_info("50-78-2", type = "cas", verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_equal(nrow(out), 1L)
  expect_equal(out[["query"]], "50-78-2")
  expect_equal(out[["type"]], "cas")
  expect_equal(out[["unii"]], "R16CO5Y76E")
  expect_false(is.na(out[["smiles"]]))
})

Sys.sleep(5)

test_that("gsrs_chem_info column names are correct", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_chem_info("aspirin", type = "name", verbose = FALSE)

  expected_cols <- c(
    "query", "type", "unii", "preferred_name", "substance_class",
    "smiles", "formula", "mwt", "inchi_key", "inchi",
    "stereochemistry", "optical_activity", "charge",
    "stereo_centers", "defined_stereo", "ez_centers",
    "molfile", "date_retrieved"
  )
  expect_equal(names(out), expected_cols)
})

Sys.sleep(5)

test_that("gsrs_chem_info handles multiple identifiers", {
  skip_on_cran()
  skip_if_offline()

  ids <- c("aspirin", "ibuprofen")
  out <- gsrs_chem_info(ids, type = "name", verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_equal(nrow(out), 2L)
  expect_equal(out[["query"]], ids)
  expect_true(all(!is.na(out[["unii"]])))
  expect_true(all(!is.na(out[["smiles"]])))
})

Sys.sleep(5)

test_that("gsrs_chem_info returns NA row for unresolved identifier", {
  skip_on_cran()
  skip_if_offline()

  out <- suppressWarnings(
    gsrs_chem_info("ZZZNOT_A_REAL_SUBSTANCE_XYZ", type = "name", verbose = FALSE)
  )

  expect_true(is.data.frame(out))
  expect_equal(nrow(out), 1L)
  expect_true(is.na(out[["unii"]]))
  expect_true(is.na(out[["smiles"]]))
})

Sys.sleep(2)

test_that("gsrs_chem_info returns NULL and warns on empty input", {
  expect_warning(
    out <- gsrs_chem_info(c(), type = "name", verbose = FALSE)
  )
  expect_null(out)
})
