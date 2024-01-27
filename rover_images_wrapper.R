#' Get Mars Rover Image URL
#'
#' This function retrieves the URL of the first image taken by a specified camera on a specified Mars rover at a given date. It uses the Mars Rover Photos API provided by NASA.
#'
#' @param rover The name of the Mars rover. Valid options are "curiosity", "opportunity", and "spirit".
#' @param camera The camera code from which the image was taken. For "curiosity": FHAZ, RHAZ, MAST, CHEMCAM, MAHLI, MARDI, NAVCAM. For "opportunity" and "spirit": FHAZ, RHAZ, NAVCAM, PANCAM, MINITES.
#' @param date The Earth date when the photo was taken, in "YYYY-MM-DD" format.
#'
#' @return The function returns the URL of the first image matching the given parameters. If no image is found or if there is an error in the API request, it returns an appropriate message.
#'
#' @examples
#' get_mars_rover_image("curiosity", "fhaz", "2023-01-01")
#'
#' @note This function requires an internet connection to access the NASA API and a valid API key embedded in the function.
#' @export
#'
#' @import httr
#' @import jsonlite
#'
get_mars_rover_image <- function(rover, camera, date) {
  base_url <- "https://api.nasa.gov/mars-photos/api/v1/rovers"
  full_url <- paste0(base_url, "/", rover, "/photos?earth_date=", date, "&camera=", camera, "&api_key=mzKhYxF0D1G65hbU7LBryQRTsZvzma5No7JsVA4k")
  response <- GET(full_url)
  
  if (status_code(response) != 200) {
    return("Error in API request")
  }
  
  data <- fromJSON(content(response, "text"), flatten = TRUE)
  
  if (nrow(data$photos) > 0) {
    return(data$photos$img_src[1])
  } else {
    return("No image found for the given date and camera")
  }
}

# Example usage
#img_link <- get_mars_rover_image("curiosity", "fhaz", "2023-01-01")
#print(img_link)

