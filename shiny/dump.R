# sidebarLayout ----
#                                  sidebarLayout(

sidebarPanel(width = 3,
             
             # Put inputs & variables to change here!
             # GDEs, Wildfire Hazard
             "For California spatial analysis inputs"
             
),
#                                  ), # End sidebarLayout ----

# ABOVE AFTER LEAFLET MAP


raster_layer <- raster("aquafire-test/www/raster_layer.tif")

map = leaflet() %>% addTiles()

myMap = renderLeaflet(map)


map <- renderLeaflet(
  
  leaflet() %>% 
    # add tiles
    addTiles() %>% 
    
    # set view of AK
    #setView(lng = -152, lat = 70, zoom = 6) %>% 
    
    # add mini map
    #addMiniMap(toggleDisplay = TRUE, minimized = TRUE) }) %>% 
  
  addRasterImage(raster_layer))


leafletOutput(outputId = "map")
