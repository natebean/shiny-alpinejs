library(jsonlite)

initialize_alpine <- function(session, data) {
  session$sendCustomMessage("alpine-initalize", jsonlite::toJSON(data))
}

update_alpine_data <- function(session, name, data) {
  data_package <- list(name = name, data = data)
  session$sendCustomMessage(
    "alpine-update-data",
    jsonlite::toJSON(data_package)
  )
}

convert_from_alpine <- function(data) {
  jsonlite::fromJSON(data)
}