#### This document explains all the values computed in run_analysis.R along with bit of explaining of the code
    The run_analysis.R script assumes that the system on which the script is being run has only the basic R packages installed. Comment out the packages your system already has got installed accordingly.

##### Packages to be loaded to the current working environment
* rapport
* gdata
* plyr
* reshape2

##### Variables that conatain the data of the raw files read
* activityLabels - contains data of activity_labels.txt
* featureData - contains data of features.txt
* xTrain - contains data of X_train.txt
* xTest - contains data of X_test.txt
* yTest - contains data of y_test.txt
* yTrain - contains data of y_train.txt
* subjectTest - contains data of subject_test.txt
* subjectTrain - contains data of subject_train.txt

##### Intermediate data consisiting of combination of few of the raw data read from the files
* dataTest - Merged Test data from subjectTest, xTest, yTest, activityLabels
* dataTrain - Merged Train data from subjectTrain, xTrain, yTrain, activityLabels
* dataMerged - Merged Train and Test Data along with headers
* meanAndstd - A list comprising the column names which are either mean or standard deviation
* collist - The complete list comprising the column names which are either mean or standard deviation
* resultData - The data frame that consists the data of only the standard deviation and mean measurements
* headRows - The list consisting of the headers and after certain manipulations it consists of self explaining names
* dataMelt - The data frame consisting of the melted data frame of resultData
* tidyData - An independent tidy data set with the average of each variable for each activity and each subject

##### Basic algorithm of the script
* install the extra packages
* load the required packages
* read all the required files
* add appropriate headers to the partial datasets
* merge the data sets
* add appropriate headers after merging
* select the data consisting only mean and standard deviation measurements
* rename the headers such that they are self explaining
* reshape and create an independent tidy data set with the average of each variable for each activity and each subject