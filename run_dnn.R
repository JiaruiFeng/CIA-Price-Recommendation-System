source("DNN.R")
source("utils.R")
library(caret)
set.seed(234)
train_index<-train_test_split(1481661)

#use caret package to do 5-folds cross validation
folds<-createFolds(train_price[train_index],5)
train_mse_list<-c()
train_rmsle_list<-c()
val_mse_list<-c()
val_rmsle_list<-c()
history_list<-c()
for (i in 1:5){
  validation_index<-folds[[i]]
  ##total 188 variables,dropout=0.2,activation=relu
  DNN_model<-DNN(188,c(512,1024,2048,512,128))
  history<-DNN_model%>%fit(x=final_train_data[train_index,][-validation_index,],y=train_price[train_index][-validation_index],
                  bacth_size=2048,epochs=15, 
                  validation_data = list(final_train_data[train_index,][validation_index,],train_price[train_index][validation_index]))
  history_list<-c(history_list,list(history))
  train_result<-DNN_model%>%predict(final_train_data[train_index,][-validation_index,])
  val_result<-DNN_model%>%predict(final_train_data[train_index,][validation_index,])
  train_mse<-mse(train_result,true_price[train_index][-validation_index])
  train_rmsle<-rmsle(train_result,true_price[train_index][-validation_index])
  validation_mse<-mse(val_result,true_price[train_index][validation_index])
  validation_rmsle<-rmsle(val_result,true_price[train_index][validation_index])
  print(validation_mse)
  print(validation_rmsle)
  train_mse_list<-c(train_mse_list,train_mse)
  train_rmsle_list<-c(train_rmsle_list,train_rmsle)
  val_mse_list<-c(val_mse_list,validation_mse)
  val_rmsle<-c(val_rmsle_list,validation_rmsle)
  
}

