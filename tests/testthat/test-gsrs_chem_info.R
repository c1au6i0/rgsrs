library(testthat)
Sys.sleep(5)

# ---- Helper constants --------------------------------------------------------
ASPIRIN_UNII    <- "R16CO5Y76E"
ASPIRIN_CAS     <- "50-78-2"
ASPIRIN_INCHIKEY <- "BSYNRYMUTXBXSQ-UHFFFAOYSA-N"
ASPIRIN_SMILES  <- "CC(=O)Oc1ccccc1C(=O)O"
ASPIRIN_FORMULA <- "C9H8O4"

EXPECTED_COLS <- c(
  "query", "type", "unii", "preferred_name", "substance_class",
  "smiles", "formula", "mwt", "inchi_key", "inchi",
  "stereochemistry", "optical_activity", "charge",
  "stereo_centers", "defined_stereo", "ez_centers",
  "molfile", "date_retrieved"
)

# ---- type = "name" -----------------------------------------------------------

test_that("gsrs_chem_info resolves by name and returns structure data", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_chem_info("aspirin", type = "name", verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_equal(nrow(out), 1L)
  expect_equal(out[["query"]], "aspirin")
  expect_equal(out[["type"]], "name")
  expect_equal(out[["unii"]], ASPIRIN_UNII)
  expect_false(is.na(out[["smiles"]]))
  expect_equal(out[["formula"]], ASPIRIN_FORMULA)
})

Sys.sleep(5)

# ---- type = "cas" ------------------------------------------------------------

test_that("gsrs_chem_info resolves by CAS and returns structure data", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_chem_info(ASPIRIN_CAS, type = "cas", verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_equal(nrow(out), 1L)
  expect_equal(out[["query"]], ASPIRIN_CAS)
  expect_equal(out[["type"]], "cas")
  expect_equal(out[["unii"]], ASPIRIN_UNII)
  expect_false(is.na(out[["smiles"]]))
})

Sys.sleep(5)

# ---- type = "unii" -----------------------------------------------------------

test_that("gsrs_chem_info resolves by UNII directly", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_chem_info(ASPIRIN_UNII, type = "unii", verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_equal(nrow(out), 1L)
  expect_equal(out[["query"]], ASPIRIN_UNII)
  expect_equal(out[["type"]], "unii")
  expect_equal(out[["unii"]], ASPIRIN_UNII)
  expect_equal(out[["formula"]], ASPIRIN_FORMULA)
  expect_false(is.na(out[["smiles"]]))
})

Sys.sleep(5)

# ---- type = "inchikey" -------------------------------------------------------

test_that("gsrs_chem_info resolves by InChIKey and returns structure data", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_chem_info(ASPIRIN_INCHIKEY, type = "inchikey", verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_equal(nrow(out), 1L)
  expect_equal(out[["query"]], ASPIRIN_INCHIKEY)
  expect_equal(out[["type"]], "inchikey")
  expect_equal(out[["unii"]], ASPIRIN_UNII)
  expect_false(is.na(out[["smiles"]]))
})

Sys.sleep(5)

# ---- type = "smiles" ---------------------------------------------------------

test_that("gsrs_chem_info resolves by SMILES (exact) and returns structure data", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_chem_info(ASPIRIN_SMILES, type = "smiles", verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_equal(nrow(out), 1L)
  expect_equal(out[["query"]], ASPIRIN_SMILES)
  expect_equal(out[["type"]], "smiles")
  expect_equal(out[["unii"]], ASPIRIN_UNII)
  expect_false(is.na(out[["formula"]]))
})

Sys.sleep(5)

# ---- column names ------------------------------------------------------------

test_that("gsrs_chem_info returns the correct column names", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_chem_info("aspirin", type = "name", verbose = FALSE)
  expect_equal(names(out), EXPECTED_COLS)
})

Sys.sleep(5)

# ---- multiple identifiers ----------------------------------------------------

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

# ---- unresolved identifier ---------------------------------------------------

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

# ---- empty input -------------------------------------------------------------

test_that("gsrs_chem_info returns NULL and warns on empty input", {
  expect_warning(
    out <- gsrs_chem_info(c(), type = "name", verbose = FALSE)
  )
  expect_null(out)
})
