#this script is used to process test dataset 
library(keras)
library(stringr)
library(text2vec)
library(fastDummies)
library(corpus)

test_data<-read.csv("raw_data/test_stg2.tsv",sep="\t",header = T)
test_missing_index<-which(as.character(test_data$category_name)=="")
test_data$category_name<-as.character(test_data$category_name)
test_data$category_name[test_missing_index]<-"missing"


split_fun<-function(x){
  if(x=="missing"){
    return(c("missing","missing","missing"))
  }
  else{
    split_string<-unlist(strsplit(x,split="/"))
    #if there are / inside category name, paste it together. since only sub_category2 would have / inside, simpily paste last string
    if(length(split_string)>3){
      final_split<-c(split_string[1],split_string[2])
      split_string<-split_string[-c(1,2)]
      final_split<-c(final_split,paste(split_string,collapse = ""))
    }else{
      final_split<-split_string
    }
    
    return(final_split)
  }
}
load("processed_data/cate1.RData")
load("processed_data/cate2.RData")
load("processed_data/cate3.RData")
#test_data
test_split_categ<-sapply(test_data$category_name,split_fun)
test_split_categ<-t(test_split_categ)
test_split_categ<-data.frame(test_split_categ,row.names = NULL)
colnames(test_split_categ)<-c("main_category","sub_category1","sub_category2")
test_split_categ$main_category[!test_split_categ$main_category%in%unique_main_category]="missing"
test_split_categ$sub_category1[!test_split_categ$sub_category1%in%unique_sub_category1]="missing"
test_split_categ$sub_category2[!test_split_categ$sub_category2%in%unique_sub_category2]="missing"
test_data<-cbind(test_data,test_split_categ)
test_data<-test_data[,-4]

test_data$brand_name<-as.character(test_data$brand_name)
test_brand_missing<-which(test_data$brand_name=="")
test_data$brand_name[test_brand_missing]="missing"

test_data$item_description=as.character(test_data$item_description)
test_data$item_description[test_data$item_description==""]="missing"


count_length<-function(x){
  split_desc<-unlist(strsplit(x,split=" "))
  split_desc<-split_desc[which(!split_desc%in%c(" ",""))]
  return(length(split_desc))
}
test_desc_length<-sapply(test_data$item_description,count_length)
test_desc_length<-as.numeric(test_desc_length)
test_data<-data.frame(test_data,desc_length=test_desc_length)

remove_punctuation<-function(x){
  processed_string<-str_replace_all(x,pattern="\\[rm\\]",replacement = "")
  processed_string<-str_replace_all(processed_string,pattern="[:punct:]",replacement="")
  processed_string<-str_replace_all(processed_string,pattern="[\\[\\]\\^\\$\\.\\|\\?\\*\\+\\(\\)\\-]",replacement = "")
  processed_string<-str_replace_all(processed_string,pattern="[\\\\]",replacement = "")
  processed_string<-str_replace_all(processed_string,pattern="[@#_=+<>,;:'~`]",replacement = "")
  processed_string<-str_replace_all(processed_string,pattern="/",replacement = " ")
  if(processed_string=="No description yet"){
    processed_string="missing"
  }
  processed_string
}

#other features
test_dummy_condition<-dummy_cols(c(test_data$item_condition_id))
test_dummy_condition<-dummy_condition[,-1]
colnames(test_dummy_condition)<-c("condition_id_1","condition_id_2","condition_id_3","condition_id_4","condition_id_5")

test_dummy_main_cate<-dummy_cols(c(test_data$main_category))
test_dummy_main_cate<-test_dummy_main_cate[,-1]

test_dummy_sub_cate<-dummy_cols(c(test_data$sub_category1))
test_dummy_sub_cate<-test_dummy_sub_cate[,-1]

test_log_length<-log10(c(test_data$desc_length))
model_test_data<-data.frame(test_dummy_condition,test_dummy_main_cate,test_dummy_sub_cate,test_data$shipping,test_log_length)


# final Feature-------------
final_desc_encoder<-keras:load_model_hdf5("model/description_encoder_32.h5")
final_name_encoder<-keras:load_model_hdf5("model/name_encoder_8.h5")
final_cate_encoder<-keras:load_model_hdf5("model/cate_encoder_8.h5")
final_brand_encoder<-keras:load_model_hdf5("model/brand_encoder_8.h5")
load("model/brand_tfidf.RData")
load("model/cate_tfidf.RData")
load("model/desc_tfidf.RData")
load("model/name_tfidf.RData")
load("model/brand_vectorizer.RData")
load("model/cate_vectorizer.RData")
load("model/desc_vectorizer.RData")
load("model/name_vectorizer.RData")

