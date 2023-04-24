server <- function(input, output) {
  
  # Load the raster layer
  r <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/raster_layer.tif")
  
  
  output$map <- renderLeaflet({
    leaflet() %>% 
      addProviderTiles("Esri.WorldImagery") %>%
      setView(-120.829529, 37.538843, zoom = 6) %>%
      addRasterImage(r, opacity = input$layer_opacity, layerId = "rasterLayer") %>% 
      addLayersControl(overlayGroups = "rasterLayer", options = layersControlOptions(collapsed = FALSE)) %>% 
      addMouseCoordinates() %>% 
      addMeasure(
        position = "bottomleft",
        primaryLengthUnit = "miles",
        primaryAreaUnit = "sqmiles",
        activeColor = "#3D535D",
        completedColor = "#36454F") 
    
  }) # End render leaflet
  
  observeEvent(input$overlay, {
    if (input$overlay) {
      leafletProxy("map", data = r) %>%
        addRasterImage(r, opacity = input$opacity, layerId = "overlay") # Add the overlay layer
    } else {
      leafletProxy("map", data = r) %>%
        removeLayer("overlay") # Remove the overlay layer
    }
  })
  
  
}


