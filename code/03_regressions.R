library(pacman)
p_load(tidyverse,lubridate,conflicted)

conflict_prefer("filter", "dplyr")
##############################################
analysis_ds <- readRDS("cache/analysis_ds.rds")
#Ryan's model with explicit dummies (written in a lazy way)

visitation <- read_csv(file = "data/visitation_with_weather_and_dummies.csv")
model_formula <- as.formula(str_c("visits ~ policy +",
                                  str_c(names(visitation %>% select(monday:wind_speed_mean)),collapse = " + ")))
M1 <- lm(model_formula,data = visitation)

summary(m1) #This is regression 1 in the paper


#build data set
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

#interact policy and month

model_formula_2 <- as.formula(str_c("visits ~ policy + policy*month +",
                                    str_c(names(visitation %>% select(monday:wind_speed_mean)),collapse = " + ")))

M2 <- lm(model_formula_2,data = visit_factor)
#I get an error message ^here^ but the summary comes out fine, if you know what's going on feel free to fix it

summary(M2) #this is regression 2 in the paper


#look at hourly data

M3 <- lm(visits ~ policy + policy*hour + day + month + policy*month + precip_mean + rmax_mean + rmin_mean + 
           srad_mean + tmin_mean + tmax_mean + wind_speed_mean, data = visit_factor)

summary(M3) #this is regression 3 in the paper


