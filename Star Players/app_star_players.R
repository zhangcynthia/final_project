
library(shiny)
library(tidyverse)
library(rsconnect)

NBAdata <- read_csv("NBAdataOSD.csv")
NBAplayers<-read_csv("https://raw.githubusercontent.com/fivethirtyeight/data/master/nba-raptor/modern_RAPTOR_by_team.csv")



ui<-fluidPage(
  headerPanel("Top 5% Players of Each Type of Team in NBA From 2014 to 2021"),
  sidebarLayout(
    sidebarPanel(
      
      selectInput(inputId="season",
                  label="Choose a year",
                  choices=c(2014:2021)),
      
      selectInput(inputId ="type",
                  label="Choose a strategy type (O=Offense, D=defense, S=swing)",
                  choices=NBAdata$team_type)
    ),
    mainPanel(
      tableOutput("NBAplayers")
      ))
  )


server<-function(input,output) {
  
  output$NBAplayers<- renderTable({
    NBAdata_small<-NBAdata %>% 
      select(team_type,team,season) 
    processed_NBAdata<-NBAplayers %>%
      inner_join(NBAdata_small,by= c("team"="team", "season")) 
    
    processed_NBAdata %>%
      filter(season==input$season) %>%
      slice_max(raptor_total,prop = 0.05) %>% 
      filter(team_type==input$type) %>% 
      select(team,player_name) %>%
      rename(`Players' Names` = player_name, `Team Abb.` = team)
 
  })
}

shinyApp(ui,server)
