context("check errors")


test_that("check errors", {
  expect_error(formatData(), "")
})


test_that("check errors", {
  expect_error(getLikelihood(), "")
})
