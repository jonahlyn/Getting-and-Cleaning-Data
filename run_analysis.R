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

# Test Data
test.set <- read.table("data/UCI HAR Dataset/test/X_test.txt")    # 2947 obs. of 561 variables
test.labels <- read.table("data/UCI HAR Dataset/test/y_test.txt") # 2947 obs. of 1 variable
test.subjects <- read.table("data/UCI HAR Dataset/test/subject_test.txt") #2947 obs. of  1 variable

# Name the columns
names(test.set) <- features[,2]
names(test.set)

str(test.set) # 2947 obs. of  561 variables
head(test.set, n=5)[,1:5]

str(test.labels) # 2947 obs. of  1 variable
head(test.labels)
table(test.labels, useNA="ifany") # 1-6 (Activity Labels)

str(test.subjects) # 2947 obs. of  1 variable
head(test.subjects)
table(test.subjects, useNA="ifany") # 2,4,9,10,12,13,18,20,24 (of the 30 volunteers)

test.set$Subject <- test.subjects
test.set$Activity <- test.labels

test.set[, c("Subject", "Activity")]

# Train Data

train.set <- read.table("data/UCI HAR Dataset/train/X_train.txt")
train.labels <- read.table("data/UCI HAR Dataset/train/y_train.txt")
train.subjects <- read.table("data/UCI HAR Dataset/train/subject_train.txt")

# Name the columns
names(train.set) <- features[,2]

str(train.set) # 7352 obs. of  561 variables
head(train.set)[,1:5]

str(train.labels) # 7352 obs. of  1 variable
head(train.labels)
table(train.labels, useNA="ifany") # 1-6 (Activity Labels)

str(train.subjects) # 7352 obs. of  1 variable
head(train.subjects)
table(train.subjects, useNA="ifany") # 1-30 (Volunteers)

train.set$Subject <- train.subjects
train.set$Activity <- train.labels

train.set[, c("Subject", "Activity")]

data.set <- rbind(test.set, train.set)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
##################################################################


# 3. Uses descriptive activity names to name the activities in the data set
##################################################################


# 4. Appropriately labels the data set with descriptive variable names.
##################################################################


# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##################################################################







