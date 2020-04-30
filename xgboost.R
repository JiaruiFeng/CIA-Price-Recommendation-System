install.packages('xgboost')
install.packages("bootstrap")
library(bootstrap)
library(xgboost)

traindata4 <- list(data=model_train,label=model_price) 
dtrain <- xgb.DMatrix(data = traindata4$data, label = traindata4$label) 
xgb <- xgboost(data = dtrain,
               eta = 0.5,
               max_depth = 12, 
               nround=25,
               )





