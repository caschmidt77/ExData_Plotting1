#Code to construct Plot 2 - Line plot of Global Active Power

#load packages
library(tidyverse)
library(data.table)
library(lubridate)

#download and unzip file if not already present in specified path
if (!file.exists("./data")){
  dir.create("./data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!file.exists("./data/raw-data.zip")){
  download.file(fileUrl, "./data/raw-data.zip", mode = "wb") #recall zip files require mode = "wb"
  unzip("./data/raw-data.zip", exdir = "./data", unzip = "internal")
}

#read file (txt) to data.table
power <- fread(file = "./data/household_power_consumption.txt", na.strings ="?", data.table = TRUE)

#perform preliminary inspection of data on command line using head, dim, str functions
#note >2M rows, 9 cols; "Date" & "Time" are character values that require conversion

power[, Date := as.Date(Date, format = "%d/%m/%Y")] #convert "Date" to allow subsetting

#subset the dates for analysis (2007-02-01 & 2007-02-02)
data <- power[Date == "2007-02-01" | Date == "2007-02-02"]
#create an object with POXITct ymd_hms date object to allow plotting with appropriate (weekday) labels
data[, Day_Time := lubridate::ymd_hms(paste(Date, Time, sep = "_"))]

#create Plot 2 - line plot of Global Active Power

#following line of code correctly creates plot and outputs to screen graphics device
plot(data$Day_Time, data$Global_active_power, type = "l", xlab = "",
     ylab = "Global Active Power (kilowatts)")


#create png file and rerun code, with dev.off() called to close png graphics device
png(filename = "plot 2.png", width = 480, height = 480)
plot(data$Day_Time, data$Global_active_power, type = "l", xlab = "",
     ylab = "Global Active Power (kilowatts)")
dev.off()

