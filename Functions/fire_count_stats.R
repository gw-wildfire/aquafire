fire_count_stats <- function(sample_dataframe, eco_region_code = "Input in function"){
  gde <- sample_dataframe %>%
    filter(gde == 1)
  non_gde <- sample_dataframe %>%
    filter(gde == 0)
  
  mean_all <- mean(sample_dataframe$value)
  mean_gde <- mean(gde$value)
  mean_non_gde <- mean(non_gde$value)
  
  max_all <- max(sample_dataframe$value)
  max_gde <- max(gde$value)
  max_non_gde <- max(non_gde$value)
  
  min_all <- min(sample_dataframe$value)
  min_gde <- min(gde$value)
  min_non_gde <- min(non_gde$value)
  
  # define a mode function - finds the NON-ZERO MODE IF THERE ARE NON-ZERO VALUES
  getmode <- function(v) {
    v_nonzero <- v[v != 0]
    if(length(v_nonzero) == 0){
      return(0)
    } else {
      uniqv <- unique(v_nonzero)
    uniqv[which.max(tabulate(match(v_nonzero, uniqv)))]}
  }
  

  
  mode_all <- getmode(sample_dataframe$value)
  mode_gde <- getmode(gde$value)
  mode_non_gde <- getmode(non_gde$value)

  stats <- data.frame(group = c("GDEs and Non-GDEs", "GDEs", "Non-GDEs"), 
                      mean = c(mean_all, mean_gde, mean_non_gde), 
                      maximum = c(max_all, max_gde, max_non_gde),
                      minimum = c(min_all, min_gde, min_non_gde), 
                      nonzero_mode = c(mode_all, mode_gde, mode_non_gde), 
                      ecoregion_code = c(eco_region_code, eco_region_code, eco_region_code))
  
  return(stats)
}








