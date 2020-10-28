

#install.packages("pacman")
library(pacman)
p_load(tidyverse)

#Read in data
rmnp_daily <- read_csv("data/rmnp_daily_visits.csv")

save(rmnp_daily,file="cache/intermediate_data.Rdata")

ggplot(rmnp_daily,aes(x=measure_date,y=visits)) +
  geom_line()

ggsave("outputs/sample_figure.png")
