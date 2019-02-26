# calculate migration distances from Lotek GPS-Argos telemetry devices


# Load packages -----------------------------------------------------------

Packages <- c('sp', 'geosphere', 'tidyverse', 'lubridate', 'rgeos')
lapply(Packages, library, character.only = TRUE)

# Get proper version of 'select' going
select <- dplyr::select


# Calculate the distance from the first gps observation -------------------

# Create an output list that is the length of the number of tags we're looking at
TagIDs <- unique(locs$TagID)

amkeList <- vector('list', length = length(TagIDs))

# Write for-loop to calculate distances for each tag, its origin, and subsequent locations
for(i in 1:length(TagIDs)){
  # Filter to a single TagID:
  idSubset <- locs %>%
    filter(TagID == TagIDs[i])
  # Spatial point of capture location:
  ptOrigin <- idSubset %>%
    filter(Date == min(Date)) %>%
    select(Longitude, Latitude) %>%
    distinct %>%
    SpatialPoints(proj4string = CRS('+proj=longlat'))
  # Spatial points of gps fixes:
  idSubsetSpatial <- idSubset %>%
    select(Longitude, Latitude) %>%
    SpatialPoints(proj4string = CRS('+proj=longlat'))
  # Add column of distances:
  idSubset$distBreedingKm <- distGeo(ptOrigin, idSubsetSpatial)/1000
  # Output distances:
  amkeList[[i]] <- idSubset
}

# Bind list and code migratory stage:

amkeMigration <- bind_rows(amkeList) %>%
  arrange(TagID, Date) %>%
  group_by(TagID) %>%
  mutate(
    Stage = case_when(
      Date < min(Date[distBreedingKm >= 10]) ~ 'Non-breeding',
      Date >= min(Date[distBreedingKm/max(distBreedingKm) > 0.95]) ~ 'Breeding',
      TRUE ~ 'Migration'
    )
  ) %>%
  ungroup
amkeMigration %>% print(n=Inf)

amkeMigration %>%
  group_by(TagID) %>%
  filter(distBreedingKm == max(distBreedingKm)) %>%
  select(TagID, Date, Time, Latitude, Longitude, distBreedingKm)
