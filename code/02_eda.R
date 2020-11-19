#This script conducts exploratory data analysis (EDA)

#load packages - though you may want to do this in a single script for the whole project
library(pacman)
p_load(tidyverse,lubridate)

##############################################


analysis_ds <- readRDS("cache/analysis_ds.rds")


#Does the weather data make sense?  Let's make it long so it is easier to plot
plot_weather <- analysis_ds %>%
  distinct(measure_date,.keep_all = T) %>%   #weather is daily and not hourly
  select(measure_date,contains("mean")) %>%
  pivot_longer(-measure_date,
               names_to = "weather_variable",
               values_to = "value")

ggplot(plot_weather,aes(x=measure_date,y=value,color=weather_variable)) +
  geom_line() +
  theme_minimal() +
  facet_wrap(~weather_variable,scales="free")

#The seasonal patterns make sense


#How does visitation vary over time?
analysis_ds %>%
  mutate(dow=ordered(weekdays(measure_date), levels=c("Monday", "Tuesday", "Wednesday", "Thursday", #Have R create the days of the week
                                                      "Friday", "Saturday", "Sunday")),
         year=year(measure_date)) %>%     #extract the year
  group_by(year,dow,hour) %>%            
  summarize(visits=mean(visits)) %>%    #calculate mean visits by day, hour, and year (see previous line)
  ggplot() +
  geom_tile(aes(x=hour,y=dow,fill=visits)) +
  geom_vline(xintercept = 17) +
  scale_fill_viridis_c() +
  theme_minimal() +
  facet_wrap(~year,ncol = 1)

ggsave("outputs/visits_heatmap.png")
