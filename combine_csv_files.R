
# Load the libraries ------------------------------------------------------

library(tidyverse)
library(lubridate)
library(here)

here::here()

# Read in the data --------------------------------------------------------

# Read the file and create a column of the file's name;
# this provides a column to group points by TagID or code
read_plus <- function(flnm) {
  read_csv(flnm) %>% 
    mutate(Filename = flnm)
}

# Read each .csv file with tracking data
tbl <-
  list.files(path = here('converted_argos'),
              pattern='*.csv', 
              full.names = T) %>% 
  map_df(~read_plus(.))
#tbl

# Use stringr to pull out the tag code from the filename
# Convert date to lubridate (YYYY-MM-DD) format
# Select relevant variables
tbl <- tbl %>%
  mutate(TagID = str_sub(Filename, start = -23, end = -18)) %>%
  mutate(Date = dmy(Date)) %>%
  select(TagID, CRC, Date, Time, Latitude, Longitude, Fix) %>%
  arrange(TagID, Date) %>%
  distinct()
#tbl %>% print(n=Inf)

# Filter out bad points here and duplicates
locs <- tbl %>% 
  filter(CRC !="Fail") %>%
  filter(Fix %in% c("3D", "2D", "A1", "A2", "A3")) %>% # select GPS locations and higher quality Argos location classes
  select(-CRC) %>% # this allows you remove duplicates labeled with different CRCs (OK, OK(corrected))
  distinct() 
#locs

# Rename fix type
locs <- locs %>%
  mutate(type = case_when(
    Fix %in% c("3D", "2D") ~ "GPS",
    Fix %in% c('A1', 'A2', 'A3') ~ 'Argos')) %>%
  mutate(Fix = str_c(Fix, type, sep = ' ')) %>%
  select(-type)
#locs 

# Sort it and create fix # by TagID and date
locs <- locs %>%
  arrange(TagID, Date) %>%
  mutate(Sequence = sequence(rle(.$TagID)$lengths))
#locs

# need to figure out a better way to deal with these bad locations:
locs <- locs %>%
  filter(Sequence != 52)

# Sort it and create fix # by TagID and date
locs <- locs %>%
  arrange(TagID, Date) %>%
  mutate(Sequence = sequence(rle(.$TagID)$lengths))
locs

locs <- locs %>%
  filter(Date > '2019-01-01' & Longitude > -150 & Longitude < -50)

# Check - how many locations and tags are there?
#table(locs$TagID)
#locs %>% print.data.frame()

appended_date <- Sys.Date()

# Write to csv file by date more data was added
write_csv(locs, str_c(here('output_data'), '/', 'amke_locations', '_', appended_date, '.csv'))

