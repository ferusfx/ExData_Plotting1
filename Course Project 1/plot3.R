setwd("~/Coursera/4 Exploratory Data Analysis")
# load the data.table 'magic' package to work with the data
library(data.table)
# set Language settings to that, otherwise the plotted 'days' will be in local computer's language
Sys.setlocale('LC_TIME', 'C')

# make sure the sources data folder exists
if (!file.exists('Course Project 1')) {
  dir.create('Course Project 1')
}

if (!file.exists('Course Project 1/household_power_consumption.txt')) {
  
  # download the zip file and unzip
  file.url<-'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
  download.file(file.url,destfile='Course Project 1/household_power_consumption.txt')
  unzip('Course Project 1/household_power_consumption.txt',exdir='Course Project 1',overwrite=TRUE)
    
}
# read file
mydt <- fread("Course Project 1/household_power_consumption.txt", nrows = 2880, skip="1/2/2007;00:00:00;0.326;0.128;243.150;1.400;0.000;0.000;0.000")
# set column names
setnames(mydt, c("V1", "V2", "V3", "V4", "V5", "V6", "V7", "V8", "V9"), 
         c("Date","Time", "Global_active_power", "Global_reactive_power", "Voltage",
           "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
# format Date column to YYYY-MM-DD
x <- paste(mydt[,Date], mydt[,Time])
mydt[, DateTime:=x]
mydt <- mydt[, c(10, 3:9), with=FALSE]
mydt[[1]] <- strptime(mydt[[1]], "%d/%m/%Y %H:%M:%S")

# if plots folder doesn't exist, create one
if (!file.exists('Course Project 1/plots')) {
  dir.create('Course Project 1/plots')
}

# create / start image processing for plot3
png(filename='Course Project 1/plots/plot3.png',width=480,height=480,units='px')
# plot data as plot
lineCol <- c('black','red','blue')
labels <- c('Sub_metering_1','Sub_metering_2','Sub_metering_3')
plot(mydt[, DateTime],mydt[, Sub_metering_1],type='l',col=lineCol[1],xlab='',ylab='Energy sub metering')
lines(mydt[, DateTime],mydt[, Sub_metering_2],col=lineCol[2])
lines(mydt[, DateTime],mydt[, Sub_metering_3],col=lineCol[3])
# add a legend
legend('topright',legend=labels,col=lineCol,lty='solid')
# save plot to file / close
close <- dev.off()