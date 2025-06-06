## 1. Loading the Required 'data.table' R Library (install package, if needed)
if (!library(data.table, logical.return = TRUE, quietly = TRUE)) {
    install.packages("data.table", dependencies=TRUE)
    # now, load the 'data.table' library again. if failed, stop and report error
    if(!library(data.table, logical.return = TRUE, quietly = TRUE)) {
        stop("error: required data.table library could not be loaded")
    }
}

## 2. Downloading the household_power_consumption Data Set
if(!file.exists("household_power_consumption.txt")){
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata/data/household_power_consumption.zip"
    download.file(fileUrl, destfile="dataset.zip", method="curl")
    unzip(zipfile = "dataset.zip") 
    if(!file.exists("household_power_consumption.txt")){
        stop("error: failed to download and/or unzip the required data set file")
    }
}

## 3. Read data table
DT <- fread("household_power_consumption.txt", sep=";", na.strings ="?")

## 4. change DT$Date character colimn to be of Date type
DT$Date <- as.Date(DT$Date, "%d/%m/%Y")

## 5. for DT, using ONLY data from the dates 2007-02-01 and 2007-02-02.
DT <- DT[(DT$Date >= "2007-02-01") & (DT$Date <= "2007-02-02"), ]

## 6. Create a new  POSIXct type column "dateTime" (combining Date and Time)
DT[, dateTime := as.POSIXct(paste(Date, Time), format = "%Y-%m-%d %H:%M:%S")]

## 7. Draw plot3
##    7.1 open PNG graphics file device
png("plot3.png", width=480, height=480)
##    7.2 start plot, but don't plot yet, with no x-axis's tick-marks and labels 
plot(DT$dateTime, DT$Sub_metering_1, type="n", 
     ylab= "Energy sub metering", xlab="", xaxt = "n") 
##    7.3 add the x-axis's tick-marks and labels
##        note: checked with the weekdays() the actual points that 
##              the Date changes from Thursday to Friday (row = 1441)
axis(1, at = DT$dateTime[c(1, 1441, 2880)], labels = c("Thu", "Fri", "Sat"))
##    7.4 add the three line graphs of DT$Sub_metering_1, _2 and _3
lines(DT$dateTime, DT$Sub_metering_1, col="black")
lines(DT$dateTime, DT$Sub_metering_2, col="red")
lines(DT$dateTime, DT$Sub_metering_3, col="blue")
##    7.5 add a legend
legend("topright", lwd = 1, col = c("black", "red", "blue"), 
      legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
##    7.6 close PNG graphics file device
dev.off()