#name 
test_data_name<-sapply(test_data$name,remove_punctuation)
it_name_test=itoken(test_data_name, 
                    preprocessor = prep_fun, 
                    tokenizer = tok_fun, 
                    ids = test_data$test_id, 
                    progressbar = FALSE)

#use pre-trained tf-idf to convert test name
dtm_test_name =create_dtm(it_name_test,name_vectorizer)
dtm_test_name_tfidf=transform(dtm_test_name,name_tfidf)
final_name_train_8<-predict_on_batch(final_name_encoder,dtm_test_name_tfidf)


test_data_brand<-sapply(test_data$brand_name,remove_punctuation)
it_brand_test=itoken(test_data_brand, 
                     preprocessor = prep_fun, 
                     tokenizer = tok_fun, 
                     ids = test_data$test_id, 
                     progressbar = FALSE)
#use pre-trained tf-idf to convert test name
dtm_test_brand =create_dtm(it_brand_test,brand_vectorizer)
dtm_test_brand_tfidf=transform(dtm_test_brand,brand_tfidf)
final_brand_train_8<-predict_on_batch(final_brand_encoder,dtm_test_brand_tfidf)

test_data_cate<-sapply(test_data$sub_category2,remove_punctuation)
it_cate_test=itoken(test_data_cate, 
                    preprocessor = prep_fun, 
                    tokenizer = tok_fun, 
                    ids = test_data$test_id, 
                    progressbar = FALSE)
#use pre-trained tf-idf to convert test name
dtm_test_cate =create_dtm(it_cate_test,cate_vectorizer)
dtm_test_cate_tfidf=transform(dtm_test_cate,cate_tfidf)
final_cate_train_8<-predict_on_batch(final_cate_encoder,dtm_test_cate_tfidf)

test_description<-sapply(test_data$item_description,remove_punctuation)
test_description<-as.character(test_description)
test_data$item_description<-test_description
it_desc_test=itoken(test_data$item_description, 
                    preprocessor = prep_fun, 
                    tokenizer = tok_fun, 
                    ids = test_data$test_id, 
                    progressbar = FALSE)

#use pre-trained tf-idf to convert test name
dtm_test_desc =create_dtm(it_desc_test,desc_vectorizer)
dtm_test_desc_tfidf=transform(dtm_test_desc,desc_tfidf)
final_desc_train_32<-predict_on_batch(final_desc_encoder,dtm_test_desc_tfidf)

model_test_data<-as.matrix(model_test_data)
final_test_data<-cbind(model_test_data,final_brand_train_8,final_cate_train_8,final_name_train_8,final_desc_train_32)
final_test_data<-as.matrix(final_test_data)
save(final_test_data,file="/processed_data/final_test_data.RData")


##boolean feature####
logical_test_data<-apply(final_test_data, 2, as.logical)
logical_test_data<-apply(logical_test_data,2,as.numeric)
save(logical_test_data,file="processed_data/logical_test_data.RData")




# stemming feature####
stem_desc_encoder<-keras:load_model_hdf5("model/stem_desc_encoder_32.h5")
stem_name_encoder<-keras:load_model_hdf5("model/stem_name_encoder_8.h5")
stem_cate_encoder<-keras:load_model_hdf5("model/stem_cate_encoder_8.h5")
stem_brand_encoder<-keras:load_model_hdf5("model/stem_brand_encoder_8.h5")
load("model/stem_brand_tfidf.RData")
load("model/stem_cate_tfidf.RData")
load("model/stem_desc_tfidf.RData")
load("model/stem_name_tfidf.RData")
load("model/stem_brand_vectorizer.RData")
load("model/stem_cate_vectorizer.RData")
load("model/stem_desc_vectorizer.RData")
load("model/stem_name_vectorizer.RData")
stemming<-function(x){
  c<-paste(unlist(text_tokens(x, stemmer = "en")),collapse = " ")
  c
}

#name
test_data_name_stem<-sapply(test_data$name,stemming)
prep_fun = tolower
tok_fun = space_tokenizer
#name_iterator
it_name= itoken(test_data_name_stem, 
                preprocessor = prep_fun, 
                tokenizer = tok_fun, 
                ids = test_data$test_id, 
                progressbar = FALSE)


