#this script is used to train final xgboost model
#for all four feature in splited train data
#and total train data.
#save model trained in total train data
library(xgboost)
source("utils.R")
library(keras) 

#train on splited train data----------
train_index<-train_test_split(1481661)
model_train<-final_train_data[train_index,]
stem_train<-stem_train_data[train_index,]
combine_train<-combine_train_data[train_index,]
logical_train<-logical_train_data[train_index,]
model_price<-train_price[train_index]
model_price1<-train_price[train_index]
model_price2<-train_price[train_index]
model_price3<-train_price[train_index]
model_test<-final_train_data[-train_index,]
stem_test<-stem_train_data[-train_index,]
logical_test<-logical_train_data[-train_index,]
combine_test<-combine_train_data[-train_index,]


traindata <- list(data=model_train,label=model_price) 
dtrain <- xgb.DMatrix(data = traindata$data, label = traindata$label)

traindata_stem <- list(data=stem_train,label=model_price1) 
dtrain_stem <- xgb.DMatrix(data = traindata_stem$data, label = traindata_stem$label)

traindata_logical <- list(data=logical_train,label=model_price2) 
dtrain_logical <- xgb.DMatrix(data = traindata_logical$data, label = traindata_logical$label)


traindata_combine <- list(data=combine_train,label=model_price3) 
dtrain_combine <- xgb.DMatrix(data = traindata_combine$data, label = traindata_combine$label)

xgb_model <- xgboost(data = dtrain,
                     eta = 0.5,
                     max_depth = 12, 
                     nround=25,
)
xgb_stem <- xgboost(data = dtrain_stem,
                    eta = 0.5,
                    max_depth = 12, 
                    nround=25,
)
xgb_logical <- xgboost(data = dtrain_logical,
                       eta = 0.5,
                       max_depth = 12, 
                       nround=25,
)
xgb_combine <- xgboost(data = dtrain_combine,
                       eta = 0.5,
                       max_depth = 12, 
                       nround=25,
)

train_result_model<-predict(xgb_model,model_train)
train_result_stem<-predict(xgb_stem,stem_train)
train_result_logical<-predict(xgb_logical,logical_train)
train_result_combine<-predict(xgb_combine,combine_train)

prediction_model<-predict(xgb_model,model_test)
prediction_stem<-predict(xgb_stem,stem_test)
prediction_logical<-predict(xgb_logical,logical_test)
prediction_combine<-predict(xgb_combine,combine_test)

save(prediction_model,file="prediction_model.RData")
save(prediction_stem,file="prediction_stem.RData")
save(prediction_logical,file="prediction_logical.RData")
save(prediction_combine,file="prediction_combine.RData")

v = as.vector(train_index)
save(v,file = "train_index.Rdata")
save(df,file="test_index.Rdata")
df <- final_train_data[,0]
df <- df[-v,]


#train on total train data------------
traindata <- list(data=final_train_data,label=train_price) 
dtrain <- xgb.DMatrix(data = traindata$data, label = traindata$label)

traindata_stem <- list(data=stem_train_data,label=train_price) 
dtrain_stem <- xgb.DMatrix(data = traindata_stem$data, label = traindata_stem$label)

traindata_logical <- list(data=logical_train_data,label=train_price) 
dtrain_logical <- xgb.DMatrix(data = traindata_logical$data, label = traindata_logical$label)


xgb_model <- xgboost(data = dtrain,
                     eta = 0.5,
                     max_depth = 12, 
                     nround=25,
)

saveRDS(xgb_model ,file = "model/xgb_final.rda")

model1 <- readRDS("model/xgb_final.rda")

prediction_model<-predict(model1,final_train_data)

##
xgb_stem <- xgboost(data = dtrain_stem,
                    eta = 0.5,
                    max_depth = 12, 
                    nround=25,
)

saveRDS(xgb_stem ,file = "model/xgb_stem.rda")

model2 <- readRDS("model/xgb_stem.rda")

prediction_stem<-predict(model2,stem_train_data)

##
xgb_logical <- xgboost(data = dtrain_logical,
                       eta = 0.5,
                       max_depth = 12, 
                       nround=25,
)

saveRDS(xgb_logical,file = "model/xgb_logical.rda")

model3 <- readRDS("model/xgb_logical.rda")

prediction_logical<-predict(model3,logical_train_data)



#######
save(prediction_model,file="prediction_model1.RData")
save(prediction_stem,file="prediction_stem1.RData")
save(prediction_logical,file="prediction_logical1.RData")
save(prediction_combine,file="prediction_combine1.RData")


#Stacking XGBoost 
prediction_CNN<-read.delim("processed_data/total_predictions/CNN_prediction.txt",header=F)
dataset<-cbind(prediction_CNN,prediction_logical,prediction_model,prediction_stem)
colnames(dataset)<-c("cnn","logical","final","stem")
dataset<-as.matrix(dataset)
train_price<-log(true_price+1)

traindata <- list(data=dataset,label=train_price) 
dtrain <- xgb.DMatrix(data = traindata$data, label = traindata$label) 
xgb_stacking <- xgboost(data = dtrain, 
                     eta = 0.2,
                     max_depth = 4, 
                     nround=40
)
saveRDS(xgb_stacking,file = "xgb_stacking.rda")
