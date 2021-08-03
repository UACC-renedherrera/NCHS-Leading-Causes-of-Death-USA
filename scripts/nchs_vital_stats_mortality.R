# set up ----
# load packages to read and tidy data
library(here)
library(tidyverse)
library(janitor)

# source citation ----
# 

# 
# set values
url <- "https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/DVS/mortality/mort2019us.zip"
path_zip <- "data/raw"
path_unzip <- "data/raw/mort2019us"
zip_file <- "mort2019us.zip"
# use curl to download
curl::curl_download(url, destfile = paste(path_zip, zip_file, sep = "/"))
# set value
zipped_file <- "data/raw/mort2019us.zip"
# unzip to folder
unzip(zipped_file, exdir = path_unzip)

mort_2019 <- read_fwf( #n_max = 100, 
  file = "data/raw/mort2019us/VS19MORT.DUSMCPUB_r20210304",
  col_positions = fwf_cols(month = c(65,66), 
                           sex = c(69,69), 
                           age = c(77,78), 
                           year = c(102,105), 
                           cause = c(160,161), 
                           hispanic = c(484, 486),
                           race = c(489,490)),
  col_types = c("cfccccc"))

mort_2019 <- mort_2019 %>%
  mutate(month_name = if_else(month == "01", "Jan", 
                         if_else(month == "02", "Feb",
                                 if_else(month == "03", "Mar", 
                                         if_else(month == "04", "Apr",
                                                 if_else(month == "05", "May",
                                                         if_else(month == "06", "Jun",
                                                                 if_else(month == "07", "Jul",
                                                                         if_else(month == "08", "Aug",
                                                                                 if_else(month == "09", "Sep",
                                                                                         if_else(month == "10", "Oct",
                                                                                                 if_else(month == "11", "Nov",
                                                                                                         if_else(month == "12", "Dec", "")))))))))))))

mort_2019 <- mort_2019 %>%
  mutate(cause_name = if_else(cause == "04", "Malignant neoplasms", 
                              if_else(cause == "18", "Major cardiovascular diseases",
                                      if_else(cause == "17", "Alzheimer's disease",
                                              if_else(cause == "28", "CLRD", 
                                                      if_else(cause == "38", "Motor vehicle accidents",
                                                              if_else(cause == "39", "All other and unspecified accidents and adverse effects",
                                                                      if_else(cause == "40", "Intentional self-harm (suicide)", "Other"))))))))

mort_2019 <- mort_2019 %>%
  mutate(race_name = if_else(race == "01", "White",
                             if_else(race == "02", "Black",
                                     if_else(race == "03", "AIAN", "Other"))))

mort_2019 <- mort_2019 %>%
  mutate(hispanic_code = if_else(hispanic %in% c(100:199), "No", "Yes"))

# explore 
glimpse(mort_2019)

mort_2019 %>%
  group_by(cause_name) %>%
  summarise(count = n())
