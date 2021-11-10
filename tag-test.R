library(stringr)



withAlpine <- function(code) {
  update_alpine_directives(code)
}


update_alpine_directives <- function(tag) {
  # print("****tag")
  # print(typeof(tag))
  # print(tag)
  if (typeof(tag) == "list") {
    if (is.null(tag$attribs)) {
      print("no attribs")
      print(tag)
    } else {
      # lapply(names(tag$attribs), function(x) {
      #   print("attr to update")
      #   print(x)
      #   print(str_extract(x, "x_"))
      # })
      names(tag$attribs) <-
        str_replace(names(tag$attribs), "x_", "x-")

      names(tag$attribs) <-
        str_replace(names(tag$attribs), "x-bind_", "x-bind:")

      names(tag$attribs) <-
        str_replace(names(tag$attribs), "x-on_", "x-on:")

      if (is.null(tag$children)) {
        print("no child")
      } else {
        # print("*children")
        # print(typeof(tag$children))
        # print(tag$children)
        new_children <- lapply(tag$children, function(child) {
          # print("****child")
          # print(child)
          child <- update_alpine_directives(child)
          child
        })
        tag$children <- new_children
      }
    }
  }
  tag
}

a <- withAlpine(div(
  class = "myclass",
  x_text = "blah",
  h3(x_for = "foo", "header"),
  p(x_on_click = "hi", "text"),
  div(p(x_bind_blah = "biz"))
))

a