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

#Remove the temporary file
unlink(temp_file)

#Create hist of Global Active Power, color red, main title and x label
plot1<-hist(filtered_data$Global_active_power, col="red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")

#Save hist to png and close connection
dev.copy(png, file = "plot1.png", width = 480, height = 480)
dev.off()