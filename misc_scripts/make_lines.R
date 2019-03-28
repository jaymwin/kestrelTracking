
# Lines for each bird:

makeLines <-
  function(dataframeIn, colorMatch) {
    # Unique IDs:
    birdIDs <- unique(dataframeIn$TagID)
    # List of data frames, one per ID:
    tracksList <- vector('list', length = length(birdIDs))
    for (i in 1:length(tracksList)) {
      tracksList[[i]] <- dataframeIn %>%
        filter(TagID == birdIDs[i])
    }
    # List of lines objects (one list item per tagId):
    birdLines <- vector('list', length = length(birdIDs))
    for (i in 1:length(tracksList)) {
      coordMat <- tracksList[[i]] %>%
        select(Longitude, Latitude) %>%
        as.matrix
      birdLines[[i]] <- Lines(Line(coordMat),
                              ID = tracksList[[i]] %>%
                                select(TagID) %>%
                                unique)
    }
    # Combine lines list to spatial lines data frame:
    SpatialLinesDataFrame(
      SpatialLines(birdLines),
      data = dataframeIn %>%
        select(TagID) %>%
        distinct,
      match.ID = FALSE
    )
  }