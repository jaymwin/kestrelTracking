
library(here)
library(tidyverse)

files <- c('combine_csv_files.R', 'mapview.R', 'plot_timeline.R')

# run scripts
files %>%
  map(., source)
