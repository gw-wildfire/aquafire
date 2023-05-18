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
  
  # reading in data
  
  # reading in ecoregions
  eco_regions <- read_sf("../aquafire/data/ca_eco_l3") %>% 
    janitor::clean_names()  %>% 
    st_transform(crs_ca) %>% 
    rename(region = us_l3name)
  
  # reading in tslf of california
  tslf_raster_masked <- raster("shiny/data/tslf_raster_masked.tif")
  
  # subsetting by ecoregion
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
  
  # loading tslf by ecoregion
  coast_range_tslf <- raster("shiny/data/tslf/coast_range_crop.tif")
  central_basin_tslf <- raster("shiny/data/tslf/central_basin_crop.tif")
  mojave_basin_tslf <- raster("shiny/data/tslf/mojave_basin_crop.tif")
  cascades_tslf <- raster("shiny/data/tslf/cascades_crop.tif")
  sierra_nevada_tslf <- raster("shiny/data/tslf/sierra_nevada_crop.tif")
  central_foothills_coastal_mountains_tslf <- raster("shiny/data/tslf/central_foothills_coastal_mountains_crop.tif")
  central_valley_tslf <- raster("shiny/data/tslf/central_valley_crop.tif")
  klamath_mountains_tslf <- raster("shiny/data/tslf/klamath_mountains_crop.tif")
  southern_mountains_tslf <- raster("shiny/data/tslf/southern_mountains_crop.tif")
  northern_basin_tslf <- raster("shiny/data/tslf/northern_basin_crop.tif")
  sonoran_basin_tslf <- raster("shiny/data/tslf/sonoran_basin_crop.tif")
  socal_norbaja_coast_tslf <- raster("shiny/data/tslf/socal_norbaja_coast_crop.tif")
  eastern_cascades_slopes_foothills_ <- raster("shiny/data/tslf/eastern_cascades_slopes_foothills_crop.tif")
  
  # making a list of tslf by ecoregion
  tslf_list <- list()
  tslf_list[[1]] <- coast_range_tslf
  tslf_list[[2]] <- central_basin_tslf
  tslf_list[[3]] <- mojave_basin_tslf
  tslf_list[[4]] <- cascades_tslf
  tslf_list[[5]] <- sierra_nevada_tslf
  tslf_list[[6]] <- central_foothills_coastal_mountains_tslf
  tslf_list[[7]] <- central_valley_tslf
  tslf_list[[8]] <- klamath_mountains_tslf
  tslf_list[[9]] <- southern_mountains_tslf
  tslf_list[[10]] <- northern_basin_tslf
  tslf_list[[11]] <- sonoran_basin_tslf
  tslf_list[[12]] <- socal_norbaja_coast_tslf
  tslf_list[[13]] <- eastern_cascades_slopes_foothills_tslf
  
  
  # raster fire count layer cropped by ecoregion
  fire_count <- raster("shiny/data/fire_count.tif")
  fire_threat <- raster("shiny/data/fire_threat.tif")
  
  # reading in fire_count data by ecoregion
  coast_range_fire_count <- raster("shiny/data/fire_count/coast_range_fire_count.tif")
  central_basin_fire_count <- raster("shiny/data/fire_count/central_basin_fire_count.tif")
  mojave_basin_fire_count <- raster("shiny/data/fire_count/mojave_basin_fire_count.tif")
  cascades_fire_count <- raster("shiny/data/fire_count/cascades_fire_count.tif")
  sierra_nevada_fire_count <- raster("shiny/data/fire_count/sierra_nevada_fire_count.tif")
  central_foothills_coastal_mountains_fire_count <- raster("shiny/data/fire_count/central_foothills_coastal_mountains_fire_count.tif")
  central_valley_fire_count <- raster("shiny/data/fire_count/central_valley_fire_count.tif")
  klamath_mountains_fire_count <- raster("shiny/data/fire_count/klamath_mountains_fire_count.tif")
  southern_mountains_fire_count <- raster("shiny/data/fire_count/southern_mountains_fire_count.tif")
  northern_basin_fire_count <- raster("shiny/data/fire_count/northern_basin_fire_count.tif")
  sonoran_basin_fire_count <- raster("shiny/data/fire_count/sonoran_basin_fire_count.tif")
  socal_norbaja_coast_fire_count <- raster("shiny/data/fire_count/socal_norbaja_coast_fire_count.tif")
  eastern_cascades_slopes_foothills_fire_count <- raster("shiny/data/fire_count/eastern_cascades_slopes_foothills_fire_count.tif")
  
  # making list of fire_count by ecoregion
  fire_count_list <- list()
  fire_count_list[[1]] <- coast_range_fire_count
  fire_count_list[[2]] <- central_basin_fire_count
  fire_count_list[[3]] <- mojave_basin_fire_count
  fire_count_list[[4]] <- cascades_fire_count
  fire_count_list[[5]] <- sierra_nevada_fire_count
  fire_count_list[[6]] <- central_foothills_coastal_mountains_fire_count
  fire_count_list[[7]] <- central_valley_fire_count
  fire_count_list[[8]] <- klamath_mountains_fire_count
  fire_count_list[[9]] <- southern_mountains_fire_count
  fire_count_list[[10]] <- northern_basin_fire_count
  fire_count_list[[11]] <- sonoran_basin_fire_count
  fire_count_list[[12]] <- socal_norbaja_coast_fire_count
  fire_count_list[[13]] <- eastern_cascades_slopes_foothills_fire_count
  
  
  tm <- tm_shape(socal_norbaja_coast_gdes) +
    tm_raster()
  
  tm1 <- tm_shape(southern_mountains_gdes) +
    tm_raster()
  
  gde_polygon_4 <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_4/gde_polygon_4.shp")
  gde_polygon_4 <- st_make_valid(gde_polygon_4)
  simp <- st_simplify(gde_polygon_4, dTolerance = 5)
  gde_4 <- tm_shape(simp) + tm_polygons()
  
}

