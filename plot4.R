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

## Plot 4
png("plot4.png", width = 480, height = 480)
##universal parameters
par(mfcol=c(2,2),mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0), xlog = FALSE)  
##top left graph
with(pwdnew, plot(pwddt, Global_active_power, pch = NA, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)"))
##bottom left graph
with(pwdnew, plot(pwddt, Sub_metering_1, pch = NA, type = "l", xlab = "", ylab = "Energy Submetering", ylim = c(0,40)))  
par(new=TRUE)
with(pwdnew, plot(pwddt, Sub_metering_2, pch = NA, type = "l", col = "red", xlab = "", ylab = "Energy Submetering", ylim = c(0,40)))
par(new=TRUE)
with(pwdnew, plot(pwddt, Sub_metering_3, pch = NA, type = "l", col = "blue", xlab = "",  ylab = "Energy Submetering", ylim = c(0,40)))
legend("top", bty = "n", xjust = 1, pt.cex = 1, cex = .7, ncol = 1, text.width = 1, y.intersp = .95, pch = c("_", "_", "_"), col=c("black","red","blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")) 
##top right graph
with(pwdnew, plot(pwddt, Voltage, pch = NA, type = "l", xlab = "datetime", ylab = "Voltage"))  
##bottom right graph
with(pwdnew, plot(pwddt, Global_reactive_power, pch = NA, type = "l", xlab = "datetime", ylab = "Global ReActive Power"))  
dev.off()
