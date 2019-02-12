
library(gmailr)

time_in_seconds <- 5*60

Sys.sleep(time_in_seconds) # add delay here to allow time to upload the new map to my github site

ccList <- c("anjolenehunt@boisestate.edu", 
            "jessewatson@boisestate.edu", 
            "fcphenology@boisestate.edu")

## let others know that the new map is ready to view
msg = mime() %>%
  from("jasonwiniarski@u.boisestate.edu") %>%
  to("julieheath@boisestate.edu") %>%
  cc(ccList) %>%
  subject(paste0("New kestrel tracks - ", Sys.Date())) %>%
  text_body("Hi,

Here's an updated map of our tagged kestrels:
  
https://jaymwin.github.io/tracking_map.html

Jay")

# create_draft(msg) - to make a draft first
send_message(msg)
