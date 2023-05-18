server <- function(input, output, session) {
  
  # Load the raster layer
  
  # need to be able to plot each ecoregion independently 
  
  # attempt sunday at noon
  
  # rasters <- list(
  #   "socal_norbaja_coast_gdes" = socal_norbaja_coast_gdes,
  #   "southern_mountains_gdes" = southern_mountains_gdes,
  #   "sonoran_basin_gdes" = sonoran_basin_gdes
  #   # add the remaining ecoregions here
  # )
  
  # fire_count <- raster("shiny/data/fire_threat.tif")
  
  tmap_mode("view")
  # end
  
  #  tm_df <- observe({
  #    # proxy <- tmapProxy("map", session)
  # 
  #    validate(
  #      need(length(input$ecoregion_type_input) > 0, "Select more than one ecosystem"))
  # 
  #    
  #    tm <- tm_shape(socal_norbaja_coast_gdes) + tm_raster()
  #    tm1 <- tm_shape(southern_mountains_gdes) + tm_raster()
  #    # if ("socal_norbaja_coast_gdes" %in% input$ecoregion_type_input) {
  #    #   tm_shape(socal_norbaja_coast_gdes) + tm_raster()
  #    # } else if ("southern_mountains_gdes" %in% input$ecoregion_type_input) {
  #    #   tm_shape(southern_mountains_gdes) + tm_raster()
  #    # } else if ("sonoran_basin_gdes" %in% input$ecoregion_type_input) {
  #    #   tm_shape(sonoran_basin_gdes) + tm_raster()
  #    # }
  # 
  #  # if ("socal_norbaja_coast_gdes" %in% input$ecoregion_type_input) {
  #  #   tm_shape(socal_norbaja_coast_gdes) + tm_raster()
  #  # } else if ("southern_mountains_gdes" %in% input$ecoregion_type_input) {
  #  #   tm_shape(southern_mountains_gdes) + tm_raster()
  #  # } else if ("sonoran_basin_gdes" %in% input$ecoregion_type_input) {
  #  #   tm_shape(sonoran_basin_gdes) + tm_raster()
  #  # }
  # 
  #    # tm <- tmap::tmap_element()
  #    # for (raster_name in input$ecoregion_type_input) {
  #    #   raster_obj <- rasters[[raster_name]]
  #    #   tm <- tm + tmap::tm_raster(raster_obj)
  #    # }
  # 
  #    # putting tm raster layer into tm_df object and filtering by ecoregion_type - but need ecoregion_type to be a column in tm
  # 
  #    # tm_df <- tm %>%
  #    #   filter(ecoregion_type %in% c(input$ecoregion_type_input))
  # 
  # 
  # })
  
  
  map_reactive <- reactive({
    print(input$ecoregion_type_input)
    print(input$firelayer_type_input)
    
    gde_4
    
    # if ("socal_norbaja_coast_gdes" %in% input$ecoregion_type_input) {
    #   tm
    # } else if ("southern_mountains_gdes" %in% input$ecoregion_type_input) {
    #   tm1
    # }else{
    #   NULL
    # }
  })
  
  output$map <- renderTmap({
    
    req(!is.null(map_reactive()))
    
    print('Started loading')
    map_reactive()
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







