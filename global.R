# Global File
# File that connects both UI and Server File 

# Import Library
library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(scales)
library(glue)
library(plotly)
library(lubridate)
library(stringr)
options(scipen = 100)


# Read Data
data <- read.csv("Pakistan Largest Ecommerce Dataset.csv", stringsAsFactors = TRUE, encoding = "latin1")

# Cleansing Data
data_clean <- data %>% 
  select(
    # Delete unneeded data 
    -c(increment_id, sales_commission_code, Working.Date, BI.Status,MV, Year, Month, Customer.Since, M.Y, FY, X, X.1, X.2, X.3, X.4)) %>% 
  
  mutate(
    # Change data types
    created_at= dmy(created_at),
    sku= as.character(sku),
    
    # Add new columns
    month= month(created_at, label = FALSE, abbr = TRUE),
    year= year(created_at)
  ) %>% 
  
  # Rename columns
  rename(
    c(product_name = sku, category_name = category_name_1)) %>% 
  
  # Filter data
  filter(
    # only take data in the year 2017
    year(created_at) %in% c(2017),
    category_name != "\\N",
    grepl("_", product_name)  
  )