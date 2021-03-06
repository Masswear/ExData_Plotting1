##Set locale to English to allow for English time units
Sys.setlocale("LC_TIME", "English")

##set path to source file, assuming the file is contained within a folder "data" in the working directory
file <- "data/household_power_consumption.txt"

# The following code was used once to identify the lines in the dataset containing the data from the dates
# of interest. This information is used to only read in the data from just those dates rather than reading
# in the entire dataset and subsetting to those dates.
##########################################################################################################
#                                                                                                        #
# ##load data.table package and read entire dataset into R using fread()                                 #
# library(data.table)                                                                                    #
# data <- fread(file)                                                                                    #
#                                                                                                        #
# ##extract numbers of lines with dates of interest                                                      #
# lines <- which(data$Date == "1/2/2007" | data$Date == "2/2/2007")                                      #
#                                                                                                        #
# ##Identify the first line after the header containing data of interest. This will be the number of     #
# ##lines to skip.                                                                                       #
# head(lines, 1)                                                                                         #
#                                                                                                        #
# ##Identify number of lines to read                                                                     #
# length(lines)                                                                                          #
#                                                                                                        #
##########################################################################################################

##read header of dataset
header <- read.table(file, header=FALSE, sep=";", stringsAsFactors=FALSE, nrows=1)

##read lines of file containing data of interest
febdata <- read.table(file, header=FALSE, sep=";", stringsAsFactors=FALSE, na.strings="?", 
                      skip=66637, nrows=2880)

##assign colnames to dataset
colnames(febdata) <- unlist(header)

##create new variable combining Date and Time variable
datetime <- (paste(febdata$Date, febdata$Time))

##combine datetime variable with rest of dataset
febdata <- cbind(datetime, febdata)

##convert datetime variable to class POSIXlt
febdata$datetime <- strptime(febdata$datetime, "%d/%m/%Y %H:%M:%S")

##remove obsolete variables Date and Time
febdata <- febdata[-c(2,3)]

##create Plot 3
##open png device with width and height as specified
png("plot3.png", width = 480, height = 480)
        ##set background to transparent
        par(bg=NA)
        ##create plot with appropriate labels and data of sub metering 1
        plot(febdata$datetime, febdata$Sub_metering_1, type="l", ylab = "Energy sub metering", xlab="")
                ##add additional line with data of sub metering 2
                lines(febdata$datetime, febdata$Sub_metering_2, type="l", col = "red")
                ##add additional line with data of sub metering 3
                lines(febdata$datetime, febdata$Sub_metering_3, type="l", col = "blue")
                ##add legend
                legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
                                                                 col = c("black", "red", "blue"), lty=c(1,1,1))
##close device
dev.off()