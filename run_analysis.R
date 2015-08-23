#All the project data has been saved in the directory ./dataProject
#./dataProject is also the working directory for R
x_test<-read.table("./test/X_test.txt") #Read X_test file
x_train<-read.table("./train/X_train.txt") #Read X_train file
y_test<-read.table("./test/y_test.txt") #Read y_test file
y_train<-read.table("./train/y_train.txt") #Read y_train file
subject_test<-read.table("./test/subject_test.txt") #Read test subject file
subject_train<-read.table("./train/subject_train.txt") #Read train subject file

#Put together data from x_test,y_test and subject_test
test_data<-cbind(subject_test,y_test,x_test)

#Put together data from x_train,y_train and subject_train
train_data<-cbind(subject_train,y_train,x_train)

#Combine test and train data
all_data<-rbind(test_data,train_data)

#Reassign column names to the first 3 columns 
#Else default column names are V1, V1.1 ...
colnames(all_data)[1]<-c("V")
colnames(all_data)[2]<-c("V0")
colnames(all_data)[3]<-c("V1")

#Extract columns with mean and std 
#This can be improved upon by doing it programmatically
ext_data1<-all_data[,c("V","V0","V1","V2","V3","V4","V5","V6")]
ext_data2<-all_data[,c("V41","V42","V43","V44","V45","V46")]
ext_data3<-all_data[,c("V81","V82","V83","V84","V85","V86")]
ext_data4<-all_data[,c("V121","V122","V123","V124","V125","V126")]
ext_data5<-all_data[,c("V161","V162","V163","V164","V165","V166")]
ext_data6<-all_data[,c("V201","V202","V214","V215","V227","V228")]
ext_data7<-all_data[,c("V240","V241","V253","V254")]
ext_data8<-all_data[,c("V266","V267","V268","V269","V270","V271")]
ext_data9<-all_data[,c("V345","V346","V347","V348","V349","V350")]
ext_data10<-all_data[,c("V424","V425","V426","V427","V428","V429")]
ext_data11<-all_data[,c("V503","V504","V516","V517","V529","V530")]
ext_data12<-all_data[,c("V542","V543")]

#Combine all the extracted columns 
extract_data<-cbind(ext_data1,ext_data2,ext_data3,ext_data4,ext_data5)
extract_data<-cbind(extract_data,ext_data6,ext_data7,ext_data8,ext_data9)
extract_data<-cbind(extract_data,ext_data10,ext_data11,ext_data12)

#Name the activity from the corresponding activity number
for(i in 1:nrow(extract_data)){
  if (extract_data[i,2]>6) {extract_data[i,2]="NA"}
  if (extract_data[i,2]==1) {extract_data[i,2]="walking"}
  if (extract_data[i,2]==2) {extract_data[i,2]="walking_upstairs"}
  if (extract_data[i,2]==3) {extract_data[i,2]="walking_downstairs"}
  if (extract_data[i,2]==4) {extract_data[i,2]="sitting"}
  if (extract_data[i,2]==5) {extract_data[i,2]="standing"}
  if (extract_data[i,2]==6) {extract_data[i,2]="laying"}
}

#Read the variable names corresponding to mean and std dev from features.txt file 
measure_name<-read.table("./features.txt") #Read features file
measure_name<-measure_name[c("1","2","3","4","5","6","41","42", 
                                "43","44","45","46","81","82","83",
                                "84","85","86","121","122","123",
                                "124","125","126","161","162","163",
                                "164","165","166","201","202","214",
                                "215","227","228","240","241","253",
                                "254","266","267","268","269",
                                "270","271","345","346","347",
                                "348","349","350","424","425",
                                "426","427","428","429","503",
                                "504","516","517","529","530",
                                "542","543"),]

#Change column 2 of measure_name to character vector instead of factors in dataframe
measure_name<-as.character(measure_name[,2]) 
#Remove () from variable name
measure_name<-gsub("\\(|\\)","",measure_name)
#Change "-" to "_" in variable name 
measure_name<-gsub("-","_",measure_name)

#Assign column names 
colnames(extract_data)<-c("Subject","Activity",measure_name)

#Create tidy data
tidy_data<-extract_data%>%
  group_by(Subject,Activity)%>%
  summarise_each(funs(mean))

#Write tidy data to text file
write.table(tidy_data,file="./tidydata.txt",row.names = FALSE)







