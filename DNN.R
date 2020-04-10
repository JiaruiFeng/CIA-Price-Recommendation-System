library(keras)
tensorflow::tf$random$set_seed(123)
DNN<-function(input_dim,layer_list,dropout=0.2,activation="relu"){
  input<-layer_input(shape=c(input_dim))
  for (i in 1:length(layer_list)){
    if(i==1){
      dense<-input%>%layer_dense(units=layer_list[i],activation =activation, kernel_regularizer = regularizer_l2(l = 0.001))%>%
        layer_batch_normalization()%>%
        layer_activation( activation)
      if(dropout>0){
        dense<-dense%>%layer_dropout(dropout)
      }
    }else{
      dense<-dense%>%layer_dense(units=layer_list[i],activation =activation, kernel_regularizer = regularizer_l2(l = 0.001))%>%
        layer_batch_normalization()%>%
        layer_activation( activation)
      if(dropout>0){
        dense<-dense%>%layer_dropout(dropout)
      }
    }
  }
  output<-dense%>%layer_dense(units=1,activation = NULL)
  DNN_model<-keras_model(input=input,output=output)
  DNN_model%>%compile(    loss = 'mse',
                          optimizer = optimizer_adam())
  DNN_model
}