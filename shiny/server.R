server <- function(input, output, session) {
  
  
  tmap_mode("view")
  
  
  observeEvent(input$ecoregion_type_input,{
    print('new ecoregion')
    updateCheckboxGroupButtons(session = session,
                               inputId = 'type_raster',
                               selected = character(0))
    
  })
  
  # GDE map----
  map_reactive <- reactive({
    
    # print(input$ecoregion_type_input)
    
    print(input$type_raster)
    
    # req(!is.null(input$ecoregion_type_input))
    
    # calling ecoregion_type_input from pickerInput
    eco_selected <- input$ecoregion_type_input
    eco_selected2 = gsub('gde_', '', eco_selected)
    
    # removing info for connectivity between layers
    names_fire2 = gsub('_fire_count', '', names_fire)
    names_tslf2 = gsub('_tslf', '', names_tslf)
    names_fire_threat2 = gsub('_fire_threat', '', names_fire_threat)
    names_burn_severity2 = gsub('_burn_severity', '', names_burn_severity)
    names_ecoregion2 = names(ecoregion_list)
    
    # creating reactivity for RASTER layers
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
    
    # GDE polygon map----
    tm_level_one <- tm_basemap(leaflet::providers$Esri.WorldStreetMap) +
      tm_basemap(leaflet::providers$Esri.WorldTerrain) +
      tm_shape(ecoregion_list[[wecoregion]]) + tm_polygons(alpha = 0.2, interactive = FALSE) +
      tm_shape(california_polygon) + tm_polygons(alpha = 0, border.col = "black", interactive = FALSE) +
      tm_shape(gde_list[[eco_selected]],
               point.per = "feature") +
      tm_polygons(col = '#0f851e', # GDE color
                  id = 'popup_text',
                  border.col = 'white',
                  lwd = 0.1,
                  alpha = 0.6,
                  popup.vars = c("Wetland Type" = "WETLAND",
                                 "Dominant Vegetation Type" = "VEGETAT",
                                 "Area (km2)" = "are_km2",
                                 "Land Cover Type" = "land_cover_type",
                                 "Maximum Fire Count" = "mx_fr_c",
                                 "Years Since Last Fire" = "mn_tslf",
                                 "Average Fire Threat" = "avg_fr_t",
                                 "Average Fire Severity" = "avg_fr_s"
                  )) +
      tmap_options(check.and.fix = TRUE)
    
    # toggle fire count raster layer
    if('Fire Count' %in% input$type_raster){
      print(' FIRE COUNT ')
      fire_layer <- fire_count_list[[wfire]]
      tm_level_one <- tm_level_one + tm_shape(fire_layer) +
        tm_raster(palette = 'Reds',
                  alpha = input$alpha1,
                  title = 'Fire Count',
                  breaks = seq(0, maxValue(fire_layer), 1),
                  labels = c(as.character(seq(0, maxValue(fire_layer), 1)))
        )
    }
    
    # toggle TSLF raster layer
    if('TSLF' %in% input$type_raster){
      print(' TSLF ')
      tslf_layer <- tslf_list[[wtslf]]
      tm_level_one <- tm_level_one + tm_shape(tslf_layer) +
        tm_raster(palette = '-YlOrRd',
                  alpha = input$alpha2,
                  title = 'TSLF',
                  breaks = seq(0, maxValue(tslf_layer), 10))
    }
    
    # toggle fire threat raster layer
    if('Fire Threat' %in% input$type_raster){
      print(' FIRE THREAT ')
      fire_threat_layer <- fire_threat_list[[wfire_threat]]
      tm_level_one <- tm_level_one + tm_shape(fire_threat_layer) +
        tm_raster(palette = 'Oranges', # OrRd
                  alpha = input$alpha3,
                  title = 'Fire Threat',
                  breaks = seq(0, maxValue(fire_threat_layer), 1),
                  labels = c("Low (0-1)", "Moderate (1-2)", "High (2-3)", "Very High (3-4)", "Extreme (4-5)"))
    }
    
    # toggle burn severity layer
    if('Burn Severity' %in% input$type_raster){
      print(' BURN SEVERITY ')
      burn_severity_layer <- burn_severity_list[[wburn_severity]]
      tm_level_one <- tm_level_one + tm_shape(burn_severity_layer) +
        tm_raster(palette = 'YlOrBr', # CHANGE PALATTE
                  alpha = input$alpha4,
                  title = 'Burn Severity',
                  labels = c("NA", "Low", "Medium", "High")
                  # breaks = seq(1, maxValue(burn_severity_layer), 1),
                  # labels = c(as.character(seq(1, maxValue(burn_severity_layer), 1)))
        )
    }
    
    # displaying map
    tm_level_one
    
  })
  
  # render main map
  output$map <- renderTmap({
    
    req(!is.null(map_reactive()))
    
    print('Started loading')
    map_reactive()
  })
  
  
  # render ecoregion map----
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
    
    # Map with each ecoregion
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
                  popup.vars = NULL,
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # sierra nevada
      tm_shape(sierra_nevada) +
      tm_polygons(col = "#C0CB77", 
                  title = "Region", 
                  id = "popup_text", 
                  popup.vars = NULL,
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # central cal mtns
      tm_shape(central_foothills_coastal_mountains) +
      tm_polygons(col = "#7FD6CB", 
                  title = "Region", 
                  id = "popup_text", 
                  popup.vars = NULL,
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # socal mountains
      tm_shape(southern_mountains) +
      tm_polygons(col = "#F4E285", 
                  title = "Region", 
                  id = "popup_text", 
                  popup.vars = NULL,
                  alpha = 0.55, border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # east cascade foothills
      tm_shape(eastern_cascades_slopes_foothills) +
      tm_polygons(col = "#F4C26F", 
                  title = "Region", 
                  id = "popup_text",
                  popup.vars = NULL,
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # central basin and range
      tm_shape(central_basin) +
      tm_polygons(col = "#F4A259", 
                  title = "Region", 
                  id = "popup_text",
                  popup.vars = NULL,
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # mojave basin and range
      tm_shape(mojave_basin) +
      tm_polygons(col = "#8CB369", 
                  title = "Region", 
                  id = "popup_text",
                  popup.vars = NULL,
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # klamath mtns
      tm_shape(klamath_mountains) +
      tm_polygons(col = "#A8986B", 
                  title = "Region", 
                  id = "popup_text", 
                  popup.vars = NULL,
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # northern basin
      tm_shape(northern_basin) +
      tm_polygons(col = "#829374", 
                  title = "Region", 
                  id = "popup_text",
                  popup.vars = NULL,
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3, lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # sonoran basin
      tm_shape(sonoran_basin) +
      tm_polygons(col = "#5B8E7D", 
                  title = "Region", 
                  id = "popup_text", 
                  popup.vars = NULL,
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # socal baja coast
      tm_shape(socal_norbaja_coast) +
      tm_polygons(col = "#BC4B51", 
                  title = "Region", 
                  id = "popup_text", 
                  popup.vars = NULL,
                  alpha = 0.55, 
                  border.col = 'white', lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right") +
      
      # central valley
      tm_shape(central_valley) +
      tm_polygons(col = "lightgrey", 
                  title = "Region", 
                  id = "popup_text",
                  popup.vars = NULL,
                  alpha = 0.5, 
                  border.col = 'white', lwd = 0.3,
                  lwd = 0.3) +
      tm_layout(legend.outside = TRUE, 
                legend.outside.position = "right")  +
      tm_view(bbox = cali_bounds)
    
    
  }) # End ecoregion map tab
  
  
  # stats histogram page----
  
  # fire count histogram reactivity
  fire_count_hist_reactive <- reactive({
    
    print(input$ecoregion_stats_type_input)
    req(!is.null(input$ecoregion_stats_type_input))
    
    # selecting ecoregion for histogram
    selected_hist_ecoregion <- input$ecoregion_stats_type_input
    fire_hist_ecoregion <- fire_count_histogram_df %>% filter(ecoregion == selected_hist_ecoregion)
    plot_title <- fire_hist_ecoregion$ecoregion_name
    
    fire_max <- max(fire_hist_ecoregion$value)
    
    
    # fire count histogram
    ggplot(fire_hist_ecoregion, aes(x = value, y = proportion, fill = as.factor(gde_status))) +
      geom_bar(stat = "identity", position = "dodge") +
      geom_text(aes(label = round(proportion, 2)),
                position = position_dodge(width = 0.9),
                vjust = -.5,
                size = 3.5,
                check_overlap = TRUE) +
      scale_fill_manual(values = c("#A3B18A", "#DDA15E"),
                        labels = c("Non-GDE", "GDE")) +
      labs(x = "Fire Count",
           y = "Relative Frequency (%)",
           fill = "GDE Status",
           title = str_wrap(paste0("Relative Fire Frequency for ", plot_title), 30)) +
      theme_classic() +
      theme(legend.position = 'right',
            plot.title = element_text(hjust = 0.5,
                                      size = 15),
            axis.text = element_text(size = 13,
                                     color = 'black'),
            axis.title = element_text(size = 15,
                                      color = 'black'),
            axis.title.x = element_text(vjust = -1.1),
            axis.text.x = element_text(vjust = -1.5)) +
      scale_x_continuous(expand = c(0,0)) # ,
      # breaks = seq(0, fire_max, 1))
      
  })
  
  # render fire count histogram plot
  output$fire_count_hist <- renderPlot({
    
    req(!is.null(fire_count_hist_reactive()))
    fire_count_hist_reactive()
    
  })
  
  # burn severity histogram reactivity
  burn_severity_hist_reactive <- reactive({
    print(input$ecoregion_stats_type_input)
    req(!is.null(input$ecoregion_stats_type_input))
    
    selected_hist_ecoregion <- input$ecoregion_stats_type_input
    burn_hist_ecoregion <- burn_severity_histogram_df %>% filter(ecoregion == selected_hist_ecoregion)
    
    if (nrow(burn_hist_ecoregion) == 0) {
      plot_title <- "No Data Available"
      plot_msg <- "Not\nEnough\nData"
      
      ggplot() +
        annotate("text", x = 0.5, y = 0.5, label = plot_msg, size = 15, hjust = 0.5, vjust = 0.5, color = "red") +
        labs(x = "Burn Severity",
             y = "Relative Frequency (%)") +
        theme_void()
    } else {
      
      plot_title <- unique(burn_hist_ecoregion$ecoregion_name)
      
      burn_hist_ecoregion$value[burn_hist_ecoregion$value == 2] <- 'Low'
      burn_hist_ecoregion$value[burn_hist_ecoregion$value == 3] <- 'Medium'
      burn_hist_ecoregion$value[burn_hist_ecoregion$value == 4] <- 'High'
      
      ggplot(burn_hist_ecoregion, aes(x = value, y = proportion, fill = as.factor(gde_status))) +
        geom_col(position = "dodge") +
        geom_text(aes(label = round(proportion, 2)),
                  position = position_dodge(width = 1.9),
                  vjust = -0.5,
                  size = 3.5,
                  check_overlap = TRUE) +
        scale_fill_manual(values = c("#A3B18A", "#DDA15E"),
                          labels = c("Non-GDE", "GDE")) +
        labs(x = "Burn Severity",
             y = "Relative Frequency (%)",
             fill = "GDE Status",
             title = str_wrap(paste0("Relative Burn Severity Frequency for ", plot_title), 30)) +
        theme_classic() +
        theme(legend.position = 'right',
              plot.title = element_text(hjust = 0.5, size = 15),
              axis.text = element_text(size = 13, color = 'black'),
              axis.title = element_text(size = 15, color = 'black'),
              axis.title.x = element_text(vjust = -1.1),
              axis.text.x = element_text(vjust = -1.5)) +
        # scale_y_continuous(expand = c(0,0)) +
        scale_x_discrete(limits = burn_hist_ecoregion$value)
      
    }
  })
  
  output$burn_severity_hist <- renderPlot({
    
    req(!is.null(burn_severity_hist_reactive()))
    burn_severity_hist_reactive()
    
  })
  
  # adding fire count info to the histogram
  fire_count_text_reactive <- reactive({
    
    req(!is.null(input$ecoregion_stats_type_input))
    
    # Selecting ecoregion for histogram
    selected_text_ecoregion <- input$ecoregion_stats_type_input
    fire_text_ecoregion <- fire_count_text_df$values[fire_count_text_df$column_names == selected_text_ecoregion]
    
    # Returning the second column value for the selected ecoregion
    fire_text_ecoregion
    
  })
  
  output$fire_count_text <- renderText(
    
    fire_count_text_reactive()
    
  )
  
  # adding burn severity info to the histogram
  burn_severity_text_reactive <- reactive({
    
    req(!is.null(input$ecoregion_stats_type_input))
    
    selected_text_ecoregion <- input$ecoregion_stats_type_input
    burn_text_ecoregion <- burn_severity_text_df$values[burn_severity_text_df$column_names == selected_text_ecoregion]
    
    burn_text_ecoregion
    
  })
  
  output$burn_severity_text <- renderText(
    
    burn_severity_text_reactive()
    
  )
  
  
  # render data source data table on About page with hyperlinks
  output$dataTable <- renderDataTable({
    
    data_df$Source <- sprintf(
      "<a href='%s' target='_blank' rel='noopener noreferrer'>%s</a>",
      data_df$link_address,
      data_df$Source
    )
    data_df_subset <- subset(data_df, select = -link_address)
    data_df_subset
    
    
  }, escape = FALSE, options = list(paging = FALSE, info = FALSE, searching = FALSE))
  
}
