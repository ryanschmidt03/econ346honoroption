#Always start with a statement about the intent of the script

#load packages - though you may want to do this in a single script for the whole project
library(pacman)
p_load(tidyverse,lubridate,conflicted)

conflict_prefer("filter", "dplyr")
##############################################
analysis_ds <- readRDS("cache/analysis_ds.rds")

#Continue like you did in the previous script

visit_factor <- analysis_ds %>%
  mutate(day=weekdays(measure_date),
         month=month(measure_date,label = T,abbr = F),
         hour=factor(hour),
         hour=relevel(hour,ref = "16"),
         day=factor(day),
         day=relevel(day,ref = "Sunday"),
         month=factor(month,ordered = F),
         month=relevel(month,ref = "June"),
         policy=ifelse(measure_date %within% (as_date("2020-06-04") %--% as_date("2020-10-12")),1,0)) %>%
  filter((measure_date %within% (as_date("2020-06-04") %--% as_date("2020-10-12"))) | 
           (measure_date %within% (as_date("2019-06-04") %--% as_date("2019-10-12"))))

m2 <- lm(visits ~ policy*hour + day + month, data = visit_factor)
summary(m2)
