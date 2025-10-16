# file utk nyambungin duaa duanyaa (UI & Server)

library(shiny)
library(shinydashboard)

# import library, ada library nyaa
library(dplyr)
library(ggplot2)
library(scales)
library(glue)
library(plotly)
library(lubridate)
library(stringr)
options(scipen = 100)


# read data, ada bagiaan read dataa
data <- read.csv("Pakistan Largest Ecommerce Dataset.csv", stringsAsFactors = TRUE, encoding = "latin1")

# cleansing data, adaa bagiaan cleansing ~> ngilangin gaperlu, ngubah tipe dataa, nambah kolom baru, filter kalo dibutuhkan ~> sampee bener bener sesuai, bagus, dan bersih
data_clean <- data %>% 
  select(
    #membersihkan yang tidak perlu
    -c(increment_id, sales_commission_code, Working.Date, BI.Status,MV, Year, Month, Customer.Since, M.Y, FY, X, X.1, X.2, X.3, X.4)) %>% 
  
  mutate(
    #ngubah tipe data
    created_at= dmy(created_at),
    sku= as.character(sku),
    
    #nambah kolom
    month= month(created_at, label = FALSE, abbr = TRUE),
    year= year(created_at)
  ) %>% 
  
  #gantii nama kolom
  rename(
    c(product_name = sku, category_name = category_name_1)) %>% 
  
  filter(
    #filter hanya menggunakan tahun 2017
    year(created_at) %in% c(2017),
    category_name != "\\N",
    grepl("_", product_name) # filter nama produk yang tidak adaa "_" atau kelihatan seperti barcode 
  )