fire_count_histogram <- function(sample_data, eco_region_code){
  
  # Create GDE dataframe for title
  df <- data.frame(
    code = c(0, 1, 13, 14, 4, 5, 6, 7, 78, 8, 80, 81, 85, 9),
    region = c(
      "",
      "Coast Range",
      "Central Basin and Range",
      "Mojave Basin and Range",
      "Cascades",
      "Sierra Nevada",
      "Central California Foothills and Coastal Mountains",
      "Central California Valley",
      "Klamath Mountains/California High North Coast Range",
      "Southern California Mountains",
      "Northern Basin and Range",
      "Sonoran Basin and Range",
      "Southern California/Northern Baja Coast",
      "Eastern Cascades Slopes and Foothills"
    ),
    stringsAsFactors = FALSE
  )
  
  eco_region_name <- df$region[df$code == eco_region_code]
  
  plot_title = paste0(eco_region_name, ": Relative Frequency of Fire Counts in GDEs and Non-GDEs")
  
  fire_count_gdes <- sample_data %>%
    filter(gde == 1) %>%
    group_by(value) %>%
    summarize(proportion_1 = n() / nrow(.) * 100)
  
  fire_count_nongdes <- sample_data %>%
    filter(gde == 0) %>%
    group_by(value) %>%
    summarize(proportion_0 = n() / nrow(.) * 100)
  
  fire_count_histogram <- inner_join(fire_count_gdes, fire_count_nongdes, by = "value") %>%
    rename("GDE" = "proportion_1", 
           "NonGDE" = "proportion_0") %>% 
    pivot_longer(cols = c(2,3),
                 names_to = "gde_status",
                 values_to = "proportion"
    ) %>%
    mutate(eco_region = eco_region_name)
  
  return(fire_count_histogram)
  
  # ggplot(fire_count_histogram, aes(x = value, y = proportion, fill = gde_status)) + 
  #   geom_bar(stat = "identity", position = "dodge") +
  #   scale_fill_manual(values = c("#A3B18A", "#DDA15E")) +
  #   labs(x = "Fire Count", 
  #        y = "Relative Frequency (%)",
  #        fill = "GDE Status",
  #        title = plot_title) + 
  #   theme_classic() + 
  #   theme(legend.position = 'none',
  #         plot.title = element_text(hjust = 0.5,
  #                                   size = 15),
  #         axis.text = element_text(size = 13,
  #                                  color = 'black'),
  #         axis.title = element_text(size = 15,
  #                                   color = 'black'),
  #         axis.title.x = element_text(vjust = -1.1),
  #         axis.text.x = element_text(vjust = -1.5)) + 
  #   scale_y_continuous(expand = c(0,0)) + scale_x_continuous(expand = c(0,0))
}