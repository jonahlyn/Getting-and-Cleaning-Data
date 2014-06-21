
Disclaimer
------------------
The code contained in this repository was written for the final project for Coursera's Getting and Cleaning Data Course.


What data is used
---------------------------
This script works with the Human Activity Recognition Using Smartphones Dataset. The original dataset and its description can be found here:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


How the data is processed
-------------------------------------------
This script creates two separate data sets as output and stores the files in the output directory.

### tidy.txt

The purpose of the first data set was to prepare (tidy) the data in the original data set for further operation and the creation of the second data set described below.

The experiment that produced the original data set separated participants into test and train groups so it was necessary to merge the test and train data into a single data set using a simple row bind. 

Since the operations in the second data set are only concerned with the mean and standard deviation for each measurement, the mean() and std() features from the list of 17 signals in features_info.txt in the original data set were selected - 8 with XYZ 3-axial signals (8 * 3 * 2 = 48) and 9 magnitudes (9 * 2 = 18) for a total of 66 features extracted. Extracting the features with 'mean()' and 'std()' in the feature name seemed to accomplish this.

The original data set coded the six activities as 1-6 so it was necessary to use activity_labels.txt from the original data set to get human-readable names of the activities. This was accomplished by using a join on the 'Activity' column.

To avoid impossibly long feature names it was decided the original feature names were sufficiently descriptive. The original feature names were used for the tidy data set in lower case minus the special characters '(' and ')'.

### tidy-avg.txt

Finally, the script calculates the average of each mean and standard deviation feature for each activity and each subject. This was most easily accomplished using the melt and cast functions in the Hadley Wickham's reshape2 package.


What output can be expected
--------------------------------------------
Two new files will be written to the output directory.

1. tidy.txt
2. tidy-avg.txt

Both files can be read into R with read.table.


How to run the script
-----------------------------------
The script is written in the R statistical programming language. It is assumed that the working directory has been set to the root of the repository.

The dataset as downloaded on Wed Jun 18, 2014 has been included in the repository in the data folder. If the dataset should be updated in the future it should be sufficient to delete or rename the data folder. The new dataset will be downloaded the next time the script is run.

The script relies on the following packages which must be installed prior to running the script:

* plyr
* reshape2

