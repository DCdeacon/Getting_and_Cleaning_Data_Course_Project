## Getting and Cleaning Data Project, Johns Hopkins University

Daniel Bober

### Description
Information about the variables, data, and process used in the course project for the Johns Hopkins Getting and Cleaning Data course.

### Source Data
[A description of the data used in this project can be found here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#)

[The source data can be found at this here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

### Data Set Information
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

### Attribute Information
The following is provided for each record in the data set: 
- Acceleration from the accelerometer (total acceleration) and the estimated body acceleration in each axis direction
- Angular velocity from the gyroscope in each axis direction
- A 561-feature vector with time and frequency domain variables
- An activity label
- A subject identifier

### Section 0: Prepare the workspace, read in the data, rename the columns in each data frame
First, set the working directory, and load the plyr and dplyr packages, then read in the following files:
- activity_labels.txt
- features.txt
- subject_train.txt
- X_train.txt
- y_train.txt
- subject_test.txt
- X_test.txt
- y_test.txt

Rename the columns

### Section 1: Merge the training data set and the test data set into one data set
Combine the training data sets together, then the test data sets together; combine the aggregate training and test data frames into one data frame

From the aggregate data frame, remove duplicate column names

## Section 2: Extract only the measurements on the mean and standard deviation for each measurement
From the aggregate data frame with no duplicates, select only the columns containing “mean” or “std” in their names

## Section 3: Use descriptive activity names to name the activities in the data set
Merge the mean and std data frame with the ActivityType table to rename the activity types

## Section 4: Label the data set with descriptive variable names
Loop through the column names and rename them using cleaner, more descriptive names (remove things like “-“, “()”, etc)

## Section 5: Create a separate data set w/ the average of each variable for each activity and subject
First, group the data by SubjectID then ActivityType; calculate the mean of each column (variable)

Write this final table to a .txt file