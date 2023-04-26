server <- function(input, output) {
  
  # Load the raster layer
  r <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/raster_layer.tif")
  
  
  
  output$map <- renderLeaflet({
 
    
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


