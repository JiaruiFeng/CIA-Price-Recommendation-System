#This script is used to bulid stacking model 
#using ridge and XGBoost
source("utils.R")
#load test result for four model
load()
prediction_CNN<-read.delim("processed_data/test_predictions/CNN_prediction.txt",header=F)
dataset<-cbind(prediction_CNN,prediction_logical,prediction_model,prediction_stem)
colnames(dataset)<-c("cnn","logical","final","stem")
dataset<-as.matrix(dataset)
train_price<-log(true_price+1)
final_train_price<-train_price[test_index]

#ridge regression
library(glmnet)
grid = 10^seq(10,-2,length=100)
cv.ridge = cv.glmnet(dataset,final_train_price,alpha=0,lambda=grid,intercept=T)
plot(cv.ridge)
bestlam = cv.ridge$lambda.min
ridge_model<-glmnet(dataset,final_train_price,alpha = 0,intercept = T)
prediction_ridge<-predict(ridge_model,newx=dataset,s=bestlam)
test_rmsle<-rmsle(prediction_ridge,true_price[test_index])
predict(ridge_model,x=dataset,type="coefficients",s=bestlam,excat=T)

#XGBoost
library(caret)
library(xgboost)
xb_train_index<-sample(c(1:444499),444499*0.8)
traindata <- list(data=dataset[xb_train_index,],label=final_train_price[xb_train_index]) 
dtrain <- xgb.DMatrix(data = traindata$data, label = traindata$label) 

xgb_model <- xgboost(data = dtrain, 
                     eta = 0.5,
                     max_depth = 20, 
                     nround=30
)

xb_test_prediction<-predict(xgb_model,dataset[-xb_train_index,])
final_true_price<-true_price[test_index]
rmsle(xb_test_prediction,final_true_price[-xb_train_index])



