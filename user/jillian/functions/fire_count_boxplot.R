fire_count_boxplot <- function(data, gde_col, count_col) {
  # Subset data to only include non-zero counts
  data <- data[data[[count_col]] != 0,]
  
  # Create boxplots
  library(ggplot2)
  p1 <- ggplot(data, aes(x = factor(1), y = data[[count_col]], fill = data[[gde_col]])) +
    geom_boxplot() +
    xlab("") +
    ylab("Fire Count") +
    ggtitle("Fire Counts in GDEs and Non-GDEs") +
    theme(plot.title = element_text(hjust = 0.5))
  
  p2 <- ggplot(data[data[[gde_col]] == "GDE",], aes(x = factor(1), y = data[[count_col]])) +
    geom_boxplot() +
    xlab("") +
    ylab("Fire Count") +
    ggtitle("Fire Counts in GDEs") +
    theme(plot.title = element_text(hjust = 0.5))
  
  p3 <- ggplot(data[data[[gde_col]] == "Non-GDE",], aes(x = factor(1), y = data[[count_col]])) +
    geom_boxplot() +
    xlab("") +
    ylab("Fire Count") +
    ggtitle("Fire Counts in Non-GDEs") +
    theme(plot.title = element_text(hjust = 0.5))
  
  # Combine boxplots into one figure
  library(cowplot)
  combined_plot <- plot_grid(p1, p2, p3, nrow = 1)
  return(combined_plot)
}
