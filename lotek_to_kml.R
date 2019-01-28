
# Load the libraries ------------------------------------------------------

library(tidyverse)
library(readr)
library(lubridate)
library(sp)
library(rgdal)
library(rgeos)

here()
source('points_to_lines.R')

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

# Use stringr to pull out the tag code from the filename
# Convert date to lubridate (YYYY-MM-DD) format
# Select relevant variables
tbl <- tbl %>%
  mutate(TagID = substr(Filename, start = 22, stop = 27)) %>%
  mutate(Date = dmy(Date)) %>%
  select(TagID, CRC, Date, Time, Latitude, Longitude, Fix) 
tbl

# Filter out bad points here and duplicates
locs <- tbl %>% 
  filter(CRC !="Fail") %>%
  filter(Fix == "3D") %>% # select good GPS locations
  select(-CRC) %>% # this allows you remove duplicates labeled with different CRCs (OK, OK(corrected))
  distinct() 
locs

# Sort it and create fix # by TagID and date
locs <- locs %>%
  arrange(TagID, Date) %>%
  mutate(Sequence = sequence(rle(.$TagID)$lengths))
locs

# Create kml file ----------------------------------------------------------

# Doesn't like the time format for some reason
locs <- locs %>%
  select(-Time)

# Create coordinates
coordinates(locs)<- c("Longitude", "Latitude")

# Assign WGS 84 projection
proj4string(locs) <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")

# Write the kml file
writeOGR(locs,"AMKE_locations.kml","Tagged_AMKE_locs","KML")
