## For any Queries regarding the working of the script read the README.md file in the same repository as this.

## install required packages
install.packages("rapport")
install.packages("gdata")
install.packages("plyr")
install.packages("reshape2")

## load the packages into the current environment
library(plyr)
library(gdata)
library(rapport)
library(reshape2)

## read all the required files into memory
activityLabels <- read.table("./activity_labels.txt")
featureData <- read.table("./features.txt")
xTrain <- read.table("./train/X_train.txt")
xTest <- read.table("./test/X_test.txt")
yTest <- read.table("./test/y_test.txt")
yTrain <- read.table("./train/y_train.txt")
subjectTest <- read.table("./test/subject_test.txt")
subjectTrain <- read.table("./train/subject_train.txt")

## cast the data type of the activityLabels to character from factor
## add headers to the xTrain and xTest portion of data
activityLabels$V2 <- as.character(activityLabels$V2)
colnames(xTest) <- featureData$V2
colnames(xTrain) <- featureData$V2

## merge the data and attributes from various files to a single data entity
dataTest <- cbind(cbind(join(yTest, activityLabels, by="V1"), subjectTest), xTest)
dataTrain <- cbind(cbind(join(yTrain, activityLabels, by="V1"), subjectTrain), xTrain)
dataMerged <- rbind(dataTest, dataTrain)

## add header names to the first the columns according to the order it was binded before
colnames(dataMerged)[1] <- "activityCode"
colnames(dataMerged)[2] <- "activityLabel"
colnames(dataMerged)[3] <- "Subject"


## data consisting of the mean and standard deviation is only selected

## matchcols retrieves all the column names that consist the pattern supplied in 'with' argument
## and excludes all that consists of the pattern supplied in 'without' argument
## the 'method' indicates either 'and' or 'or' among the patterns given in 'with'
meanAndstd <- matchcols(dataMerged, with=c("mean", "std"), without="Mean", method="or")
collist <- c("activityCode", "activityLabel", "Subject", meanAndstd$mean, meanAndstd$std)
resultData <- dataMerged[, collist]

## renaming the headers of the dataset consisting of only the data of the mean and the standard deviation
headRows <- names(resultData)
headRows <- tolower(headRows)
headRows <- gsub("tbody", "timeseriesBody", headRows)
headRows <- gsub("freq", "Frequency", headRows)
headRows <- gsub("fbody", "frequencyBody", headRows)
headRows <- gsub("acc", "Accelearation", headRows)
headRows <- gsub("gyro", "Gyroscope", headRows)
headRows <- gsub("mag", "Magnitude", headRows)
headRows <- lapply(headRows, tocamel)
colnames(resultData) <- headRows

## we reshape the data with the melt and dcast functions and create 
## and an independent tidy data set with the average of each variable for each activity and each subject
dataMelt <- melt(resultData, id = c("subject","activitylabel"))
tidyData <- dcast(dataMelt, subject + activitylabel~variable, mean)

## resulted the tidy data
tidyData