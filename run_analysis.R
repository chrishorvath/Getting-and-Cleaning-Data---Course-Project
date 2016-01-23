library(reshape2)
library(RCurl)

filename <- "Dataset.zip"

# Download Dataset if it is not already avalible
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="libcurl")
}  

# Unzip file unless it has already been done
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}


# Load activity labels and features initial list of activities needed 
# Descriptive values will be merged into final tidy dataset as factor elements as well
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels[,2] <- as.character(activity_labels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# Identify the column position of measurement mean and standard deviation
# Columns will be used limit data load to these fields
measure_mean_std <- grep(".*mean.*|.*std.*", features[,2])

# Find the column names to match features and clean up naming conventions
measure_mean_std.names <- features[measure_mean_std,2]
measure_mean_std.names = gsub('-mean', 'Mean', measure_mean_std.names)
measure_mean_std.names = gsub('-std', 'Std', measure_mean_std.names)
measure_mean_std.names <- gsub('[-()]', '', measure_mean_std.names)



# Load the datasets (only mean and standard deviations)
train <- read.table("UCI HAR Dataset/train/X_train.txt")[measure_mean_std]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[measure_mean_std]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge test and train data
tidyData <- rbind(train, test)

# add descriptive column names for the full data set
colnames(tidyData) <- c("subject", "activity", measure_mean_std.names)

# turn activities & subjects into factors (descriptive labels)
# No descriptive labels for subject so just the value for enumeration
tidyData$activity <- factor(tidyData$activity, levels = activity_labels[,1], labels = activity_labels[,2])
tidyData$subject <- as.factor(tidyData$subject)


# pivot data for mean calculation on the subject / activity as key
tidyData.melted <- melt(tidyData, id = c("subject", "activity"))

# Calculate the average of each variable for each activity and each subject
tidyData.mean <- dcast(tidyData.melted, subject + activity ~ variable, mean)


#  output table to tidy.txt
write.table(tidyData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)