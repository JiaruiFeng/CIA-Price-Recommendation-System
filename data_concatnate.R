model_train_data<-as.matrix(model_train_data)
final_train_data<-cbind(model_train_data,brand_train_data_8,cate_train_data_8,name_train_data_8,desc_train_data_32)
final_train_data<-as.matrix(final_train_data)
save(final_train_data,file="/processed_data/final_train_data.RData")

model_test_data<-as.matrix(model_test_data)
final_test_data<-cbind(model_test_data,brand_test_data_8,cate_test_data_8,name_test_data_8,desc_test_data_32)
final_test_data<-as.matrix(final_test_data)
save(final_test_data,file="processed_data/final_test_data.RData")

test_data<-read.csv("raw_data/test.tsv", sep = '\t', header = TRUE)
