#' Obtain Sample from Burn Severity Layers
#' This function will return n burn severity samples from within GDEs and n from outside GDEs. Use compareRaster() before running this function. 
#' @param input_raster_layer Burn severity raster layer
#' @param gde_raster_layer GDE raster layer
#' @param n Sample size - recommended value of 30 for burn severity due to limited data size. 
#'
#' @return Data frame with sample results. 
#' @export
#'
#' @examples
burn_sev_sampling <- function(input_raster_layer, gde_raster_layer, n = 30){
  
  gde_raster_layer <- mask(gde_raster_layer, input_raster_layer)
  
  gde_sample <- sampleStratified(gde_raster_layer, size = 1000, sp = TRUE, buffer = 1000)
  
  init_raster_sample <- extract(input_raster_layer, gde_sample) 
  
  gde_sample$value <- init_raster_sample
  
  df <- as.data.frame(gde_sample) %>%
    mutate(gde = as.factor(layer)) %>%
    dplyr::select(cell, gde, value, x, y) 
  
  
  burn_sev_gde_sample <- df %>%
    filter(gde == 1) %>%
    sample_n(n)
  
  burn_sev_nongde_sample <- df %>%
    filter(gde == 0) %>%
    sample_n(n)
  
  burn_severity_sample <- rbind(burn_sev_gde_sample, burn_sev_nongde_sample)
  
  
  return(burn_severity_sample)
}