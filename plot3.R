##################################plot3.R###################################
#Section 1:                                                                #
#     Shows steps used to initially explore data file and calculate the    #
#     number of rows to skip before importing rows and how many rows to    #
#     import.                                                              #
#Section 2:                                                                #
#     Imports, cleans, and plots the data covering 2/1 and 2/2 of 2007.    #
############################################################################

################
####SECTION1####
################
#   Data downloaded from:https://d396qusza40orc.cloudfront.net/
#                        exdata%2Fdata%2Fhousehold_power_consumption.zip
dataLoc <- paste("C:/Users/Philip/Documents/Coursera/DataScienceSpecialization/",
                 "rDirectory/exdata_data_household_power_consumption/",
                 "household_power_consumption.txt", sep = "")

#   Read in first 10 lines to explore and get first date and time value
head <- read.table(dataLoc, nrow = 10, header = TRUE, sep = ";")

#   Convert date and time for the first observation to proper format
firstObs <- as.POSIXct(strptime(paste(head[1,1],head[1,2]), "%d/%m/%Y %H:%M:%S"))

#   Create data and time for the first observation with date 2/1/2007
#to use in calculating the days between 2/1 and the start of the dataset
desireObs <- as.POSIXct(strptime("2007-02-01 00:00:00", "%Y-%m-%d %H:%M:%S"))

##comes out to 46.275 days##
desireObs - firstObs

#   Calculate the number of observations before desired range starts as given by:
#(full days until desired range)*24*60 + minutes remaining in first partial day
#in data.
countSkip <- round(desireObs - firstObs)*24*60 + 396

#   Confirm that countSkip skips to the first observation with date 2/1/2007
test <- read.table(dataLoc, skip = countSkip, nrow = 1, header = TRUE, sep = ";")

#   Calculate the number of hours in two days, this is the number of observations
#that will be imported to get the range including 2/1 and 2/1 of 2007
countRowTake <- 2*24*60

################
####SECTION2####
################

#   Read in data for  2007-02-01 and 2007-02-02. Assumes that instructs literally
#mean use data with these dates as opposed to data that covers those dates based
#on time (this alternative definition would have 2/1 00:00:01 as the first
#observation and 2/3 00:00:00 as the last observation). In the end, the difference
#between using one and the other is very small in the plots.
data2plot <- read.table(dataLoc, skip = countSkip, nrow = countRowTake,
                        header = FALSE, sep = ";", na.strings ="?")

#Clean data by restoring the names of the columns and formating date and time.
names(data2plot) <- names(head)

data2plot$Date <- as.Date(data2plot$Date, "%d/%m/%Y")
data2plot$Time <- as.POSIXct(strptime(paste(data2plot$Date,data2plot$Time),
                                      "%Y-%m-%d %H:%M:%S"))

#Make Plot 3
#Set directory to save in
setwd("C:/Users/Philip/Documents/Coursera/DataScienceSpecialization/ExData_Plotting1")

png(filename = "plot3.png", width = 480, height = 480)

with(data2plot, plot(Time, Sub_metering_1, type = "l",
                   ylab = "Energy sub metering", xlab = ""))
with(data2plot, points(Time, Sub_metering_2, type = "l", col = "red"))
with(data2plot, points(Time, Sub_metering_3, type = "l", col = "blue"))
legend("topright", lty = 1, col = c("black", "blue", "red"),
       legend = c("Sub_metering_1", "Sub_metering_2",
                  "Sub_metering_3"))

dev.off()