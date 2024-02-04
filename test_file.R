library(testthat)
source("neo_function_wrapper.R")

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

source("epic_wrapper.R")

# get_metadata test cases
test_that("Invalid API response returns error message", {
  data <- get_metadata('notarealtype', '2023-01-07')
  expect_equal(response, 'Response status code not 200')
})

test_that("Valid API response returns metadata", {
  data <- get_metadata('natural', '2023-01-07')
  expect_equal(typeof(data), 'list')
  expect_equal(typeof(data$image), 'character')  
})

# get_urls test cases
test_that("EPIC url list works as expected for natural", {
  url_list <- get_image_urls('natural', '2023-01-07')
  expect_equal(url_list[1], 'https://epic.gsfc.nasa.gov/archive/natural/2023/01/07/png/epic_1b_20230107004554.png')
})

test_that("EPIC url list works as expected for cloud", {
  url_list <- get_image_urls('cloud', '2023-01-07')
  expect_equal(url_list[1], "https://epic.gsfc.nasa.gov/archive/cloud/2023/01/07/png/epic_cloudfraction_20230107004554.png")
})

#plot_centroids test case
test_that('plot_centroids returns a leaflet plot', {
  centroid_plot <- get_centroids('natural', '2023-01-07')
  expect_is(centroid_plot, 'leaflet')
})
