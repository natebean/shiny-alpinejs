
library(shiny)
library(lubridate)
library(bslib)

ui <- fluidPage(
  theme = bs_theme(version = 5),
  h1("Hello World"),
  includeHTML("www/include.html"),
  div(
    class = "container",
    p("From Shiny"),
    textOutput("first_round_trip")
  )
)

server <- function(input, output, session) {
  session$sendCustomMessage("message-from-shiny", "Hi from Shiny")
  print("running")

  output$first_round_trip <- renderText({
    print("first_input")
    paste(input$first_input, " and back", now())
  })
}

# Run the application
shinyApp(ui = ui, server = server)