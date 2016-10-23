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

fdata<-fdata[, c(ncol(fdata), 1:ncol(fdata)-1)] # reorganize column DateTime to be the first
fdata[,4:ncol(fdata)]<-sapply(fdata[,4:ncol(fdata)], as.numeric)

#plot 1----------------------------------------------------------------------
with(fdata,hist(Global_active_power, col="red", breaks = 16,
                main="Global active power", 
                xlab="Global active power(kilowatts)"))

dev.copy(png, "plot1.png",width = 480, height = 480)
dev.off()
