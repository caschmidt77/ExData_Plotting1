#Code to construct Plot 4 - 4 plots as specified arranged for comparison

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
data[, datetime := lubridate::ymd_hms(paste(Date, Time, sep = "_"))]

#create plots and check by sending to screen device
#plot 1 - top left
par(mfcol = c(2,2)) #2 rows, 2 cols, filled columnwise (use mfrow to fill rowwise)
plot(data$datetime, data$Global_active_power, type = "l", xlab = "",
     ylab = "Global Active Power")

#plot 2 - bottom left
plot(data$datetime, data$Sub_metering_1, type = "l", col = "black", xlab = "",
     ylab = "Energy sub metering")
lines(data$datetime, data$Sub_metering_2, col = "red")
lines(data$datetime, data$Sub_metering_3, col = "blue")
#add notes: reduce cex to reduce legend text size, bty = "n" removes box from around legend
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = c(1,1,1), col = c("black", "red", "blue"), cex = 0.7, bty = "n")

#plot 3 - top right
#use of width drgument assinged xlab and ylab direct from variable name without prefixing "data$"
with(data, plot(datetime, Voltage, type = "l", xlab = "datetime"))

#plot 4 - bottom right
with(data, plot(datetime, Global_reactive_power, type = "l"))

#send plots to png file using above code
png("plot 4.png")
par(mfcol = c(2,2)) #2 rows, 2 cols, filled columnwise (use mfrow to fill rowwise)
plot(data$datetime, data$Global_active_power, type = "l", xlab = "",
     ylab = "Global Active Power")
plot(data$datetime, data$Sub_metering_1, type = "l", col = "black", xlab = "",
     ylab = "Energy sub metering")
lines(data$datetime, data$Sub_metering_2, col = "red")
lines(data$datetime, data$Sub_metering_3, col = "blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = c(1,1,1), col = c("black", "red", "blue"), cex = 0.7, bty = "n")
with(data, plot(datetime, Voltage, type = "l", xlab = "datetime"))
with(data, plot(datetime, Global_reactive_power, type = "l"))
dev.off()
