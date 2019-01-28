
library(gmailr)

time_in_seconds <- 10*60

Sys.sleep(time_in_seconds) # add delay here to allow time to upload the new map to my github site

## let others know that the new map is ready to view
msg = mime() %>%
  from("jasonwiniarski@u.boisestate.edu") %>%
  to("julieheath@boisestate.edu") %>%
  cc("fcphenology@boisestate.edu") %>%
  subject(paste0("New kestrel tracks - ", Sys.Date())) %>%
  text_body("Hi,

Here's an updated map of our tagged kestrels:
  
https://jaymwin.github.io/tracking_map.html

Jay")

send_message(msg)