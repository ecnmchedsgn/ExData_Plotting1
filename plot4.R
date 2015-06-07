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

# same as in Plot2.R
myvector <- df$Global_active_power
myts <- ts(myvector)

# create new data frame (same as in Plot 3)
df$Time <- as.numeric(df$Time)
tt <- 1:2880
mydf <- data.frame(cbind(tt,df$Sub_metering_1,df$Sub_metering_2,df$Sub_metering_3))
library(reshape)
mydd <- melt(mydf,id = c("tt"))

# plot 4
png(filename = "plot4.png", width = 480, height = 480)

par(mfrow = c(2,2),
    oma = c(1,1,0,0) + 0.1,
    mar = c(5,4,1,0) + 1)

par(pty="s",cex=0.55)
plot(myts,xaxt = "n", xlab = "",ylab = "Global Active Power (kilowatts)")
axis(side = 1, at = c(1,1440,2880), labels = c("Thur","Fri","Sat"))


par(pty="s",cex=0.55)
plot(df$Voltage,type='l',xaxt = 'n',xlab=" ",ylab="Voltage")
axis(side = 1, at = c(1,1440,2880), labels = c("Thur","Fri","Sat"))
title(xlab = "datetime")


par(pty="s",cex=0.55)
tmp <- subset(mydd, variable == 'V2')
plot(tmp$value, type = 'l', xaxt='n',xlab="",ylab="Energy sub metering")
axis(side = 1, at = c(1,1440,2880), labels = c("Thur","Fri","Sat"))
tmp <- subset(mydd, variable == 'V3')
lines(tmp$value, col = 'red')
tmp <- subset(mydd, variable == 'V4')
lines(tmp$value, col = 'blue')
legend("topright", bty = "n",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

par(pty="s",cex=0.55)
plot(df$Global_reactive_power,type='l',xaxt = 'n',xlab=" ",ylab="Global_reactive_power")
axis(side = 1, at = c(1,1440,2880), labels = c("Thur","Fri","Sat"))
title(xlab = "datetime")

dev.off()


