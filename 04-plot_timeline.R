
theme_set(theme_minimal())
library(LaCroixColoR)

locs %>%
  filter(Date > '2019-06-01' & Date < '2019-12-15') %>%
  ggplot(., aes(Date, TagID, color = TagID)) +
  geom_point(pch = '|', size = 5) +
  theme(legend.position = 'none') +
  scale_color_manual(values = lacroix_palette("PassionFruit", n = 9, type = "continuous"))

ggsave(here::here('timeline.png'), width = 5, height = 3, units = 'in')