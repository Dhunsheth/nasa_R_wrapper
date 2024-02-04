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