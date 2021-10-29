



library(shiny)

ui <- fluidPage(
  # tags$head(
  #   tags$script(src = "https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js", defer = NA),
  #   tags$script(src = "index.js"),
  # ),
  h1("Hello World"),
  includeHTML("www/include.html"),
  div(class = "container",
      p("From Shiny"),
      textOutput("first_round_trip"))
)

server <- function(input, output, session) {
  session$sendCustomMessage("message-from-shiny", "Hi from Shiny")
  print("running")
  
  output$first_round_trip <- renderText({
    print("first_input")
    paste(input$first_input, " and back")
  })
}

# Run the application
shinyApp(ui = ui, server = server)