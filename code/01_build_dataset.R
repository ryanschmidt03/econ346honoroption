#This script builds the dataset.

library(pacman)
p_load(tidyverse,lubridate)

#####################################
#Read in visitation
#visit_raw <- read_csv(file = "data/visitation_with_policy_day_and_month_dummies.csv")  

#Read in hourly visitation (I've included the total number of devices observed
#in the panel over time.  This should be used to normalize the visits.)
hourly_raw <- read_csv("data/rmnp_hourly.csv") %>%
  mutate(est_visits=round(visits/devices*331000000)) 

#we are calculating the fraction of the panel that visits RMNP and then
#multiplying by the US population assuming the panel represents the population

#Read in weather
weather_raw <- read_csv("data/weather_rmnp.csv")


# analysis_ds <- inner_join(visit_raw,
#                           weather_raw,
#                           by="date")

#Merge 
analysis_ds <- inner_join(hourly_raw,
                          weather_raw,
                          by=c("measure_date"="date"))

saveRDS(analysis_ds,file = "cache/analysis_ds.rds")
