# What are the leading causes of death in the USA? 
# What are the leading causes of death in the AZ? 
# René Dario Herrera
# renedherrera at email dot arizona dot edu
# The University of Arizona Cancer Center 
# 3 August 2021

# setup ####
# packages 
library(here)
library(tidyverse)

# read data ####
nchs_cod_az <- read_rds("data/tidy/nchs_cod_az.rds")

glimpse(nchs_cod_az)

# data exploration ####
# leading cause of death 
nchs_cod_az %>%
  filter(cause_name != "All causes") %>%
  filter(cause_name %in% c("Heart disease", "Cancer", "Unintentional injuries", "CLRD", "Alzheimer's disease"))

