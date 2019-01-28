
library(ggmap)

gc <- locs 
gc

X <- mean(gc$Longitude)
Y <- mean(gc$Latitude)

bbox <- c(left = X-15, bottom = Y-38, right = X+25, top = Y+12)
stamen <- get_stamenmap(bbox, zoom = 5)

ggmap(stamen) +
  geom_path(aes(x=Longitude, y = Latitude), data = gc, color= "red", linetype=1, alpha=0.7) +
  #geom_point(aes(x = Longitude, y = Latitude), data = gc, 
  #           fill='red', colour = "white", pch=21, size = 1, alpha=0.7) +
  theme_bw() +
  xlab('Longitude') +
  ylab('Latitude') +
  theme(text = element_text(size=8))

ggsave('C:/Users/jasonwiniarski/Desktop/amke_track.png', units='in', width=2, height=3, dpi=600)

