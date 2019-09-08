
library(gmailr)

time_in_seconds <- 3*60

Sys.sleep(time_in_seconds) # add delay here to allow time to upload the new map to my github site

me <- "jasonwiniarski@u.boisestate.edu"

PI <- "julieheath@boisestate.edu"

cc_list <- c("anjolenehunt@boisestate.edu", 
            "jessewatson@boisestate.edu", 
            "fcphenology@boisestate.edu")

## let others know that the new map is ready to view
msg = mime() %>%
  from(me) %>%
  to(PI) %>%
  cc(cc_list) %>%
  subject(str_c("New kestrel tracks - ", Sys.Date())) %>%
  text_body("Hi,

Here's an updated map of our tagged kestrels:
  
https://jaymwin.github.io/tracking_map.html

Jay")

# create_draft(msg) - to make a draft first
send_message(msg)
