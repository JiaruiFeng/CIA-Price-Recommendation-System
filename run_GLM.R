#this script is used to train GLM for 5-fold cross validation
#GLM model with gamma distribution
# since data seem like gamma distribution
#use combine data

source("utils.R")
library(caret)
set.seed(234)
#split train and test data
train_index<-train_test_split(1481661)
train_price<-log(true_price+1)

#use caret package to do 5-folds cross validation
folds<-createFolds(train_price[train_index],5)
train_mse_list<-c()
train_rmsle_list<-c()
val_mse_list<-c()
val_rmsle_list<-c()

for(i in 1:5)
{
  print(i)
validated_index<-folds[[i]]
print(validated_index[1])
data<-cbind(combine_train_data[train_index,][-validated_index,],train_price[train_index][-validated_index])
data<-as.data.frame(data)
colnames(data)[131]<-"y"
val_data<-cbind(combine_train_data[train_index,][validated_index,],train_price[train_index][validated_index])
colnames(data)[131]<-"y"
val_data<-as.data.frame(val_data)
glm_fit<-glm(y~.,data=data,family = Gamma(link = "identity"))
predict_train<-predict(glm_fit,data)
train_rmsle<-rmsle(predict_train,true_price[train_index][-validated_index])
train_mse<-mse(predict_train,true_price[train_index][-validated_index])
predict_val<-predict(glm_fit,val_data)
val_rmsle<-rmsle(predict_val,true_price[train_index][validated_index])
val_mse<-mse(predict_val,true_price[train_index][validated_index])
train_mse_list<-c(train_mse_list,train_mse)
train_rmsle_list<-c(train_rmsle_list,train_rmsle)
val_rmsle_list<-c(val_rmsle_list,val_rmsle)
val_mse_list<-c(val_mse_list,val_mse)
}

mean(train_rmsle_list)
mean(val_rmsle_list)
mean(train_mse_list)
mean(val_mse_list)


#run the model in all splited train data
#and check the error in different group
train_index<-train_test_split(1481661)
train_price<-log(true_price+1)
combine_train_data<-data.frame(combine_train_data,y=train_price)
glm_fit<-glm(y~.,data=combine_train_data[train_index,],family = Gamma(link = "identity"))
predict_val<-predict(glm_fit,combine_train_data[-train_index,])
predict_train<-predict(glm_fit,combine_train_data[train_index,])

true_val_price<-true_price[-train_index]
rmsle_list<-c()
for( i in 0:19){
  price_range<-i*100
  group<-true_val_price>price_range&true_val_price<=(price_range+100)
  print(sum(group))
  group_rmsle<-rmsle(predict_val[group],true_val_price[group])
  rmsle_list<-c(rmsle_list,group_rmsle)
}


true_train_price<-true_price[train_index]
train_rmsle_list<-c()
for( i in 0:19){
  price_range<-i*100
  group<-true_train_price>price_range&true_train_price<=(price_range+100)
  print(sum(group))
  group_rmsle<-rmsle(predict_train[group],true_train_price[group])
  train_rmsle_list<-c(train_rmsle_list,group_rmsle)
}


rmsle_data<-data.frame(group=seq(100,2000,100),rmsle=rmsle_list)
plot_ly(rmsle_data,x=~group,y=~rmsle,type="bar")
