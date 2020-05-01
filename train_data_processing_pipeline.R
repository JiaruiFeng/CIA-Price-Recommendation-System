library(text2vec)
library(fastDummies)
library(corpus)
library(stringr)

#This script used to process and tranform data to a form that can be train by model
#here we only process train data in kaggle and 
# 4.1 preprocessing

# 4.1.1 word vectorizing and word embedding -----------------------------

#First, let's us convert the string variable to vector. Bascially, there are several ways for convertion, 
#first is using vectorzation method like Document-term matrix, term-co-occurrence matrix or use technique like TF-IDF. 
#Second method is to train a word2vec model to convert each word to a vector. Third method is use doc2vec. 



#finally, we will construct four type of data using different tricks
#we name it as final, stem, combine and logical respectively

#train_data<-read.csv("processed_data/processed_train_data.csv",row.names =1,stringsAsFactors = F)
stop_words <-c("i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", 
               "your", "yours","the","a","in","at","for","of","they","their","has",
               "have","etc","will","would","on","with","it","its","under","above",
               "which","where","that","is","are","to","from","and","used","not","no",
               "but","out","please","ds","z1","there","these","here","doesnt","dont",
               "isnt","arent","would","wouldnt","x","also","this","items","or","as",
               "ju","an","any","wont","1","2","3","4","5","6","7","8","9","0","about","all","being","i","or")





# Preprocessing for other variable ----------------------------------
# we will use this in final, stem and logical feature.

train_index<-(1:1481661)
dummy_condition<-dummy_cols(c(train_data$item_condition_id))
dummy_condition<-dummy_condition[,-1]
colnames(dummy_condition)<-c("condition_id_1","condition_id_2","condition_id_3","condition_id_4","condition_id_5")
train_dummy_condition<-dummy_condition[train_index,]

#Then, convert `main_category`

dummy_main_cate<-dummy_cols(c(train_data$main_category))
dummy_main_cate<-dummy_main_cate[,-1]
train_dummy_main_cate<-dummy_main_cate[train_index,]

#finally, convert `sub_category1`

dummy_sub_cate<-dummy_cols(c(train_data$sub_category1))
dummy_sub_cate<-dummy_sub_cate[,-1]
train_dummy_sub_cate<-dummy_sub_cate[train_index,]

#About `desc_length`, in order it get good model performance, we use log to re scale it.

log_desc_length<-log10(c(train_data$desc_length))
train_log_length<-log_desc_length[train_index]

#We put all the categorical variables together to build our final train and test data

model_train_data<-data.frame(train_dummy_condition,train_dummy_main_cate,train_dummy_sub_cate,train_data$shipping,train_log_length,price=train_data$price)
save(model_train_data,file="processed_data/model_train_data.RData")
save(train_data$price,file="true_price.RData")



# final Feature-------------
#name 
train_data_name<-sapply(train_data$name,remove_punctuation)
prep_fun = tolower
tok_fun = space_tokenizer
#name_iterator
it_name= itoken(train_data_name, 
                preprocessor = prep_fun, 
                tokenizer = tok_fun, 
                ids = train_data$train_id, 
                progressbar = FALSE)

#To avoid data snooping problem, we will first use train data to convert both train and test data.
nam_vocab<-create_vocabulary(it_name,stopwords=stop_words)
#prune the vocabulary to reduce the dimension
name_vocab = prune_vocabulary(nam_vocab, term_count_min = 100, 
                              doc_proportion_max = 0.3,vocab_term_max = 2000)
name_vectorizer = vocab_vectorizer(name_vocab)
dtm_train_name = create_dtm(it_name, name_vectorizer)
name_tfidf = TfIdf$new()
#fit and train tf-idf in train name
dtm_train_name_tfidf = fit_transform(dtm_train_name, name_tfidf)
save(dtm_train_name_tfidf,file="train_name_tfidf.RData")
save(name_vocab,file="name_vocab.RData")
save(name_tfidf,file="name_tfidf.RData")
save(name_vectorizer,file="name_vectorizer.RData")


 #  Brand_Name 
train_data_brand<-sapply(train_data$brand_name,remove_punctuation)
#name_iterator
it_brand_train= itoken(train_data_brand, 
                       preprocessor = prep_fun, 
                       tokenizer = tok_fun, 
                       ids = train_data$train_id, 
                       progressbar = FALSE)

