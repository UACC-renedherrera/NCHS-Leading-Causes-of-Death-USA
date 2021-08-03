# What are the leading causes of death in the USA? 
# What are the leading causes of death in the AZ? 
# René Dario Herrera
# renedherrera at email dot arizona dot edu
# The University of Arizona Cancer Center 
# 3 August 2021

# setup ####
# packages 
library(here)
library(RSocrata)
library(tidyverse)
library(janitor)
library(lubridate)

# read data ####
nchs_cod <- read.socrata(url = "https://data.cdc.gov/resource/bi63-dtpu.json") %>%
  as_tibble() %>%
  clean_names()

# inspect
glimpse(nchs_cod)

# year
nchs_cod %>%
  distinct(year)

# change year from character to date year 
nchs_cod <- nchs_cod %>%
  mutate(year = year(as_date(year, format = "%Y")))

# x_113_cause_name
nchs_cod %>%
  distinct(x_113_cause_name)

# cause_name
nchs_cod %>%
  distinct(cause_name)

# state
nchs_cod %>%
  distinct(state)

# convert deaths and aadr from character to numeric
nchs_cod <- nchs_cod %>%
  mutate(
    deaths = as.numeric(deaths),
    aadr = as.numeric(aadr)
  )

# filter to AZ only 
nchs_cod_az <- nchs_cod %>%
  filter(state == "Arizona")

# save to disk 
write_rds(nchs_cod_az, "data/tidy/nchs_cod_az.rds")

