#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(rjson)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
  titlePanel("Hackspace Woodworking Room Map"),
  sidebarLayout(
    sidebarPanel(
      selectizeInput(
        inputId = 'itemSelection',
        label = 'Find Item',
        choices = sort(item_df$name),
        options = list(
          placeholder = 'Search for item',
          onInitialize = I('function() { this.setValue(""); }')
        )
      ),
      h3("Map Options:"),
      checkboxInput(inputId = "areaLabels", label = "Show area names", value = TRUE)
    ),
    mainPanel(
      plotOutput(outputId = "mapPlot", height = "1000px")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$mapPlot <- renderPlot(plot_map(input$itemSelection, input$areaLabels))
}

# Run the application 
shinyApp(ui = ui, server = server)
