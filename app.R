library(shiny)
library(lubridate)
library(bslib)
source("shiny-alpinejs.R")
library(tibble)

ui <- fluidPage(
  theme = bs_theme(version = 5),
  tags$head(
    tags$script(src = "alpine-loader.js"),
    tags$script(src = "index.js"),
    tags$link(rel = "stylesheet", href = "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.0/font/bootstrap-icons.css"),
    includeCSS("www/table-example.css")
  ),
  div(
    class = "container",
    h1("Alpine Table Test"),
    div(
      `x-shiny-data` = "tableData",
      class = "container",
      div(style = "margin: 10px 0",
          tags$button(`@click` = "updateTableData", "Refresh")),
      tags$table(class = "table table-border",
                 tags$thead(tags$tr(
                   tags$th(class = "text-column", "Column"),
                   tags$th(class = "text-column", "Title"),
                   tags$th(class = "robot-column", tags$i(class = "bi bi-robot"))
                 )),
                 tags$tbody(
                   tags$template(`x-for` = "row in data",
                                 tags$tr(
                                   tags$td(`x-text` = "row.column"),
                                   tags$td(
                                     tags$div(
                                       class = "title-value",
                                       `x-data` = "{open: false, editing: false}",
                                       `@mouseover` = "open = true",
                                       `@mouseout` = "open = false",
                                       tags$span(`x-text` = "row.title",
                                                 `x-show` = "!editing"),
                                       tags$div(
                                         `x-show` = "open && !editing",
                                         class = "edit-panel",
                                         tags$i(class = "bi bi-pencil edit-icon",  `@click` = "editing = true;"),
                                         tags$i(class = "bi bi-check-circle edit-icon",
                                                `@click` = "row.robot = 'green-robot'"),
                                         tags$i(class = "bi bi-x-circle edit-icon",
                                                `@click` = "row.robot = 'hidden-robot'")
                                         
                                       ),
                                       tags$div(
                                         tags$input(
                                           type = "text",
                                           `x-show` = "editing",
                                           `:value` = "row.title",
                                           `@keyup.enter` = "editing = false; row.title = $event.target.value.trim(); $event.target.value = row.title;",
                                           `@blur` = "editing = false"
                                         )
                                       )
                                       
                                     )
                                   ),
                                   tags$td(class = "robot-column",
                                           tags$i(class = "bi bi-robot", `:class` = "row.robot"))
                                 ))
                 )),
      tags$button(`@click` = "sendDataToShiny('tableData')", "Save")
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
  
  
  update_alpine_data(session, "tableData", table_data)
  
  observeEvent(input$tableData_data, {
    ans <- convert_from_alpine(input$tableData_data)
    print(ans)
    results <<- ans
  })
}

# Run the application
shinyApp(ui = ui, server = server)
