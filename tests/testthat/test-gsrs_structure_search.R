library(testthat)
Sys.sleep(5)

# Aspirin SMILES: CC(=O)Oc1ccccc1C(=O)O
# Aspirin UNII:   R16CO5Y76E

test_that("gsrs_structure_search returns a data frame for exact match", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_structure_search(
    "CC(=O)Oc1ccccc1C(=O)O", type = "exact", verbose = FALSE
  )

  expect_true(is.data.frame(out))
  expect_gt(nrow(out), 0L)
  expect_true("query_smiles" %in% names(out))
})

Sys.sleep(2)

test_that("gsrs_structure_search exact match returns the correct substance", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_structure_search(
    "CC(=O)Oc1ccccc1C(=O)O", type = "exact", verbose = FALSE
  )

  expect_true(
    "R16CO5Y76E" %in% out[["approval_id"]],
    label = "Exact SMILES match for aspirin should return UNII R16CO5Y76E"
  )
  expect_equal(out[["query_smiles"]][[1]], "CC(=O)Oc1ccccc1C(=O)O")
})

Sys.sleep(2)

test_that("gsrs_structure_search similarity returns results including aspirin", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_structure_search(
    "CC(=O)Oc1ccccc1C(=O)O", type = "sim", cutoff = 0.9,
    top = 10, verbose = FALSE
  )

  expect_true(is.data.frame(out))
  expect_gt(nrow(out), 0L)
  expect_true("R16CO5Y76E" %in% out[["approval_id"]],
    label = "Similarity search at 0.9 cutoff should include aspirin itself")
})

Sys.sleep(2)

test_that("gsrs_structure_search respects top parameter", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_structure_search(
    "CC(=O)Oc1ccccc1C(=O)O", type = "sub", top = 3, verbose = FALSE
  )

  expect_lte(nrow(out), 3L)
})

Sys.sleep(2)

test_that("gsrs_structure_search column names are correct", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_structure_search(
    "CC(=O)Oc1ccccc1C(=O)O", type = "exact", verbose = FALSE
  )

  expected_cols <- c(
    "uuid", "approval_id", "preferred_name", "substance_class",
    "status", "definition_type", "definition_level", "version",
    "names_url", "codes_url", "self_url", "date_retrieved", "query_smiles"
  )
  expect_true(all(expected_cols %in% names(out)))
})

test_that("gsrs_structure_search aborts on invalid SMILES argument", {
  expect_warning(
    out <- gsrs_structure_search(123, verbose = FALSE)
  )
  expect_null(out)
})
