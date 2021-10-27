#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  tags$head(
    tags$script(src = "https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js", defer = NA),
    tags$script(src = "index.js"),
  ),
  h1("Hello World"),
  p(`x-data` = "index", `x-text` = "value"),
  p(`x-data` = "indexA", `x-text` = "value"),
  includeHTML("www/include.html")
)
# Define server logic required to draw a histogram
server <- function(input, output) {
  
}

# Run the application
shinyApp(ui = ui, server = server)
