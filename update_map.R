
library(here)
library(purrr)

files <- c('combine_csv_files.R', 'mapview.R')

map(files, source)
