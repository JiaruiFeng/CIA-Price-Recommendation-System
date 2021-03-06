#This script create and train autoencoder for description, name, brand name and sub category2 tf-idf vector
#File also contains code to convert original data to encoded data and evaluate autoencoder performance
#In order to run this script, you need first load corresponding Rdata from processed_data file.
source("autoEncoder.R")
source("SparseMatrixFit.R")
source("utils.R")
library(keras)

#create and train auto encoder model
#first load corresponding data from processed_data file

#final feature---------
#description 32
#auto encoder for item description vector with 32 dimension for output of encoder part
model<-autoEncoder(5000,c(1024,256,128,32),c(32,128,256,1024))
encoder_model<-model[[1]]
AE_model<-model[[2]]

AE_model<-autoEncoderFit(dtm_train_desc_tfidf,AE_model,batch_size = 2056,epoch=10,num_sample = 1481661)

encoder_model%>%save_model_hdf5("model/description_encoder_32.h5")
AE_model%>%save_model_hdf5("model/description_AE_32.h5")


#name 8
#auto encoder for item name vector with 8 dimension for output of encoder part
model<-autoEncoder(2000,c(512,128,32,8),c(8,32,128,512))
encoder_model<-model[[1]]
AE_model<-model[[2]]

AE_model<-autoEncoderFit(dtm_train_name_tfidf,AE_model,batch_size = 2056,epoch=10,num_sample = 1481661)

encoder_model%>%save_model_hdf5("model/name_encoder_8.h5")
AE_model%>%save_model_hdf5("model/name_AE_8.h5")

#brand name 8
#auto encoder for brand name vector with 8 dimension for output of encoder part
model<-autoEncoder(1000,c(512,128,32,8),c(8,32,128,512))
encoder_model<-model[[1]]
AE_model<-model[[2]]

AE_model<-autoEncoderFit(dtm_train_brand_tfidf,AE_model,batch_size = 2056,epoch=10,num_sample = 1481661)

encoder_model%>%save_model_hdf5("model/brand_encoder_8.h5")
AE_model%>%save_model_hdf5("model/brand_AE_8.h5")


#category  8
#auto encoder for sub category 2 vector with 8 dimension for output of encoder part
model<-autoEncoder(960,c(512,128,32,8),c(8,32,128,512))
encoder_model<-model[[1]]
AE_model<-model[[2]]

AE_model<-autoEncoderFit(train_stem_cate_tfidf,AE_model,batch_size = 2056,epoch=3,num_sample = 1481661)

encoder_model%>%save_model_hdf5("model/cate_encoder_8.h5")
AE_model%>%save_model_hdf5("model/cate_AE_8.h5")



#convert data to encoded form and evaluate AE model######
#brand 8
brand_encoder_8<-keras::load_model_hdf5("model/brand_encoder_8.h5")
brand_AE_8<-keras::load_model_hdf5("model/brand_AE_8.h5")
#get encodered result
brand_train_data_8<-sparseMatrixPredict(dtm_train_brand_tfidf,brand_encoder_8,128,1481661)
save(brand_train_data_8,file="processed_data/train_brand_encoded_8.RData")
brand_test_data_8<-sparseMatrixPredict(dtm_test_brand_tfidf,brand_encoder_8,128,693359)
save(brand_test_data_8,file="processed_data/test_brand_encoded_8.RData")
#compute mse
brand_8_test_mse<-sparseMatrixMetric(dtm_test_brand_tfidf,brand_AE_8,dtm_test_brand_tfidf,128,693359,se)
brand_8_train_mse<-sparseMatrixMetric(dtm_train_brand_tfidf,brand_AE_8,dtm_train_brand_tfidf,128,1481661,se)


#name 8
name_encoder_8<-keras::load_model_hdf5("model/name_encoder_8.h5")
name_AE_8<-keras::load_model_hdf5("model/name_AE_8.h5")
#get encodered result
name_train_data_8<-sparseMatrixPredict(dtm_train_name_tfidf,name_encoder_8,128,1481661)
save(name_train_data_8,file="processed_data/train_name_encoded_8.RData")
name_test_data_8<-sparseMatrixPredict(dtm_test_name_tfidf,name_encoder_8,128,693359)
save(name_test_data_8,file="processed_data/test_name_encoded_8.RData")
#compute mse
name_8_test_mse<-sparseMatrixMetric(dtm_test_name_tfidf,name_AE_8,dtm_test_name_tfidf,128,693359,se)
name_8_train_mse<-sparseMatrixMetric(dtm_train_name_tfidf,name_AE_8,dtm_train_name_tfidf,128,1481661,se)

#cate 8########
cate_encoder_8<-keras::load_model_hdf5("model/cate_encoder_8.h5")
cate_AE_8<-keras::load_model_hdf5("model/cate_AE_8.h5")
#get encodered result
cate_train_data_8<-sparseMatrixPredict(dtm_train_cate_tfidf,cate_encoder_8,128,1481661)
save(cate_train_data_8,file="processed_data/train_cate_encoded_8.RData")
cate_test_data_8<-sparseMatrixPredict(dtm_test_cate_tfidf,cate_encoder_8,128,693359)
save(cate_test_data_8,file="processed_data/test_cate_encoded_8.RData")
#compute mse
cate_8_test_mse<-sparseMatrixMetric(dtm_test_cate_tfidf,cate_AE_8,dtm_test_cate_tfidf,128,693359,se)
cate_8_train_mse<-sparseMatrixMetric(dtm_train_cate_tfidf,cate_AE_8,dtm_train_cate_tfidf,128,1481661,se)


