[![r_test](https://github.com/Dhunsheth/nasa_R_wrapper/actions/workflows/r_test.yml/badge.svg?branch=main)](https://github.com/Dhunsheth/nasa_R_wrapper/actions/workflows/r_test.yml)

# NASA NEO Function Documentation

This document provides a guide on using the `get_neo` function, which interacts with the NASA Near Earth Object (NEO) API to retrieve NEO data for a specified date range.

## 1. Importing the Function

To use the `get_neo` function, you first need to import the R script where the function is defined. If the script is named "neo_function_wrapper.R" and is in the same directory, use the following:

`source("neo_function_wrapper.R")`

If the script is in another directory, include the file path in addition to the file name.

## 2. Using the get_neo Function

Call the `get_neo(start_date, end_date)` function to retrieve NEO data. The function requires two parameters:

- **start_date:** Start date in 'YYYY-MM-DD' format.    
- **end_date:** End date in 'YYYY-MM-DD' format.    

**Note:** The difference between the start and end date must be 7 days or less. Otherwise, an error will occur.   

Ex: `neo_data <- get_neo('2023-01-01', '2023-01-07')`    

`print(neo_data)` will output the plot if it was not done by default.  

## 3. Additional Analysis    

All data is returned by the function, and additional analysis can be performed by accessing the `neo_data$data` attribute. Asteroid-specific information can be retrieved using `neo_data$data$links`.

## Conclusion   

Following these steps allows you to interact with the NASA NEO API and retrieve relevant data for analysis. Make sure to adhere to the date range limitations to ensure a successful API request.


# NASA DSCOVR: EPIC wrapper Documentation

This document provides a guide for using the `get_image_urls` and `plot_centroids` functions, which interact with the NASA DSCOVR Earth Polychromatic Imaging Camera (EPIC) API to imagery of the Earth from the DSCOVR instrument.

## 1. Importing the Function

To use the functions, you first need to import the R script where the function is defined. If the script is named "epic_wrapper.R" and is in the same directory, use the following:

`source("epic_wrapper.R")`

If the script is in another directory, include the file path in addition to the file name.

## 2. Using the get_image_urls Function
  
Once the script has been successfully imported, call the `get_image_urls(type, date)` function and pass the type of images you want to view and the date.

**Type:** 
If no type is provided the default will be 'natural'. Other types include 'enhanced', 'aerosol', and 'cloud'. 

**Date:**
If no date is provided the default date is the most recent date with available images. Format should be 'YYYY-MM-DD'.

The function returns a list of urls to access the images on a browser. 

Ex: `image_list <- get_image_urls('natural', '2024-01-01')`    

Here are examples of the other types of images:

`images_enhanced <- get_image_urls('enhanced', '2024-01-01')`

`images_aerosol <- get_image_urls('aerosol', '2024-01-01')`

`images_cloud <- get_image_urls('cloud', '2024-01-01')`

## 3. Using the get_image_urls Function

We can get an idea of the scope of each image taken on a given day by plotting the centroids of each image in the set. Call the `plot_centroids(type, date)` function with the same parameters as before.

Ex: `plot_centroids('natural', '2024-01-01')`

# NASA Rover Images Function
## Importing the Function

In order to call the function, we must import the R script where the function is defined ("rover_images_wrapper_module").

`source("../rover_images_wrapper_module.R")`

If you are in another directory, you must also add the file path where this script is located in addition to the file name.

## Using 'get_mars_rover_image_url(rover, camera, date)' Function

**Format of camera:** FHAZ, RHAZ, MAST, CHEMCAM, MAHLI, MARDI, NAVCAM. For "opportunity" and "spirit": FHAZ, RHAZ, NAVCAM, PANCAM, MINITES.

**Format of rover:** "curiosity", "opportunity", and "spirit"

**Format of date:** YYYY-MM-DD

Example: `img_link <- get_mars_rover_image_url("curiosity", "fhaz", "2023-01-01")`

## Conclusion     

This function will return a hyperlink to the requested image. Copy/paste this URL into a web browser to see the image.
