server <- function(input, output) {
  
  # Load the raster layer
  raster_layer <- raster("aquafire-test/www/raster_layer.tif")

#   Create a leaflet map
  # output$map <- renderLeaflet(
  #   leaflet() %>%
  #     addProviderTiles("Esri.WorldImagery") %>% 
  #     addRasterImage(raster_layer))

  
  # build leaflet map ----
  output$map <- renderLeaflet({
    
    leaflet() %>% 
      
      # add tiles
      addProviderTiles("Esri.WorldImagery") %>% 
      
      # set view of AK
      setView(lng = -152, lat = 70, zoom = 6) %>% 
      
      # add mini map
      addMiniMap(toggleDisplay = TRUE, minimized = TRUE) }) %>% 
    
    addRasterImage(raster_layer)
    
}