brand_vocab<-create_vocabulary(it_brand_train,stopwords = stop_words)
brand_vocab<-prune_vocabulary(brand_vocab, term_count_min = 20, 
                              doc_proportion_max = 0.3,vocab_term_max = 1000)
brand_vectorizer = vocab_vectorizer(brand_vocab)
dtm_train_brand = create_dtm(it_brand_train, brand_vectorizer)
brand_tfidf = TfIdf$new()
#fit and train tf-idf in train name
dtm_train_brand_tfidf = fit_transform(dtm_train_brand, brand_tfidf)
save(dtm_train_brand_tfidf,file="train_brand_tfidf.RData")
save(brand_tfidf,file="brand_tfidf.RData")
save(brand_vectorizer,file="brand_vectorizer.RData")
save(brand_vocab,file="brand_vocab.RData")


 #Sub_category 
train_data_cate<-sapply(train_data$sub_category2,remove_punctuation)
prep_fun = tolower
tok_fun = space_tokenizer
#name_iterator
it_cate_train= itoken(train_data_cate, 
                      preprocessor = prep_fun, 
                      tokenizer = tok_fun, 
                      ids = train_data$train_id, 
                      progressbar = FALSE)

cate_vocab<-create_vocabulary(it_cate_train,stopwords = stop_words)
cate_vocab<-prune_vocabulary(cate_vocab, term_count_min = 20, 
                             doc_proportion_max = 0.3,vocab_term_max = 960)
cate_vectorizer = vocab_vectorizer(cate_vocab)
dtm_train_cate = create_dtm(it_cate_train, cate_vectorizer)
cate_tfidf = TfIdf$new()
#fit and train tf-idf in train name
dtm_train_cate_tfidf = fit_transform(dtm_train_cate, cate_tfidf)
save(dtm_train_cate_tfidf,file="train_cate_tfidf.RData")
save(cate_vocab,file="cate_vocab.RData")
save(cate_tfidf,file="cate_tfidf.RData")
save(cate_vectorizer,file="cate_vectorizer.RData")


#Item_description 
prep_fun = tolower
tok_fun = word_tokenizer
#name_iterator
it_desc_train= itoken(train_data$item_description, 
                      preprocessor = prep_fun, 
                      tokenizer = tok_fun, 
                      ids = train_data$train_id, 
                      progressbar = FALSE)

desc_vocab<-create_vocabulary(it_desc_train,stopwords = stop_words)
desc_vocab<-prune_vocabulary(desc_vocab, term_count_min = 20, 
                             doc_proportion_max = 0.3,vocab_term_max = 5000)
desc_vectorizer = vocab_vectorizer(desc_vocab)
dtm_train_desc = create_dtm(it_desc_train, desc_vectorizer)
desc_tfidf = TfIdf$new()
#fit and train tf-idf in train name
dtm_train_desc_tfidf = fit_transform(dtm_train_desc, desc_tfidf)
save(dtm_train_desc_tfidf,file="train_desc_tfidf.RData")
save(dtm_test_desc_tfidf,file="test_desc_tfidf.RData")
save(desc_tfidf,file="desc_tfidf.RData")
save(desc_vocab,file="desc_vocab.RData")
save(desc_vectorizer,file="desc_vectorizer.RData")


#Then, we start to use GloVe to build word vectors for `item_description`
# stop_words <-c("i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "your", "yours","the","a","in","at","for","of","they","their","has","have","etc","will","would","on","with","it","its","under","above","which","where","that","is","are","to","from","and","used","not","no","but","out","please","ds","z1","there","these","here","doesnt","dont","isnt","arent","would","wouldnt","x","also","this","items","or","as","ju","an","any","wont","1","2","3","4","5","6","7","8","9","0","about","all","being","i","or")
# desc_vocab<-create_vocabulary(it_desc_train,stopwords = stop_words)
# desc_vocab<-prune_vocabulary(desc_vocab,  term_count_min = 5L)
# vectorizer = vocab_vectorizer(desc_vocab)
# vectorizer = vocab_vectorizer(desc_vocab)
# tcm = create_tcm(it_desc_train, vectorizer, skip_grams_window = 5L)
# glove = GlobalVectors$new(rank=100, x_max = 700,learning_rate=0.01)
# glove_desc=glove$fit_transform(tcm, n_iter = 20,  n_threads = 4)
# 
# wv_context = glove$components
# glove_desc = glove_desc + t(wv_context)
# save(glove_desc,file="glove_word_embedding.RData")



