server <- function(input, output) {
  
  # Load the raster layer
  r <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/gde_boundaries.tif")
  
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
  }) # End observeEvent for raster image opacity and toggle on/off
  
  
  
  
  #### Getting interactive GDE % burned
  
  # Define reactive event for groundwater-dependent ecosystem raster layer clicks
  observeEvent(input$map_click, {
    # Get clicked coordinates
    click_coords <- input$map_click
    
    # Get value of clicked pixel in groundwater-dependent ecosystem raster layer
    clicked_gde_value <- extract(gde_raster, click_coords)
    
    # Create a mask to extract values from the time since last burn raster layer
    mask <- gde_raster == clicked_gde_value
    
    # Extract values from the time since last burn raster layer using the mask
    burn_values <- extract(burn_raster, mask = mask)
    
    # Calculate % area burned within the clicked groundwater-dependent ecosystem
    pct_burned <- sum(burn_values > 0) / sum(!is.na(burn_values)) * 100
    
    # Update the map with the % area burned within the clicked groundwater-dependent ecosystem
    leafletProxy("map", data = gde_raster) %>%
      addLabelOnlyMarkers(lng = click_coords$lng, lat = click_coords$lat, label = paste0(round(pct_burned, 2), "% burned"))
  })

}










