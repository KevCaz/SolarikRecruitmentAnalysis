library(letiRmisc)
context("format Data")


test_that("check errors", {
  expect_error(formatData(), "")
})
