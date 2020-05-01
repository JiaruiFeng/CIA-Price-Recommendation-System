#this script used to train xgboost in all splited train data
#and then check the test error for all price range group
source("utils.R")
library(xgboost)
library(plotly)
library(dplyr)
traindata415<- list(data=final_train_data,label=train_price)
dtrain415 <- xgb.DMatrix(data = traindata415$data, label = traindata415$label) 
xgb_model415 <- xgboost(data = dtrain415, 
                     eta = 0.5,
                     max_depth = 12, 
                     nround=25,
)
prediction415<-predict(xgb_model415,model_test)
c<-which(sort(test_price)<101)
sort(prediction415)[300000]
sort(test_price)[1:432066]#1:100
sort(test_price)[432067:441461]#200
sort(test_price)[441462:443290]#300
sort(test_price)[443291:443902]#400
sort(test_price)[443901:444164]#500
sort(test_price)[444165:444271]#600
sort(test_price)[444272:444346]#700
sort(test_price)[444347:444395]#800
sort(test_price)[444396:444425]#900
sort(test_price)[444426:444447]#1000
sort(test_price)[444448:444466]#1100
sort(test_price)[444467:444472]#1200
sort(test_price)[444473:444481]#1300
sort(test_price)[444482:444486]#1400
sort(test_price)[444487:444490]#1600
sort(test_price)[444491:444493]#1700
sort(test_price)[444494:444495]#1800
sort(test_price)[444494:444499]#2000

sort(prediction415)[432066]#1:100
sort(prediction415)[432067:441461]#200
sort(prediction415)[441462:443290]#300
sort(prediction415)[443291:443902]#400
sort(prediction415)[443901:444164]#500
sort(prediction415)[444165:444271]#600
sort(prediction415)[444272:444346]#700
sort(prediction415)[444347:444395]#800
sort(prediction415)[444396:444425]#900
sort(prediction415)[444426:444447]#1000
sort(prediction415)[444448:444466]#1100
sort(prediction415)[444467:444472]#1200
sort(prediction415)[444473:444481]#1300
sort(prediction415)[444482:444486]#1400
sort(prediction415)[444487:444490]#1600
sort(prediction415)[444491:444493]#1700
sort(prediction415)[444494:444495]#1800
sort(prediction415)[444494:444499]#2000

max(test_price)


test_mse1<-mse(sort(prediction415)[1:432066],sort(test_price)[1:432066])
test_rmsle1<-rmsle(sort(prediction415)[1:432066],sort(test_price)[1:432066])
test_mse2<-mse(sort(prediction415)[432067:441461],sort(test_price)[432067:441461])
test_rmsle2<-rmsle(sort(prediction415)[432067:441461],sort(test_price)[432067:441461])
test_mse3<-mse(sort(prediction415)[441462:443290],sort(test_price)[441462:443290])
test_rmsle3<-rmsle(sort(prediction415)[441462:443290],sort(test_price)[441462:443290])
test_mse4<-mse(sort(prediction415)[443291:443902],sort(test_price)[443291:443902])
test_rmsle4<-rmsle(sort(prediction415)[443291:443902],sort(test_price)[443291:443902])
test_mse5<-mse(sort(prediction415)[443901:444164],sort(test_price)[443901:444164])
test_rmsle5<-rmsle(sort(prediction415)[443901:444164],sort(test_price)[443901:444164])
test_mse6<-mse(sort(prediction415)[444165:444271],sort(test_price)[444165:444271])
test_rmsle6<-rmsle(sort(prediction415)[444165:444271],sort(test_price)[444165:444271])
test_mse7<-mse(sort(prediction415)[444272:444346],sort(test_price)[444272:444346])
test_rmsle7<-rmsle(sort(prediction415)[444272:444346],sort(test_price)[444272:444346])
test_mse8<-mse(sort(prediction415)[444347:444395],sort(test_price)[444347:444395])
test_rmsle8<-rmsle(sort(prediction415)[444347:444395],sort(test_price)[444347:444395])
test_mse9<-mse(sort(prediction415)[444396:444425],sort(test_price)[444396:444425])
test_rmsle9<-rmsle(sort(prediction415)[444396:444425],sort(test_price)[444396:444425])
test_mse10<-mse(sort(prediction415)[444426:444447],sort(test_price)[444426:444447])
test_rmsle10<-rmsle(sort(prediction415)[444426:444447],sort(test_price)[444426:444447])
test_mse11<-mse(sort(prediction415)[444448:444466],sort(test_price)[444448:444466])
test_rmsle11<-rmsle(sort(prediction415)[444448:444466],sort(test_price)[444448:444466])
test_mse12<-mse(sort(prediction415)[444467:444472],sort(test_price)[444467:444472])
test_rmsle12<-rmsle(sort(prediction415)[444467:444472],sort(test_price)[444467:444472])
test_mse13<-mse(sort(prediction415)[444473:444481],sort(test_price)[444473:444481])
test_rmsle13<-rmsle(sort(prediction415)[444473:444481],sort(test_price)[444473:444481])
test_mse14<-mse(sort(prediction415)[444482:444486],sort(test_price)[444482:444486])
test_rmsle14<-rmsle(sort(prediction415)[444482:444486],sort(test_price)[444482:444486])
test_mse15<-mse(sort(prediction415)[444487:444489],sort(test_price)[444487:444489])
test_rmsle15<-rmsle(sort(prediction415)[444487:444489],sort(test_price)[444487:444489])
test_mse16<-mse(sort(prediction415)[444490],sort(test_price)[444490])
test_rmsle16<-rmsle(sort(prediction415)[444490],sort(test_price)[444490])
test_mse17<-mse(sort(prediction415)[444491:444493],sort(test_price)[444491:444493])
test_rmsle17<-rmsle(sort(prediction415)[444491:444493],sort(test_price)[444491:444493])
test_mse18<-mse(sort(prediction415)[444494:444495],sort(test_price)[444494:444495])
test_rmsle18<-rmsle(sort(prediction415)[444494:444495],sort(test_price)[444494:444495])
test_mse19<-mse(sort(prediction415)[444496:444498],sort(test_price)[444496:444498])
test_rmsle19<-rmsle(sort(prediction415)[444494:444495],sort(test_price)[444494:444495])
test_mse20<-mse(sort(prediction415)[444494:444499],sort(test_price)[444494:444499])
test_rmsle20<-rmsle(sort(prediction415)[444494:444499],sort(test_price)[444494:444499])

