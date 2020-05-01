#util function collection

#square error, one row should represent one sample
se<-function(y_pre,y_tr){
  y_pre<-as.matrix(y_pre)
  y_tr<-as.matrix(y_tr)
  devi<-y_pre-y_tr
  se<-sum(apply(devi,1,function(x){sum(x^2)}))
  se
}

#train/test dataset split
#num_sample is the number of sample
#train_per is the percetange of train set
#seed used to define random
#return the index of train set
#easy to get test set use -train
train_test_split<-function(num_sample,train_per=0.7,seed=123){
  set.seed(seed)
  train_index<-sample(c(1:num_sample),size=num_sample*train_per,replace=F)
  train_index
}

#Root mean Squared Logarithmic Error
#y_pre is the natural logarithm of predict price
#y_tr is original true price
rmsle<-function(y_pre,y_tr){
  natr_y_tr<-log(y_tr+1)
  num_sample<-length(y_pre)
  sum_log<-sum((y_pre-natr_y_tr)^2)
  rmsle_result<-sqrt(sum_log/num_sample)
  rmsle_result
}


#mean Squared Error
#y_pre is the natural logarithm of predict price
#y_tr is original true price
mse<-function(y_pre,y_tr){
  original_y_pre<-exp(y_pre)-1
  num_sample<-length(y_tr)
  mse_result<-sum((original_y_pre-y_tr)^2)/num_sample
  mse_result
}
