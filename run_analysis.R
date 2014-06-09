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

# From features_info.txt:
# "The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ."
# and
# "the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ)"
# Accelerometer (tBodyAcc-XYZ) and the gyroscope (tBodyGyro-XYZ)

# If each measurement in the dataset is a row, 
# I should extract the mean and standard deviation of the variables as such.

mean.sd.meas <- c("tBodyAcc-mean()-X",    "tBodyAcc-mean()-Y",    "tBodyAcc-mean()-Z", 
                  "tBodyAcc-std()-X",     "tBodyAcc-std()-Y",     "tBodyAcc-std()-Z",
                  "tGravityAcc-mean()-X", "tGravityAcc-mean()-Y", "tGravityAcc-mean()-Z",
                  "tGravityAcc-std()-X",  "tGravityAcc-std()-Y",  "tGravityAcc-std()-Z",
                  "tBodyGyro-mean()-X",   "tBodyGyro-mean()-Y",   "tBodyGyro-mean()-Z",
                  "tBodyGyro-std()-X",    "tBodyGyro-std()-Y",    "tBodyGyro-std()-Z")

data.ext <- data.set[, c("Subject", "Activity", mean.sd.meas)]

str(data.ext)
head(data.ext, n=10)[,1:6]

# 3. Uses descriptive activity names to name the activities in the data set
##################################################################


# 4. Appropriately labels the data set with descriptive variable names.
##################################################################


# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##################################################################







