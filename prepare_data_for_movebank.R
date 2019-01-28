
# Load the libraries ------------------------------------------------------

library(tidyverse)
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
  list.files(pattern="*.csv", 
             full.names = T) %>% 
  map_df(~read_plus(.))
tbl

# Use stringr to pull out the tag code from the filename
# Convert date to lubridate (YYYY-MM-DD) format
# Select relevant variables
tbl <- tbl %>%
  mutate(TagID = str_sub(Filename, start = 22, end = 27)) %>%
  mutate(Date = dmy(Date)) %>%
  select(TagID, CRC, Date, Time, Latitude, Longitude, Fix) %>%
  arrange(TagID, Date) %>%
  distinct()
tbl 

# Filter out bad points here and duplicates
locs <- tbl %>% 
  filter(CRC !="Fail") %>%
  filter(Fix %in% c("3D", "2D", "A1", "A2", "A3")) %>% # select GPS locations 
  select(-CRC) %>% # this allows you remove duplicates labeled with different CRCs (OK, OK(corrected))
  distinct() 
locs %>% print.data.frame()

# Sort it and create fix # by TagID and date
locs <- locs %>%
  arrange(TagID, Date) 
locs

locs <- locs %>%
  mutate(type = case_when(
    Fix %in% c("3D", "2D") ~ "GPS",
    Fix %in% c('A1', 'A2', 'A3') ~ 'Argos')) %>%
  mutate(Fix = paste(Fix, type)) %>%
  select(-type)
locs


# Write to csv file -------------------------------------------------------

write_csv(locs, "C:/Users/jasonwiniarski/Desktop/amke_locations_movebank.csv")