dtm_test_stem_name = create_dtm(it_name, stem_name_vectorizer)
test_stem_name_tfidf = transform(dtm_test_stem_name, stem_name_tfidf)
stem_test_name_8<-predict_on_batch(stem_name_encoder,test_stem_name_tfidf)


#brand name
test_data_brand_stem<-sapply(test_data$brand,stemming)
prep_fun = tolower
tok_fun = space_tokenizer
#name_iterator
it_brand= itoken(test_data_brant_stem, 
                preprocessor = prep_fun, 
                tokenizer = tok_fun, 
                ids = test_data$test_id, 
                progressbar = FALSE)


dtm_test_stem_brand = create_dtm(it_brand, stem_brand_vectorizer)
test_stem_brand_tfidf = transform(dtm_test_stem_brand, stem_brand_tfidf)
stem_test_brand_8<-predict_on_batch(stem_brand_encoder,test_stem_brand_tfidf)


#description
test_data_desc_stem<-sapply(test_data$item_description,stemming)
prep_fun = tolower
tok_fun = space_tokenizer
#name_iterator
it_desc= itoken(test_data_desc_stem, 
                preprocessor = prep_fun, 
                tokenizer = tok_fun, 
                ids = test_data$test_id, 
                progressbar = FALSE)


dtm_test_stem_desc = create_dtm(it_desc, stem_desc_vectorizer)
test_stem_desc_tfidf = transform(dtm_test_stem_desc, stem_desc_tfidf)
stem_test_desc_32<-predict_on_batch(stem_desc_encoder,test_stem_desc_tfidf)


test_data_cate_stem<-sapply(test_data$sub_category2,stemming)
prep_fun = tolower
tok_fun = space_tokenizer
#name_iterator
it_cate= itoken(test_data_cate_stem, 
                preprocessor = prep_fun, 
                tokenizer = tok_fun, 
                ids = test_data$test_id, 
                progressbar = FALSE)


dtm_test_stem_cate = create_dtm(it_cate, stem_cate_vectorizer)
test_stem_cate_tfidf = transform(dtm_test_stem_cate, stem_cate_tfidf)
stem_test_cate_8<-predict_on_batch(stem_cate_encoder,test_stem_cate_tfidf)

stem_test_data<-cbind(model_test_data,stem_test_brand_8,stem_test_cate_8,stem_test_name_8,stem_test_desc_32)
stem_test_data<-as.matrix(stem_test_data)
save(stem_test_data,file="processed_data/stem_test_data.RData")

#combine feature#######
load("model/combine_tfidf.RData")
load("model/combine_vectorizer.RData")
combine_encoder<-load_model_hdf5("model/combine_encoder_128.h5")

test_data<-read.csv(file = 'raw_data/test_stg2.tsv', sep = '\t', header = TRUE)
test_missing_index<-which(as.character(test_data$category_name)=="")
test_data$category_name<-as.character(test_data$category_name)
test_data$category_name[test_missing_index]<-"missing"

test_data$brand_name<-as.character(test_data$brand_name)
test_brand_missing<-which(test_data$brand_name=="")
test_data$brand_name[test_brand_missing]="missing"


test_data$item_description=as.character(test_data$item_description)
test_data$item_description[test_data$item_description==""]="missing"



combine_text<-apply(test_data[,c("category_name","brand_name","name","item_description")],1,
                    function(x){paste(x,collapse = " ")})

combine_text<-sapply(combine_text,remove_punctuation)
combine_text<-sapply(combine_text,stemming)

prep_fun = tolower
tok_fun = space_tokenizer
#combin_iterator
it_combine= itoken(combine_text, 
                   preprocessor = prep_fun, 
                   tokenizer = tok_fun, 
                   ids = test_data$test_id, 
                   progressbar = FALSE)


dtm_test_combine = create_dtm(it_combine, combine_vectorizer)

test_combine_tfidf = transform(dtm_test_combine, combine_tfidf)
combine_test_128<-predict_on_batch(combine_encoder,test_combine_tfidf)

#other variables
other_variables<-test_data[,c("item_condition_id","shipping")]

#after autoencoder
combine_test_data<-cbind(other_variables,combine_test_128)
combine_test_data<-as.matrix(combine_test_data)
save(combine_test_data,file="processed_data/combine_test_data.RData")



