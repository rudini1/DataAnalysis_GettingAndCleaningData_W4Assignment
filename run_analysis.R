# prerequisites
      setwd("~/Documents/Coursera/Data analysis/DataCleaning/week4/ProgrammingAssignmentW4/DataAnalysis_GettingAndCleaningData_W4Assignment")
      library(reshape2)
      library(data.table)
      library(dplyr)
      library(data.table)
      
# download files and load all into R. (prepares the raw data)
      # source("./ImportScript.R") # alternatively outsource the data loading to a separate script
      #  Script to load the data into R-objects
      
      
      ### Download and unzip the dataset:
      filename <- "../getdata-projectfiles-UCI HAR Dataset.zip"
      
      if (!file.exists(filename)){
            fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
            download.file(fileURL, filename)
      }  
      if (!file.exists("../UCI HAR Dataset")) { 
            unzip(filename, exdir = "../") 
      }
      ### List all files all the selected files contain columns with mean or std (used later) or describe the data
      allfiles<- list.files("../UCI HAR Dataset" ,recursive = TRUE)
      selectedfiles <- allfiles[-(grep("Inertial Signals", allfiles))]
      selectedfiles
      ### load the dataset ignoring the inertial signals (those have anyway already been used to generate the features we load)
      training_x = fread("../UCI HAR Dataset/train/X_train.txt", header=FALSE)
      training_y = fread("../UCI HAR Dataset/train/Y_train.txt", header=FALSE)
      training_subject = fread("../UCI HAR Dataset/train/subject_train.txt", header=FALSE)
      
      testing_x = fread("../UCI HAR Dataset/test/X_test.txt", header=FALSE)
      testing_y = fread("../UCI HAR Dataset/test/Y_test.txt", header=FALSE)
      testing_subject = fread("../UCI HAR Dataset/test/subject_test.txt", header=FALSE)
      
      activity_labels = fread("../UCI HAR Dataset/activity_labels.txt", header=FALSE)      
# 1 Merge the training and the test sets to create one data set
      # this is rather simple as training and testing have same columns/variables.
      # So just attach all training variables together and then (I chose first the y- and subject-column)

      wholedataset <- rbind(cbind(training_y, training_subject, training_x), cbind(testing_y, testing_subject, testing_x))

# 2 Extracts only the measurements on the mean and standard deviation for each measurement.

      # I decided to first tidy the names and then apply the select function from dplyr
      # rename features using the variable names in features.txt
      # clean feature names with substitutions
      # fread creates a data table = data frame what is a list of columns. [[]] extracts the column as a vector
      features = fread("../UCI HAR Dataset/features.txt")[[2]]
            features = gsub('-mean', 'Mean', features)
            features = gsub('-std', 'Std', features)
            features = gsub('[-()]', '', features)
      # rename features. The whole data set including the labels and the subject is renamed. So make the vector accounting for that.
      names(wholedataset) <- c("label_activity", "subject", features)
      # head(wholedataset)
      duplicated(features) # has duplicate column names???
      # make the names unique and contain only allowed characters
      features <- make.names(names = names(wholedataset), unique=TRUE, allow_=TRUE)
      names(wholedataset) <- features
## extract all variables with "mean" and "std" in the name (anywhere) and keep the added label/subject columns
      extracteddataset <- select(wholedataset, matches("label_activity|subject|mean|std", ignore.case = TRUE ))
      colnames(extracteddataset) <- tolower(colnames(extracteddataset)) # tidy data are named lowercase
# 3 Uses descriptive activity names to name the activities in the data set
      # activity labels contain the descriptive activity
      # make the variable a factor and then change the levels according to the description from loaded file in avtivity_labels
      extracteddataset$label_activity <- as.factor(extracteddataset$label_activity)
      extracteddataset$subject <- as.factor(extracteddataset$subject)
      levels(extracteddataset$label_activity) <- activity_labels[[2]]
      extracteddataset$label_activity # just to check
      # str(extracteddataset)
# 4 Appropriately labels the data set with descriptive variable names.
      # In my script this has allready been done in the second step where 
      # renaming has been done before selecting the mean and std columns
      # The codebook should contain the names (=labels) and descriptions of the variables
      colnames(extracteddataset)

# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
      # use the dplyer package known from the lectures
       tidydata <- extracteddataset %>% group_by(label_activity, subject) %>% summarise_all(mean, na.rm = TRUE)
      # tidydata
      # write the tidy table into a file to upload
      write.table(tidydata, "tidy.txt", sep="\t")
      