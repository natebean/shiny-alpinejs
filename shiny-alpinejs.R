library(jsonlite)

initialize_alpine <- function(session, data) {
  session$sendCustomMessage("alpine-initalize", toJSON(data))
}

convert_alpine <- function(data){
  fromJSON(data)
}

