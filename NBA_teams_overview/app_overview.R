library(shiny)
library(tidyverse)
library(readr)
NBAdata <- read_csv("NBAdata.csv")

ui <- fluidPage(
    titlePanel("NBA Teams Performance Overview (2011-2021)"),
    selectInput(inputId = "Team",
                choices = NBAdata %>%
                  arrange(Team) %>%
                  distinct(Team)%>%
                  pull(Team),
                multiple = TRUE,
                label = "Select the team you are interested in:"),
    submitButton(text = "Create the plot!"),
    plotOutput(outputId = "teamplot")
)

server <- function(input, output) {
    output$teamplot <- renderPlot({
      NBAdata %>%
        filter(Team %in% input$Team,
               Year %in% Year) %>%
        ggplot(aes(x = Year, y = `W/L Ratio`, color = Team)) +
        geom_line() +
        scale_x_continuous(breaks=2011:2021) +
        labs(title="Team Performance Overview") +
        theme(panel.grid.major.x = element_blank()) +
        theme(plot.title = element_text(hjust = 0.5,colour = "black", face = "bold",
                                        size = 14, vjust = 1)
    )})
}

# Run the application 
shinyApp(ui = ui, server = server)
