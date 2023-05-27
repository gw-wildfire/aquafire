# load packages ----
library(shiny)
library(lterdatasampler)
library(tidyverse)
library(shinycssloaders)
library(leaflet)
library(raster)
library(rgdal)
library(leafem)
library(sf)
library(bslib)
library(shinyWidgets)
library(tmap)

datadir <- path.expand("~/../../capstone/aquafire")

preloaded = FALSE

if(!preloaded){
  
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
  
  # reading in fire threat data by ecoregion----
  print('loading fire threat data')
  
  path_fire_threat <- "data/fire_threat"
  fire_threat.files <- list.files(path_fire_threat, full.names = T)
  fire_threat.files2 <- list.files(path_fire_threat, full.names = F)
  fire_threat.files2 = gsub('.tif', '', fire_threat.files2)
  fire_threat_list <- list()
  
  length(fire_threat.files)
  
  for(i in 1:length(fire_threat.files)) {
    print(i)
    file_i = fire_threat.files[i]
    file_i2 = fire_threat.files2[i]
    fire_threat_list[[file_i2]] = raster(file_i)
    # fire_threat_list[[i]] <- aggregate(fire_count_list[[i]], fact = 10)
  }
  # MESSING WITH THIS!!!!!! ABOVE
  
  # reading in GDE data by ecoregion----
  print('loading GDE data')
  
  path_gde <- "data/gde_ecoregions"
  gde.files <- list.files(path_gde, full.names = T)
  gde.files2 <- list.files(path_gde, full.names = F)
  gde_list <- list()
  
  length(gde.files)
  
  for(i in 1:length(gde.files)){
    print(i)
    file_i = gde.files[i]
    file_i2 = gde.files2[i]
    gde_list[[file_i2]] = st_make_valid(st_read(file_i))
  }
  
  dec_place <- 2
  for (i in 1:length(gde_list)) {
    
    gde_shapefile <- gde_list[[i]]
    
    gde_shapefile <- gde_shapefile %>% rename(area_col = area)
    
    gde_shapefile$area_col <- round(gde_shapefile$area_col, dec_place)
    
    gde_list[[i]] <- gde_shapefile
    
  }
  
  # main page ecoregions
  
  # RENAMING
  
  names_gde <- names(gde_list)
  names(names_gde) = gsub('gde_', '', names_gde)
  names(names_gde) = gsub('_', ' ', names(names_gde))
  names(names_gde) = names(names_gde) %>% stringr::str_to_title()
  
  names_tslf <- names(tslf_list)
  names(names_tslf) = gsub('_tslf', '', names_tslf)
  names(names_tslf) = gsub('_', ' ', names(names_tslf))
  names(names_tslf) = names(names_tslf) %>% stringr::str_to_title()
  
  names_fire <- names(fire_count_list)
  names(names_fire) = gsub('_fire_count', '', names_fire)
  names(names_fire) = gsub('_', ' ', names(names_fire))
  names(names_fire) = names(names_fire) %>% stringr::str_to_title()
  
  names_fire_threat <- names(fire_threat_list)
  names(names_fire_threat) = gsub('_fire_threat', '', names_fire_threat)
  names(names_fire_threat) = gsub('_', '', names(names_fire_threat))
  names(names_fire_threat) = names(names_fire_threat) %>% stringr::str_to_title()
}