#desc 32########
desc_encoder_32<-keras::load_model_hdf5("model/description_encoder_32.h5")
desc_AE_32<-keras::load_model_hdf5("model/description_AE_32.h5")
#get encodered result
desc_train_data_32<-sparseMatrixPredict(dtm_train_desc_tfidf,desc_encoder_32,128,1481661)
save(desc_train_data_32,file="processed_data/train_desc_encoded_32.RData")
desc_test_data_32<-sparseMatrixPredict(dtm_test_desc_tfidf,desc_encoder_32,128,693359)
save(desc_test_data_32,file="processed_data/test_desc_encoded_32.RData")
#compute mse
desc_32_test_mse<-sparseMatrixMetric(dtm_test_desc_tfidf,desc_AE_32,dtm_test_desc_tfidf,128,693359,se)
desc_32_train_mse<-sparseMatrixMetric(dtm_train_desc_tfidf,desc_AE_32,dtm_train_desc_tfidf,128,1481661,se)


##stemming features####
#description 32
#auto encoder for item description vector with 32 dimension for output of encoder part
model<-autoEncoder(5000,c(1024,256,128,32),c(32,128,256,1024))
encoder_model<-model[[1]]
AE_model<-model[[2]]

AE_model<-autoEncoderFit(train_stem_desc_tfidf,AE_model,batch_size = 2056,epoch=3,num_sample = 1481661)

encoder_model%>%save_model_hdf5("model/stem_desc_encoder_32.h5")
AE_model%>%save_model_hdf5("model/stem_desc_AE_32.h5")


#cate 8
#auto encoder for stemmed item category vector with 8 dimension for output of encoder part 
model<-autoEncoder(665,c(512,128,32,8),c(8,32,128,512))
encoder_model<-model[[1]]
AE_model<-model[[2]]

AE_model<-autoEncoderFit(train_stem_cate_tfidf,AE_model,batch_size = 2056,epoch=3,num_sample = 1481661)

encoder_model%>%save_model_hdf5("model/stem_cate_encoder_8.h5")
AE_model%>%save_model_hdf5("model/stem_cate_AE_8.h5")

#name 8
#auto encoder for item name vector with 8 dimension for output of encoder part
model<-autoEncoder(2000,c(512,128,32,8),c(8,32,128,512))
encoder_model<-model[[1]]
AE_model<-model[[2]]

AE_model<-autoEncoderFit(train_stem_name_tfidf,AE_model,batch_size = 2056,epoch=3,num_sample = 1481661)

encoder_model%>%save_model_hdf5("model/stem_name_encoder_8.h5")
AE_model%>%save_model_hdf5("model/stem_name_AE_8.h5")



#brand name 8
#auto encoder for item name vector with 8 dimension for output of encoder part
model<-autoEncoder(760,c(512,128,32,8),c(8,32,128,512))
encoder_model<-model[[1]]
AE_model<-model[[2]]
AE_model<-autoEncoderFit(train_stem_brand_tfidf,AE_model,batch_size = 2056,epoch=3,num_sample = 1481661)
encoder_model%>%save_model_hdf5("model/stem_brand_encoder_8.h5")
AE_model%>%save_model_hdf5("model/stem_brand_AE_8.h5")

#get encodered result
#brand
encoder_model<-load_model_hdf5("model/stem_brand_encoder_8.h5")
AE_model<-load_model_hdf5("model/stem_brand_AE_8.h5")
stem_train_brand_8<-sparseMatrixPredict(train_stem_brand_tfidf,encoder_model,2056,1481661)
save(stem_train_brand_8,file="processed_data/stem_train_brand_encoded_8.RData")

#cate
encoder_model<-load_model_hdf5("model/stem_cate_encoder_8.h5")
AE_model<-load_model_hdf5("model/stem_cate_AE_8.h5")
stem_train_cate_8<-sparseMatrixPredict(train_stem_cate_tfidf,encoder_model,2056,1481661)
save(stem_train_cate_8,file="processed_data/stem_train_cate_encoded_8.RData")

#desc
encoder_model<-load_model_hdf5("model/stem_desc_encoder_32.h5")
AE_model<-load_model_hdf5("model/stem_desc_AE_32.h5")
stem_train_desc_32<-sparseMatrixPredict(train_stem_desc_tfidf,encoder_model,2056,1481661)
save(stem_train_desc_32,file="processed_data/stem_train_desc_encoded_32.RData")

#name
encoder_model<-load_model_hdf5("model/stem_name_encoder_8.h5")
AE_model<-load_model_hdf5("model/stem_name_AE_8.h5")
stem_train_name_8<-sparseMatrixPredict(train_stem_name_tfidf,encoder_model,2056,1481661)
save(stem_train_name_8,file="processed_data/stem_train_name_encoded_8.RData")




##combine 128#####
#name 8
#auto encoder for item name vector with 8 dimension for output of encoder part
model<-autoEncoder(6000,c(1024,256,128),c(128,256,1024))
encoder_model<-model[[1]]
AE_model<-model[[2]]

AE_model<-autoEncoderFit(train_stem_name_tfidf,AE_model,batch_size = 2056,epoch=3,num_sample = 1481661)

encoder_model%>%save_model_hdf5("model/combine_encoder_128.h5")
AE_model%>%save_model_hdf5("model/combine_AE_128.h5")

encoder_model<-load_model_hdf5("model/combine_encoder_128.h5")
AE_model<-load_model_hdf5("model/combine_AE_128.h5")

combine_train_128<-sparseMatrixPredict(train_combine_tfidf,encoder_model,2056,1481661)
save(combine_train_128,file="processed_data/combine_train_encoded_128.RData")





