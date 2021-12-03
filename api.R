setwd("~/x/0_/47_r_api")
library(plumber)
library(shiny)
library(httr)
library(future)
# library(base64enc)
# library(jsonlite)

plan(multisession)

# pr("plumber.R")

start.plumber <- function() {
  router <- pr("plumber.R")
  future( pr_run(router, port=8000) )
  return( NULL )
}

ui <- fluidPage(
  titlePanel("Dual server test"),
  inputPanel(
    textInput("a", "a", value=0),
    textInput("b", "b", value=0)
  ),
  textOutput("txtResult")  
)

server <- function(input, output) {
  output$txtResult <- renderText({
    a <- as.numeric(input$a)
    b <- as.numeric(input$b)
    resp <- httr::POST("http://127.0.0.1:8000/sum", query=list(a=a, b=b))
    content(resp)[[1]]
  })
}

# Seems to stop w/ shiny
start.plumber()

# Start shiny
shinyApp(ui = ui, server = server)

# Testing
ex <-  httr::GET("http://127.0.0.1:8000/plot")
ex <-  httr::POST("http://127.0.0.1:8000/sum?a=1&b=2")

content(ex)[[1]]

render(ex$content)
