







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
  div(
    class = "container",
    h1("Hello World"),
    p(`x-data` = "{ message: 'Awake at last!!'}", `x-text` = "message", "loading"),
    includeHTML('www/table-example.html'),
    div(
      `x-data` = "$store.vectorList",
      alpine_template(`x-for` = "item in data", p(`x-text` = "item"))
    )
  )
)

server <- function(input, output, session) {
  table_data <- tribble(
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
  
  data_table_package <- list(name = "tableData", data = table_data)
  
  vector_data <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
  
  vector_package <- list(name = 'vectorList', data = vector_data)
  
  
  data_package <- list(data_table_package,
                       vector_package)
  
  data_table_package <-
    list(name = "tableData", data = data_package)
  
  
  
  initialize_alpine(session, data_package)
  
  observeEvent(input$tableData_data, {
    ans <- convert_alpine(input$tableData_data)
    print(ans)
    results <<- ans
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
