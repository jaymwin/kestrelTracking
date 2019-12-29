
# Load the libraries ------------------------------------------------------

library(pacman) # for loading packages
p_load(tidyverse, lubridate, here, fs, vroom, furrr, janitor)
plan(multicore) # for furrr function


# Read in the data --------------------------------------------------------

# find all the csv files
csv_list <- dir_ls(here::here('converted_argos_microwave'), 
                   glob = '*csv')

# read and combine
tbl <- future_map_dfr(csv_list, readr::read_csv, .id = 'path')

# clean names
tbl <- tbl %>% clean_names()

# Select relevant variables
tbl <- tbl %>%
  mutate(tag_id = str_sub(path, start = -23, end = -18)) %>%
  mutate(date = dmy(date)) %>%
  select(tag_id, crc, date, time, latitude, longitude, fix) %>%
  arrange(tag_id, date) %>%
  distinct()
tbl
#tbl %>% print(n=Inf)

# Filter out bad points here and duplicates
locs <- tbl %>% 
  filter(crc !="Fail") %>%
  #filter(fix %in% c("3D", "2D", "A1", "A2", "A3")) %>% # select GPS locations and higher quality Argos location classes
  select(-crc) %>% # this allows you remove duplicates labeled with different CRCs (OK, OK(corrected))
  distinct() 
locs

# Rename fix type
locs <- locs %>%
  mutate(type = case_when(
    fix %in% c("3D", "2D") ~ "GPS",
    TRUE ~ 'Argos')) %>%
  mutate(fix = str_c(fix, type, sep = ' ')) %>%
  select(-type)
locs 

# Sort it and create fix # by TagID and date
locs <- locs %>%
  arrange(tag_id, date) %>%
  mutate(sequence = sequence(rle(.$tag_id)$lengths))
locs

# # need to figure out a better way to deal with these bad locations:
# locs <- locs %>%
#   filter(sequence != 52)

# Sort it and create fix # by TagID and date
locs <- locs %>%
  arrange(tag_id, date) %>%
  mutate(sequence = sequence(rle(.$tag_id)$lengths))
locs

# Check - how many locations and tags are there?
#table(locs$TagID)
#locs %>% print.data.frame()

appended_date <- Sys.Date()

# Write to csv file by date more data was added
vroom_write(locs, str_c(here::here('output_data_microwave'), '/', 'amke_locations', '_', appended_date, '.csv'), delim = ",")
