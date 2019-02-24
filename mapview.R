
library(tidyverse)
library(sf)
library(mapview)

# find the most recent file, which is last in the list due to sorting
output_data_directory <- list.files(here('output_data'))
last_file_loc <- length(output_data_directory)

# read in file
locs <- read_csv(paste0(here('output_data'), '/', output_data_directory[last_file_loc]))

# change Argos code to 3 digit ID to make leaflet plotting cleaner
locs <- locs %>%
  mutate(TagID = str_sub(TagID, start = 4, end = 6)) 

# convert to sf object
sf_locs <- sf::st_as_sf(locs, coords = c("Longitude","Latitude")) %>% 
  sf::st_set_crs(4326)

# create lines
sf_lines <- sf_locs %>% 
  dplyr::arrange(TagID, Date) %>% 
  dplyr::group_by(TagID) %>% 
  dplyr::summarise(do_union = FALSE) %>% 
  sf::st_cast("MULTILINESTRING")

# create points
sf_points <- sf_locs %>% 
  dplyr::arrange(TagID, Date) %>% 
  dplyr::group_by(TagID) %>% 
  #dplyr::summarise(do_union = FALSE) %>% 
  sf::st_cast("MULTIPOINT")

# line map
map1 <- sf_lines %>% 
  mapview(
    map.types = c("CartoDB.Positron", "Esri.WorldImagery", "Stamen.Terrain", "OpenStreetMap.Mapnik"),
    zcol = "TagID", burst = TRUE, legend = FALSE, homebutton = FALSE
    )

map2 <- sf_points %>% 
  mapview(
    map.types = c("CartoDB.Positron", "Esri.WorldImagery", "Stamen.Terrain", "OpenStreetMap.Mapnik"),
    zcol = "TagID", burst = TRUE, legend = FALSE, homebutton = FALSE
  )

# combine together
combinedMap <- map1 + map2

# save as html
mapshot(combinedMap, url = here("tracking_map.html"))
