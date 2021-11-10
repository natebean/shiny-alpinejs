library(jsonlite)

update_alpine_data <- function(session, name, data) {
  data_package <- list(name = name, data = data)
  session$sendCustomMessage(
    "shiny-alpine:update-data",
    jsonlite::toJSON(data_package)
  )
}

convert_from_alpine <- function(data) {
  jsonlite::fromJSON(data)
}


use_alpine <- function() {
  hd <- htmltools::htmlDependency(
    name = "ShinyAlpine",
    version = "0.0.1",
    src = c(href = ""),
    script = "alpine-loader.js"
  )

  hd
}


withAlpine <- function(code) {
  update_alpine_directives(code)
}


update_alpine_directives <- function(tag) {
  if (typeof(tag) == "list") {
    if (!is.null(tag$attribs)) {
      names(tag$attribs) <-
        str_replace(names(tag$attribs), "x_", "x-")

      names(tag$attribs) <-
        str_replace(names(tag$attribs), "x-bind_", "x-bind:")

      names(tag$attribs) <-
        str_replace(names(tag$attribs), "x-on_", "x-on:")

      names(tag$attribs) <-
        str_replace(names(tag$attribs), "x-shiny_data", "x-shiny-data")

      if (!is.null(tag$children)) {
        new_children <- lapply(tag$children, function(child) {
          child <- update_alpine_directives(child)
          child
        })
        tag$children <- new_children
      }
    }
  }
  tag
}