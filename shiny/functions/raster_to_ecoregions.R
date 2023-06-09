#' Divide a raster layer into eco regions and write files (California only) 
#' 
#' @param raster_layer Formal Class RasterLayer. The layer that you'd like to divide into eco regions. CRS must be 
#' @param file_name Root file name to be used when naming exported raster layers. The eco region US level 3 code will be appended to the end of this file name. 
#' @param crs Default is 3310. Four number CRS code- should match the CRS of raster_layer input. 
#' @param write_to_file If set to TRUE, will write each eco region  as a file. If FALSE, will assign each eco region as an object. 
#'
#' @return 
#' @export 
#'
#' @examples
raster_to_ecoregions <- function(raster_layer, file_name, crs = 3310, write_to_file){

  crs <- st_crs(crs)
  
  # Load in ecoregions shapefile
  eco_regions <- read_sf(here::here('data', 'ca_eco_l3')) %>% 
    janitor::clean_names()  %>% 
    st_transform(crs) %>% 
    rename(region = us_l3name) %>% 
    mutate(us_l3code = as.numeric(us_l3code))
  
  # Convert eco regions shapefile to SpatialPolygonsDataFrame
  eco_regions_sp <- as_Spatial(eco_regions) %>%
    SpatialPolygonsDataFrame(., data.frame(ID=1:nrow(eco_regions)))
  
  # Crop raster to extent of shapefile
  raster_cropped <- crop(raster_layer, eco_regions)
  
  # Loop through each eco region and crop raster to that region
  for(i in 1:nrow(eco_regions)){
    # Subset shapefile to current eco region
    eco_region_subset <- eco_regions_sp[eco_regions_sp$ID == i,]
    
    # Crop raster to extent of eco region
    raster_region_crop <- crop(raster_cropped, eco_region_subset)
    
    raster_subset <- mask(raster_region_crop, eco_region_subset)
    
    if (write_to_file){
      # Write out raster to file
      writeRaster(raster_subset, filename = paste0("raster_output/", file_name, "_", eco_regions$us_l3code[i], ".tif"), format = "GTiff", overwrite = TRUE)
    } else {
      assign(paste0(file_name, "_", eco_regions$us_l3code[i]), raster_subset, envir = .GlobalEnv)
    }

   paste0("Completed writing file or object", i, "out of 13.")
  }
  
}
