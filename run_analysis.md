run\_analysis
================

preliminaries
=============

`library(reshape2)       library(data.table)       library(dplyr)`

      # download files and load all into R. (prepares the raw data)
      # source("./ImportScript.R") # alternatively outsource the data loading to a separate script
      

1 Merge the training and the test sets to create one data set
=============================================================

      wholedataset <- rbind(cbind(training_y, training_subject, training_x), cbind(testing_y, testing_subject, testing_x))

2 Extracts only the measurements on the mean and standard deviation for each measurement.
=========================================================================================

tidy the names
--------------

rename features using the variable names in features.txt
--------------------------------------------------------

      # clean feature names with substitutions
      # fread creates a data table = data frame what is a list of columns. [[]] extracts the column as a vector
      features = fread("../UCI HAR Dataset/features.txt")[[2]]
            features = gsub('-mean', 'Mean', features)
            features = gsub('-std', 'Std', features)
            features = gsub('[-()]', '', features)
      # rename features. The whole data set including teh labels and the subject is renamed. So make the vector accounting for that.
      names(wholedataset) <- c("label_activity", "subject", features)
      # head(wholedataset)
      duplicated(features) # has duplicate column names???
      # make the names unique and contain only allowed characters
      features <- make.names(names = names(wholedataset), unique=TRUE, allow_=TRUE)
      names(wholedataset) <- features

extract all variables with "mean" and "std" in the name (anywhere) and keep the added label/subject columns
-----------------------------------------------------------------------------------------------------------

      # columnswanted <- grep("mean|std", names(wholedataset), ignore.case = TRUE, value = TRUE)
      # extracteddataset <- dplyr::select(wholedataset, columnswanted)
      extracteddataset <- select(wholedataset, matches("label_activity|subject|mean|std", ignore.case = TRUE ))
      colnames(extracteddataset) <- tolower(colnames(extracteddataset)) # tidy data are named lowercase

3 Uses descriptive activity names to name the activities in the data set
========================================================================

      # acivity labels contain the descriptive activity
      extracteddataset$label_activity <- as.factor(extracteddataset$label_activity)
      extracteddataset$subject <- as.factor(extracteddataset$subject)
      levels(extracteddataset$label_activity) <- activity_labels[[2]]
      extracteddataset$label_activity
      # str(extracteddataset)

4 Appropriately labels the data set with descriptive variable names.
====================================================================

      # In my script this has allready been done in the second step where 
      # renaming has been done before selecting the mean and std columns
      # The codebook should contain the names (=labels) and descriptions of the variables
      colnames(extracteddataset)

5 From the data set in step 4, creates a second, independent tidy data set
==========================================================================

with the average of each variable for each activity and each subject.
=====================================================================

      tidydata <- extracteddataset %>% group_by(label_activity, subject) %>% summarise_all(mean, na.rm = TRUE)
      # tidydata
      write.table(tidydata, "tidy.txt", sep="\t")