##after autoencoder 
#first run autoencoder then use encoded data to 
model_train_data<-as.matrix(model_train_data)
final_train_data<-cbind(model_train_data,brand_train_data_8,cate_train_data_8,name_train_data_8,desc_train_data_32)
final_train_data<-as.matrix(final_train_data)
save(final_train_data,file="/processed_data/final_train_data.RData")


##boolean feature####
logical_train_data<-apply(final_train_data, 2, as.logical)
logical_train_data<-apply(logical_train_data,2,as.numeric)
save(logical_train_data,file="processed_data/logical_train_data.RData")



# stemming feature####
stemming<-function(x){
  c<-paste(unlist(text_tokens(x, stemmer = "en")),collapse = " ")
  c
}

#name
train_data_name_stem<-sapply(train_data$name,stemming)

prep_fun = tolower
tok_fun = space_tokenizer
#name_iterator
it_name= itoken(train_data_name_stem, 
                preprocessor = prep_fun, 
                tokenizer = tok_fun, 
                ids = train_data$train_id, 
                progressbar = FALSE)


stem_nam_vocab<-create_vocabulary(it_name,stopwords=stop_words)
#prune the vocabulary to reduce the dimension
stem_name_vocab = prune_vocabulary(stem_nam_vocab, term_count_min = 100, 
                              doc_proportion_max = 0.3,vocab_term_max = 2000)
stem_name_vectorizer = vocab_vectorizer(stem_name_vocab)
dtm_train_stem_name = create_dtm(it_name, stem_name_vectorizer)
stem_name_tfidf = TfIdf$new()
#fit and train tf-idf in train name
train_stem_name_tfidf = fit_transform(dtm_train_stem_name, stem_name_tfidf)
save(train_stem_name_tfidf,file="train_stem_name_tfidf.RData")
save(stem_name_vocab,file="stem_name_vocab.RData")
save(stem_name_tfidf,file="stem_name_tfidf.RData")
save(stem_name_vectorizer,file="stem_name_vectorizer.RData")


#brand name
train_data_brand_stem<-sapply(train_data$brand_name,stemming)
prep_fun = tolower
tok_fun = space_tokenizer
#name_iterator
it_brand= itoken(train_data_brand_stem, 
                preprocessor = prep_fun, 
                tokenizer = tok_fun, 
                ids = train_data$train_id, 
                progressbar = FALSE)


stem_brand_vocab<-create_vocabulary(it_brand,stopwords=stop_words)
#prune the vocabulary to reduce the dimension
stem_brand_vocab = prune_vocabulary(stem_brand_vocab, term_count_min = 100, 
                                   doc_proportion_max = 0.3,vocab_term_max = 760)
stem_brand_vectorizer = vocab_vectorizer(stem_brand_vocab)
dtm_train_brand_name = create_dtm(it_brand, stem_brand_vectorizer)
stem_brand_tfidf = TfIdf$new()
#fit and train tf-idf in train name
train_stem_brand_tfidf = fit_transform(dtm_train_brand_name, stem_brand_tfidf)
save(train_stem_brand_tfidf,file="train_stem_brand_tfidf.RData")
save(stem_brand_vocab,file="stem_brand_vocab.RData")
save(stem_brand_tfidf,file="stem_brand_tfidf.RData")
save(stem_brand_vectorizer,file="stem_brand_vectorizer.RData")


#description
train_data_desc_stem<-sapply(train_data$item_description,stemming)
prep_fun = tolower
tok_fun = space_tokenizer
#name_iterator
it_desc= itoken(train_data_desc_stem, 
                 preprocessor = prep_fun, 
                 tokenizer = tok_fun, 
                 ids = train_data$train_id, 
                 progressbar = FALSE)


stem_desc_vocab<-create_vocabulary(it_desc,stopwords=stop_words)
#prune the vocabulary to reduce the dimension
stem_desc_vocab = prune_vocabulary(stem_desc_vocab, term_count_min = 20, 
                                   doc_proportion_max = 0.3,vocab_term_max = 5000)
stem_desc_vectorizer = vocab_vectorizer(stem_desc_vocab)
dtm_train_stem_desc = create_dtm(it_desc, stem_desc_vectorizer)
stem_desc_tfidf = TfIdf$new()
#fit and train tf-idf in train name
train_stem_desc_tfidf = fit_transform(dtm_train_stem_desc, stem_desc_tfidf)
save(train_stem_desc_tfidf,file="processed_data/train_stem_desc_tfidf.RData")
save(stem_desc_vocab,file="processed_data/stem_desc_vocab.RData")
save(stem_desc_tfidf,file="processed_data/stem_desc_tfidf.RData")
save(stem_desc_vectorizer,file="processed_data/stem_desc_vectorizer.RData")



