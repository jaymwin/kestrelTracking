
library(sf)
library(mapview)

# find the most recent file, which is last in the list due to sorting
output_data_directory <- dir_ls(here::here('output_data'))
last_file_loc <- length(output_data_directory)

output_data_directory[last_file_loc]

# read in file
locs <- read_csv(output_data_directory[last_file_loc])
locs %>% print(n=Inf)

# change Argos code to 3 digit ID to make leaflet plotting cleaner
locs <- locs %>%
  mutate(tag_id = str_sub(tag_id, start = 4, end = 6)) 
locs

# right now, filter to 2019 birds to clean up map
# locs <- locs %>%
#   filter(longitude > -150 & longitude < -50 & date < '2019-12-15')

# remove microwave data
locs <- locs %>%
  filter(tag_id != '521' & tag_id != '522')
locs %>% print(n=Inf)

mapview_locs <- locs 

# mapview_locs <- locs %>%
#   filter(date > '2019-05-01')
# mapview_locs %>% print(n=Inf)

# convert to sf object
sf_locs <- sf::st_as_sf(
  mapview_locs, coords = c("longitude","latitude")
  ) %>% 
  sf::st_set_crs(4326)

# create lines
sf_lines <- sf_locs %>% 
  dplyr::arrange(tag_id, date) %>% 
  dplyr::group_by(tag_id) %>% 
  dplyr::summarise(do_union = FALSE) %>% 
  sf::st_cast("MULTILINESTRING")
str(sf_lines)

# create points
sf_points <- sf_locs %>% 
  dplyr::arrange(tag_id, date) %>% 
  dplyr::group_by(tag_id) %>% 
  #dplyr::summarise(do_union = FALSE) %>% 
  sf::st_cast("MULTIPOINT")

# line map
map1 <- sf_lines %>% 
  mapview(
    map.types = c(
      "CartoDB.Positron", 
      "Esri.WorldImagery", 
      "Stamen.Terrain", 
      "OpenStreetMap.Mapnik"
      ),
    #zcol = "tag_id", 
    #burst = TRUE, 
    legend = FALSE, 
    homebutton = FALSE
    )

# point map
map2 <- sf_points %>%
  mapview(
    map.types = c("CartoDB.Positron", "Esri.WorldImagery", "Stamen.Terrain", "OpenStreetMap.Mapnik"),
    #zcol = "tag_id", 
    #burst = TRUE, 
    legend = FALSE, 
    homebutton = FALSE
  )

# combine together
combinedMap <- map1 + map2
combinedMap

# save as html
mapshot(combinedMap, url = here::here("tracking_map.html"))
