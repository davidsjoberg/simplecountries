library(testthat)
test_that("simple_country_name works", {
  expect_equal(simple_country_name("Czech"), "Czechia")
  expect_equal(simple_country_name(c("Czech", "Great Britain", "great britain")), c("Czechia", "United Kingdom", "United Kingdom"))
  expect_equal(simple_country_name(c("Czech", NA, "great britain")), c("Czechia", NA, "United Kingdom"))
  expect_equal(simple_country_name(c("Frankrike", NA, "us")), c("France", NA, "United States"))

  expect_warning(simple_country_name(c("Czech", "Great Britain", "abc123")))
  expect_error(simple_country_name(c(1, 2, 3)))
})
