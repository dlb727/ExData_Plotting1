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

## Plot 3
png("plot3.png", width = 480, height = 480)
with(pwdnew, plot(pwddt, Sub_metering_1, pch = NA, type = "l", xlab = "", ylab = "Energy Submetering", ylim = c(0,40)))
par(new=TRUE)
with(pwdnew, plot(pwddt, Sub_metering_2, pch = NA, type = "l", col = "red", xlab = "", ylab = "Energy Submetering", ylim = c(0,40)))
par(new=TRUE)
with(pwdnew, plot(pwddt, Sub_metering_3, pch = NA, type = "l", col = "blue", xlab = "",  ylab = "Energy Submetering", ylim = c(0,40)))
legend("topright", cex = .75, pch = c("_", "_", "_"), col=c("black","red","blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")) 
dev.off()
