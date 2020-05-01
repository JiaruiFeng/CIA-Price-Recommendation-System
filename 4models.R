source("xgboost.R")
source("utils.R")
library(keras)
traindata <- list(data=final_train_data,label=train_price) 
dtrain <- xgb.DMatrix(data = traindata$data, label = traindata$label)

traindata_stem <- list(data=stem_train_data,label=train_price) 
dtrain_stem <- xgb.DMatrix(data = traindata_stem$data, label = traindata_stem$label)

traindata_logical <- list(data=logical_train_data,label=train_price) 
dtrain_logical <- xgb.DMatrix(data = traindata_logical$data, label = traindata_logical$label)


traindata_combine <- list(data=combine_train_data,label=train_price) 
dtrain_combine <- xgb.DMatrix(data = traindata_combine$data, label = traindata_combine$label)

xgb_model <- xgboost(data = dtrain,
                     eta = 0.5,
                     max_depth = 12, 
                     nround=25,
)

saveRDS(xgb_model ,file = "xgb_model.rda")

model1 <- readRDS("xgb_model.rda")

prediction_model<-predict(model1,final_train_data)

##
xgb_stem <- xgboost(data = dtrain_stem,
                    eta = 0.5,
                    max_depth = 12, 
                    nround=25,
)

saveRDS(xgb_stem ,file = "xgb_stem.rda")

model2 <- readRDS("xgb_stem.rda")

prediction_stem<-predict(model2,stem_train_data)

##
xgb_logical <- xgboost(data = dtrain_logical,
                       eta = 0.5,
                       max_depth = 12, 
                       nround=25,
)

saveRDS(xgb_logical,file = "xgb_logical.rda")

model3 <- readRDS("xgb_logical.rda")

prediction_logical<-predict(model3,logical_train_data)

##
xgb_combine <- xgboost(data = dtrain_combine,
                       eta = 0.5,
                       max_depth = 12, 
                       nround=25,
)

saveRDS(xgb_combine ,file = "xgb_combine.rda")

model4 <- readRDS("xgb_combine.rda")

prediction_combine<-predict(model4,combine_train_data)


#######
save(prediction_model,file="prediction_model1.RData")
save(prediction_stem,file="prediction_stem1.RData")
save(prediction_logical,file="prediction_logical1.RData")
save(prediction_combine,file="prediction_combine1.RData")


