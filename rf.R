install.packages('randomForest')
library(randomForest)
library(plyr)
source("utils.R")
str(final_train_data)
head(final_train_data)
train_index<-train_test_split(1481661)
model_train<-final_train_data[train_index,]
model_test<-final_train_data[-train_index,]
model_price<-train_price[train_index]


