# 1. Install and load the `tideverse` library

#install.packages("tidyverse")
library(tidyverse)
library(lubridate)

# 2. Set working directory
setwd("~/Data Science/Calgary - Women's Data Science Study Group/06_meeting")

# 3. Locate current working directory
getwd()

# 4. Display the list of files present in that directory
list.files()

# 5. Read the selected csv file
fire_emergency_response <- read_csv("Fire_Emergency_Response_Calls_workshop.csv")
head(fire_emergency_response)

hist_community_pop <- read_csv("Historical_Community_Populations_workshop.csv")
head(hist_community_pop)

licensed_pets <- read_csv("Licensed_Pets_workshop.csv")
head(licensed_pets)

pets_impound <-read_csv("Pets_Impound_Outcomes.csv")
head(pets_impound)

water_consumption <- read_csv("Water_Single_Family_Consumption_workshop.csv")
head(water_consumption)


# 6. Explore the data structure
str(fire_emergency_response)
str(hist_community_pop)
str(licensed_pets)
str(pets_impound)
str(water_consumption)

glimpse(fire_emergency_response)
glimpse(hist_community_pop)
glimpse(licensed_pets)
glimpse(pets_impound)
glimpse(water_consumption)

# 7. Explore the dataset dimensions (number of rows and number of columns)
dim(fire_emergency_response)
dim(hist_community_pop)
dim(licensed_pets)
dim(pets_impound)
dim(water_consumption)


# 8. Display the first and last rows of the dataset  
head(fire_emergency_response)
tail(fire_emergency_response)

head(hist_community_pop)
tail(hist_community_pop)

head(licensed_pets)
tail(licensed_pets)

head(pets_impound)
tail(pets_impound)

head(water_consumption)
tail(water_consumption)



# 9. Is there any missing data? If yes, remove the rows with at least one column with `NA`# 
summary(fire_emergency_response)

summary(hist_community_pop)
hist_community_pop <- hist_community_pop %>% drop_na()
summary(hist_community_pop)

summary(licensed_pets)
summary(pets_impound)
summary(water_consumption)

# 10. If it makes sense, create new variables from the column that represents date (ex.: `month`,`year`, `weekdays`,`quarters`)
fire_emergency_response$date <-parse_date_time(fire_emergency_response$date,'%d/%m/%Y', exact = TRUE)
hist_community_pop$census_year <- parse_date_time(hist_community_pop$census_year,'%d/%m/%Y %H:%M:%S %p', exact = TRUE)
licensed_pets$DATE <- parse_date_time(licensed_pets$DATE, '%m/%d/%Y %H:%M:%S %p', exact = TRUE)
pets_impound$DATE <- parse_date_time(pets_impound$DATE, '%m/%d/%Y %H:%M:%S %p', exact = TRUE)
water_consumption$date <- parse_date_time(water_consumption$date,'%m/%d/%Y %H:%M:%S %p', exact = TRUE)

#data$year <- year(data$varDate) 
#data$month <- month(data$varDate)
#data$day <- day(data$varDate)
#data$weekdays <- weekdays(data$varDate)
#data$quarter <- quarter(data$varDate)

# 11. Create any other variable you think will provide insights
# 12. Create summarized tables using Data manipulation with`dplyr`: On meeting #5 you will find some examples on how to use the `dplyr` functions `select`, `filter`, `arrange`, `rename`, `mutate`, and `summarise`
# 13. Create plots using `ggplot2`. Example: barplots, boxplots, histograms, time series plots, scatter plot, among others. Search on Google different ways to present the results by month or year, by groups... You can find some examples on meeting #4 and meeting #5.


