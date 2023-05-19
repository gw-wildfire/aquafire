
## Load Libraries
library(tidyverse)
library(sf)
library(here)
library(janitor)
library(raster)
library(rgdal)
library(fasterize)

# set working directory
#setwd(here('~/Desktop/MEDS/Capstone/aquafire'))

# loading in tslf raster layer
tslf_raster_masked <- raster("data/tslf_raster_masked.tif")

#source("user/jillian/functions/raster_to_ecoregions.R")

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


## LOOPRASTER ----
# path_raster <- "/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/data/tslf"

# crop.files <- list.files(path_raster, full.names = T)
# crop.files2 <- list.files(path_raster, full.names = F)
# tslf_list <- list()
# 
# length(crop.files)
# 
# for(i in 1:length(crop.files)){
#   print(i)
#   file_i = crop.files[i]
#   file_i2 = crop.files2[i]
#   tslf_list[[file_i2]] = raster(file_i)
# }


# ANnother bookmark ----

# WORKING WITH GDE DATA----
#gde_polygon_8 <- st_make_valid(gde_polygon_8)





# gde_coast_range <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_coast_range/gde_polygon_1.shp")
# gde_central_basin <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_central_basin/gde_polygon_13.shp")
# gde_mojave_basin <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_mojave_basin/gde_polygon_14.shp")
# gde_cascades <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_cascades/gde_polygon_4.shp")
# gde_sierra_nevada <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_sierra_nevada/gde_polygon_5.shp")
# gde_central_foothills_coastal_mountains <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_central_foothills_coastal_mountains/gde_polygon_6.shp")
# gde_central_valley <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_central_valley/gde_polygon_7.shp")
# gde_klamath_mountains <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_klamath_mountains/gde_polygon_78.shp")
# gde_southern_mountains <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_southern_mountains/gde_polygon_8.shp")
# gde_northern_basin <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_northern_basin/gde_polygon_80.shp")
# gde_sonoran_basin <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_sonoran_basin/gde_polygon_81.shp")
# gde_socal_norbaja_coast <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_socal_norbaja_coast/gde_polygon_85.shp")
# gde_eastern_cascades_slopes_foothills <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_eastern_cascades_slopes_foothills/gde_polygon_9.shp")


# this gde 

#gde_8 <- tm_shape(gde_polygon_8) + tm_polygons()


# NOTES:----
# # reading in largest gde polygon - central_foothills_coastal_mountains at 316MB
# largest_gde <- gde_central_foothills_coastal_mountains %>% 
#   filter(area > 10000) # more than 2.2~ acres - still 34k obs! too big! MAX 10k?

# if filter GDEs less than 1 acre, what will be missing? will still be included in the ecoregion analysis





