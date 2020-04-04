#This script contains functions for use data with sparseMatrix format to train, predict and evaluate model
#most function is build for keras model casue the majority of ML model don't support mini-batch training.

#input model and sparse matrix data, output model after train.
#Don't do shuffle for dataset.
autoEncoderFit<-function(data,model,batch_size=32,epoch=20,num_sample){
  for (i in 1:epoch){
    batch_time<-ceiling(num_sample/batch_size)
    for (j in 1:batch_time){
      if(j!=batch_time){
        sample_index<-seq((j-1)*batch_size+1,j*batch_size)
      }else{
        sample_index<-seq((j-1)*batch_size+1,num_sample)
      }
      fit_data<-as.matrix(data[sample_index,])
      print(paste0("epoch:",i,", ","train on ",(j-1)*batch_size+1,"/",num_sample))
      model%>%fit(x=fit_data,y=fit_data,batch_size=batch_size,epochs=1)
    }
  }
  return(model)
}

#input model and sparse matrix data, output prediction result as matrix format. 
#Be careful for the size of data and memory useage
sparseMatrixPredict<-function(data,model,batch_size=128 ,num_sample){
  predict_result<-c()
  batch_time<-ceiling(num_sample/batch_size)
  for (j in 1:batch_time){
    if(j!=batch_time){
      sample_index<-seq((j-1)*batch_size+1,j*batch_size)
    }else{
      sample_index<-seq((j-1)*batch_size+1,num_sample)
    }
    predict_data<-as.matrix(data[sample_index,])
    print(paste0("predict on ",(j-1)*batch_size+1,"/",num_sample))
    result<-model%>%predict(predict_data)
    if(j==1){
      predict_result<-result
    }
    else{
      predict_result<-rbind(predict_result,result)
    }
  }
  return(predict_result)
}

#evaluate model performance for sparse matrix data
#function will first use model to predict result
#then use result to compute metric function
#the metric function should be a sum format. this function will calculate average finally
sparseMatrixMetric<-function(data,model,y_tr,batch_size=128,num_sample,metric_function){
  evaluation_result<-0
  batch_time<-ceiling(num_sample/batch_size)
  for (j in 1:batch_time){
    if(j!=batch_time){
      sample_index<-seq((j-1)*batch_size+1,j*batch_size)
    }else{
      sample_index<-seq((j-1)*batch_size+1,num_sample)
    }
    predict_data<-as.matrix(data[sample_index,])
    print(paste0("predict on ",(j-1)*batch_size+1,"/",num_sample))
    y_pre_batch<-model%>%predict(predict_data)
    y_tr_batch<-y_tr[sample_index,]
    evaluation_result<-evaluation_result+metric_function(y_pre_batch,y_tr_batch)
  }
  evaluation_result/num_sample
}