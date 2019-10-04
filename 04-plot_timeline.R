
theme_set(theme_minimal())
library(LaCroixColoR)

locs %>%
  filter(date > '2019-06-01' & date < '2019-12-15') %>%
  ggplot(., aes(date, tag_id, color = tag_id)) +
  geom_point(pch = '|', size = 5) +
  theme(legend.position = 'none') +
  scale_color_manual(values = lacroix_palette("PassionFruit", n = 9, type = "continuous")) +
  labs(
    x = 'Date',
    y = 'TagID'
      )

ggsave(here::here('timeline.png'), width = 5, height = 3, units = 'in')
