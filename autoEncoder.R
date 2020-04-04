#This script implement auto encoder model use Keras
library(keras)
#encoder_list and decoder_list are vectors indicate the output dimension for each layer in encoder and decoder.
#Normally,these two list should be symmetric.
autoEncoder<-function(input_dim,encoder_list,decoder_list){
  #AutoEncoder
  input<-layer_input(shape=c(input_dim))
  #encoder
  
  for (i in 1:length(encoder_list)){
    if(i==1){
      encoder<-input%>%layer_dense(units=encoder_list[i],activation="relu")%>%
        layer_batch_normalization()%>%
        layer_activation("relu")
    }else{
      encoder<-encoder%>%layer_dense(units=encoder_list[i],activation="relu")%>%
        layer_batch_normalization()%>%
        layer_activation("relu")
    }
  }
  
  encoder_model<-keras_model(input=input,output=encoder)

  for (j in 1:length(decoder_list)){
    if(j==1){
      decoder<-encoder%>%
        layer_dense(units=decoder_list[j],activation="relu")%>%
        layer_batch_normalization()%>%
        layer_activation("relu")
    }else{
      decoder<-decoder%>%
        layer_dense(units=decoder_list[j],activation="relu")%>%
        layer_batch_normalization()%>%
        layer_activation("relu")
    }
  }
    
  decoder<-decoder%>%layer_dense(units=input_dim)
  AE_model<-keras_model(input=input,output=decoder)
  AE_model%>%compile(
    loss = 'mse',
    optimizer = optimizer_adam()
  )
  return(list(encoder_model,AE_model))
}
