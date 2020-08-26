#Code to construct Plot 3 - Overlaid line plots of Sub_metering data from 3 sources

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

#create Plot 3: three overlaid line plots on single frame representing each sub meter reading

#following line of code correctly creates plot and outputs to screen graphics device
plot(data$Day_Time, data$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
lines(data$Day_Time, data$Sub_metering_2, col = "red")
lines(data$Day_Time, data$Sub_metering_3, col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lty = c(1,1,1), cex = 0.8) #note cex arg needed to print legend text

#create png file and rerun code, with dev.off() called to close png graphics device
png(filename = "plot 3.png", width = 480, height = 480)
plot(data$Day_Time, data$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
lines(data$Day_Time, data$Sub_metering_2, col = "red")
lines(data$Day_Time, data$Sub_metering_3, col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lty = c(1,1,1), cex = 0.8)
dev.off()



