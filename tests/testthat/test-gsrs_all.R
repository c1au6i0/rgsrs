library(testthat)
Sys.sleep(5)

test_that("gsrs_all returns a named list with correct elements", {
  skip_on_cran()
  skip_if_offline()

  suppressWarnings(
    out <- gsrs_all("R16CO5Y76E", verbose = FALSE)
  )
  out <- gsrs_all("R16CO5Y76E", verbose = FALSE)

  expect_true(is.list(out))
  expect_equal(names(out), c("substance", "names", "codes"))
})

Sys.sleep(5)

test_that("gsrs_all substance element has correct structure", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_all("R16CO5Y76E", verbose = FALSE)

  expect_true(is.data.frame(out$substance))
  expect_equal(nrow(out$substance), 1L)
  expect_equal(out$substance[["query"]], "R16CO5Y76E")
})

Sys.sleep(5)

test_that("gsrs_all names element has correct structure", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_all("R16CO5Y76E", verbose = FALSE)

  expect_true(is.data.frame(out$names))
  expect_gt(nrow(out$names), 0L)
  expect_true("name" %in% names(out$names))
  expect_true("query" %in% names(out$names))
})

Sys.sleep(5)

test_that("gsrs_all codes element has correct structure", {
  skip_on_cran()
  skip_if_offline()

  out <- gsrs_all("R16CO5Y76E", verbose = FALSE)

  expect_true(is.data.frame(out$codes))
  expect_gt(nrow(out$codes), 0L)
  expect_true("code_system" %in% names(out$codes))
  expect_true("query" %in% names(out$codes))
})

test_that("gsrs_all returns NULL and warns on invalid input", {
  expect_warning(
    out <- gsrs_all(c(), verbose = FALSE)
  )
  expect_null(out)
})
