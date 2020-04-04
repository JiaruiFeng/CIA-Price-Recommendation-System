
#square error, one row should represent one sample
se<-function(y_pre,y_tr){
  y_pre<-as.matrix(y_pre)
  y_tr<-as.matrix(y_tr)
  devi<-y_pre-y_tr
  se<-sum(apply(devi,1,function(x){sum(x^2)}))
  se
}
