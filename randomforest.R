source("rf.R")
source("utils.R")
library(caret)

train_index<-train_test_split(1481661)
model_train<-final_train_data[train_index,]
model_test<-final_train_data[-train_index,]
model_price<-train_price[train_index]
test_price<-true_price[-train_index]
 

folds<-createFolds(train_price[train_index],5)
train_mse_list<-c()
train_rmsle_list<-c()
val_mse_list<-c()
val_rmsle_list<-c()
rf <- randomForest(label~., data=traindata4, importance=TRUE, proximity=TRUE,ntree=900,mtry=12)
for (i in 1:5){
  validation_index<-folds[[i]]
  train_result<-predict(rf,model_train[-validation_index,])
  val_result<-predict(rf,model_train[validation_index,])
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
print(train_rmsle_list)
print(val_rmsle)
print(train_mse_list)
print(val_mse_list)
max(train_result)
max(true_price)