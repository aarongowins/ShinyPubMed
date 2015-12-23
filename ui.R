
library(shinydashboard)
library(shiny)
library(shinythemes)
shinyUI(fluidPage(theme=shinytheme("united"),
                  tags$div(
                    HTML("<h1><strong>PubMed Search</strong></h1>")
                    
                  ),
                  #tags$head(
                  #tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
                  # ),
                  tabsetPanel(
                    tabPanel("PubMed Search",
                             headerPanel("PubMed Search"),
                             sidebarLayout(
                               sidebarPanel(
                                 helpText("Type a word below and search PubMed to find documents that contain that word in the text.
                                          You can even type multiple words. You can search authors, topics, any acronym, etc."),
                                 textInput("text", label = h3("Keyord(s)"), value = "pinkeye"),
                                 helpText("You can specify the start and end dates of your search, use the format YYYY/MM/DD"),
                                 textInput("date1", label = h3("From"),value="2000/01/01"),
                                 textInput("date2", label = h3("To"),  value = "2015/11/07"),
                                 helpText("Now select the output you'd like to see. 
                                          You can see a barplot of articles per year, a wordcloud of the abstract texts, or a table of the top six authors"),
                                 actionButton("goButton","PLOT"),
                                 actionButton("wordButton","WORDS"),
                                 actionButton("authButton","AUTHORS"),
                                 tags$p(""),
                                 tags$a(href="http://datascienceplus.com/pubmed-search-shiny-app-rismed/", "Click here for the full tutorial"),
                                 tags$p(""),
                                 tags$a(href="http://rpubs.com/aarongowins/132049", "Click here for demo slides"),
                                 headerPanel("Scholar Indices"),
                                 helpText("Type an author's name below and search PubMed to find his or her scholar indices."),
                                 textInput("name", label = h3("Author"), value = "Yi Kuo Yu"),
                                 helpText("Now select the output you'd like to see. 
                                          You can see an h-score, an m-quotient, or a g-score"),
                                 actionButton("HButton","H"),                       
                                 actionButton("MButton","M"),
                                 actionButton("GButton","G"),
                                 tags$p(""),
                                 textOutput("HPlot"),
                                 textOutput("MPlot"),
                                 textOutput("GPlot"),
                                 tags$p(""),
                                 tags$a(href="http://datascienceplus.com/hindex-gindex-pubmed-rismed/", "Click here for the Scholar Indices tutorial"),
                                 tags$p(""),
                                 tags$a(href="https://www.linkedin.com/in/aarongowins", "Aaron's linkedin page")
                                 
                                 ),
                               
                               
                               mainPanel(
                                 
                                 plotOutput("distPlot"),
                                 plotOutput("wordPlot"),
                                 tableOutput("authList")
                               )
                                 )
                    )
                    
                    
                    
                  )
))





