library(shiny)
library(lubridate)
library(bslib)
library(tibble)
library(stringr)
library(dplyr)
source("shiny-alpinejs.R")

ui <- fluidPage(
  theme = bs_theme(version = 5),
  tags$head(
    tags$script(src = "alpine-loader.js"),
    tags$script(src = "index.js"),
    tags$link(
      rel = "stylesheet",
      href = "https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.0/font/bootstrap-icons.css"
    ),
    tags$link(
      rel = "stylesheet",
      href = "table-example.css"
    )
  ),
  div(
    class = "container",
    h1("Alpine Table Test"),
    div(
      `x-shiny-data` = "tableData",
      class = "container",
      div(
        style = "margin: 10px 0",
        tags$button(`@click` = "updateTableData", class = "btn btn-dark", "Generate Fake Data")
      ),
      tags$table(
        class = "table table-border narrow-table",
        tags$thead(
          tags$tr(
            tags$th("Column"),
            tags$th("Title"),
            tags$th(class = "robot-column", tags$i(class = "bi bi-robot"))
          )
        ),
        tags$tbody(
          tags$template(
            `x-for` = "row in data",
            tags$tr(
              tags$td(`x-text` = "row.column"),
              tags$td(
                tags$div(
                  class = "title-value", `x-data` = "{open: false, editing: false}",
                  `@mouseover` = "open = true",
                  `@mouseleave` = "open = false",
                  tags$span(`x-text` = "row.title", `x-show` = "!editing"),
                  tags$div(
                    `x-show` = "open && !editing",
                    class = "edit-panel",
                    tags$i(
                      class = "bi bi-pencil edit-icon",
                      `@click` = "editing = true;"
                    ),
                    tags$i(
                      class = "bi bi-check-circle edit-icon",
                      style = "color: green",
                      `@click` = str_squish("
                            row.robot = 'green-robot';
                            row.robot_change = 'liked';
                      ")
                    ),
                    tags$i(
                      class = "bi bi-x-circle edit-icon",
                      style = "color: red",
                      `@click` = str_squish("
                              row.robot = 'hidden-robot';
                              row.robot_change = 'rejected';
                      ")
                    )
                  ),
                  tags$div(
                    tags$input(
                      type = "text",
                      `x-show` = "editing",
                      `:value` = "row.title",
                      `@keyup.enter` = str_squish("editing = false;
                                        var newValue = $event.target.value.trim();
                                        if(newValue !== row.title) {
                                          row.title_change = 'updated';
                                        }
                                        row.title = newValue ;
                                        $event.target.value = row.title;"),
                      `@blur` = "editing = false"
                    )
                  )
                )
              ),
              tags$td(
                class = "robot-column",
                tags$i(class = "bi bi-robot", `:class` = "row.robot")
              )
            )
          )
        )
      ),
      tags$button(
        `@click` = "sendDataToShiny('tableData')",
        class = "btn btn-dark", "Send to Shiny"
      )
    ),
    div(
      class = "m-2",
      `x-shiny-data` = "likedData",
      h5("Liked Titles"),
      tags$template(
        `x-for` = "item in data",
        p(`x-text` = "item.title")
      )
    )
  )
)

server <- function(input, output, session) {
  table_data <- tribble(
    ~id, ~column, ~title, ~robot, ~title_change, ~robot_change,
    1, "one-column", "one-title", "green-robot", "", "",
    2, "two-column", "two-title", "red-robot", "", "",
    3, "three-column", "three-title", "", "", ""
  )

  update_alpine_data(session, "tableData", table_data)

  observeEvent(input$tableData_data, {
    ans <- convert_from_alpine(input$tableData_data)
    return <- ans %>% filter(robot_change == "liked")
    update_alpine_data(session, "likedData", return)
  })
}

# Run the application
shinyApp(ui = ui, server = server)