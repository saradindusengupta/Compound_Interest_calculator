# Setup 
library(shiny)
library(dplyr)
library(ggplot2)
library(stringr)
library(rCharts)
library(reshape2)
# Function to generate data frame for compound interest
compound_table <- function(principle,r,t,contribution){
  
  data <- data.frame(year = seq(1, t))
  data$start_principle <- 0
  data$start_balance <- 0
  data$interest <- 0
  data$end_balance <-0 
  data$end_principle <- 0
  
  data$start_balance <- principle
  
  
  compound_without_contribution <- function (x){
    
    (principle) * (1 + r)^x
  }
  
  compound_with_contribution <- function (x){
    (principle * (1 + r)^x) + contribution*( ((1 + r)^x -1) / r  )
  }
  calculateInterest <- function(x){
    x*r
  }
  calculateStartPrinciple <- function(x){
    principle+ (x-1)*contribution
  }
  
  data <- data %>% mutate(end_balance=round(compound_with_contribution(year),1)) %>% mutate(start_balance= round( ifelse(is.na(lag(end_balance)) ,start_balance ,lag(end_balance) ),1)) %>% mutate(interest= round(calculateInterest(as.numeric(start_balance) ),1)) %>%  mutate(start_principle= calculateStartPrinciple(year)  ) %>% mutate(end_principle= start_principle+contribution  ) 
  
 
  return (data)
}

options(RCHART_WIDTH = 800)
options(RCHART_HEIGHT = 500)
# Main Server Code 
shinyServer(function(input, output) {
  
  
  dataFrame <- reactive({
    
    principal <- input$principal
    r <- (input$interest_rate)/100
    t <- input$years
    contribution <- input$addition
    
    
    
    data <- compound_table(principal,r,t,contribution)
    
  })
  
  
  ## Display result
  output$result  <- renderPrint({
    data <- dataFrame()
    t <- tail(data,1)
    
    result <- cat("Total years invested : " , t$year, " \n" ) + cat("Total amount invested : " , t$end_principle, "$\n") + cat("Total interest earned: ", sum(data$interest), "$\n") + cat("Final Amount : ", t$end_balance, "$\n") 
    
  
  })
  
  
  
  
  
  
  
  ## Make a chart with the data
  output$myChart <- renderChart({
    
    data <- dataFrame()
    df <- select(data,year,end_balance,end_principle)
    names(df) <- c("Year","Final Amount", "Invested Amount")
    reshapeDF <- melt(df, id.vars="Year")
    
    # dat.chart$value <- round(dat.chart$value, 0)
    chart <- rPlot(x="Year", y='value', type='line',data=reshapeDF,color="variable")
    chart$addParams( dom = 'myChart', title="Compound Interest Graph")
    chart$guides(y = list(min = 0, title = "Money"))
    chart$guides(x = list(min = 0, title = "Years"))
    #chart$xAxis(axisLabel = 'Years')
   #chart$yAxis(axisLabel = 'Money')
    return(chart)
  })

   
    
    ## Display Compound Interest table
    output$compound_interest_table <- renderDataTable({
      
      
      
      data <- dataFrame()
     
    }, options = list(iDisplayLength = 12))
