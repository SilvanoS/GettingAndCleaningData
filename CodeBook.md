# CodeBook

#STEP 1: Read data from the targeted files:

The files we have to analyze are stored in a folder called 'UCI HAR Dataset'.  
See the README.txt file for the detailed information on the dataset.    
The files that will be used to load data are listed as follows:

test/subject_test.txt  
test/X_test.txt   
test/Y_test.txt   
train/subject_train.txt   
train/X_train.txt   
train/Y_train.txt   

Values of Variable Activity consist of data from "Y_train and Y_test.txt”    
Values of Variable Subject consist of data from “subject_train.txt” and subject_test.txt"     
Values of Varibles Features consist of data from “X_train.txt” and “X_test.txt”     
Names of Variables Features come from “features.txt”     
levels of Variable Activity come from “activity_labels.txt”       

So we will use Activity, Subject and Features as part of descriptive variable names for data in data frame.

Get the list of the file

fileslist <- file.path("UCI HAR Dataset")
files<-list.files(fileslist, recursive=TRUE)




Read data from the targeted files   

Read the Activity files:     
dataActivityTest  <- read.table(file.path(fileslist, "test" , "Y_test.txt" ),header = FALSE)     
dataActivityTrain <- read.table(file.path(fileslist, "train", "Y_train.txt"),header = FALSE)     



Read the Subject files:     

dataSubjectTrain <- read.table(file.path(fileslist, "train", "subject_train.txt"),header = FALSE)     
dataSubjectTest  <- read.table(file.path(fileslist, "test" , "subject_test.txt"),header = FALSE)     



Read the Features files:     

dataFeaturesTest  <- read.table(file.path(fileslist, "test" , "X_test.txt" ),header = FALSE)     
dataFeaturesTrain <- read.table(file.path(fileslist, "train", "X_train.txt"),header = FALSE)     

#STEP 2: Merges the training and the test sets to create one data set:

1.Concatenate the data tables by rows (using rbind function)   
2.set names to variables           
3.Merge columns to get the data frame Data for all data (using cbind function)           

#STEP 3: Extracts only the measurements on the mean and standard deviation for each measurement.
For this purpose we subset Names of Features by measurements on the mean and standard deviation.  

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

Subset the data frame Data by seleted names of Features

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
subData<-subset(Data,select=selectedNames)

#STEP 4: Uses descriptive activity names to name the activities in the data set   
according with descriptive activity names from "activity_labels.txt"    

subData$activity <- as.character(subData$activity)     
subData$activity[subData$activity == 1] <- "Walking"       
subData$activity[subData$activity == 2] <- "Walking Upstairs"            
subData$activity[subData$activity == 3] <- "Walking Downs"    
subData$activity[subData$activity == 5] <- "Standing"     
subData$activity[subData$activity == 6] <- "Laying"      
subData$activity <- as.factor(subData$activity)       



Appropriately labels the data set with descriptive variable names     

names(subData)<-gsub("^t", "time", names(subData))     
names(subData)<-gsub("^f", "frequency", names(subData))      
names(subData)<-gsub("Acc", "Accelerometer", names(subData))         
names(subData)<-gsub("Gyro", "Gyroscope", names(subData))         
names(subData)<-gsub("Mag", "Magnitude", names(subData))         
names(subData)<-gsub("BodyBody", "Body", names(subData))           

#STEP 5: Creates a second, independent tidy data set and ouput it     

library(plyr);     
subData2<-aggregate(. ~subject + activity, subData, mean)            
subData2<-subData2[order(subData2$subject,subData2$activity),]          
write.table(subData2, file = "tidydata_ss.txt",row.name=FALSE)               






