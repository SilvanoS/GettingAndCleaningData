# CodeBook

 STEP 1: Read data from the targeted files:

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

STEP 2: Merges the training and the test sets to create one data set:

1.Concatenate the data tables by rows    
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)     
dataActivity<- rbind(dataActivityTrain, dataActivityTest)     
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)      

2.set names to variables      
names(dataSubject)<-c("subject")     
names(dataActivity)<- c("activity")      
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)      
names(dataFeatures)<- dataFeaturesNames$V2      

3.Merge columns to get the data frame Data for all data      
dataCombine <- cbind(dataSubject, dataActivity)      
Data <- cbind(dataFeatures, dataCombine)      


