# Save URL of the zip file
zip_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Create a temporary file to store the downloaded zip file
temp_file <- tempfile()

# Download the zip file
download.file(zip_url, temp_file)

# Read the data file from the zip archive
data <- read.table(unz(temp_file, "household_power_consumption.txt"), header = TRUE, sep = ";", dec = ".")

# Convert Date and Time to Date/Time 
data$DateTime <- strptime(paste(data$Date, data$Time), format = "%d/%m/%Y %H:%M:%S")

# Filter rows where Date is "2007-02-01" or "2007-02-02"
filtered_data <- subset(data, DateTime >= "2007-02-01 00:00:00" & DateTime < "2007-02-03 00:00:00")

#Convert chr numbers to numeric
filtered_data$Global_active_power <- as.numeric(filtered_data$Global_active_power)
filtered_data$Global_reactive_power <- as.numeric(filtered_data$Global_reactive_power)
filtered_data$Voltage <- as.numeric(filtered_data$Voltage)
filtered_data$Global_intensity <- as.numeric(filtered_data$Global_intensity)
filtered_data$Sub_metering_1 <- as.numeric(filtered_data$Sub_metering_1)
filtered_data$Sub_metering_2 <- as.numeric(filtered_data$Sub_metering_2)

#Add weekday
filtered_data$day<- factor(weekdays(filtered_data$DateTime, TRUE),
                            levels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"),
                            labels = c("Mon", "Tues", "Wed", "Thurs", "Fri", "Sat", "Sun"))

#Remove the temporary file
unlink(temp_file)

# Set up the plot
par(mar = c(5, 4, 4, 2) + 0.1)

#Specify x and y, graph  type, color, line density, add label and remove x axis
plot(filtered_data$DateTime, filtered_data$Global_active_power, type = "l", col = "black", lwd = 1,
       +      xlab = "", ylab = "Global Active Power (kilowatts)",
       +      xaxt = "n")

# Add a black border around the plot
  box(lwd = 1)
 
# Format the x-axis to use abbr weekdays and add a day for Sat
  axis.POSIXct(1, at = seq(min(filtered_data$DateTime), max(filtered_data$DateTime) + 86400, by = "day"),  
                 +              format = "%a", las = 1)

# Set the background color to white
  par(bg = "white")
 
#Save hist to png and close connection
dev.copy(png, file = "plot2.png", width = 480, height = 480)
dev.off()