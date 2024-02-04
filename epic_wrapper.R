library(httr)
library(jsonlite)
library(leaflet)
library(htmltools)

api_key <- 'fVnQw6kAGUfwkaLWnhgmNmW7S6SxVx4E27oJgDG9'


get_metadata <- function(type='natural', date = NULL){
    #' Get metadata from DSCOVR: EPIC API
    #' 
    #' This function constructs a URL for DSCOVR: EPIC API, makes an HTTP GET request,
    #' and returns the response object.
    #'
    #' @param type A character string specifying the type of image to get info on.
    #' Deafult is 'natural'. Other options are 'enhanced', 'aerosol', and 'cloud'
    #' @param date A character string specifying the date of image 'YYYY-MM-DD' format.
    #' Default is NULL and will return info for the most recent image.
    #'
    #' @return A JSON response object containing the data retrieved from the DSCOVR: EPIC API.
    #'
    #' @examples
    #' data <- get_metadata('natural', '2023-01-07')
    #' print(response)

  base_url <- paste("https://api.nasa.gov/EPIC/api/", type, sep = '')
  # Construct the URL
  url <- ifelse(is.null(date), base_url, paste0(base_url, "/date/", date))
  
  # Make the API request
  response <- GET(url, query = list(api_key = api_key))
  
  # Check for successful response
  if (response$status_code == 200){
    # Parse the JSON response
    data <- fromJSON(content(response, "text", encoding = "UTF-8"))
    return(data)
  }else {
    return('Response status code not 200')
  }
}

get_image_urls <- function(type='natural', date = NULL){
    #' Get list of image urls from DSCOVR: EPIC API
    #' 
    #' This function retrieves metadata from DSCOVR: EPIC API, 
    #' constructs the urls to access each image from the specified date
    #' and returns the urls in a list.
    #'
    #' @param type A character string specifying the type of image to get info on.
    #' Deafult is 'natural'. Other options are 'enhanced', 'aerosol', and 'cloud'
    #' @param date A character string specifying the date of image 'YYYY-MM-DD' format.
    #' Default is NULL and will return info for the most recent image.
    #'
    #' @return A list of urls to access images from the DSCOVR: EPIC API.
    #'
    #' @examples
    #' image_urls <- get_image_urls('natural', '2023-01-07')

  data <- get_metadata(type, date)
  year <- substr(data$date, 1, 4)
  month <- substr(data$date, 6, 7)
  day <- substr(data$date, 9, 10)
  image_urls <- paste('https://epic.gsfc.nasa.gov/archive', type, year, month, day, 'png', data$image, sep = '/')
  image_urls <- paste(image_urls, '.png', sep = '')
  return(image_urls)
}

plot_centroids <- function(type='natural', date = NULL){
    #' Generate a plot of centroid locations for images from
    #' the DSCOVR: EPIC API
    #' 
    #' This function retrieves metadata from DSCOVR: EPIC API, 
    #' and plots the centroids of each image taken from the the specified date
    #' on a map of Earth.
    #'
    #' @param type A character string specifying the type of image to get info on.
    #' Deafult is 'natural'. Other options are 'enhanced', 'aerosol', and 'cloud'
    #' @param date A character string specifying the date of image 'YYYY-MM-DD' format.
    #' Default is NULL and will return info for the most recent image.
    #'
    #' @return A leaflet plot of Earth with centroids of each image plotted
    #'
    #' @examples
    #' plot <- plot_centroids('natural', '2023-01-07')


  data <- get_metadata(type, date)
  df <- data.frame(longitude = data$centroid_coordinates$lon, 
                 latitude = data$centroid_coordinates$lat,
                 name = data$image)
  
  leaflet(df) %>% addTiles() %>% addMarkers(~longitude, ~latitude, label = ~htmlEscape(name))
}