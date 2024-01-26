library(httr)
library(jsonlite)
library(tibble)
library(dplyr)
library(tidyverse)
library(lubridate)
library(scales)
library(roxygen2)

get_plot <- function(data){
  #' Generate a Plot for Near Earth Objects (NEO) Data
  #'
  #' This function takes NEO data, processes it, and creates a scatter plot with
  #' information about the miss distance from Earth, estimated diameter, and color-coded
  #' by estimated diameter.
  #'
  #' @param data A list containing NEO data, typically retrieved from the NASA API.
  #'
  #' @return A ggplot2 object representing the scatter plot of NEO data.
  #'
  #' @examples
  #' # Assuming you have NEO data obtained from the NASA API
  #' neo_data <- get_neo('2023-01-01', '2023-01-07')
  #' plot <- get_plot(neo_data)
  #' print(plot)

  flat_list <- enframe(data$near_earth_objects, name = "date", value = "asteroids")
  neo_data <- flat_list %>%
    unnest(cols = c(asteroids)) %>%
    mutate(date = as.Date(date))
  
  flattened_close_approach_data <- enframe(neo_data$close_approach_data) %>% unnest(cols = c(value))
  flattened_close_approach_data$miss_distance$kilometers <- as.numeric(flattened_close_approach_data$miss_distance$kilometers)
  est_diameter_avg <- (neo_data$estimated_diameter$kilometers$estimated_diameter_max + neo_data$estimated_diameter$kilometers$estimated_diameter_min)/2
  
  neo_data <- neo_data %>%
    mutate(full_date = flattened_close_approach_data$close_approach_date_full) %>%
    mutate(miss_distance_km = flattened_close_approach_data$miss_distance$kilometers) %>%
    mutate(approach_velocity_km_per_h = flattened_close_approach_data$relative_velocity$kilometers_per_hour) %>%
    mutate(est_diameter_avg = est_diameter_avg)
  
  neo_data$full_date <- parse_date_time(neo_data$full_date, orders = "%Y-%b-%d %H:%M")
  neo_data$full_date <- as.POSIXct(neo_data$full_date)
  
  plot <- ggplot(neo_data, aes(x = full_date, y = miss_distance_km, size = est_diameter_avg, color = est_diameter_avg)) +
    geom_point() +
    ggtitle("Near Earth Objects") +
    labs(x = '', y = "Miss Distance from Earth (km)", size = 'Estimated Diameter', color = '') +
    theme(plot.title = element_text(hjust = 0.5)) +
    scale_x_datetime(
      labels = date_format("%Y-%m-%d %H:%M"),
      breaks = pretty_breaks(n = 5)
    ) +
    scale_y_continuous(
      labels = scales::comma_format(scale = 1, accuracy = 1),
      breaks = scales::pretty_breaks(n = 7)
    ) +
    scale_color_viridis_c(guide = guide_colorbar(reverse = TRUE))
  return(plot)
}


get_response <- function(start_date, end_date){
  #' Get API Response for Near Earth Objects (NEO) Data
  #'
  #' This function constructs a URL for the NASA NEO API, makes an HTTP GET request,
  #' and returns the response object.
  #'
  #' @param start_date A character string specifying the start date in 'YYYY-MM-DD' format.
  #' @param end_date A character string specifying the end date in 'YYYY-MM-DD' format.
  #'
  #' @return An HTTP response object containing the data retrieved from the NASA NEO API.
  #'
  #' @examples
  #' response <- get_response('2023-01-01', '2023-01-07')
  #' print(response)
  
  url <- "https://api.nasa.gov/neo/rest/v1/feed"
  # start_date <- '2015-09-07'
  # end_date <- '2015-09-12'
  api_key <- 'gEQLIrhs9YeVTGJR9cLQ3ywn4hjsJOO59oe70KVC'
  
  modified_url <- modify_url(url, query=list(start_date = start_date, end_date = end_date, api_key = api_key))
  response <- GET(modified_url)
  if (response$status_code == 200){
    return(response)
  }else {
    print('response$headers$`x-ratelimit-remaining`')
    return('Response status code not 200')
  }
}

check_date <- function(start_date, end_date) {
  #' Check Validity of Date Range
  #'
  #' This function checks the validity of a given date range by attempting to parse
  #' the start and end dates and verifying that the difference is 7 days or less.
  #'
  #' @param start_date A character string specifying the start date in 'YYYY-MM-DD' format.
  #' @param end_date A character string specifying the end date in 'YYYY-MM-DD' format.
  #'
  #' @return 'PASS' if the date range is valid; '7_d_fail' if the difference between
  #' start and end date is more than 7 days.
  #'
  #' @examples
  #' result <- check_date('2023-01-01', '2023-01-07')
  #' print(result) -> should pass because difference is 7 or less.

  tryCatch(
    {
      parsed_start_date <- as.Date(start_date)
      parsed_end_date <- as.Date(end_date)
      
      if (parsed_end_date - parsed_start_date > 7){
        print('Difference between start and end date must be 7 days or less.')
        return('7_d_fail')
      } else {
        return('PASS')
      }
      
    },
    error = function(e) {
      print('Date format should be in YYYY-MM-DD format.')
      warning("Invalid date format. Please enter a valid date.")
    }
  )
}


get_neo <- function(start_date, end_date){
  #' Get Near Earth Objects (NEO) Data and Plot
  #'
  #' This function retrieves Near Earth Objects (NEO) data for a specified date range,
  #' checks the validity of the date range, and plots the data if the request is successful.
  #'
  #' @param start_date A character string specifying the start date in 'YYYY-MM-DD' format.
  #' @param end_date A character string specifying the end date in 'YYYY-MM-DD' format.
  #'
  #' @return A plot of NEO data if the request is successful; otherwise, an error message.
  #'
  #' @examples
  #' get_neo('2023-01-01', '2023-01-07')

  check <- check_date(start_date, end_date)
  if (check == '7_d_fail'){
    print("Try another start and end date or check date format.")
    return('Request failed')
  }else {
    response <- get_response(start_date, end_date)
  }
  if (response$status_code == 200){
    data <- fromJSON(response$url)
    plot <- get_plot(data)
    print(plot)
    return(plot)
  }else {
    return("Failed")
  }
}



