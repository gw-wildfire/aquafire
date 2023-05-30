server <- function(input, output, session) {
  
  tmap_mode("view")
  # end
  
  # when new ecoregion selected, gets rid of fire metric selections - HOW TO DO UPON CLICKING NEW ECOREGION
  observeEvent(input$ecoregion_type_input,{
    print('new ecoregion')
    updateCheckboxGroupButtons(session = session,
                               inputId = 'type_raster',
                               selected = character(0))
    
  })
  
  # GDE map----
  map_reactive <- reactive({
    print(input$ecoregion_type_input)
    # print(input$firelayer_type_input)
    # print(input$tslf_type_input)
    # 
    print(input$type_raster)
    # tm_level_one = tm_shape(gde_list[[input$ecoregion_type_input]]) +
    #   tm_raster()
    
    req(!is.null(input$ecoregion_type_input))
    
    eco_selected <- input$ecoregion_type_input
    eco_selected2 = gsub('gde_', '', eco_selected)
    
    names_fire2 = gsub('_fire_count', '', names_fire)
    names_tslf2 = gsub('_tslf', '', names_tslf)
    names_fire_threat2 = gsub('_fire_threat', '', names_fire_threat)
    names_burn_severity2 = gsub('_burn_severity', '', names_burn_severity)
    names_ecoregion2 = names(ecoregion_list)
    
    wfire = which(names_fire2 == eco_selected2)
    wfire = names_fire[wfire]
    print(wfire)
    
    wtslf = which(names_tslf2 == eco_selected2)
    wtslf = names_tslf[wtslf]
    print(wtslf)
    
    wfire_threat = which(names_fire_threat2 == eco_selected2)
    wfire_threat = names_fire_threat[wfire_threat]
    print(wfire_threat)
    
    wburn_severity = which(names_burn_severity2 == eco_selected2)
    wburn_severity = names_burn_severity[wburn_severity]
    print(wburn_severity)
    
    wecoregion = which(names_ecoregion2 == eco_selected2)
    wecoregion = names_ecoregion2[wecoregion]
    print(wecoregion)
    
    
    tm_level_one <- tm_basemap(leaflet::providers$Esri.WorldTerrain) +
      tm_basemap(leaflet::providers$Esri.WorldStreetMap) +
      tm_shape(ecoregion_list[[wecoregion]]) +
      tm_polygons(alpha = 0.2, interactive = FALSE) +
      tm_shape(gde_list[[input$ecoregion_type_input]], 
               point.per = "feature") +
      tm_polygons(col = '#0f851e',
                  id = 'popup_text',
                  border.col = 'white',
                  lwd = 0.1,
                  alpha = 0.6,
                  popup.vars = c("Wetland Type" = "WETLAND_NA", 
                                 "Area" = "area",
                                 "Vegetation Type" = "VEGETATION")
      ) + tmap_options(check.and.fix = TRUE) +
      # tm_borders(col = , lwd = 2) +
      tm_layout(title = 'test', title.position = 'right')
    
    # if(gde_list[[input$ecoregion_type_input]])
    
    if('Fire Count Raster' %in% input$type_raster){
      print(' FIRE COUNT RASTER ')
      fire_layer <- fire_count_list[[wfire]]
      tm_level_one <- tm_level_one + tm_shape(fire_layer) +
        tm_raster(palette = 'Reds',
                  alpha = input$alpha1,
                  title = 'Fire Count Raster',
                  breaks = seq(0, maxValue(fire_layer), 1),
                  labels = c(as.character(seq(0, maxValue(fire_layer), 1)))
        ) # breaks = seq(0, length(fire_layer), 1)
    }
    
    if('TSLF Raster' %in% input$type_raster){
      print(' TSLF RASTER ')
      tslf_layer <- tslf_list[[wtslf]]
      tm_level_one <- tm_level_one + tm_shape(tslf_layer) +
        tm_raster(palette = 'seq',
                  alpha = input$alpha2,
                  title = 'TSLF Raster') +
        tm_layout(aes.palette = list(seq = "-YlOrRd")) # reversing palette
    }
    
    if('Fire Threat Raster' %in% input$type_raster){
      print(' FIRE THREAT RASTER ')
      fire_threat_layer <- fire_threat_list[[wfire_threat]]
      tm_level_one <- tm_level_one + tm_shape(fire_threat_layer) +
        tm_raster(palette = 'Reds',
                  alpha = input$alpha3,
                  title = 'Fire Threat Raster')
      #labels = c("Low", "Moderate", "High", "Very High", "Extreme"))
    }
    
    if('Burn Severity Raster' %in% input$type_raster){
      print(' BURN SEVERITY RASTER ')
      burn_severity_layer <- burn_severity_list[[wburn_severity]]
      tm_level_one <- tm_level_one + tm_shape(burn_severity_layer) +
        tm_raster(palette = 'Reds', # CHANGE PALATTE
                  alpha = input$alpha4,
                  title = 'Burn Severity Raster',
                  labels = c("NA", "Low", "Medium", "High")
                  # breaks = seq(1, maxValue(burn_severity_layer), 1),
                  # labels = c(as.character(seq(1, maxValue(burn_severity_layer), 1)))
        )
    }
    
    tm_level_one # %>%  tmap_leaflet() %>% leaflet::hideGroup("gde_list[[input$ecoregion_type_input]]")
    
  })
  
  output$map <- renderTmap({
    
    req(!is.null(map_reactive()))
    
    print('Started loading')
    map_reactive()
  })
  
  
  # main page ecoregion map----
  output$main_map <- renderTmap({
    
    # Define the text information for the popup
    popup_text <- "1. COAST RANGE"
    coast_range$popup_text <- popup_text
    popup_text <- "4. CASCADES"
    cascades$popup_text <- popup_text
    popup_text <- "5. SIERRA NEVADA"
    sierra_nevada$popup_text <- popup_text
    popup_text <- "6. CENTRAL CALIFORNIA FOOTHILLS AND COASTAL MOUNTAINS"
    central_foothills_coastal_mountains$popup_text <- popup_text
    popup_text <- "7. CENTRAL CALIFORNIA VALLEY"
    central_valley$popup_text <- popup_text
    popup_text <- "8. SOUTHERN CALIFORNIA MOUNTAINS"
    southern_mountains$popup_text <- popup_text
    popup_text <- "9. EASTERN CASCADE SLOPES AND FOOTHILLS"
    eastern_cascades_slopes_foothills$popup_text <- popup_text
    popup_text <- "13. CENTRAL BASIN AND RANGE"
    central_basin$popup_text <- popup_text
    popup_text <- "14. MOJAVE BASIN AND RANGE"
    mojave_basin$popup_text <- popup_text
    popup_text <- "78. KLAMATH MOUNTAINS AND CALIFORNIA HIGH NORTH COAST RANGE"
    klamath_mountains$popup_text <- popup_text
    popup_text <- "80. NORTHERN BASIN AND RANGE"
    northern_basin$popup_text <- popup_text
    popup_text <- "81. SONORAN BASIN AND RANGE"
    sonoran_basin$popup_text <- popup_text
    popup_text <- "85. SOUTHERN CALIFORNIA/NORTHERN BAJA COAST"
    socal_norbaja_coast$popup_text <- popup_text
    
    # Plot the polygons with interactive click events and custom popup
    main_cali_map  <- tm_basemap(leaflet::providers$Esri.WorldTerrain) +
      tm_basemap(leaflet::providers$Esri.WorldStreetMap) +
      tm_shape(coast_range) +
      tm_polygons(col = "#0081A7", 
                  title = "Region", 
                  id = "popup_text", 
                  popup.vars = NULL,
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # cascades
      tm_shape(cascades) +
      tm_polygons(col = "#8CB369", 
                  title = "Region", 
                  id = "popup_text", 
                  popup.vars = c("region", "state_name"),
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # sierra nevada
      tm_shape(sierra_nevada) +
      tm_polygons(col = "#C0CB77", 
                  title = "Region", 
                  id = "popup_text", 
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # central cal mtns
      tm_shape(central_foothills_coastal_mountains) +
      tm_polygons(col = "#7FD6CB", 
                  title = "Region", 
                  id = "popup_text", 
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # socal mountains
      tm_shape(southern_mountains) +
      tm_polygons(col = "#F4E285", 
                  title = "Region", 
                  id = "popup_text", 
                  alpha = 0.55, border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # east cascade foothills
      tm_shape(eastern_cascades_slopes_foothills) +
      tm_polygons(col = "#F4C26F", 
                  title = "Region", 
                  id = "popup_text", 
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # central basin and range
      tm_shape(central_basin) +
      tm_polygons(col = "#F4A259", 
                  title = "Region", 
                  id = "popup_text", 
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # mojave basin and range
      tm_shape(mojave_basin) +
      tm_polygons(col = "#8CB369", 
                  title = "Region", 
                  id = "popup_text", 
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # klamath mtns
      tm_shape(klamath_mountains) +
      tm_polygons(col = "#A8986B", 
                  title = "Region", 
                  id = "popup_text", 
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # northern basin
      tm_shape(northern_basin) +
      tm_polygons(col = "#829374", 
                  title = "Region", 
                  id = "popup_text", 
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # sonoran basin
      tm_shape(sonoran_basin) +
      tm_polygons(col = "#5B8E7D", 
                  title = "Region", 
                  id = "popup_text", 
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # socal baja coast
      tm_shape(socal_norbaja_coast) +
      tm_polygons(col = "#BC4B51", 
                  title = "Region", 
                  id = "popup_text", 
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # central valley
      tm_shape(central_valley) +
      tm_polygons(col = "lightgrey", 
                  title = "Region", 
                  id = "popup_text", 
                  alpha = 0.5, 
                  border.col = 'white', lwd = 0.3,
                  lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right")  +
      tm_view(bbox = cali_bounds)
    
    
    
  })
  
  
  
  # stats page----
  stats_reactive <- reactive({
    
    print(input$ecoregion_stats_type_input)
    
    req(!is.null(input$ecoregion_stats_type_input))
    
    stats_selected <- input$ecoregion_stats_type_input
    # stats here
    req(!is.null(input$ecoregion_type_input))
    
    # make a list of 
    
    eco_selected <- input$ecoregion_stats_type_input
    eco_selected2 = gsub('gde_', '', eco_selected)
    
    wstat = which(names_stats2 == eco_selected2)
    wstat = names_stat[wstat]
    print(wstat)
    
    stat <- stat_list[[input$ecoregion_stats_type_input]]
    
    stat
    
    # make a list of stats images!!
    
    # if('Stats Image' %in% input$ecoregion_stats_type_input){
    #   print(' FIRE COUNT RASTER ')
    #   stat_layer <- stat_list[[wstat]]
    #   tm_level_one <- tm_level_one + tm_shape(fire_layer) +
    #     tm_raster(palette = 'Reds',
    #               alpha = input$alpha1,
    #               title = 'Fire Count Raster',
    #               breaks = seq(0, maxValue(fire_layer), 1))
    #   }
    
    
    
  })
  
  stats_selected <- 
    # stats output----
  output$stats <- renderImage({
    
    stats_reactive
    
  })
  
  data_df <- data.frame(Data = c("Groundwater-Dependent Ecosystems", "Fire Count", "Time Since Last Fire (TSLF)", "Fire Threat", "Burn Severity"),
                        Source = c("The Nature Conservancy", "Cal Fire (layer produced by us)", "Cal Fire (layer produced by us)", "Cal Fire", "USGS and USFS"),
                        Information = c("Groundwater-Dependent Ecosystems are from The Nature Conservancy",
                                        "This layer was created from the fire perimeter data from Cal Fire, and is a raster layer where each cell is the total number of fires that occured since 1950.",
                                        "This layer was created from the fire perimeter data from Cal Fire, and is a raster layer where each cell is the time in years since the last fire occured since 1950.",
                                        "Fire Threat is a layer created by Cal Fire that represents the relative vulnerability of an area to wildfires. Some variables that are used in this modeled fire layer are fire occurance, vegetation type and density, topography and weather conditions.",
                                        "The Burn Severity layer was changed to apply the mode of all previous fires in a single cell. The originial layer is derived from satellite data and represents how intensely a fire burned in a certain area. "))
  
  
  output$dataTable <- renderTable(data_df)
  
  # renderTable({
  #   
  # })
  
}

