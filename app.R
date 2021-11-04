




library(shiny)
library(lubridate)
library(bslib)
source('shiny-alpinejs.R')
library(tibble)

ui <- fluidPage(
  theme = bs_theme(version = 5),
  tags$script(src = "alpine-loader.js"),
  tags$script(src = "index.js"),
  includeCSS("www/table-example.css"),
  h1("Hello World"),
  p(`x-data` = "{ message: 'Awake at last!!'}", `x-text` = "message", "loading"),
  includeHTML('www/table-example.html')
)

server <- function(input, output, session) {
  data <- tribble(
    ~ column,
    ~ title,
    ~ robot,
    "one-column",
    "one-title",
    "green-robot",
    "two-column",
    "two-title",
    "red-robot"
    
  )
  
  dataPackage <- list(name = "tableData", data = data)
  
  initialize_alpine(session, dataPackage)
  
  observeEvent(input$tableData_data, {
    ans <- convert_alpine(input$tableData_data)
    print(ans)
    results <<- ans 
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)

