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

## 4. Change DT$Date character colimn to be of Date type
DT$Date <- as.Date(DT$Date, "%d/%m/%Y")

## 5. For DT, using ONLY data from the dates 2007-02-01 and 2007-02-02.
DT <- DT[(DT$Date >= "2007-02-01") & (DT$Date <= "2007-02-02"), ]

## 6. Draw plot1
##    6.1 open PNG graphics file device
png("plot1.png", width=480, height=480)
##    6.2 draw the Histogram
hist(DT$Global_active_power, col="red", xlab="Global Active Power (kilowatts)", 
     main = "Global Active Power")
##    6.3 close PNG graphics file device
dev.off()
