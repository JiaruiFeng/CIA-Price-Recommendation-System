source("loading.R")
source("predict_function.R")
function(input, output,session) {
  rv<-reactiveValues(
    brand_list=NULL,
    cate1=NULL,
    cate2=NULL,
    cate3=NULL,
    cate1UI={},
    cate2UI={},
    cate3UI={},
    brandNameUI={},
    final_name_tfidf=NULL,
    final_brand_tfidf=NULL,
    final_cate_tfidf=NULL,
    final_desc_tfidf=NULL,
    final_name_vectorizer=NULL,
    final_brand_vectorizer=NULL,
    final_cate_vectorizer=NULL,
    final_desc_vectorizer=NULL
  )
  
  output$brandName<-renderUI(rv$brandNameUI)
  output$Category1<-renderUI(rv$cate1UI)
  output$Category2<-renderUI(rv$cate2UI)
  output$Category3<-renderUI(rv$cate3UI)
  
  observeEvent("",initial_app(rv,input))
  observeEvent(input$predict,predict_process(rv,input))
  
  output$finalFeature <- renderImage({
    return(list(
      src = "picture/final_feature.png",
      contentType = "image/png",
      alt = "final feature"
    ))
  },deleteFile = FALSE)
  
  output$preprocessing <- renderImage({
    return(list(
      src = "picture/preprocessing.png",
      contentType = "image/png",
      alt = "preprocessing"
    ))
  },deleteFile = FALSE)
  
  output$logicalFeature <- renderImage({
    return(list(
      src = "picture/logical_feature.png",
      contentType = "image/png",
      alt = "logical feature"
    ))
  },deleteFile = FALSE)
  
  output$stemFeature <- renderImage({
    return(list(
      src = "picture/stem_feature.png",
      contentType = "image/png",
      alt = "stem feature"
    ))
  },deleteFile = FALSE)
  
  output$combineFeature <- renderImage({
    return(list(
      src = "picture/combine_feature.png",
      contentType = "image/png",
      alt = "combine feature"
    ))
  },deleteFile = FALSE)
  
}