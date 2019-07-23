
library(here)
library(tidyverse)

files <- c('01-combine_csv_files.R', 
           '02-mapview.R',
           #'03-email_update.R' skip for now; emails list of folks with new tracking map
           '04-plot_timeline.R')

# run scripts
files %>%
  map(., source)
