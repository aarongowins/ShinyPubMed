## This is how to get code to github !!

# libraries we need
library(shiny)
library(SnowballC)
library(qdap)
library(ggplot2)
library(RISmed)
library(wordcloud)
library(DT)

# Create the graph
shinyServer(function(input, output) {
  word1<-eventReactive(input$goButton, {input$text})
  
  
  output$distPlot <- renderPlot({
    
    d1<-input$date1
    d2<-input$date2
    
    res <- EUtilsSummary(word1(), type="esearch", db="pubmed", datetype='pdat', mindate=d1, maxdate=d2, retmax=500)
    date()
    fetch <- EUtilsGet(res, type="efetch", db="pubmed")
    count<-table(YearPubmed(fetch))
    count<-as.data.frame(count)
    names(count)<-c("Year", "Counts")
    num <- data.frame(Year=count$Year, Counts=cumsum(count$Counts)) 
    num$g <- "g"
    names(num) <- c("Year", "Counts", "g")
    q <- qplot(x=Year, y=Counts, data=count, geom="bar", stat="identity")
    q <- q + geom_line(aes(x=Year, y=Counts, group=g), data=num) +
      ggtitle(paste("PubMed articles containing \'", word1(), "\' ", "= ", max(num$Counts), sep="")) +
      ylab("Number of articles") +
      xlab(paste("Year \n Query date: ", Sys.time(), sep="")) +
      labs(colour="") +
      theme_bw()
    q 
  })
  
  # Create the wordcloud
  word2<-eventReactive(input$goButton, {input$text})
  
  output$wordPlot<-renderPlot({
    d1<-input$date1
    d2<-input$date2
    res <- EUtilsSummary(word2(), type="esearch", db="pubmed", datetype='pdat', mindate=d1, maxdate=d2, retmax=500)
    fetch <- EUtilsGet(res, type="efetch", db="pubmed")
    articles<-data.frame('Abstract'=AbstractText(fetch))
    abstracts<-as.character(articles$Abstract)
    abstracts<-paste(abstracts, sep="", collapse="") 
    wordcloud(abstracts, min.freq=10, max.words=70, colors=brewer.pal(7,"Dark2"))
  })
  
  # Create the author table
  word3<-eventReactive(input$goButton, {input$text})
  
  output$authList<-renderTable({
    d1<-input$date1
    d2<-input$date2
    res <- EUtilsSummary(word3(), type="esearch", db="pubmed", datetype='pdat', mindate=d1, maxdate=d2, retmax=500)
    fetch <- EUtilsGet(res, type="efetch", db="pubmed")
    AuthorList<-Author(fetch)
    Last<-sapply(AuthorList, function(x) paste(x$LastName))
    auths<-as.data.frame(sort(table(unlist(Last)), dec=TRUE))
    colnames(auths)<-"Count"
    auths <- cbind(Author=rownames(auths), auths)
    rownames(auths) <- NULL
    auths<-head(auths, 10)
    
  })
  
  # Create the author h-index
  word4<-eventReactive(input$HButton, {input$name})
  
  output$HPlot<-renderText({
    res1 <- EUtilsSummary(word4(), type="esearch", db="pubmed", datetype='pdat',mindate=1900, maxdate=2015,retmax=500)
    citations<-Cited(res1)
    citations<-as.data.frame(citations)
    
    citations<-citations[order(citations$citations,decreasing=TRUE),]
    citations<-as.data.frame(citations)
    citations<-cbind(id=rownames(citations),citations)
    citations$id<-as.character(citations$id)
    citations$id<-as.numeric(citations$id)
    h<-max(which(citations$id<=citations$citations))
    paste(input$name,"'s h-index is",h)
  })
  
  
  # Create the m-quotient
  word5<-eventReactive(input$MButton, {input$name})
  
  output$MPlot<-renderText({
    res2 <- EUtilsSummary(word5(), type="esearch", db="pubmed", datetype='pdat',mindate=1900, maxdate=2015,retmax=500)
    citations<-Cited(res2)
    citations<-as.data.frame(citations)
    
    citations<-citations[order(citations$citations,decreasing=TRUE),]
    citations<-as.data.frame(citations)
    citations<-cbind(id=rownames(citations),citations)
    citations$id<-as.character(citations$id)
    citations$id<-as.numeric(citations$id)
    h<-max(which(citations$id<=citations$citations))
    y <- YearPubmed(EUtilsGet(res2))
    low<-min(y)
    high<-max(y)
    den<-high-low
    m<-h/den
    paste(input$name,"'s m-quotient is",signif(m,3))
  })
  
  # Create the q-index
  word6<-eventReactive(input$GButton, {input$name})
  
  output$GPlot<-renderText({
    res3 <- EUtilsSummary(word6(), type="esearch", db="pubmed", datetype='pdat',mindate=1900, maxdate=2015,retmax=500)
    citations<-Cited(res3)
    citations<-as.data.frame(citations)
    
    citations<-citations[order(citations$citations,decreasing=TRUE),]
    citations<-as.data.frame(citations)
    citations<-cbind(id=rownames(citations),citations)
    citations$id<-as.character(citations$id)
    citations$id<-as.numeric(citations$id)
    
    citations$square<-citations$id^2
    citations$sums<-cumsum(citations$citations)
    g<-max(which(citations$square<citations$sums))
    paste(input$name,"'s g-index is",g)
  })
  
  
  # Back to the keyword search, create the timespan comparison, ** a little sloppy here...
  word7<-eventReactive(input$compButton, {input$text})
  
  output$comparisonPlot<-renderTable({
    d3<-input$date3
    d4<-input$date4
    d5<-input$date5
    d6<-input$date6
    res <- EUtilsSummary(word7(), type="esearch", db="pubmed", datetype='pdat', mindate=d3, maxdate=d4, retmax=500)
    fetch <- EUtilsGet(res, type="efetch", db="pubmed")
    res1 <- EUtilsSummary(word7(), type="esearch", db="pubmed", datetype='pdat', mindate=d5, maxdate=d6, retmax=500)
    fetch1 <- EUtilsGet(res1, type="efetch", db="pubmed")
    
    library(qdap)
    
    articles1<-data.frame('Abstract'=AbstractText(fetch))
    articles2<-data.frame('Abstract'=AbstractText(fetch1))
    #abstracts1<-articles1[which(articles1$Year==argument),]
    #abstracts1<-data.frame(abstracts1)
    abstractsOnly1<-as.character(articles1$Abstract)
    abstractsOnly2<-as.character(articles2$Abstract)
    abstractsOnly1<-paste(abstractsOnly1, sep="", collapse="")
    abstractsOnly2<-paste(abstractsOnly2, sep="", collapse="")
    abstractsOnly1<-as.vector(abstractsOnly1)
    abstractsOnly2<-as.vector(abstractsOnly2)
    abstractsOnly1<-strip(abstractsOnly1)
    abstractsOnly2<-strip(abstractsOnly2)
    first<-rm_stopwords(abstractsOnly1, stopwords = qdapDictionaries::Top100Words)
    second<-rm_stopwords(abstractsOnly2, stopwords = qdapDictionaries::Top100Words)
    ord1<-as.data.frame(table(first))
    ord2<-as.data.frame(table(second))
    ord1<-ord1[order(ord1$Freq, decreasing=TRUE),]
    ord2<-ord2[order(ord2$Freq, decreasing=TRUE),]
    ord1<-head(ord1,20)
    ord2<-head(ord2,20)
    ord<-cbind(ord1,ord2)
    row.names(ord)<-NULL
    ord
    
    
  })
  
  
  
})
