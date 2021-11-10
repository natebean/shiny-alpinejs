
#' Update data on the client
#'
#' @param session \code{session} from Shiny
#' @param name Name of the data store you want to update
#' @param data List of data
#'
#' @export
update_alpine_data <- function(session, name, data) {
  data_package <- list(name = name, data = data)
  session$sendCustomMessage("shiny-alpine:update-data",
                            jsonlite::toJSON(data_package))
}

#' Helper to convert JSON coming back from the client
#' @param data result of of an input$<store_name>_data
#' @export
convert_from_alpine <- function(data) {
  jsonlite::fromJSON(data)
}

#' Inserts the proper Javascript files for Alpine.js
#' @export
use_alpine <- function() {
  hd <- htmltools::htmlDependency(
    name = "shinyAlpine",
    version = "0.0.1",
    src = system.file("www", package = "shinyAlpinejs"),
    script = "alpine-loader.js"
  )

  hd
}

#' Allows the use of R friendly names for Alpine directives
#' Any HTML attribute staring with x_ is converted to x-
#' x_on_ is converted to x-on:
#' x_bind_ is converted to x-bind:
#' x_shiny_data is converted to x-shiny-data
#' @param code shiny.tag list
#' @export
withAlpine <- function(code) {
  update_alpine_directives(code)
}


update_alpine_directives <- function(tag) {
  if (typeof(tag) == "list") {
    if (!is.null(tag$attribs)) {
      names(tag$attribs) <-
        stringr::str_replace(names(tag$attribs), "x_", "x-")

      names(tag$attribs) <-
        stringr::str_replace(names(tag$attribs), "x-bind_", "x-bind:")

      names(tag$attribs) <-
        stringr::str_replace(names(tag$attribs), "x-on_", "x-on:")

      names(tag$attribs) <-
        stringr::str_replace(names(tag$attribs), "x-shiny_data", "x-shiny-data")

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
