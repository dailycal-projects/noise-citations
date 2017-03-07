

library(shiny)
library(leaflet)
library(leaflet.extras)

coords = readRDS("citation_coordinates.rds")
und_coords = readRDS('underage_citations.rds')

m <- leaflet() %>%
  setView(lng = mean(coords$Longitude) , lat = mean(coords$Latitude),
          zoom = 14) %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addProviderTiles(providers$OpenStreetMap.BlackAndWhite) %>%
  addCircleMarkers(lng=(coords$Longitude), lat=(coords$Latitude),
                   popup= coords$Date, radius = 5, group = "points") %>%
  addHeatmap(lng = coords$Longitude , lat = coords$Latitude, blur = 30,
             minOpacity = 0.001 ,max = 1,radius = 15, group = "heatmap") %>%
  addMarkers(lng=(und_coords$Longitude) , lat =(und_coords$Latitude),
             group = "underage citations",
             popup = und_coords$Ticket.Date.And.Time ) %>%
  
  addLayersControl(
    baseGroups = ,
    overlayGroups = c("heatmap", "points", "underage citations"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>% 
  hideGroup("underage citations") %>%
  hideGroup("points")

# Define server logic required to draw graphs
shinyServer(function(input, output) {
  
output$plot = renderLeaflet({
    m
})
  
  
})
  
  