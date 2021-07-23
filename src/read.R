#JTW DATA READER

# libraries
if (!require('rstudioapi')) install.packages('rstudioapi', dependencies = TRUE)
library(rstudioapi)
if (!require('sf')) install.packages('sf', dependencies = TRUE)
library(sf)
if (!require('tidyverse')) install.packages('tidyverse', dependencies = TRUE)
library(tidyverse)
if (!require('stringr')) install.packages('stringr', dependencies = TRUE)
library(stringr)
if (!require('janitor')) install.packages('janitor', dependencies = TRUE)
library(janitor)
if (!require('readxl')) install.packages('readxl', dependencies = TRUE)
library(readxl)

#set script location as wd 
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# parameters
crs <- 4326

# unzip files
for (file in list.files(path = "./../data", pattern = "*.zip")) {
  print(paste0("./../data/", file))
  unzip(
    zipfile = paste0("./../data/", file),
    exdir = "./../data",
    overwrite = TRUE
  )
}

# read, re-project, and centroid shapefiles
for (file in list.files(path = "../data", pattern = "*.shp")){
  path <- paste0("../data/", file)
  print(path)
  name1 <-
    paste0("sf_", gsub("-", "_", gsub(" ", "_", str_to_lower(
      gsub(".shp", "", file)
    ))))
  print(name1)
  
  sf1 <- st_read(dsn = path) %>% 
    st_as_sf() %>%
    clean_names() %>%
    st_transform(crs = crs) %>% 
    st_make_valid()
  
  assign(name1, sf1)
}

# read csv
for (file in list.files(path = "../data", pattern = "*csv")){
  path <- paste0("../data/", file)
  print(path)
  
  df1 <- read.csv(path)
  
  
  name <- paste0("csv_", gsub(
    "-", "_", gsub(" ", "_", str_to_lower(
      gsub(
        ".csv", "", file)))))
  print(name)

  assign(name, df1)
}

