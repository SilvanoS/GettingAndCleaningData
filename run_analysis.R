##Get the list of the file

fileslist <- file.path("UCI HAR Dataset")
files<-list.files(fileslist, recursive=TRUE)


#The files that will be used to load data are:
#  test/subject_test.txt
#  test/X_test.txt
#  test/y_test.txt
#  train/subject_train.txt
#  train/X_train.txt
#  train/y_train.txt

#Read data from the targeted files

#Read the Activity files:
dataActivityTest  <- read.table(file.path(fileslist, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(fileslist, "train", "Y_train.txt"),header = FALSE)



#Read the Subject files:

dataSubjectTrain <- read.table(file.path(fileslist, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(fileslist, "test" , "subject_test.txt"),header = FALSE)



#Read the Features files:

dataFeaturesTest  <- read.table(file.path(fileslist, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(fileslist, "train", "X_train.txt"),header = FALSE)



#Merges the training and the test sets to create one data set:
#1.Concatenate the data tables by rows:

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

#2.set names to variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(fileslist, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

#3.Merge columns to get the data frame Data for all data:

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)



#Extracts only the measurements on the mean and standard deviation for each measurement:
#Subset Name of Features by measurements on the mean and standard deviation

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

#Subset the data frame Data by seleted names of Features

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
subData<-subset(Data,select=selectedNames)


#Uses descriptive activity names to name the activities in the data set
#according with descriptive activity names from "activity_labels.txt"



subData$activity <- as.character(subData$activity)
subData$activity[subData$activity == 1] <- "Walking"
subData$activity[subData$activity == 2] <- "Walking Upstairs"
subData$activity[subData$activity == 3] <- "Walking Downstairs"
subData$activity[subData$activity == 4] <- "Sitting"
subData$activity[subData$activity == 5] <- "Standing"
subData$activity[subData$activity == 6] <- "Laying"
subData$activity <- as.factor(subData$activity)



#Appropriately labels the data set with descriptive variable names

names(subData)<-gsub("^t", "time", names(subData))
names(subData)<-gsub("^f", "frequency", names(subData))
names(subData)<-gsub("Acc", "Accelerometer", names(subData))
names(subData)<-gsub("Gyro", "Gyroscope", names(subData))
names(subData)<-gsub("Mag", "Magnitude", names(subData))
names(subData)<-gsub("BodyBody", "Body", names(subData))


#Creates a second,independent tidy data set and ouput it

library(plyr);
subData2<-aggregate(. ~subject + activity, subData, mean)
subData2<-subData2[order(subData2$subject,subData2$activity),]
write.table(subData2, file = "tidydata_ss.txt",row.name=FALSE)

