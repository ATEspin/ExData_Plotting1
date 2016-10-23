library(data.table) #reading using data.table is faster than using read.table
library(dplyr)

# Downloading, unzipping and reading the data------------------------------
url="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, "electric_power_consumption.zip")
unzip("electric_power_consumption.zip")
file="household_power_consumption.txt"

#The next line is use to read a small proportion of the data to take a look of the
#structure. Then we can decide how we read the data we want.

    # temporal<-fread(file, nrow=10)

data_all<-fread(file, sep=";",header = T,stringsAsFactors = FALSE)
fdata<-filter(data_all,Date=="1/2/2007" | Date=="2/2/2007") #Subsetting the data with the dates

    #rm(data_all) #cleaning the whole data set

fdata<-as.data.frame(fdata)#Tansformation to data frame, for some reason strptime() is having 
#a weird response with data.table objects but it works fine with data frame objects.

#Setting Date/Time----------------------------------------------

fdata$Date<-as.Date(fdata$Date, "%d/%m/%Y", tz="GMT")
fdata$DateTime<-with(fdata, paste(Date,Time))
fdata$DateTime<-strptime(fdata$DateTime,"%Y-%m-%d %H:%M:%S", tz="GMT")

fdata<-fdata[, c(ncol(fdata), 1:ncol(fdata)-1)] #reorganize column DateTime to be the first
fdata[,4:ncol(fdata)]<-sapply(fdata[,4:ncol(fdata)], as.numeric)

#plot 4----------------------------------------------------------------------
par(mfrow=c(2,2), mar=c(3,4,2,1))

with(fdata,{
    plot(x=DateTime, y=Global_active_power, col="black", type="l",
              main="", ylab="Global Active Power (kilowatts)", xlab="Time")
    
    plot(x=DateTime, y=Voltage, col="black", type="l",
         main="", ylab="Voltage", xlab="Time")
    
    plot(x=DateTime, y=Sub_metering_1,type="l", col="black",
         ylab="Energy sub metering", xlab="Time")
    lines(x=DateTime, y=Sub_metering_2, col="red")
    lines(x=DateTime, y=Sub_metering_3, col="blue")
    legend("topright",col=c("black", "red", "blue"), lty=1, cex=0.8,pt.cex = 1,
            legend=c("Sub metering 1","Sub metering 2", "Sub metering 3"),
           y.intersp=0.2, bty="n", xjust=1, text.width = 50000, seg.len = 1)
    
    plot(x=DateTime, y=Global_reactive_power, col="black", type="l",
         main="", ylab="Global Reactive Power", xlab="Time")
})
    

dev.copy(png, "plot4.png",width = 480, height = 480)
dev.off()
