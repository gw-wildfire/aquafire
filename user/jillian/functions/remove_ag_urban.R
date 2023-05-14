
#' Remove NLCD Agricultural, Urban, Open Water Areas from Raster Layers 
#'
#' @param input_raster_layer Formal class RasterLayer. The raster that you'd like to remove Ag and Urban areas from
#' @param nlcd_raster_layer  Formal class RasterLayer. Default is nlcd_rasterlayer (my object name) The NLCD raster can be obtained using the FedData package. Be sure that your final NLCD layer has the same extent and CRS as the input raster layer, check using the compareRaster() function.  
#'
#' @return Returns the input layer, with the areas that were Open water / Ag / Urban set to NA. 
#' @export
#'
#' @examples
remove_ag_urban <- function(input_raster_layer, nlcd_raster_layer = nlcd_rasterlayer){
  # Removes: 
  # 11 Open Water
  # 21 - 24 Developed to varying degrees 
  # 81 Pasture / Hay
  # 82 Cultivated Crops
  nlcd_vals_to_remove <- c(11, 21, 22, 23, 24, 81, 82) 
  
  nlcd_raster_layer[nlcd_raster_layer %in% nlcd_vals_to_remove] <- NA
  
  input_raster_layer[is.na(nlcd_raster_layer)] <- NA
  
  return(input_raster_layer)
}