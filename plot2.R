#read first column of dates
df = read.table(file="household_power_consumption.txt",sep=";", header=T, colClasses=c("character", rep("NULL",8)))

#evaluate dates 2007-02-01 and 2007-02-02
date <- strptime(df$Date, format = "%d/%m/%Y")
library(lubridate)
date <- ymd(date, tz = "EST") # assume EST time zone

start_date <- ymd("2007-02-01", tz = "EST")
end_date <- ymd("2007-02-02", tz = "EST")
select_date <- date >= start_date & date <= end_date
row <- which(select_date == TRUE);
skiprow <- row[1] 
numrows <- sum(select_date)

# read selected rows (total of 2880 rows)
df = read.table(file="household_power_consumption.txt",sep=";", header=T, skip = skiprow, nrows = numrows, 
                col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3"))


# plot 2
# convert to time series
myvector <- df$Global_active_power
myts <- ts(myvector)

# plot
par(pty="s")
png(filename = "plot2.png", width = 480, height = 480)
plot(myts,xaxt = "n", xlab = "",ylab = "Global Active Power (kilowatts)")
axis(side = 1, at = c(1,1440,2880), labels = c("Thur","Fri","Sat"))
dev.off()