

library(tidyverse)
library(here)

here()


# Load the data
locs <- read_csv(here('/output_data/amke_locations_2018-09-03.csv'))
locs

#locs <- locs %>%
#  filter(TagID == "025")

# This will look better once our tagged birds depart for migration...

# Load the base maps
na.lakes <- map_data(map = "lakes")
na.lakes <- na.lakes %>% mutate(long = long - 360)

# Include all of the Americas to begin
na.map <- map_data(map = "world2")
na.map <- na.map %>% 
  #filter(region %in% c("Canada", "USA")) %>% 
  mutate(long = long - 360)

map_offset <- 5

# set limits to map based on transmitter locations
xmin <- min(locs$Longitude, na.rm = TRUE) - map_offset
xmax <- max(locs$Longitude, na.rm = TRUE) + map_offset
ymin <- min(locs$Latitude, na.rm = TRUE) - map_offset
ymax <- max(locs$Latitude, na.rm = TRUE) + map_offset

# map
ggplot(na.lakes, aes(long, lat)) + 
  geom_polygon(data = na.map, aes(long, lat, group = group), colour = "grey", fill = "grey98") + 
  geom_polygon(aes(group = group), colour = "grey", fill = "white") + 
  geom_path(data = locs, aes(Longitude, Latitude, color=as.factor(TagID)), size=.05) + 
  geom_point(data = locs %>% filter(Sequence ==1), aes(Longitude, Latitude), colour = "red", shape = 4) + # capture location
  geom_point(data = locs %>% filter(Sequence > 1), aes(Longitude, Latitude, color=as.factor(TagID))) + # capture location
  scale_colour_discrete("TagID") +
  coord_quickmap(xlim = c(xmin, xmax), ylim = c(ymin, ymax)) + 
  xlab("Longitude (°)") + 
  ylab("Latitude (°)") + 
  theme_bw() 

