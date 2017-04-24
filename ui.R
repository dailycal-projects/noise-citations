
library(shiny)
library(leaflet)
library(leaflet.extras)

shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
  ),
  
  titlePanel(""),
  
  h1("Noise Citations in Berkeley" , align = "center"),
  
  p('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque venenatis consequat ligula. Donec elit purus, accumsan ac congue in, mattis sed nisl. Sed semper sit amet magna quis tincidunt. Fusce euismod ipsum quis massa sollicitudin efficitur. In in ultricies nunc. Morbi eu lorem ante. Sed enim sem, aliquet eget purus nec, placerat ultricies leo. Fusce interdum posuere facilisis. Vestibulum interdum iaculis turpis, eu porttitor erat bibendum ut.',
    style = "width: 60%; margin: 30px auto;"),
  column(12, align = "center", 
    leafletOutput("plot" , width = "80%", height = 600)
  )
  
))