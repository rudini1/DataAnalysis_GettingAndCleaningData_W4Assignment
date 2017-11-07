#  Script to load the data into R-objects

## Prerequisite 
setwd("~/Documents/Coursera/Data analysis/DataCleaning/week4/ProgrammingAssignmentW4/DataAnalysis_GettingAndCleaningData_W4Assignment")
library(data.table)

## Download and unzip the dataset:
filename <- "../getdata-projectfiles-UCI HAR Dataset.zip"

if (!file.exists(filename)){
      fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
      download.file(fileURL, filename)
}  
if (!file.exists("../UCI HAR Dataset")) { 
      unzip(filename) 
}
## List all files
allfiles<- list.files("../UCI HAR Dataset" ,recursive = TRUE)
selectedfiles <- allfiles[-(grep("Inertial Signals", allfiles))]
selectedfiles
## load the dataset ignoring the inertial signals as those have already been used to generate the features
training_x = fread("../UCI HAR Dataset/train/X_train.txt", header=FALSE)
training_y = fread("../UCI HAR Dataset/train/Y_train.txt", header=FALSE)
training_subject = fread("../UCI HAR Dataset/train/subject_train.txt", header=FALSE)

testing_x = fread("../UCI HAR Dataset/test/X_test.txt", header=FALSE)
testing_y = fread("../UCI HAR Dataset/test/Y_test.txt", header=FALSE)
testing_subject = fread("../UCI HAR Dataset/test/subject_test.txt", header=FALSE)

mydata <- c("training_subject", "training_x", "training_y", "testing_subject", "testing_x", "testing_y")
sapply(mydata, data.table)

##
##
##