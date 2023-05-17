# load packages ----
library(shiny)
library(lterdatasampler)
library(tidyverse)
library(shinyWidgets)
library(shinycssloaders)
library(leaflet)
library(raster)
library(rgdal)
library(leafem)
library(sf)
library(tmap)
library(bslib)

datadir <- path.expand("~/../../capstone/aquafire")

preloaded = TRUE

if(!preloaded){
  # NOTES - INSTEAD OF 13 FIELDS, ONLY USE 1
  
  source('shiny/code/crop.R', echo = T)
  
  eco_regions <- read_sf("../aquafire/data/ca_eco_l3") %>% 
    janitor::clean_names()  %>% 
    st_transform(crs_ca) %>% 
    rename(region = us_l3name)
  
  # data reading in
  
  tslf_raster_masked <- raster("shiny/www/tslf_raster_masked.tif")
  
  coast_range <- eco_regions[1,]
  central_basin <- eco_regions[2,]
  mojave_basin <- eco_regions[3,]
  cascades <- eco_regions[4,]
  sierra_nevada <- eco_regions[5,]
  central_foothills_coastal_mountains <- eco_regions[6,]
  central_valley <- eco_regions[7,]
  klamath_mountains <- eco_regions[8,]
  southern_mountains <- eco_regions[9,]
  northern_basin <- eco_regions[10,]
  sonoran_basin <- eco_regions[11,]
  socal_norbaja_coast <- eco_regions[12,]
  eastern_cascades_slopes_foothills <- eco_regions[13,]
  
  coast_range_crop <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/tslf/coast_range_crop.tif")
  central_basin_crop <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/tslf/central_basin_crop.tif")
  mojave_basin_crop <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/tslf/mojave_basin_crop.tif")
  cascades_crop <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/tslf/cascades_crop.tif")
  sierra_nevada_crop <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/tslf/sierra_nevada_crop.tif")
  central_foothills_coastal_mountains_crop <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/tslf/central_foothills_coastal_mountains_crop.tif")
  central_valley_crop <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/tslf/central_valley_crop.tif")
  klamath_mountains_crop <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/tslf/klamath_mountains_crop.tif")
  southern_mountains_crop <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/tslf/southern_mountains_crop.tif")
  northern_basin_crop <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/tslf/northern_basin_crop.tif")
  sonoran_basin_crop <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/tslf/sonoran_basin_crop.tif")
  socal_norbaja_coast_crop <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/tslf/socal_norbaja_coast_crop.tif")
  eastern_cascades_slopes_foothills_crop <- raster("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/tslf/eastern_cascades_slopes_foothills_crop.tif")
  
  tslf_list <- list()
  
  tslf_list[[1]] <- coast_range_crop
  tslf_list[[2]] <- central_basin_crop
  tslf_list[[3]] <- mojave_basin_crop
  tslf_list[[4]] <- cascades_crop
  tslf_list[[5]] <- sierra_nevada_crop
  tslf_list[[6]] <- central_foothills_coastal_mountains_crop
  tslf_list[[7]] <- central_valley_crop
  tslf_list[[8]] <- klamath_mountains_crop
  tslf_list[[9]] <- southern_mountains_crop
  tslf_list[[10]] <- northern_basin_crop
  tslf_list[[11]] <- sonoran_basin_crop
  tslf_list[[12]] <- socal_norbaja_coast_crop
  tslf_list[[13]] <- eastern_cascades_slopes_foothills_crop
  
  
  # raster fire count layer cropped by ecoregion
  fire_count <- raster("shiny/www/fire_count.tif")
  fire_threat <- raster("shiny/www/fire_threat.tif")
  
  coast_range_fire_count <- crop(fire_count, coast_range)
  central_basin_fire_count <- crop(fire_count, central_basin)
  mojave_basin_fire_count <- crop(fire_count, mojave_basin)
  cascades_fire_count <- crop(fire_count, cascades)
  sierra_nevada_fire_count <- crop(fire_count, sierra_nevada)
  central_foothills_coastal_mountains_fire_count <- crop(fire_count, central_foothills_coastal_mountains)
  central_valley_fire_count <- crop(fire_count, central_valley)
  klamath_mountains_fire_count <- crop(fire_count, klamath_mountains)
  southern_mountains_fire_count <- crop(fire_count, southern_mountains)
  northern_basin_fire_count <- crop(fire_count, northern_basin)
  sonoran_basin_fire_count <- crop(fire_count, sonoran_basin)
  socal_norbaja_coast_fire_count <- crop(fire_count, socal_norbaja_coast)
  eastern_cascades_slopes_foothills_fire_count <- crop(fire_count, eastern_cascades_slopes_foothills)
  
  
  tm <- tm_shape(socal_norbaja_coast_gdes) +
    tm_raster()
  
  tm1 <- tm_shape(southern_mountains_gdes) +
    tm_raster()
  
}

