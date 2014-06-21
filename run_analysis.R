#
# file: run_analysis.R
# Main script to process the data set and creates two tidy data sets as output.
#

# If a data directory does not exist, create the directory and download the data set into it.
if(!file.exists("./data")){ 
  dir.create("./data") 
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "data/dataset.zip", method = "curl") 
  data.downloaded = date()
  unzip("data/dataset.zip", exdir = "data")
  
  print(paste("New data set downloaded on:", data.downloaded))
}


# 1. Merges the training and the test sets to create one data set.
##################################################################

# Get the file containing the column names for the variables and use it to create a vector of column names.
features <- read.table("data/UCI HAR Dataset/features.txt")
cnames <- c("Subject", "Activity", as.character(features[,2]))


# Read in the test data
test.set <- read.table("data/UCI HAR Dataset/test/X_test.txt")
test.labels <- read.table("data/UCI HAR Dataset/test/y_test.txt")
test.subjects <- read.table("data/UCI HAR Dataset/test/subject_test.txt")

# Merge labels and subject columns into the test data set
test.set <- cbind(test.subjects, test.labels, test.set)

# Name the columns of the test data set
colnames(test.set) <- cnames


# Read in the train data
train.set <- read.table("data/UCI HAR Dataset/train/X_train.txt")
train.labels <- read.table("data/UCI HAR Dataset/train/y_train.txt")
train.subjects <- read.table("data/UCI HAR Dataset/train/subject_train.txt")

# Merge labels and subject columns into the train data set
train.set <- cbind(train.subjects, train.labels, train.set)

# Name the columns of the train data set
names(train.set) <- cnames


# Combine the test and train data sets into a single data frame
data.set <- rbind(test.set, train.set)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
############################################################################################

# This extracts the mean and standard deviation for each signal listed in features_info.txt.
# 8 variables with XYZ 3-axial signals (8 * 3 * 2 = 48) 
# and 9 magnitudes of these variables (9 * 2 = 18)
# for a total of 66 features extracted.

# Select only the features with mean() and std() in the name
mean.meas <- grep("(mean|std)\\(\\)", colnames(data.set), value = TRUE)

# Subset the merged data set to select only these features
data.ext <- data.set[, c("Subject", "Activity", mean.meas)]


# 3. Uses descriptive activity names to name the activities in the data set
##################################################################

library("plyr")

# Read in the activity labels
activity.labels <- read.table("data/UCI HAR Dataset/activity_labels.txt")
colnames(activity.labels) <- c("Activity", "Activity.Label")

# Join the activity labels into the data set
data.act <- join(data.ext, activity.labels, by = 'Activity')

# Reorder the columns so that the activity label is the second column.
data.act <- data.act[c(1,69,2:68)]

# Remove the original "Activity" column
data.act <- data.act[,!(colnames(data.act) %in% c("Activity"))]


# 4. Appropriately labels the data set with descriptive variable names.
##################################################################

colnames(data.act) <- gsub("\\(\\)", "", tolower(colnames(data.act)))
colnames(data.act) <- gsub("-", ".", colnames(data.act))


# 5. Creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.
##################################################################

library(reshape2)

# Collect the column names for future use
colids <- colnames(data.act)[1:2]
colvars <- colnames(data.act)[3:length(colnames(data.act))]

# Reshape the data and take the mean of each variable by subject and activity
data.melt <- melt(data.act, id=colids, measure.vars=colvars)
data.cast <- dcast(data.melt, subject + activity.label ~ variable, mean)

# Add 'avg' to the variable name to differentiate the data in the new data set.
colnames(data.cast) <- c(colids, gsub("(.*)", "avg.\\1", colvars))


# Write data sets to a file
##################################################################

if(!file.exists("./output")){ 
  dir.create("./output") 
}

write.table(data.act, file = "output/tidy-original.txt", row.names = FALSE, quote = FALSE)
write.table(data.cast, file = "output/tidy-avg.txt", row.names = FALSE, quote = FALSE)
