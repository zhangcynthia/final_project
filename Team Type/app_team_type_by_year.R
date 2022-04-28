
library(shiny)
library(tidyverse)
library(rsconnect)

NBAdata <- read_csv("NBAdataOSD.csv")



ui<-fluidPage(
  headerPanel("Offense, Swing, and Defense Teams in NBA From 2011 to 2021"),
  sidebarLayout(
    sidebarPanel(
      
      selectInput(inputId="season",
                  label="Choose a year",
                  choices=NBAdata$season)
    ),
    mainPanel(
      tabsetPanel(type="tab",
      tabPanel("Offense teams",tableOutput("NBAdata")),
      tabPanel("Swing teams", tableOutput("NBAdata2")),
      tabPanel("Defense teams", tableOutput("NBAdata3"))
    ))
  )
)

server<-function(input,output) {
  
  output$NBAdata<- renderTable({
    #subset(NBAdata,year$NBAdata==input$year)
    NBAdata %>%
      filter(season==input$season) %>%
      filter(team_type=="O") %>% 
      select(team_full) %>%
      rename(`Team Name` = team_full)
    })
  output$NBAdata2<-renderTable({
    NBAdata %>% 
      filter(season==input$season) %>% 
      filter(team_type=="S") %>% 
      select(team_full) %>%
      rename(`Team Name` = team_full)
  })
  output$NBAdata3<-renderTable({
    NBAdata %>% 
      filter(season==input$season) %>% 
      filter(team_type=="D") %>% 
      select(team_full) %>%
      rename(`Team Name` = team_full)
  })
}

shinyApp(ui,server)
