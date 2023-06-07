#' Stratified Random Sampling for Raster Layers (GDE & non-GDE)
#'
#' @param input_raster_layer Raster layer we're analyzing 
#' @param gde_raster_layer Raster layer with GDE data 
#' @param n Number of samples, default 1000. 
#'
#' @return Returns a data frame containing sample points and values
#' @export
#'
#' @examples
stratified_sample <- function(input_raster_layer, gde_raster_layer, n = 1000){
  
  gde_sample <- sampleStratified(gde_raster_layer, size = n, sp = TRUE, buffer = 1000)
  
  raster_sample <- extract(input_raster_layer, gde_sample) 
  
  gde_sample$value <- raster_sample
  
  df <- as.data.frame(gde_sample) %>%
    mutate(gde = as.factor(layer)) %>%
    dplyr::select(cell, gde, value, x, y) 
  
  return(df)
}