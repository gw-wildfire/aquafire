fire_count_violin_plot <- function(sample_data, eco_region_code = 0) {
  
  # Eco region key for naming plot
  
  # Create the dataframe
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
  
  
  # Create violin plot
  ggplot(sample_data, aes(x = gde, y = value, fill = gde)) +
    geom_violin(trim = FALSE) +
    scale_fill_manual(values = c("#DDA15E", "#A3B18A")) +
    scale_x_discrete(labels = c('Non-GDE', 'GDE')) +
    xlab("") +
    ylab("Fire Count") +
    ggtitle(paste0(eco_region_name, ": Distribution of Fire Counts in Non-GDEs vs GDEs")) +
    theme_classic() +
    coord_flip() +
    theme(legend.position = 'none',
          plot.title = element_text(hjust = 0.5,
                                    size = 15),
          axis.text = element_text(size = 13,
                                   color = 'black'),
          axis.title = element_text(size = 15,
                                    color = 'black'),
          axis.title.x = element_text(vjust = -1.1),
          axis.text.x = element_text(vjust = -1.5))
  
}
