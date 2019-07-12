
library(here)
library(tidyverse)

files <- c('01-combine_csv_files.R', '02-mapview.R', '04-plot_timeline.R')

# run scripts
files %>%
  map(., source)
