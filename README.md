# shinyAlpinejs

A small integration of Shiny and [Alpine.js](http://alpinejs.dev).
It uses Alpine and some 'glue' to integrate Shiny and [Alpine.js stores](https://alpinejs.dev/magics/store)

## Shiny UI
Add an `x-shiny-data` attribute to a html element to connect it with Shiny.  
The value is the name of your data store.  `hello_world` in this case.
You will access the data of the store in Alpine using `data` (see below)


    div(`x-shiny-data` = "hello_world", 
	    p(`x-text` = "data")
	   )
    #You can think of hello_world as a list with a data element.
    hello_world <- list(data = "Hello World")

To avoid backticks you can use `withAlpine()`.  
This will do the following conversions
| R Friendly      | Alpine Directive |
| -----------     | -----------      |
| `x_*`           | `x-*`            |
| `x_bind_*`      | `x-bind:*`       |
| `x_on_*`        | `x-on:*`         |
| `x_shiny_data`  | `x-shiny-data`   |

## Shiny Server
To send data to Alpine

    update_alpine_data(session, "hello_world", "Hello World")

## Send Data from Alpine to Shiny
Use the `sendDataToShiny` with the data store name as the parameter.

    tags$button(
      `@click` = "sendDataToShiny('hello_world')",
      class = "btn btn-dark", "Send to Shiny"
    )

## Reactive to Alpine Update
   Updates are inputs based on data store name + "_data". In this case `hello_world_data`.
   
  `convert_from_alpine` will convert the data into an R object

    observeEvent(input$hello_world_data, {
		    ans <- convert_from_alpine(input$hello_world_data)
		    print(ans)
    })
  

