source("xgboost.R")
source("utils.R")
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

