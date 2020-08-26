#Code to construct Plot 1 - Histogram of Global Active Power

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
data[, Time := as.ITime(Time)] #convert "Time" here rather than before subsetting to reduce user.time

#create Plot 1: histogram of Global Active Power on subject days as specified

#following line of code correctly creates plot and outputs to screen graphics device
par(mfrow = c(1,1))
hist(data$Global_active_power, main = "Global Active Power", col = "red",
     xlab = "Global Active Power (kilowatts)")

#create png file of desired histogram
png(filename = "plot 1.png", width = 480, height = 480)
hist(data$Global_active_power, main = "Global Active Power", col = "red",
     xlab = "Global Active Power (kilowatts)")
dev.off()
