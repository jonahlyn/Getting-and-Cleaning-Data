# How to set the working directory to the current one?

# If a data directory does not exist, create the directory and download the data set into it.
if(!file.exists("./data")){ 
  dir.create("./data") 
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "data/dataset.zip", method = "curl") 
  data.downloaded = date()
  unzip("data/dataset.zip", exdir = "data")
}


# 1. Merges the training and the test sets to create one data set.
##################################################################

# Get the file containing the column names for the variables
features <- read.table("data/UCI HAR Dataset/features.txt")
str(features) # 561 obs. of  2 variables
cnames <- c("Subject", "Activity", as.character(features[,2]))
str(cnames)


# Test Data
test.set <- read.table("data/UCI HAR Dataset/test/X_test.txt")    # 2947 obs. of 561 variables
test.labels <- read.table("data/UCI HAR Dataset/test/y_test.txt") # 2947 obs. of 1 variable
test.subjects <- read.table("data/UCI HAR Dataset/test/subject_test.txt") #2947 obs. of  1 variable

str(test.set) # 2947 obs. of  561 variables
head(test.set, n=5)[,1:5]

str(test.labels) # 2947 obs. of  1 variable
head(test.labels)
table(test.labels, useNA="ifany") # 1-6 (Activity Labels)

str(test.subjects) # 2947 obs. of  1 variable
head(test.subjects)
table(test.subjects, useNA="ifany") # 2,4,9,10,12,13,18,20,24 (of the 30 volunteers)

# Add new columns to the data
test.set <- cbind(test.subjects, test.labels, test.set)

# Name the columns
colnames(test.set) <- cnames
colnames(test.set)

head(test.set, n=5)[,1:5]


# Train Data
train.set <- read.table("data/UCI HAR Dataset/train/X_train.txt")
train.labels <- read.table("data/UCI HAR Dataset/train/y_train.txt")
train.subjects <- read.table("data/UCI HAR Dataset/train/subject_train.txt")

str(train.set) # 7352 obs. of  561 variables
head(train.set)[,1:5]

str(train.labels) # 7352 obs. of  1 variable
head(train.labels)
table(train.labels, useNA="ifany") # 1-6 (Activity Labels)

str(train.subjects) # 7352 obs. of  1 variable
head(train.subjects)
table(train.subjects, useNA="ifany") # 1-30 (Volunteers)

# Add new columns to the data
train.set <- cbind(train.subjects, train.labels, train.set)

# Name the columns
names(train.set) <- cnames

head(train.set)[,1:5]


# Combine the datasets
data.set <- rbind(test.set, train.set)

head(data.set, n=50)[,1:5]
table(data.set$Subject, useNA="ifany")



# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
##################################################################

# This extracts the mean and standard deviation for each signal listed in features_info.txt.
# 8 variables with XYZ 3-axial signals (8 * 3 * 2 = 48) 
# and 9 magnitudes of these variables (9 * 2 = 18)
# for a total of 66 features extracted.

mean.meas <- grep("(mean|std)\\(\\)", colnames(data.set), value = TRUE)

data.ext <- data.set[, c("Subject", "Activity", mean.meas)]

str(data.ext)

# 3. Uses descriptive activity names to name the activities in the data set
##################################################################

library("plyr")

# Read in the activity labels
activity.labels <- read.table("data/UCI HAR Dataset/activity_labels.txt")
colnames(activity.labels) <- c("Activity", "ActivityLabel")

# Join the activity labels into the data set
data.act <- join(data.ext, activity.labels, by = 'Activity')

# Reorder the columns so that the activity label is the second column.
data.act <- data.act[c(1,69,2:68)]

# Remove the original "Activity" column
data.act <- data.act[,!(colnames(data.act) %in% c("Activity"))]

# 4. Appropriately labels the data set with descriptive variable names.
##################################################################

colnames(data.act) <- gsub("\\(\\)", "", tolower(colnames(data.act)))


# 5. Creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.
##################################################################

library(reshape2)

# Collect the column names for future use
colids <- colnames(data.act)[1:2]
colvars <- colnames(data.act)[3:length(colnames(data.act))]

# Reshape the data and take the mean of each variable by subject and activity
data.melt <- melt(data.act, id=colids, measure.vars=colvars)
data.cast <- dcast(data.melt, subject + activitylabel ~ variable, mean)

# Add 'avg' to the variable name to differentiate the data in the new data set.
colnames(data.cast) <- c(colids, gsub("(.*)", "avg-\\1", colvars))


# Write data sets to a file
##################################################################

if(!file.exists("./output")){ 
  dir.create("./output") 
}

write.table(data.act, file = "output/tidy-original.txt", row.names = FALSE)
write.table(data.cast, file = "output/tidy-avg.txt", row.names = FALSE)
