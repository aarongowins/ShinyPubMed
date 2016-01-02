
library(shinydashboard)
library(shiny)
library(shinythemes)
dashboardPage(skin="blue",
              
              #tags$head(
              # tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css"),
             #),
              #tabsetPanel(
              #tabPanel("PubMed Search",
              dashboardHeader(title="PubMed Search",titleWidth=450),
              
              
              dashboardSidebar(width=250,
                               sidebarMenu(
                                 menuItem("Home Page",icon=icon("home"),tabName="home"),
                                 menuItem("Keyword Search",icon=icon("search"),tabName="search"),
                                 menuItem("Scholar Indices",icon=icon("mortar-board"),tabName="index"),
                                 
                                 tags$head(tags$style(HTML('
                                                           .main-header .logo {
                                                           font-family: "Georgia", Times, "Times New Roman", serif;
                                                           font-weight: bold;
                                                           font-size: 24px;
                                                           }
                                                           ')))
                                 
                                 
                                 
                                 )
                                 ),
              
              dashboardBody(
                tabItems(
                  tabItem(tabName="home",
                          
                          
                          
                          
                          
                          h3(  style = "font-family: 'times'; font-size:16pt;" ,
                               "Search the PubMed database at NCBI using the RISmed package in R.",tags$p(""),
                               "Choose from the menu on the left.",tags$p(""),
                               "** Check out the lastest upgrade in our Keyword Search, compare the most frequent words for two different 
                               timespans to see how the content of the abstracts have changed.",tags$p(""),
                               "More updates coming soon..."),
                          tags$p(""),
                          
                          tags$br(),
                          tags$br(),
                          tags$br(),
                          tags$br(),
                          tags$br(),
                          tags$br(),
                          tags$br(),
                          tags$br(),
                          tags$br(),
                          tags$br(),
                          tags$br(),
                          tags$br(),
                          tags$br(),
                          h4(
                            
                            tags$p(""),
                            tags$a(href="http://datascienceplus.com/pubmed-search-shiny-app-rismed/", 
                                   "Click here for the Keyword Search tutorial"),
                            tags$p(""),
                            tags$a(href="http://datascienceplus.com/hindex-gindex-pubmed-rismed/", 
                                   "Click here for the Scholar Indices tutorial"),
                            #tags$p(""),
                            #tags$a(href="http://rpubs.com/aarongowins/132049", "Click here for demo slides"),
                            tags$p(""),
                            tags$a(href="http://www.ncbi.nlm.nih.gov/pubmed", "PubMed homepage"),
                            tags$p(""),
                            tags$a(href="https://github.com/aarongowins", "github"),
                            tags$p(""),
                            tags$p(""),
                            tags$p(""),
                            tags$a(href="https://www.linkedin.com/in/aarongowins", "Aaron's linkedin page"),
                            "")),
                  
                  
                  tabItem(tabName="search",
                          fluidRow(
                            tabBox(width=12,
                                   tabPanel("KEYWORD HOME",h4("Below, type a keyword to search 
                                                              PubMed and find documents that contain that word in the text.",
                                                              tags$p(""),
                                                              "You can even type multiple words. You can search authors, 
                                                              topics, any acronym, etc.",
                                                              tags$p(""),
                                                              "Specify the start and end dates you'd like to search, 
                                                              using the format YYYY/MM/DD.",
                                                              tags$p(""),
                                                              "Then click 'RUN' and scroll through the tabs to see the results."),
                                            
                                            
                                            textInput("text", label = h3("Keyord(s)"), value = ""),
                                            textInput("date1", label = h3("From"),value=""),
                                            textInput("date2", label = h3("To"),  value = ""),
                                            #helpText("Now select the output you'd like to see. 
                                            #You can see a barplot of articles per year, 
                                            #a wordcloud of the abstract texts, or a table of the top six authors"),
                                            actionButton("goButton","RUN"),
                                            tags$p(""),
                                            "If your keyword is something like 'cancer' or 'research', 
                                            you might bump up against the search limit. 
                                            Try being more specific or searching fewer years."),
                                   
                                   
                                   
                                   
                                   
                                   
                                   
                                   
                                   
                                   tabPanel("BARPLOT",
                                            h4("A barplot of publications containing your keyword per year."),
                                            plotOutput("distPlot"),width=12,
                                            solidHeader=TRUE,background="olive" ),
                                   
                                   tabPanel("WORDCLOUD",
                                            h4("A wordcloud of the abstracts for your keyword."),
                                            plotOutput("wordPlot"),width=12),
                                   
                                   tabPanel("AUTHOR TABLE",
                                            h4("A table of the top ten authors with publicatons containing your keyword."),
                                            tableOutput("authList"),width=12),
                                   
                                   tabPanel("COMPARISON",
                                            h4("Enter two timespans below to compare the twenty most frequnt words in the
                                               abstracts for those periods."),
                                            
                                            fluidRow(
                                              column(width=4,
                                                     
                                                     
                                                     
                                                     h3( "First Timeframe"),
                                                     textInput("date3", label = h4("From"),value=""),
                                                     textInput("date4", label = h4("To"),  value = ""),
                                                     tags$hr(),
                                                     h3("Second Timeframe"),
                                                     textInput("date5", label = h4("From"),value=""),
                                                     textInput("date6", label = h4("To"),  value = ""),
                                                     actionButton("compButton","RUN"),
                                                     tags$p("")
                                              ),
                                              
                                              column(width=4,offset=1,
                                                     tableOutput("comparisonPlot")
                                              )
                                            )
                                            
                                            
                                            
                                            
                                            
                                            )
                                   )
                          )
                  ),
                  
                  
                  
                  
                  tabItem(tabName="index",
                          fluidRow(
                            tabBox(
                              tabPanel("INDICES", h3("Scholar Indices"),
                                       helpText(h4("Type an author's name below and search 
                                                   PubMed to find his or her scholar indices.")),
                                       textInput("name", label = h3("Author"), value = ""),
                                       helpText(h4("Now select the output you'd like to see. 
                                                   You can see an h-index, an m-quotient, or a g-index")),
                                       actionButton("HButton","H"),                       
                                       actionButton("MButton","M"),
                                       actionButton("GButton","G"),
                                       textOutput("HPlot"),
                                       textOutput("MPlot"),
                                       textOutput("GPlot")
                                       )
                                       )
                          )
              )
              
              
              
                          )
                )
              )























