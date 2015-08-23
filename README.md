---
title: "README file for project code run_analysis.R"
date: "August 23, 2015"
output: html_document
---

This document explains the code **run_analysis.R** used to create the tidy dataset for the project.

####Step 1 

#####Merge the training and the test sets to create one data set

The project working directory contains the following from the samsung dataset:

* folder __test__
* folder __train__
* file __features.txt__

Code reads the X, Y, and subject information from the test and train folders 
```{r}
x_test<-read.table("./test/X_test.txt") #Read X_test file
x_train<-read.table("./train/X_train.txt") #Read X_train file
y_test<-read.table("./test/y_test.txt") #Read y_test file
y_train<-read.table("./train/y_train.txt") #Read y_train file
subject_test<-read.table("./test/subject_test.txt") #Read test subject file
subject_train<-read.table("./train/subject_train.txt") #Read train subject file
```

Subject, Activity and variable data from __test__ folder is combined together using _cbind()_ and stored in data frame **test_data**.

```{r}
test_data<-cbind(subject_test,y_test,x_test)
```

Subject, Activity and variable data from __train__ folder is combined together using _cbind()_ and stored in data frame **train_data**.

```{r}
train_data<-cbind(subject_train,y_train,x_train)
```

Finally, test and train data is merged by using the function _rbind()_ on data frames **test_data** and **train_data** to create data frame **all_data**.

```{r}
all_data<-rbind(test_data,train_data)
```

Data frame all_data has by default 1st 2 columns named as V1, V1.1 and V1.2. In order to simplify reading the column names later, column 1-3 have been renamed as below:

```{r}
colnames(all_data)[1]<-c("V")
colnames(all_data)[2]<-c("V0")
colnames(all_data)[3]<-c("V1")
```

####Step 2
#####Extract only the measurements on the mean and standard deviation for each measurement

For this step, columns containing the mean and std dev data were visually identified using the filed __features.txt__. Corresponding columns and column 1 and 2 containing **subject** and **activity** data were extracted from data frame **all_data** and stored in a new data frame **extract_data**.

####Step 3
#####Use descriptive activity names to name the activities in the data set

Column 2 of the data frame **extract_data** has the activity information in numeric form. Each row of column 2 is read one at a time using a for loop. Information from **activity_labels** files is used to assign a descriptive name to the activity.

```{r}
for(i in 1:nrow(extract_data)){
  if (extract_data[i,2]>6) {extract_data[i,2]="NA"}
  if (extract_data[i,2]==1) {extract_data[i,2]="walking"}
  if (extract_data[i,2]==2) {extract_data[i,2]="walking_upstairs"}
  if (extract_data[i,2]==3) {extract_data[i,2]="walking_downstairs"}
  if (extract_data[i,2]==4) {extract_data[i,2]="sitting"}
  if (extract_data[i,2]==5) {extract_data[i,2]="standing"}
  if (extract_data[i,2]==6) {extract_data[i,2]="laying"}
}
```

####Step 4
#####Assigning appropriate labels to the data set with descriptive variable names

Variable names corresponding to the std dev and mean values are read from the files **features.txt** and stored as data frame **measure_name**. Next column 2 is saved as a character vector. Special character **()** is removed from the variable names and special character **-** is replaved by **_**. Finally name **Subject** is assigned to column 1, name **Activity** is assigned to column 2 and the names for rest of the columns are read from the vector **measure_name**.

```{r}
#Change column 2 of measure_name to character vector instead of factors in dataframe
measure_name<-as.character(measure_name[,2]) 
#Remove () from variable name
measure_name<-gsub("\\(|\\)","",measure_name)
#Change "-" to "_" in variable name 
measure_name<-gsub("-","_",measure_name)

#Assign column names 
colnames(extract_data)<-c("Subject","Activity",measure_name)
```

####Step 5
#####Creating a second, independent tidy data set with the average of each variable for each activity and each subject

Package **dplyr** is used for the last step of this project. Function **group_by()** is used to group the data by subject and activity. Function **summarise_each** is used to find the mean of each column. Data frame **tidy_data** is used to store this new independent tidy data set.

```{r}
#Create tidy data
tidy_data<-extract_data%>%
  group_by(Subject,Activity)%>%
  summarise_each(funs(mean))
```

Finally, **write.table()** is used to write **tidy_data** into the text file **tidydata.txt**.

```{r}
#Write tidy data to text file
write.table(tidy_data,file="./tidydata.txt",row.names = FALSE)
```