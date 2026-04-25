library(testthat)
Sys.sleep(5)

# Aspirin UNII: R16CO5Y76E

test_that("gsrs_hierarchy returns a data frame for a valid UNII", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_hierarchy("R16CO5Y76E", verbose = FALSE)

  expect_true(is.data.frame(out))
  expect_gt(nrow(out), 0L)
  expect_equal(out[["query"]][[1]], "R16CO5Y76E")
})

Sys.sleep(2)

test_that("gsrs_hierarchy returns correct data for aspirin", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_hierarchy("R16CO5Y76E", verbose = FALSE)

  # Root node (depth 0) should be aspirin itself
  root <- out[out[["depth"]] == 0L, ]
  expect_gt(nrow(root), 0L)
  expect_true(
    "R16CO5Y76E" %in% root[["approval_id"]],
    label = "Root node should be aspirin (R16CO5Y76E)"
  )
})

Sys.sleep(2)

test_that("gsrs_hierarchy column names are correct", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_hierarchy("R16CO5Y76E", verbose = FALSE)

  expected_cols <- c(
    "node_id", "parent_id", "depth", "type", "text", "expandable",
    "approval_id", "name", "ref_uuid", "substance_class",
    "deprecated", "date_retrieved", "query"
  )
  expect_true(all(expected_cols %in% names(out)))
})

test_that("gsrs_hierarchy returns NULL and warns on invalid input", {
  expect_warning(
    out <- gsrs_hierarchy(123, verbose = FALSE)
  )
  expect_null(out)
})
