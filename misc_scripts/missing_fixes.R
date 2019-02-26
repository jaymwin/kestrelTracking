# Visually determine how many points are missing --------------------------

# get the deployment date, which is the first location minus 1
# this assumes the first location transmitted, may need to change this later
deploy_date <- locs %>%
  group_by(TagID) %>%
  slice(1) %>%
  mutate(Date = Date-1)
deploy_date

# get the timeline data for each tagged bird
timeline025 <- seq(ymd('2018-01-24'), ymd(today()), by = '2 days') 
timeline025 <- as.data.frame(timeline025)
timeline025$TagID <- '025'
colnames(timeline025) <- c("Date", "TagID")

timeline026 <- seq(ymd('2018-01-26'), ymd(today()), by = '2 days') 
timeline026 <- as.data.frame(timeline026)
timeline026$TagID <- '026'
colnames(timeline026) <- c("Date", "TagID")

# combine to plot
new <- rbind(timeline025,timeline026)
new

ggplot() +
  geom_point(data=new, aes(Date, TagID), color="red", size=10, pch="|") +
  geom_point(data=deploy_date, aes(Date, TagID), color="forestgreen", size=10, pch="|") +
  geom_point(data=locs, aes(Date, TagID), color="cornflowerblue", size=10, pch="|") +
  scale_x_date(date_minor_breaks = "2 days") +
  theme_bw()