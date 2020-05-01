initial_app<-function(rv,input){
  load("data/cate1.RData")
  load("data/cate2.RData")
  load("data/cate3.RData")
  load("data/brand_name_list.RData")
  rv$cate1<-unique_main_category
  rv$cate2<-unique_sub_category1
  rv$cate3<-unique_sub_category2
  rv$brand_list<-unique_brand_name
  rv$brandNameUI<-selectInput("brandNameSelect",label=h4("Select the brand of product"),choices=unique_brand_name,selected="Others",width="400px")
  rv$cate1UI<-selectInput("cate1Select",label=h4("Category level 1"),choices=unique_main_category,selected="Others",width="260px")
  rv$cate2UI<-selectInput("cate2Select",label=h4("Category level 2"),choices=unique_sub_category1,selected="Others",width="260px")
  rv$cate3UI<-selectInput("cate3Select",label=h4("Category level 3"),choices=unique_sub_category2,selected="Others",width="260px")
  load("model/brand_tfidf.RData")
  rv$final_brand_tfidf<-brand_tfidf
  load("model/cate_tfidf.RData")
  rv$final_cate_tfidf<-cate_tfidf
  load("model/desc_tfidf.RData")
  rv$final_desc_tfidf<-desc_tfidf
  load("model/name_tfidf.RData")
  rv$final_name_tfidf<-name_tfidf
  load("model/brand_vectorizer.RData")
  rv$final_brand_vectorizer<-brand_vectorizer
  load("model/cate_vectorizer.RData")
  rv$final_cate_vectorizer<-cate_vectorizer
  load("model/desc_vectorizer.RData")
  rv$final_desc_vectorizer<-desc_vectorizer
  load("model/name_vectorizer.RData")
  rv$final_name_vectorizer<-name_vectorizer
  rv$final_name_encoder<-load_model_hdf5("model/name_encoder_8.h5")
  rv$final_brand_encoder<-load_model_hdf5("model/brand_encoder_8.h5")
  rv$final_cate_encoder<-load_model_hdf5("model/cate_encoder_8.h5")
  rv$final_desc_encoder<-load_model_hdf5("model/desc_encoder_32.h5")
  load("model/stem_brand_tfidf.RData")
  rv$stem_brand_tfidf<-stem_brand_tfidf
  load("model/stem_cate_tfidf.RData")
  rv$stem_cate_tfidf<-stem_cate_tfidf
  load("model/stem_desc_tfidf.RData")
  rv$stem_desc_tfidf<-stem_desc_tfidf
  load("model/stem_name_tfidf.RData")
  rv$stem_name_tfidf<-stem_name_tfidf
  load("model/stem_brand_vectorizer.RData")
  rv$stem_brand_vectorizer<-stem_brand_vectorizer
  load("model/stem_cate_vectorizer.RData")
  rv$stem_cate_vectorizer<-stem_cate_vectorizer
  load("model/stem_desc_vectorizer.RData")
  rv$stem_desc_vectorizer<-stem_desc_vectorizer
  load("model/stem_name_vectorizer.RData")
  rv$stem_name_vectorizer<-stem_name_vectorizer
  rv$stem_name_encoder<-load_model_hdf5("model/stem_name_encoder_8.h5")
  rv$stem_brand_encoder<-load_model_hdf5("model/stem_brand_encoder_8.h5")
  rv$stem_cate_encoder<-load_model_hdf5("model/stem_cate_encoder_8.h5")
  rv$stem_desc_encoder<-load_model_hdf5("model/stem_desc_encoder_32.h5")
  load("model/combine_tfidf.RData")
  rv$combine_tfidf<-combine_tfidf
  load("model/combine_vectorizer.RData")
  rv$combine_vectorizer<-combine_vectorizer
  rv$combine_encoder<-load_model_hdf5("model/combine_encoder_128.h5")
  
  
}