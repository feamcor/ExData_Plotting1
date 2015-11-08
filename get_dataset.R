##
## Coursera Data Science Specialization
## Course: Exploratory Data Analysis
## Course Instance: exdata-034
## Assignment: Course Project 1
## Student: Fabio Correa (feamcor)
##

#
# Introduction
# 
# This assignment uses data from the UCI ML Repository,
# a popular repository for ML datasets. In particular,
# we will be using the "Individual household electric 
# power consumption Data Set".
# 
# Description: Measurements of electric power consumption in one
# household with a one-minute sampling rate over a period of almost 4 years.
# Different electrical quantities and some sub-metering values are available.
# 
# The following descriptions of the 9 variables in the dataset are taken
# from the UCI web site:
#     
# Date: Date in format dd/mm/yyyy
# Time: time in format hh:mm:ss
# Global_active_power: household global minute-averaged active power (kw)
# Global_reactive_power: household global minute-averaged reactive power (kw)
# Voltage: minute-averaged voltage (volt)
# Global_intensity: household global minute-averaged current intensity (amp)
# Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It
#   corresponds to the kitchen, containing mainly a dishwasher, an oven and a
#   microwave (hot plates are not electric but gas powered).
# Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It
#   corresponds to the laundry room, containing a washing-machine,
#   a tumble-drier, a refrigerator and a light.
# Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It
#   corresponds to an electric water-heater and an air-conditioner.
#

##
## Download, unzip, read and returns the
## relevant dataset in order to be used
## by plotting scripts 1, 2, 3 and 4
##

get_dataset <- function() {
    rdata.filename <- "get_dataset.RData"
    if(file.exists(rdata.filename)) {
        load(rdata.filename)
        message(paste(Sys.time(), "Dataset last download on", dataset.download))
    }

    filename.1 <- "household_power_consumption.zip"
    if(!file.exists(filename.1)) {
        dataset.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(url = dataset.url, destfile = filename.1, method = "auto")
        message(paste(Sys.time(), "Downloaded dataset zip file!", filename.1))

        dataset.download = Sys.time()
        save(dataset.download, file = rdata.filename)
        message(paste(Sys.time(), "Download date wrote on file!", rdata.filename))
    }

    filename.2 <- "household_power_consumption.txt"
    if(!file.exists(filename.2)) {
        unzip(filename.1, overwrite = TRUE)
        message(paste(Sys.time(), "Dataset zip file unzipped!", filename.2))
    }

# 
# When loading the dataset into R, please consider the following:
#   The dataset has 2,075,259 rows and 9 columns.
#   First calculate a rough estimate of how much memory the dataset will
#   require in memory before reading into R. Make sure your computer has enough
#   memory (most modern computers should be fine).
#
    file.nrows <- as.integer(strsplit(trimws(system(paste(
        "wc -l", filename.2), intern = TRUE)), split = " ")[[1]][1]) - 1
    message(paste(Sys.time(), "Full dataset contains", file.nrows, "rows! (wc -l)"))

    dataset.size <- file.nrows * (    # number of rows in the file
        object.size("DD/MM/YYYY") +   # 1st column represents a date
        object.size("HH:MI:SS") +     # 2nd column represents a time
        object.size(Sys.time()) +     # New column represents date+time
        (object.size(numeric(1)) * 7) # other 7 columns are numbers
    )
    message(paste(Sys.time(), "Aproximated memory size of full dataset!",
                  format(dataset.size, units = "auto")))

#
# We will only be using data from the dates 2007-02-01 and 2007-02-02.
#   One alternative is to read the data from just those dates rather than
#   reading in the entire dataset and subsetting to those dates.
# Note that in this dataset missing values are coded as ?.
#

    dataset <- read.table(filename.2,
                          header = TRUE,
                          sep = ";",
                          na.strings = "?",
                          colClasses = c("character",
                                         "character",
                                         "numeric",
                                         "numeric",
                                         "numeric",
                                         "numeric",
                                         "numeric",
                                         "numeric",
                                         "numeric"),
                          blank.lines.skip = TRUE)
    message(paste(Sys.time(), "Read", nrow(dataset), "observations!", filename.2))

    dataset <- dataset[grep("^[12]/2/2007", dataset$Date),]
    message(paste(Sys.time(), "Reduced to", nrow(dataset), "observations from Feb 01 and 02, 2007!"))

#
# You may find it useful to convert the Date and Time variables to
#   Date/Time classes in R using the strptime() and as.Date() functions.
#
    dataset$DateTime <- as.POSIXct(paste(dataset$Date, dataset$Time),
                                   format = "%d/%m/%Y %H:%M:%S")
    dataset$Date <- NULL
    dataset$Time <- NULL
    message(paste(Sys.time(), "Coerced Date and Time into POSIXct on new DateTime column!"))
    message(paste(Sys.time(), "Eliminated original Date and Time columns!"))

    return(dataset)
}
