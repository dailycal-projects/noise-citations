
library(readr)
library(sp)
library(KernSmooth)
library(RColorBrewer)
library(magrittr)
library(shiny)
library(leaflet)
library(leaflet.extras)

drinkcoords <- read_csv("und_drink_cit_coords.csv", 
                        col_types = cols(Date = col_date(format = "%m/%d/%Y"), 
                                         Latitude = col_number(), Longitude = col_number()))
drinkcoords = na.omit(drinkcoords)

noisecoords <- read_csv("noise_citation_coords.csv", 
                        col_types = cols(Latitude = col_number(), 
                                         Longitude = col_number()))
noisecoords = na.omit(noisecoords)

drinkcoords$Time = gsub(" ", "", drinkcoords$Time, fixed = TRUE)

coords = noisecoords
und_coords = drinkcoords

und_coords$content = paste(drinkcoords$Date, drinkcoords$Time, sep = "<br/>")

library(sp)
library(KernSmooth)
library(RColorBrewer)

d2d = bkde2D(cbind(coords$Longitude, coords$Latitude) , 
             bandwidth = c(0.00055, 0.00055))
CL = contourLines(d2d$x1 , d2d$x2, d2d$fhat)

levs = as.factor(sapply(CL, '[[', "level"))
nlev = length(levels(levs))

pgons = lapply(1:length(CL) , function(i)
  Polygons(list(Polygon(cbind(CL[[i]]$x, CL[[i]]$y))), ID = i))
spgons = SpatialPolygons(pgons)

n = leaflet(spgons) %>%
  setView(lng = mean(coords$Longitude) , lat = mean(coords$Latitude),
          zoom = 14) %>%
  addTiles() %>%
  addProviderTiles(providers$OpenStreetMap.BlackAndWhite) %>% 
  addPolygons(color = rev(heat.colors(nlev, NULL)[levs]) , weight = 1,
              stroke = FALSE, group = "noise complaints heatmap") %>%
  addCircleMarkers(lng=(coords$Longitude), lat=(coords$Latitude),
                   #popup= coords$Date,
                   radius = 2, group = "noise complaints")%>%
  addMarkers(lng=(und_coords$Longitude) , lat =(und_coords$Latitude),
             group = "underage drinking citations" ,
             popup = c(und_coords$content))  %>%
  addLabelOnlyMarkers(lat = 37.877785, lng = -122.2629177, label = "Northside", 
                      labelOptions = labelOptions(noHide = T , textOnly = T, 
                                                  textsize = "17px",
                                                  style = list(
                                                    "letter-spacing" = "2px"
                                                  ))) %>%
  addLabelOnlyMarkers(lat = 37.862328, lng = -122.2656747, label = "Southside", 
                      labelOptions = labelOptions(noHide = T , textOnly = T, 
                                                  textsize = "17px",
                                                  style = list(
                                                    "letter-spacing" = "2px"
                                                  ))) %>%
  addLayersControl(
    baseGroups = ,
    overlayGroups = c("noise complaints heatmap", "noise complaints", "underage drinking citations"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>% 
  hideGroup("underage drinking citations") %>%
  hideGroup("noise complaints")

# Define server logic required to draw graphs
shinyServer(function(input, output) {
  
output$plot = renderLeaflet({
    n
})
  
  
})
  
  