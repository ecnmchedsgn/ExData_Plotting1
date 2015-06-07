#read first column of dates
df = read.table(file="household_power_consumption.txt",sep=";", header=T, colClasses=c("character", rep("NULL",8)))

#evaluate dates 2007-02-01 and 2007-02-02
date <- strptime(df$Date, format = "%d/%m/%Y")
library(lubridate)
date <- ymd(date) # assume EST time zone

start_date <- ymd("2007-02-01")
end_date <- ymd("2007-02-02")
select_date <- date >= start_date & date <= end_date
row <- which(select_date == TRUE);
skiprow <- row[1] 
numrows <- sum(select_date)

# read selected rows (total of 2880 rows)
df = read.table(file="household_power_consumption.txt",sep=";", header=T, skip = skiprow, nrows = numrows, 
                col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3"))



# create new data frame
df$Time <- as.numeric(df$Time)
tt <- 1:2880
mydf <- data.frame(cbind(tt,df$Sub_metering_1,df$Sub_metering_2,df$Sub_metering_3))
library(reshape)
mydd <- melt(mydf,id = c("tt"))

# plot
png(filename = "plot3.png", width = 480, height = 480)
par(pty="s",font.axis = 8,font.lab = 8,cex=0.8)
tmp <- subset(mydd, variable == 'V2')
plot(tmp$value, type = 'l', xaxt='n',xlab="",ylab="Energy sub metering")
axis(side = 1, at = c(1,1440,2880), labels = c("Thur","Fri","Sat"))
tmp <- subset(mydd, variable == 'V3')
lines(tmp$value, col = 'red')
tmp <- subset(mydd, variable == 'V4')
lines(tmp$value, col = 'blue')
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
dev.off()