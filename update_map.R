
library(here)
library(purrr)

files <- c('combine_csv_files.R', 'mapview.R', 'plot_timeline.R')

map(files, source)


