library(testthat)
source("neo_function_wrapper.R")
source("rover_images_wrapper_module.r")

# check_date function test cases
test_that("Valid date range returns PASS", {
  result <- check_date('2023-01-01', '2023-01-07')
  expect_equal(result, 'PASS')
})

test_that("Date range with difference > 7 days returns 7_d_fail", {
  result <- check_date('2023-01-01', '2023-01-15')
  expect_equal(result, '7_d_fail')
})

test_that("Date range with difference = 7 days returns PASS", {
  result <- check_date('2023-01-01', '2023-01-08')
  expect_equal(result, 'PASS')
})

test_that("Date range with difference < 7 days returns PASS", {
  result <- check_date('2023-01-01', '2023-01-06')
  expect_equal(result, 'PASS')
})

# get_response test cases
test_that("Valid API response returns status code 200", {
  response <- get_response('2023-01-01', '2023-01-07')
  expect_equal(response$status_code, 200)
})

test_that("Invalid date range returns status code not 200", {
  response <- get_response('2023-01-15', '2023-01-25')
  expect_equal(response, 'Response status code not 200')
})

# get_plot test case
test_that("get_plot generates a ggplot object", {
  response <- get_response('2023-01-01', '2023-01-07')
  data <- fromJSON(response$url)
  plot <- get_plot(data)
  expect_is(plot, "gg")  
})

# get_neo functiont tests
test_that("get_neo returns a ggplot object for a valid date range", {
  get_plot <- function(data) {
    return(ggplot2::ggplot() + ggplot2::geom_point())  # Stubbing, as we are focusing on testing get_neo
  }
  result <- get_neo('2023-01-01', '2023-01-07')
  expect_true(inherits(result, 'gg'))
})

test_that("check_input returns TRUE for valid inputs", {
  expect_true(check_input("curiosity", "fhaz", "2023-01-01"))
})

test_that("check_input stops for invalid rover name", {
  expect_error(check_input("invalid_rover", "fhaz", "2023-01-01"), "Invalid rover name")
})

test_that("get_api_response returns a response object for valid inputs", {
  response <- get_api_response("curiosity", "fhaz", "2023-01-01")
  expect_true(inherits(response, "response"))
  expect_equal(status_code(response), 200)
})

test_that("get_mars_rover_image_url returns a URL for valid inputs", {
  url <- get_mars_rover_image_url("curiosity", "fhaz", "2023-01-01")
  expect_true(grepl("http", url))
})

