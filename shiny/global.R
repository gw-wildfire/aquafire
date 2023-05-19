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

preloaded = FALSE

if(!preloaded){
  # NOTES - INSTEAD OF 13 FIELDS, ONLY USE 1
  
  print(getwd())
  # DELETE AFTER READING OVER ALL IMPORTANT DATA
  # source('code/crop.R', echo = T)
  
  # reading in data
  crs_ca <- st_crs(3310)
  # reading in ecoregions
  eco_regions <- read_sf("data/ca_eco_l3") %>% 
    janitor::clean_names()  %>% 
    st_transform(crs_ca) %>% 
    rename(region = us_l3name)
  
  # Load in ecoregions shapefile
  
  # ca_counties <- read_sf(here::here('data', 'CA_Counties')) %>%
  #   janitor::clean_names() %>%
  #   st_transform(crs_ca)
  
  # reading in tslf of california
  tslf_raster_masked <- raster("data/tslf_raster_masked.tif")
  
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
  

  # making a list of TSLF by ecoregion----
  print('loading TSLF data')
  path_tslf <- "data/tslf"
  
  tslf.files <- list.files(path_tslf, full.names = T)
  tslf.files2 <- list.files(path_tslf, full.names = F)
  tslf.files2 = gsub('.tif', '', tslf.files2)
  tslf_list <- list()
  
  length(tslf.files)
  
  for(i in 1:length(tslf.files)){
    print(i)
    file_i = tslf.files[i]
    file_i2 = tslf.files2[i]
    tslf_list[[file_i2]] = raster(file_i)
  }
  
  
  # raster fire count layer cropped by ecoregion----
  fire_count <- raster("data/fire_count.tif")
  fire_threat <- raster("data/fire_threat.tif")
  
  # reading in fire_count data by ecoregion----
  print('loading FIRE COUNT data')  
  
  path_fire <- "data/fire_count"
  fire.files <- list.files(path_fire, full.names = T)
  fire.files2 <- list.files(path_fire, full.names = F)
  fire.files2 = gsub('.tif', '', fire.files2)
  fire_count_list <- list()
  
  length(fire.files)
  
  for(i in 1:length(fire.files)){
    print(i)
    file_i = fire.files[i]
    file_i2 = fire.files2[i]
    fire_count_list[[file_i2]] = raster(file_i)
  }
  
  # reading in GDE data by ecoregion----
  print('loading GDE data')
  
  path_gde <- "data/gde_ecoregions"
  gde.files <- list.files(path_gde, full.names = T)
  gde.files2 <- list.files(path_gde, full.names = F)
  # fire.files2 = gsub('.tif', '', fire.files2)
  gde_list <- list()
  
  length(gde.files)
  
  for(i in 1:length(gde.files)){
    print(i)
    file_i = gde.files[i]
    file_i2 = gde.files2[i]
    gde_list[[file_i2]] = st_read(file_i)
  }
  
  simp <- st_simplify(gde_list[['gde_cascades']], dTolerance = 5) # cascades
  gde_4_simp <- tm_shape(simp) + tm_polygons()

  # tm <- tm_shape(tslf_list[['socal_norbaja_coast_crop']]) +
  #   tm_raster()
  # 
  # tm1 <- tm_shape(tslf_list[['sierra_nevada_crop']]) +
  #   tm_raster()

  
}

