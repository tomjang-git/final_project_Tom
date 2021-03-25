#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(shiny)
library(shinythemes)
library(here)
library(sp)
library(raster) 
library(leaflet)

multifactor_productivity_annual_growth <- read_csv("clean_data/multifactor_productivity_annual_growth")


ui <- fluidPage(
    
    theme = shinytheme("superhero"),
    
    titlePanel("Comparison of Growth Rates in National Productivity"),
    
    sidebarLayout(
        sidebarPanel(
            
            
            selectInput("country", 
                        "Country",
                        choices = countries
            )
        ),
        
        mainPanel(
            plotOutput("productivity_increase")
        )
    )
)

server <- function(input, output) {
    output$productivity_increase <- renderPlot({
        
        multifactor_productivity_annual_growth %>% 
            filter(time >= 1990) %>%  
            filter(country == input$country) %>% 
            ggplot() +
            aes(x = time, y = value_usd) +
            geom_point(colour = "#800020") +
            theme(axis.text.x = element_text(angle = 45, vjust = 0.5)) +
#            scale_x_continuous(breaks = 2000:2020) +
            labs(x = "Year", y = "Value (USD)") +
            geom_smooth(method = "lm")
        
      
    })
}

shinyApp(ui = ui, server = server)
