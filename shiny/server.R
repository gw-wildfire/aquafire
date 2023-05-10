server <- function(input, output) {
  
  proxy <- leafletProxy("map")
  # Load the raster layer
  
  # NOTES - INSTEAD OF 13 FIELDS, ONLY USE 1
  r <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/gde_boundaries.tif")
  f <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/tslf.tif")
  
  eco_regions <- read_sf("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/data/ca_eco_l3") %>% 
    janitor::clean_names()  %>% 
    st_transform(crs_ca) %>% 
    rename(region = us_l3name)
  
  # data reading in
  
  # socal_norbaja_coast <- eco_regions[12,]
  # socal_norbaja_coast_gdes <- crop(r, socal_norbaja_coast)
  # 
  # southern_mountains <- eco_regions[9,]
  # southern_mountains_gdes <- crop(r, southern_mountains)
  # 
  #   map_1 <- tm_shape(socal_norbaja_coast_gdes, raster.downsample = TRUE) +
  #   tm_raster()
  #   
  #   map_2 <- tm_shape(southern_mountains_gdes, raster.downsample = TRUE) +
  #     tm_raster()
  #   
  #   tm <- tm_shape(socal_norbaja_coast_gdes) +
  #     tm_raster() +
  #     tm_shape(southern_mountains_gdes) +
  #     tm_raster()
    
  
  output$map <- renderTmap({

    tm
    
    # if ("socal_norbaja_coast_gdes" %in% input$map) {
    #   map_1
    # } else if ("southern_mountains_gdes" %in% input$map) {
    #   map_2
    # }

  })

#  Update map whenever selection is made
  # observe({
  #   
  #   if (input$socal_norbaja_coast_gdes) {
  #     tm$layers[1]$visible <- TRUE
  #   } else {
  #     tm$layers[1]$visible <- FALSE
  #   }
  #   if (input$southern_mountains_gdes) {
  #     tm$layers[2]$visible <- TRUE
  #   } else {
  #     tm$layers[2]$visible <- FALSE
  #   }
  #   
  #   # if ("socal_norbaja_coast_gdes" %in% input$map) {
  #   #   map_1@layers[[1]]$visible <- TRUE
  #   # } else {
  #   #   map_2@layers[[1]]$visible <- FALSE
  #   # }
  # 
  #   # if ("southern_mountains_gdes" %in% input$map) {
  #   #   map@layers[[2]]$visible <- TRUE
  #   # } else {
  #   #   map@layers[[2]]$visible <- FALSE
  #   # }
  # 
  # })

}



# BELOW IS LEAFLET


# output$map <- renderLeaflet({
#   leaflet() %>% 
#     addProviderTiles("Esri.WorldImagery") %>%
#     setView(-120.829529, 37.538843, zoom = 6) %>%
#     addRasterImage(tslf_masked) #, opacity = input$layer_opacity, layerId = "rasterLayer") %>% 
  # addLayersControl(overlayGroups = "rasterLayer", options = layersControlOptions(collapsed = FALSE)) %>% 
  # addMouseCoordinates() %>% 
  # addMeasure(
  #   position = "bottomleft",
  #   primaryLengthUnit = "miles",
  #   primaryAreaUnit = "sqmiles",
  #   activeColor = "#3D535D",
  #   completedColor = "#36454F") 
  
# }) # End render leaflet

# observeEvent(input$overlay, {
#   if (input$overlay) {
#     leafletProxy("map", data = r) %>%
#       addRasterImage(r, opacity = input$opacity, layerId = "overlay") # Add the overlay layer
#   } else {
#     leafletProxy("map", data = r) %>%
#       removeLayer("overlay") # Remove the overlay layer
#   }
# }) # End observeEvent for raster image opacity and toggle on/off




#### Getting interactive GDE % burned

# # Define reactive event for groundwater-dependent ecosystem raster layer clicks
# observeEvent(input$map_click, {
#   # Get clicked coordinates
#   click_coords <- input$map_click
#   
#   # Get value of clicked pixel in groundwater-dependent ecosystem raster layer
#   clicked_gde_value <- extract(gde_raster, click_coords)
#   
#   # Create a mask to extract values from the time since last burn raster layer
#   mask <- gde_raster == clicked_gde_value
#   
#   # Extract values from the time since last burn raster layer using the mask
#   burn_values <- extract(burn_raster, mask = mask)
#   
#   # Calculate % area burned within the clicked groundwater-dependent ecosystem
#   pct_burned <- sum(burn_values > 0) / sum(!is.na(burn_values)) * 100
#   
#   # Update the map with the % area burned within the clicked groundwater-dependent ecosystem
#   leafletProxy("map", data = gde_raster) %>%
#     addLabelOnlyMarkers(lng = click_coords$lng, lat = click_coords$lat, label = paste0(round(pct_burned, 2), "% burned"))


#  })


# TMAP







