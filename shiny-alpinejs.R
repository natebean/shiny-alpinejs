library(jsonlite)
library(htmltools)

initialize_alpine <- function(session, data) {
  session$sendCustomMessage("alpine-initalize", toJSON(data))
}

convert_alpine <- function(data) {
  fromJSON(data)
}

alpine_template <- function(...,
                            .noWS = NULL,
                            .renderHook = NULL)
{
  # validateNoWS(.noWS)
  contents <- list(...)
  tag("template",
      contents,
      .noWS = .noWS,
      .renderHook = .renderHook)
}
