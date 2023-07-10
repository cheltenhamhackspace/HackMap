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

ui <- fluidPage(
  tags$head(
    tags$link(rel="apple-touch-icon", sizes="180x180", href="/apple-touch-icon.png"),
    tags$link(rel="icon", type="image/png", sizes="32x32", href="/favicon-32x32.png"),
    tags$link(rel="icon", type="image/png", sizes="16x16", href="/favicon-16x16.png"),
    tags$link(rel="manifest", href="/site.webmanifest")
  ),
  titlePanel(title = "Hackspace Woodworking Room Map", windowTitle = "Cheltenham Hackspace Tool Map"),
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

server <- function(input, output) {
    output$mapPlot <- renderPlot(plot_map(input$itemSelection, input$areaLabels))
}

shinyApp(ui = ui, server = server)