train_data_cate_stem<-sapply(train_data$sub_category2,stemming)
prep_fun = tolower
tok_fun = space_tokenizer
#name_iterator
it_cate= itoken(train_data_cate_stem, 
                preprocessor = prep_fun, 
                tokenizer = tok_fun, 
                ids = train_data$train_id, 
                progressbar = FALSE)


stem_cate_vocab<-create_vocabulary(it_cate,stopwords=stop_words)
#prune the vocabulary to reduce the dimension
stem_cate_vocab = prune_vocabulary(stem_cate_vocab, term_count_min = 20, 
                                   doc_proportion_max = 0.3,vocab_term_max =665)
stem_cate_vectorizer = vocab_vectorizer(stem_cate_vocab)
dtm_train_stem_cate = create_dtm(it_cate, stem_cate_vectorizer)
stem_cate_tfidf = TfIdf$new()
#fit and train tf-idf in train name
train_stem_cate_tfidf = fit_transform(dtm_train_stem_cate, stem_cate_tfidf)
save(train_stem_cate_tfidf,file="processed_data/train_stem_cate_tfidf.RData")
save(stem_cate_vocab,file="processed_data/stem_cate_vocab.RData")
save(stem_cate_tfidf,file="processed_data/stem_cate_tfidf.RData")
save(stem_cate_vectorizer,file="processed_data/stem_cate_vectorizer.RData")


#after autoencoder
#first run autoencoder and use encoded data
model_train_data<-as.matrix(model_train_data)
stem_train_data<-cbind(model_train_data,stem_train_brand_8,stem_train_cate_8,stem_train_name_8,stem_train_desc_32)
stem_train_data<-as.matrix(stem_train_data)
save(stem_train_data,file="processed_data/stem_train_data.RData")



##combine text feature####

#train_data<-read.csv(file = 'raw_data/train.tsv', sep = '\t', header = TRUE)
train_missing_index<-which(as.character(train_data$category_name)=="")
train_data$category_name<-as.character(train_data$category_name)
train_data$category_name[train_missing_index]<-"missing"

train_data$brand_name<-as.character(train_data$brand_name)
train_brand_missing<-which(train_data$brand_name=="")
train_data$brand_name[train_brand_missing]="missing"

price_less_3<-which(train_data$price<3)
print(length(price_less_3))
train_data<-train_data[train_data$price>=3,]


train_data$item_description=as.character(train_data$item_description)
train_data$item_description[train_data$item_description==""]="missing"



combine_text<-apply(train_data[,c("category_name","brand_name","name","item_description")],1,
function(x){paste(x,collapse = " ")})
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


combine_text<-sapply(combine_text,remove_punctuation)
combine_text<-sapply(combine_text,stemming)

prep_fun = tolower
tok_fun = space_tokenizer
#combin_iterator
it_combine= itoken(combine_text, 
                preprocessor = prep_fun, 
                tokenizer = tok_fun, 
                ids = train_data$train_id, 
                progressbar = FALSE)


combine_vocab<-create_vocabulary(it_combine,stopwords=stop_words)
#prune the vocabulary to reduce the dimension
combine_vocab = prune_vocabulary(combine_vocab, term_count_min = 20, 
                                   doc_proportion_max = 0.3,vocab_term_max = 6000)
combine_vectorizer = vocab_vectorizer(combine_vocab)
dtm_train_combine = create_dtm(it_combine, combine_vectorizer)
combine_tfidf = TfIdf$new()
#fit and train tf-idf in train name
train_combine_tfidf = fit_transform(dtm_train_combine, combine_tfidf)
save(train_combine_tfidf,file="processed_data/train_combine_tfidf.RData")
save(combine_vocab,file="processed_data/combine_vocab.RData")
save(combine_tfidf,file="processed_data/combine_tfidf.RData")
save(combine_vectorizer,file="processed_data/combine_vectorizer.RData")

#other variables
other_variables<-train_data[,c("item_condition_id","shipping")]

#after autoencoder
combine_train_data<-cbind(other_variables,combine_train_128)
combine_train_data<-as.matrix(combine_train_data)
save(combine_train_data,file="processed_data/combine_train_data.RData")