c<-c(100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000)

r<-c(test_rmsle1,test_rmsle2,test_rmsle3,test_rmsle4,test_rmsle5,test_rmsle6,test_rmsle7,test_rmsle8,test_rmsle9,test_rmsle10,test_rmsle11,test_rmsle12,test_rmsle13,test_rmsle14,test_rmsle15,test_rmsle16,test_rmsle17,test_rmsle18,test_rmsle19,test_rmsle20)
mse<-c(test_mse1,test_mse2,test_mse3,test_mse4,test_mse5,test_mse6,test_mse7,test_mse8,test_mse9,test_mse10,test_rmsle11,test_rmsle12,test_rmsle13,test_rmsle14,test_rmsle15,test_rmsle16,test_rmsle17,test_rmsle18,test_rmsle19,test_rmsle20)


plot_ly(x=c,y=r,type='bar',name = 'rsme',uid='price')%>% layout(xaxis = axis,yaxis=axisy)
test_rmsle<-rmsle(prediction415,test_price)
plot_ly(x=c,y=mse,type = 'scatter',mode = 'lines',name = 'rsme',uid='price')
test_rmsle<-rmsle(prediction415,test_price)
test_mse_list<-c(train_mse_list,test_mse)
test_rmsle_list<-c(test_rmsle_list,test_rmsle)

x<-(abs(sort(pre)-sort(test_price)))
axisy=list(
  title = "predicted_price",                        
  titlefont = list(
    family = "Times New Roman",
    size = 20 ),          
  type = '-',
  range = c(0,2006),                              
  fixedrange = TRUE,                           
  tickmode = "linear",                         
  tick0 = 0,                                   
  dtick = 100
)
axis=list(
  title = "true_price",                        
  titlefont = list(
    family = "Times New Roman",
    size = 20),           
  type = '-',   
  autorange = FALSE,                           
  rangemode = "normal",                        
  range = c(0,2006),                              
  fixedrange = TRUE,                           
  tickmode = "linear",                         
  tick0 = 0,                                   
  dtick = 100,                                 
  ticks = "inside",                            
  mirror = TRUE,                               
  ticklen = 5,                                 
  tickwidth = 1,                               
  tickcolor = "#444",                          
  showticklabels = TRUE                        
)
plot_ly(x=sort(test_price),y=sort(pre),type = 'scatter',name = 'rsme',uid='price')%>% layout(xaxis = axis,yaxis=axisy)
