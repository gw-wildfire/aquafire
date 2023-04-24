server <- function(input, output) {
  
  # Load the raster layer
  raster_layer <- raster("aquafire-test/www/raster_layer.tif")


  output$map <- renderLeaflet({
    leaflet() %>%
      addRasterImage(raster_layer)
  })
  
}
