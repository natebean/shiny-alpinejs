library(jsonlite)
library(htmltools)

initialize_alpine <- function(session, data) {
  session$sendCustomMessage("alpine-initalize", toJSON(data))
}

update_alpine_data <- function(session, name, data) {
  
  data_package <- list(name = name, data = data)
  session$sendCustomMessage("alpine-update-data", toJSON(data_package))
}

convert_from_alpine <- function(data) {
  fromJSON(data)
}

