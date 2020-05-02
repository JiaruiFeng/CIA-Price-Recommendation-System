library(stringr)
#This script used to brief describe and pre clean data

#1.data description --------------------------------------------------------
#The data is from Mercari, Japan’s biggest community-powered shopping app. Our ultima goal is to build a system that can help seller to automatically pricing their product.
#We can see there are total six predictive variables in data and one response variable:
  #`name`: the name of the item
  #`item_condition_id`: an integer specify the condition of item. There are total five condition:1,2,3,4,5
  #`category_name`: a string describe the category of item
  #`brand name`: a string describe the brand of item
  #`shipping`: 1 if shipping fee is paid by seller and 0 by buyer
  #`item_description`: a sectence describe the item inputed by seller.
  #`price`: the price that the item was sold for
  #There are total 1482535 data in train data set and 3460725 data in test data set.


#pre clean######
#train_data<-read.csv(file = 'raw_data/train.tsv', sep = '\t', header = TRUE)
#test_data<-read.csv(file = 'raw_data/test.tsv', sep = '\t', header = TRUE)


#Now we start to clean the data, we will try to aviod remove data due to missing value, 
#since in reality, there must be many missing value in data, we will try to build a model 
#or a system that can handle the missing data automatically and be robust to missing data.

#Name
print(sum(is.na(train_data$name)))
print(sum(as.character(train_data$name)==""))
#We can see there don't have missing value in `name`, which is reasonable, 
#since website would not allow a item without name to be sold. So we don't need to clean it.

#item_condition_id
print(sum(is.null(train_data$item_condition_id)))


#There doesn't have missing value in `item_condition_id` either.

#category_name
print(sum(as.character(train_data$category_name)==""))


#We can see there are 6327 missing value in train data.
#We fill it with "missing"

train_missing_index<-which(as.character(train_data$category_name)=="")
train_data$category_name<-as.character(train_data$category_name)
train_data$category_name[train_missing_index]<-"missing"


#Also notice that there are three level in the category, 
#we define it as `main_category`, `sub_category1` and `sub_category2`, 
#now, we try to split category to these three variable.

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
#train_data
train_split_categ<-sapply(train_data$category_name,split_fun)
train_split_categ<-t(train_split_categ)
train_split_categ<-data.frame(train_split_categ,row.names = NULL)
colnames(train_split_categ)<-c("main_category","sub_category1","sub_category2")
train_data<-cbind(train_data,train_split_categ)
train_data<-train_data[,-4]



#brand_name
print(sum(as.character(train_data$brand_name)==""))

#There are about half of brand name is missing, We will first fill it as missing.

train_data$brand_name<-as.character(train_data$brand_name)
train_brand_missing<-which(train_data$brand_name=="")
train_data$brand_name[train_brand_missing]="missing"

#price
print(sum(is.null(train_data$price)))

#`price` is the responsible value. We can see there is no missing value, however, in reality,
#Mercari doesn't allow the price to be less than 3, we need to remove those outlier data

price_less_3<-which(train_data$price<3)
print(length(price_less_3))
train_data<-train_data[train_data$price>=3,]

#There are total 874 sample that have price less than 3.

#shipping

print(sum(is.null(train_data$shipping)))
unique(train_data$shipping)

#There is no missing value in `shipping` variable.

#item_description

print(sum(is.null(train_data$item_description)))
print(sum(as.character(train_data$item_description)==""))

#There are only 4 data in train data set and 0 in test data set that have missing value, 
#simpily replace as missing

train_data$item_description=as.character(train_data$item_description)
train_data$item_description[train_data$item_description==""]="missing"

#Meanwhile, there are lot's of punctuation and special symbol that may affect our analysis, 
#we need remove it

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
train_descrption<-sapply(train_data$item_description,remove_punctuation)
train_descrption<-as.character(train_descrption)
train_data$item_description<-train_descrption

#Also, we can add a new varibale indicate the length of description

count_length<-function(x){
  split_desc<-unlist(strsplit(x,split=" "))
  split_desc<-split_desc[which(!split_desc%in%c(" ",""))]
  return(length(split_desc))
}

train_desc_length<-sapply(train_data$item_description,count_length)
train_desc_length<-as.numeric(train_desc_length)

train_data<-data.frame(train_data,desc_length=train_desc_length)

#finally, we save the results for further use
#write.csv(train_data,"processed_data/processed_train_data.csv")







