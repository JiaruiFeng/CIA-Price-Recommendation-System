
predict_process<-function(rv,input){
  stop_words <-c("i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "your", "yours","the","a","in","at","for","of","they","their","has","have","etc","will","would","on","with","it","its","under","above","which","where","that","is","are","to","from","and","used","not","no","but","out","please","ds","z1","there","these","here","doesnt","dont","isnt","arent","would","wouldnt","x","also","this","items","or","as","ju","an","any","wont","1","2","3","4","5","6","7","8","9","0","about","all","being","i","or")
  if(!is.null(input$name)){
    name<-remove_punctuation(input$name)
  }else{
    name<-"missing"
  }
  stem_name<-stemming(name)
  
  shipping<-ifelse(input$shipping,1,0)
  
  if(input$condition=="very well"){
    condition<-1
    dummy_condition<-c(1,0,0,0,0)
  }else if(input$condition=="well"){
    condition<-2
    dummy_condition<-c(0,1,0,0,0)
  }else if(input$condition=="normal"){
    condition<-3
    dummy_condition<-c(0,0,1,0,0)
  }else if(input$condition=="bad"){
    condition<-4
    dummy_condition<-c(0,0,0,1,0)
  }else{
  condition<-5
  dummy_condition<-c(0,0,0,0,1)
  }
  
  if(!is.null(input$brandNameSelect)||input$brandNameSelect!="Others"){
    brand<-remove_punctuation(input$brandNameSelect)
  }
  stem_brand<-stemming(brand)
  
  if(!is.null(input$cate1Select)){
    cate1<-input$cate1Select
  }else{
    cate1="missing"
  }
  
  if(!is.null(input$cate2Select)){
    cate2<-input$cate2Select
  }else{
    cate2="missing"
  }

  
  if(!is.null(input$cate3Select)){
    cate3<-remove_punctuation(input$cate3Select)
  }else{
    cate3="missing"
  }
  stem_cate3<-stemming(cate3)
  
  if(!is.null(input$description)){
    desc<-remove_punctuation(input$description)
  }else{
    desc="missing"
  }
  stem_desc<-stemming(desc)
  

  length<-count_length(desc)
  log_length<-log10(length+1)
  
  final_feature<-final_feature_processing(rv,name,brand,cate1,cate2,cate3,desc,shipping,dummy_condition,log_length)
  final_feature<-t(as.matrix(final_feature))
  logical_feature<-logical_feature_processing(final_feature)
  stem_feature<-stem_feature_processing(rv,stem_name,stem_brand,cate1,cate2,cate3,stem_desc,shipping,dummy_condition,log_length)
  stem_feature<-t(as.matrix(stem_feature))
  
  colnames(final_feature)<-rv$xgb_final$feature_name
  final_prediction<-predict(rv$xgb_final,final_feature)

  colnames(logical_feature)<-rv$xgb_logical$feature_name
  logical_prediction<-predict(rv$xgb_logical,logical_feature)

  colnames(stem_feature)<-rv$xgb_stem$feature_name
  stem_prediction<-predict(rv$xgb_stem,stem_feature)

  cate_input<-t(as.matrix(final_feature[1:132]))
  text_input<-t(as.matrix(final_feature[133:188]))
  cnn_prediction<-as.numeric(predict_on_batch(rv$cnn,list(cate_input,text_input)))

  
  multi_prediction<-t(as.matrix(c(cnn_prediction,logical_prediction,final_prediction,stem_prediction)))
  colnames(multi_prediction)<-rv$xgb_stacking$feature_name
  final_predict<-predict(rv$xgb_stacking,multi_prediction)
  final_price<-exp(final_predict)-1
  
  showModal(modalDialog(
      tags$h3("The suggest proce for product is:"),
      tags$h1(id="priceText",as.character(final_price)),
    title="Suggest Price",
    easyClose = TRUE
  ))
}

remove_punctuation<-function(x){
  processed_string<-str_replace_all(x,pattern="\\[rm\\]",replacement = "")
  processed_string<-str_replace_all(processed_string,pattern="[:punct:]",replacement="")
  processed_string<-str_replace_all(processed_string,pattern="[\\[\\]\\^\\$\\.\\|\\?\\*\\+\\(\\)\\-]",replacement = "")
  processed_string<-str_replace_all(processed_string,pattern="[\\\\]",replacement = "")
  processed_string<-str_replace_all(processed_string,pattern="[@#_=+<>,;:'~`]",replacement = "")
  processed_string<-str_replace_all(processed_string,pattern="/",replacement = " ")
  processed_string
}

stemming<-function(x){
  c<-paste(unlist(text_tokens(x, stemmer = "en")),collapse = " ")
  c
}

count_length<-function(x){
  split_desc<-unlist(strsplit(x,split=" "))
  split_desc<-split_desc[which(!split_desc%in%c(" ",""))]
  return(length(split_desc))
}

final_feature_processing<-function(rv,name,brand,cate1,cate2,cate3,desc,shipping,dummy_condition,log_length){
  prep_fun = tolower
  tok_fun = word_tokenizer
  name<-c(name,"missing")
  brand<-c(brand,"missing")
  desc<-c(desc,"missing")
  cate3<-c(cate3,"missing")
  it_name= itoken(name, 
              preprocessor = prep_fun, 
              tokenizer = tok_fun, 
              ids = c(1,2), 
              progressbar = FALSE)

  final_dtm_name<-create_dtm(it_name,rv$final_name_vectorizer)
  final_name_tfidf_data<-as.matrix(transform(final_dtm_name,rv$final_name_tfidf))

  it_brand= itoken(brand, 
                  preprocessor = prep_fun, 
                  tokenizer = tok_fun, 
                  ids = c(1,2), 
                  progressbar = FALSE)
  final_dtm_brand<-create_dtm(it_brand,rv$final_brand_vectorizer)
  final_brand_tfidf_data<-as.matrix(transform(final_dtm_brand,rv$final_brand_tfidf))

  it_desc= itoken(desc, 
                  preprocessor = prep_fun, 
                  tokenizer = tok_fun, 
                  ids = c(1,2), 
                  progressbar = FALSE)
  final_dtm_desc<-create_dtm(it_desc,rv$final_desc_vectorizer)
  final_desc_tfidf_data<-as.matrix(transform(final_dtm_desc,rv$final_desc_tfidf))

    it_cate= itoken(cate3, 
                  preprocessor = prep_fun, 
                  tokenizer = tok_fun, 
                  ids = c(1,2), 
                  progressbar = FALSE)
  final_dtm_cate<-create_dtm(it_cate,rv$final_cate_vectorizer)
  final_cate_tfidf_data<-as.matrix(transform(final_dtm_cate,rv$final_cate_tfidf))
  print(1)
  dummy_cate1<-dummy_cols(c(rv$cate1,cate1))[12,-1]
  dummy_cate1<-as.vector(dummy_cate1)
  print(2)
  dummy_cate2<-dummy_cols(c(rv$cate2,cate2))[115,-1]
  dummy_cate2<-as.vector(dummy_cate2)
  
  final_name_encoder<-rv$final_name_encoder
  final_brand_encoder<-rv$final_brand_encoder
  final_desc_encoder<-rv$final_desc_encoder
  final_cate_encoder<-rv$final_cate_encoder

  final_name_encoded<-predict_on_batch(final_name_encoder,final_name_tfidf_data)
  final_brand_encoded<-predict_on_batch(final_brand_encoder,final_brand_tfidf_data)
  final_desc_encoded<-predict_on_batch(final_desc_encoder,final_desc_tfidf_data)
  final_cate_encoded<-predict_on_batch(final_cate_encoder,final_cate_tfidf_data)
  
  final_name_encoded<-as.matrix(final_name_encoded)
  final_brand_encoded<-as.matrix(final_brand_encoded)
  final_desc_encoded<-as.matrix(final_desc_encoded)
  final_cate_encoded<-as.matrix(final_brand_encoded)
  print(3)
  final_name_encoded<-as.vector(final_name_encoded[1,])
  final_brand_encoded<-as.vector(final_brand_encoded[1,])
  final_desc_encoded<-as.vector(final_desc_encoded[1,])
  final_cate_encoded<-as.vector(final_cate_encoded[1,])
  print(4)
  final_feature<-unlist(c(dummy_condition,dummy_cate1,dummy_cate2,shipping,log_length,final_brand_encoded,final_cate_encoded,final_name_encoded,final_desc_encoded))
}

logical_feature_processing<-function(final_feature){
  logical_train_data<-as.numeric(as.logical(final_feature))
  logical_train_data<-t(as.matrix(logical_train_data))
  logical_train_data
}



stem_feature_processing<-function(rv,name,brand,cate1,cate2,cate3,desc,shipping,dummy_condition,log_length){
  prep_fun = tolower
  tok_fun = word_tokenizer
  name<-c(name,"missing")
  brand<-c(brand,"missing")
  desc<-c(desc,"missing")
  cate3<-c(cate3,"missing")
  it_name= itoken(name, 
                  preprocessor = prep_fun, 
                  tokenizer = tok_fun, 
                  ids = c(1,2), 
                  progressbar = FALSE)
  
  stem_dtm_name<-create_dtm(it_name,rv$stem_name_vectorizer)
  stem_name_tfidf_data<-as.matrix(transform(stem_dtm_name,rv$stem_name_tfidf))
  
  it_brand= itoken(brand, 
                   preprocessor = prep_fun, 
                   tokenizer = tok_fun, 
                   ids = c(1,2), 
                   progressbar = FALSE)
  stem_dtm_brand<-create_dtm(it_brand,rv$stem_brand_vectorizer)
  stem_brand_tfidf_data<-as.matrix(transform(stem_dtm_brand,rv$stem_brand_tfidf))
  
  it_desc= itoken(desc, 
                  preprocessor = prep_fun, 
                  tokenizer = tok_fun, 
                  ids = c(1,2), 
                  progressbar = FALSE)
  stem_dtm_desc<-create_dtm(it_desc,rv$stem_desc_vectorizer)
  stem_desc_tfidf_data<-as.matrix(transform(stem_dtm_desc,rv$stem_desc_tfidf))
  
  it_cate= itoken(cate3, 
                  preprocessor = prep_fun, 
                  tokenizer = tok_fun, 
                  ids = c(1,2), 
                  progressbar = FALSE)
  stem_dtm_cate<-create_dtm(it_cate,rv$stem_cate_vectorizer)
  stem_cate_tfidf_data<-as.matrix(transform(stem_dtm_cate,rv$stem_cate_tfidf))
  
  dummy_cate1<-as.vector(dummy_cols(c(rv$cate1,cate1))[12,-1])
  dummy_cate2<-as.vector(dummy_cols(c(rv$cate2,cate2))[115,-1])
  
  stem_name_encoder<-rv$stem_name_encoder
  stem_brand_encoder<-rv$stem_brand_encoder
  stem_desc_encoder<-rv$stem_desc_encoder
  stem_cate_encoder<-rv$stem_cate_encoder
  
  stem_name_encoded<-predict_on_batch(stem_name_encoder,stem_name_tfidf_data)
  stem_brand_encoded<-predict_on_batch(stem_brand_encoder,stem_brand_tfidf_data)
  stem_desc_encoded<-predict_on_batch(stem_desc_encoder,stem_desc_tfidf_data)
  stem_cate_encoded<-predict_on_batch(stem_cate_encoder,stem_cate_tfidf_data)
  
  stem_name_encoded<-as.matrix(stem_name_encoded)
  stem_brand_encoded<-as.matrix(stem_brand_encoded)
  stem_desc_encoded<-as.matrix(stem_desc_encoded)
  stem_cate_encoded<-as.matrix(stem_brand_encoded)
  
  stem_name_encoded<-as.vector(stem_name_encoded[1,])
  stem_brand_encoded<-as.vector(stem_brand_encoded[1,])
  stem_desc_encoded<-as.vector(stem_desc_encoded[1,])
  stem_cate_encoded<-as.vector(stem_cate_encoded[1,])
  
  stem_feature<-unlist(c(dummy_condition,dummy_cate1,dummy_cate2,shipping,log_length,stem_brand_encoded,stem_cate_encoded,stem_name_encoded,stem_desc_encoded))
}


combine_feature_processing<-function(rv,combine_text,shipping,condition){
  prep_fun = tolower
  tok_fun = word_tokenizer
  combine_text<-c(combine_text,"missing")
  it_combine= itoken(combine_text, 
                  preprocessor = prep_fun, 
                  tokenizer = tok_fun, 
                  ids = c(1,2), 
                  progressbar = FALSE)
  combine_dtm = create_dtm(it_combine, rv$combine_vectorizer)
  combine_tfidf_data<-as.matrix(transform(combine_dtm,rv$combine_tfidf))
  
  combine_encoder<-rv$combine_encoder
  combine_encoded<-predict_on_batch(combine_encoder,combine_tfidf_data)
  combine_encoded<-as.matrix(combine_encoded)
  combine_encoded<-as.vector(combine_encoded[1,])
  
  combine_feature<-unlist(c(condition,shipping,combine_encoded))
}
