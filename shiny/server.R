server <- function(input, output, session) {
  
  tmap_mode("view")
  # end
  
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
    names_fire_threat2 = gsub('_fire_threat', '',names_fire_threat) # ADDING
    
    wfire = which(names_fire2 == eco_selected2)
    wfire = names_fire[wfire]
    print(wfire)
    
    wtslf = which(names_tslf2 == eco_selected2)
    wtslf = names_tslf[wtslf]
    print(wtslf)
    
    wfire_threat = which(names_fire_threat2 == eco_selected2) # ADDING
    wfire_threat = names_fire_threat[wfire_threat]
    print(wfire_threat)
    
    tm_level_one <- tm_basemap(leaflet::providers$Esri.WorldTerrain) +
      tm_basemap(leaflet::providers$Esri.WorldStreetMap) +
      tm_shape(gde_list[[input$ecoregion_type_input]], point.per = "feature") +
      tm_polygons(col = '#0f851e',
                  id = 'popup_text',
                  border.col = 'white',
                  lwd = 0.5
                  #popup.vars = c("WETLAND_NA", "area")
      )
    
    
    # Add pop-up windows using leaflet
    # leaflet_map <- tmap_leaflet(tm_level_one)
    # leaflet_map <- leaflet_map %>%
    #   addPolygons(
    #     data = st_transform(gde_list[[input$ecoregion_type_input]], crs = 3310),
    #     fillColor = '#0f851e',
    #     fillOpacity = 0.5,
    #     label = ~paste("Area:", area, "<br>",
    #                    "Wetland:", WETLAND_NA),
    #     labelOptions = labelOptions(noHide = TRUE)
    #   )
    
    # + tm_dots(popup.vars = TRUE)
    # + tm_fill(popup.vars = "area")
    # , id = "WETLAND_NA"
    # + tm_bubbles("area") 
    # + tm_fill(interactive = TRUE, popup.vars = "WETLAND_NA")
    #  # Display legend here!?
    
    if('Fire Count Raster' %in% input$type_raster){
      print(' FIRE COUNT RASTER ')
      fire_layer <- fire_count_list[[wfire]]
      tm_level_one <- tm_level_one + tm_shape(fire_layer) +
        tm_raster(palette = 'Reds',
                  alpha = input$alpha1,
                  title = 'Fire Count Raster',
                  breaks = seq(0, maxValue(fire_layer), 1)) # breaks = seq(0, length(fire_layer), 1)
    }
    
    if('TSLF Raster' %in% input$type_raster){
      print(' TSLF RASTER ')
      tslf_layer <- tslf_list[[wtslf]]
      tm_level_one <- tm_level_one + tm_shape(tslf_layer) +
        tm_raster(palette = 'YlOrRd',
                  alpha = input$alpha2,
                  title = 'TSLF Raster')
    }
    
    if('Fire Threat Raster' %in% input$type_raster){
      print(' FIRE THREAT RASTER ')
      fire_threat_layer <- fire_threat_list[[wfire_threat]]
      tm_level_one <- tm_level_one + tm_shape(fire_threat_layer) +
        tm_raster(palette = 'Reds',
                  alpha = input$alpha3,
                  title = 'Fire Threat Raster')
    }
    
    tm_level_one # %>%  tmap_leaflet() %>% leaflet::hideGroup("gde_list[[input$ecoregion_type_input]]")
    
    
    # a <- tmap_leaflet(tm_level_one)
    # a <- a %>% addPolygons(data = tm_level_one,
    #                        label = ~paste("Area: ", area))
    # a
  })
  
  output$map <- renderTmap({
    
    req(!is.null(map_reactive()))
    
    print('Started loading')
    map_reactive()
  })
  
  # main page ecoregion map
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
    main_cali_map  <- tm_shape(coast_range) +
      tm_polygons(col = "#0081A7", 
                  title = "Region", 
                  id = "popup_text", 
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # cascades
      tm_shape(cascades) +
      tm_polygons(col = "#8CB369", 
                  title = "Region", 
                  id = "popup_text", 
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
                legend.outside.position = "right") 
    
    
    
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
    
    names_fire2 = gsub('_fire_count', '', names_fire)
    
    wstat = which(names_stats2 == eco_selected2)
    wfire = names_fire[wstat]
    print(wstat)
    
    # if('Fire Count Raster' %in% input$ecoregion_stats_type_input){
    #   print(' FIRE COUNT RASTER ')
    #   stat_layer <- stat_list[[wstat]]
    #   tm_level_one <- tm_level_one + tm_shape(fire_layer) +
    #     tm_raster(palette = 'Reds',
    #               alpha = input$alpha1,
    #               title = 'Fire Count Raster',
    #               breaks = seq(0, maxValue(fire_layer), 1))
    #   }
    
    
    
  })
  
  # stats output----
  output$stats <- renderImage({
    
    stats_reactive
    
  })
  
}

