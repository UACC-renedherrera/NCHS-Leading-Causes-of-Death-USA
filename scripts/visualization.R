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
library(ggthemes)
library(gt)
library(RColorBrewer)

# color palettes ####
# blue palette
uaz_blues3 <- c("#deebf7", "#9ecae1", "#3182bd")
uaz_blues4 <- c("#eff3ff", "#bdd7e7", "#6baed6", "#2171b5")

# red palette 
uaz_reds3 <- c("#fee0d2", "#fc9272", "#de2d26")
uaz_reds4 <- c("#fee5d9", "#fcae91", "#fb6a4a", "#cb181d")

# red and blue palette 
uaz_red_blue <- c("#AB0520", "#0C234B")

# theme ####
# set consistent theme for graphics & data visualizations
theme_uazcc_brand <- theme_clean(base_size = 14) +
  theme(
    text = element_text(
      family = "sans",
      # face = "bold",
      color = "#001C48",
      # size = rel(1.5)
    ),
    panel.background = element_rect(fill = "white"),
    panel.grid = element_line(color = "#1E5288"),
    #plot.background = element_rect(fill = "#EcE9EB"),
    aspect.ratio = 9 / 16,
    legend.background = element_rect(fill = "white"),
    legend.position = "right",
    plot.caption = element_text(size = 8),
    # plot.subtitle = element_text(size = 12),
    # plot.title = element_text(size = 14),
    strip.background = element_rect(fill = "#EcE9EB")
  )

# read data 
nchs_cod_az <- read_rds("data/tidy/nchs_cod_az.rds")

glimpse(nchs_cod_az)

# plot of leading cause of death over time 
nchs_cod_az %>%
  filter(cause_name != "All causes") %>%
  filter(cause_name %in% c("Heart disease", "Cancer", "Unintentional injuries", "CLRD", "Alzheimer's disease")) %>%
  # filter(year == "2017") %>%
  # filter(year %in% c("2013", "2014", "2015", "2016", "2017")) %>%
  # group_by(year) %>%
  # slice_max(aadr, n = 5) %>%
  # arrange(desc(year, aadr)) %>%
  ggplot(mapping = aes(x = year, y = aadr, group = cause_name)) +
  geom_line(mapping = aes(color = cause_name), size = 1) +
  ylim(c(0,250)) +
  theme_uazcc_brand +
  scale_color_colorblind() +
  labs(
    title = "Leading Cause of Death in Arizona",
    subtitle = "2015-2017, All races, both sexes",
    x = "Year",
    y = "Age adjusted rate per 100,000",
    caption = "Source: National Center for Health Statistics (2020)",
    color = "Cause of Death"
  )

ggsave(
  filename = "figures/charts/leading_cause_of_death_over_time_az.svg",
  device = "svg",
  scale = 1.5
)

# data table 
nchs_cod_az %>%
  filter(cause_name != "All causes") %>%
  filter(cause_name %in% c("Heart disease", "Cancer", "Unintentional injuries", "CLRD", "Alzheimer's disease")) %>%
  filter(year >= 2015) %>%
  select(year, cause_name, aadr) %>%
  group_by(year) %>%
  arrange(year) %>%
  arrange(desc(aadr)) %>%
  gt() %>%
  tab_header(
    title = "Leading Cause of Death in Arizona",
    subtitle = "2015-2017, All races, both sexes"
  ) %>%
  cols_label(year = "Year",
             aadr = "Age adjusted rate") %>%
  tab_source_note(source_note = "Source: National Center for Health Statistics (2020)") %>%
  gtsave(
    filename = "figures/charts/leading_cause_of_death_over_time_az_table.png",
    expand = 10
  )

