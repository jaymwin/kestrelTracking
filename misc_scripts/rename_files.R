
tbl <-list.files(path = here('converted_argos'), full.names = T)
tbl

tbl <- tbl %>%
  as.tibble() %>%
  rename(old_name = 'value') %>%
  mutate(new_name = str_sub(old_name, start = -38, end = -29)) %>%
  mutate(new_name = str_replace_all(new_name, '_', '-')) %>%
  mutate(new_name = mdy(new_name)) %>%
  mutate(new_name = str_replace_all(new_name, '-', '_')) %>%
  mutate(new_name = paste0('/Users/Jay/Desktop/lotek_transmitter_locations/converted_argos/DSA_', new_name, str_sub(old_name, start = -28, end = length(old_name))))
tbl

a <- as.vector(tbl$old_name)
b <- as.vector(tbl$new_name)

file.rename(from=a, to=b)

as.list(tbl$old_name)
