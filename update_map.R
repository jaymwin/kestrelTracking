
library(here)
library(purrr)

here <- here::here

#source('combine_csv_files.R')
#source('mapview.R')
#source('email_update.R')

files <- c('combine_csv_files.R', 'mapview.R')

map(files, source)
