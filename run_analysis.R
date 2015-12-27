# This script will do the following with data downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 1) Merge the training data set and the test data set into one data set
# 2) Extracts only the measurements on the mean and standard deviation for each measurement
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Labels the data set with descriptive variable names
# 5) From the data set in step 4, creates a separate, independent, tidy data set w/ the avg of each variable for each activity
#    and each subject

# Set working directory to location of downloaded files
setwd("/Users/danielbober/Documents/Class/Data Science/Getting and Cleaning Data/UCI HAR Dataset/")

# Load the plyr package
library(plyr)

# Load the dplyr package
library(dplyr)

# Read in the files in the UCI HAR Dataset
activity_labels <- read.table("./activity_labels.txt", header = FALSE)
features <- read.table("./features.txt", header = FALSE)

# Label the columns of activity_labels and features in the UCI HAR Dataset
colnames(activity_labels) <- c("ActivityID", "ActivityType")
colnames(features) <- c("FeaturesNumber", "FeaturesType")

# Read in the files from the "train" data folder
subject_train <- read.table("./train/subject_train.txt", header = FALSE)
x_train <- read.table("./train/X_train.txt", header = FALSE)
y_train <- read.table("./train/y_train.txt", header = FALSE)

# Label the columns of the "train" data
colnames(subject_train) <- "SubjectID"
colnames(x_train) <- features[, 2]
colnames(y_train) <- "ActivityID"

# Combine the "train" data into one data frame
traindata <- cbind(y_train, subject_train, x_train)

# Read in the files from the "test" data folder
subject_test <- read.table("./test/subject_test.txt", header = FALSE)
x_test <- read.table("./test/X_test.txt", header = FALSE)
y_test <- read.table("./test/y_test.txt", header = FALSE)

# Label the columns of the "test" files
colnames(subject_test) <- "SubjectID"
colnames(x_test) <- features[, 2]
colnames(y_test) <- "ActivityID"

# Combine the "test" data into one data frame
testdata <- cbind(y_test, subject_test, x_test)

##### 1) Create one dataset from traindata and testdata #####
agg_data <- rbind(traindata, testdata)

# Remove columns with duplicated names from agg_data
agg_clean <- agg_data[, !duplicated(colnames(agg_data))]

##### 2) Extracts only the measurements on the mean and standard deviation for each measurement #####

# Select columns containing the string "mean" from agg_clean
agg_mean <- select(agg_clean, contains("mean"))

# Select columns containing the string "std" from agg_clean
agg_std <- select(agg_clean, contains("std"))

# Combine agg_mean and agg_std into one dataset along with subject_test and y_test
agg_selected <- cbind("ActivityID" = agg_data[, 1], "SubjectID" = agg_data[, 2], agg_mean, agg_std)

##### 3) Uses descriptive activity names to name the activities in the data set #####

# Use descriptive activity names from the activity labels data frame to replace the ActivityID column in agg_selected
tidy_data <- merge(agg_selected, activity_labels, by = 'ActivityID', all.x = TRUE, sort = TRUE)

# Reorder tidy_data columns so that "ActivityType" is the first column, and "ActivityID" gets dropped
tidy_data <- cbind(tidy_data[, 89], tidy_data[, 2:88])

##### 4) Labels the data set with descriptive variable names #####

# Return a vector of column names from tidy_data
col_names <- colnames(tidy_data)

# Loop through the col_names vector and replace the variable names with simpler names
for (i in 1:length(col_names)) {
  col_names[i] <- gsub("\\()", "", col_names[i])
  col_names[i] <- gsub("^(t)", "Time", col_names[i])
  col_names[i] <- gsub("^(f)", "Freq", col_names[i])
  col_names[i] <- gsub("-mean", "Mean", col_names[i])
  col_names[i] <- gsub("-Freq", "Freq", col_names[i])
  col_names[i] <- gsub("-std", "Std", col_names[i])
  col_names[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",col_names[i])
}

# Rename the columns of tidy_data using the cleaned up names from col_names
colnames(tidy_data) <- col_names

# Rename the first column in tidy_data to read "ActivityType"
names(tidy_data)[names(tidy_data) == "Timeidy_data[, 89]"] <- "ActivityType"

##### 5) Create a separate data set w/ the average of each variable for each activity and subject #####

# Group final_tidy first by SubjectID, then by ActivityType
final_tidy <- group_by(tidy_data, SubjectID, ActivityType)

# Convert SubjectID to factors
final_tidy$SubjectID <- as.factor(final_tidy$SubjectID)

# Find the mean of average of each variable for each activity and subject
finished_data <- summarize_each(final_tidy, funs(mean))

# Write the final data set to a file and export it
write.table(finished_data, './finished_data.txt', row.names = FALSE, sep='\t')