## load following packages, if not already loaded
require(dplyr)
require(data.table)
require(lubridate)  

## read text file into data table, then subset 2 dates for plotting; discard remaining data to declutter working environment
powerdata <- read.table("./household_power_consumption.txt", sep = ";", quote = "", header = TRUE, na.strings = "?") %>% data.table()
subset(powerdata, Date == "1/2/2007") -> powerdataset
subset(powerdata, Date == "2/2/2007") -> powerdataset2
rbind(powerdataset, powerdataset2) -> pwd
rm(powerdata, powerdataset, powerdataset2)

## extract date and time columns and reformat to one column in date/time format; combine with rest of columns
nodatetime <- select(pwd, Global_active_power:Sub_metering_3)
temp <- paste(pwd$Date, pwd$Time)
dmy_hms(temp) -> pwddt
cbind(pwddt, nodatetime) -> pwdnew
rm(pwddt, temp, nodatetime)

## Plot 2
png("plot2.png", width = 480, height = 480)
par(xlog = FALSE)
with(pwdnew, plot(pwddt, Global_active_power, pch = NA, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))
dev.off()
