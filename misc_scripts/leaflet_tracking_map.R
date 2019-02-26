
# Load the libraries ------------------------------------------------------

library(tidyverse)
library(leaflet)
library(leaflet.extras)
library(here)
library(sp)
library(RColorBrewer)
library(htmlwidgets)
#library(colorRamps)

here <- here::here
source('source/make_lines.R') # create lines connecting sequential GPS fixes


# Read in the data --------------------------------------------------------

# find the most recent file, which is last in the list due to sorting
output_data_directory <- list.files(here('output_data'))
last_file_loc <- length(output_data_directory)

# read in file
locs <- read_csv(paste0(here('output_data'), '/', output_data_directory[last_file_loc]))

# change Argos code to 3 digit ID to make leaflet plotting cleaner
locs <- locs %>%
  mutate(TagID = str_sub(TagID, start = 4, end = 6)) 
#locs %>% print(n=Inf)


# Map in leaflet by individual ----------------------------------------------------------
TagIDs <- unique(locs$TagID)

# Set colors for birds:
# colorPalette <- colorFactor(palette = rainbow(length(TagIDs)), # could also try primary.colors
#                             domain = locs$TagID)

colorPalette <- colorFactor(rev(RColorBrewer::brewer.pal(9, "Set1")), 
                             domain=locs$TagID)

# colorPalette <- colorFactor(palette = 'Set1', # RColorBrewer
#                             domain = locs$TagID)


# Plot everything (points and tracks) in a leaflet map
map <- leaflet(locs) %>%
  addProviderTiles(
    "CartoDB.Positron", 
    group = "CartoDB") %>%
  addProviderTiles(
    "Esri.WorldImagery", 
    group = "Satellite") %>%
  addProviderTiles(
    "Stamen.Terrain", 
    group = "Terrain") %>%
  addProviderTiles(
    "OpenStreetMap.Mapnik", 
    group = "OpenStreetMap") %>%
  addPolylines(
    data = makeLines(locs), 
    weight = 3,
    opacity = 0.4,
    color = ~ colorPalette(TagID)) %>%
  addCircleMarkers(
    ~Longitude, 
    ~Latitude, 
    weight = 1, 
    color = 'white',
    fillColor = ~ colorPalette(TagID),
    radius = 5, 
    fillOpacity = 0.8,
    popup=paste(
      '<b style="color:#0000FF">', "TagID:", locs$TagID, '</b>', '<br>',
      "<b>", "Lat:", "</b>", locs$Latitude, "<br>",
      "<b>", "Long:", "</b>", locs$Longitude, "<br>",
      "<b>", "Date:", "</b>", locs$Date, "<br>",
      "<b>", "Time (GMT):", "</b>", locs$Time, "<br>",
      "<b>", "Fix type:", "</b>", locs$Fix, "<br>",
      "<b>", "Fix #:", "</b>", locs$Sequence)) %>%
  addLayersControl(
    position = 'bottomleft',
    baseGroups = c("CartoDB", "Satellite", "Terrain", "OpenStreetMap"), 
    options = layersControlOptions(collapsed = FALSE)) %>%
  addLegend(position = 'bottomleft',
            pal = colorPalette,
            values = ~TagID,
            labels = ~TagID,
            title = "TagID")

# obtain the last location for each bird
locs_last <- locs %>%
  group_by(TagID) %>%
  filter(row_number()==n())

# create map with pulse markers as the most recent location for each bird
pulsemap <- map %>%
  addPulseMarkers(
    data=locs_last, 
    ~Longitude, 
    ~Latitude,
    group = 'Last fix location',
    label = ~TagID,
    icon = makePulseIcon(
      heartbeat=2, 
      iconSize = 7, 
      color= ~ colorPalette(TagID))) %>%
  addLayersControl(
    position = 'bottomleft',
    baseGroups = c("CartoDB", "Satellite", "Terrain", "OpenStreetMap"), 
    overlayGroups = "Last fix location", 
    options = layersControlOptions(collapsed = FALSE)) 
pulsemap

saveWidget(pulsemap, file=here("tracking_map.html"))
