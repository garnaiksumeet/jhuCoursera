## install packages
install.packages("rapport")
install.packages("gdata")
install.packages("plyr")

## load the packages into the current environment
library(plyr)
library(gdata)
library(rapport)

## read all the file into memory
activityLabels <- read.table("./activity_labels.txt")
featureData <- read.table("./features.txt")
xTrain <- read.table("./train/X_train.txt")
xTest <- read.table("./test/X_test.txt")
yTest <- read.table("./test/y_test.txt")
yTrain <- read.table("./train/y_train.txt")
subjectTest <- read.table("./test/subject_test.txt")
subjectTrain <- read.table("./train/subject_train.txt")

## 
activityLabels$V2 <- as.character(activityLabels$V2)
colnames(xTest) <- featureData$V2
colnames(xTrain) <- featureData$V2

##
dataTest <- cbind(cbind(join(yTest, activityLabels, by="V1"), subjectTest), xTest)
dataTrain <- cbind(cbind(join(yTrain, activityLabels, by="V1"), subjectTrain), xTrain)
dataMerged <- rbind(dataTest, dataTrain)

##
colnames(dataMerged)[1] <- "activityCode"
colnames(dataMerged)[2] <- "activityLabel"
colnames(dataMerged)[3] <- "Subject"

##
meanAndstd <- matchcols(dataMerged, with=c("mean", "std"), without="Mean", method="or")
collist <- c("activityCode", "activityLabel", "Subject", meanAndstd$mean, meanAndstd$std)
resultData <- dataMerged[, collist]

##
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

##
dataMelt <- melt(resultData, id = c("subject","activitylabel"))
tidyData <- dcast(dataMelt, subject + activitylabel~variable, mean)

tidyData