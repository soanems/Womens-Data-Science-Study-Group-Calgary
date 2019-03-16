#### Exercise 1
employee[employee$YearlyIncome > 70000,]

#### Exercise 2
today_date <- Sys.time()
today_date
class(today_date) 

today_date <- as.POSIXlt(today_date)
today_date$wday
today_date$hour
today_date$yday
today_date$zone

#### Exercise 3
str(employee$HireDate)
employee$HireDate <- as.Date(employee$HireDate)
weekdays(employee$HireDate)
months(employee$HireDate)
quarters(employee$HireDate)
