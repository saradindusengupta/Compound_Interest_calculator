## Setup
source("server.R")

shinyUI(fluidPage(
  titlePanel("Compound Interest Calculator"),
  
  sidebarLayout(
    sidebarPanel(
      p("  This is a compound interest calculator which provides the value for interest and the final balance if you save money with yearly contributions"),
  helpText("Compound Interest Parameters"),
  
  # Principal Amount
  numericInput("principal", label = h5("Principal Amount ($)"),  value =1,min=0 ),
  helpText("This is the amount you will invest intially."),
  
  numericInput("addition", label = h5("Annual Contribution ($)"),   value =1,min=0  ),
  helpText("Yearly contribution to the investments"),
  
  numericInput("years", label = h5("Time (Years)"),   value =10,min=0  ),
  helpText("Total years for the investments"),
  
  numericInput("interest_rate", label = h5("Interest rate (%)"),  value =26,min=0  ),
  helpText("Interest rate for the investment"),
  
 
  actionButton("calculate",label="Calculate")
     
    ),
    
    mainPanel(
      tabsetPanel(type = "tabs", 
       
        tabPanel("Results",
               
                 h2("Results "),
                 verbatimTextOutput("result"),
                 br(),
                 h2("Graph"),
                 p(""),
                 hr(),
                 showOutput("myChart", "polycharts"),
                 hr(),
                 
                 h2("Compound Interest Data table"),
                 
                 dataTableOutput("compound_interest_table")
                 
                 
                 )
        )
      
      
     
    )
    )
  
))
