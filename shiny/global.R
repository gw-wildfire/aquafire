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
library(kableExtra)

datadir <- path.expand("~/../../capstone/aquafire")

# if(exists("preloaded")) {
#   preloaded = TRUE
# } else {
#   preloaded = FALSE
# }

preloaded = T

if(!preloaded){
  
  print(getwd())
  
  # reading in data
  crs_ca <- st_crs(3310)
  # reading in ecoregions
  eco_regions <- read_sf("data/ca_eco_l3") %>% 
    janitor::clean_names()  %>% 
    st_transform(crs_ca) %>% 
    rename(region = us_l3name)
  
  # setting bounding box of california for main_map
  cali_bounds <- st_bbox(eco_regions)
  
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
  
  # making ecoregion polygons into a list
  ecoregion_list <- list(coast_range = eco_regions[1,],
                         central_basin = eco_regions[2,],
                         mojave_basin = eco_regions[3,],
                         cascades = eco_regions[4,],
                         sierra_nevada = eco_regions[5,],
                         central_foothills_coastal_mountains = eco_regions[6,],
                         central_valley = eco_regions[7,],
                         klamath_mountains = eco_regions[8,],
                         southern_mountains = eco_regions[9,],
                         northern_basin = eco_regions[10,],
                         sonoran_basin = eco_regions[11,],
                         socal_norbaja_coast = eco_regions[12,],
                         eastern_cascades_slopes_foothills = eco_regions[13,])
  
  # loading GDE data----
  print('loading GDE data')
  
  # getting path file names for GDEs
  path_gde <- "data/gde_ecoregions"
  gde.files <- list.files(path_gde, full.names = T)
  gde.files2 <- list.files(path_gde, full.names = F)
  gde_list <- list()
  
  length(gde.files)
  
  # reading in GDE data
  for(i in 1:length(gde.files)){
    print(i)
    file_i = gde.files[i]
    file_i2 = gde.files2[i]
    gde_list[[file_i2]] = st_make_valid(st_read(file_i))
  }
  
  # editing GDE shapefiles
  dec_place <- 2
  for (i in 1:length(gde_list)) {
    gde_shapefile <- gde_list[[i]]
    gde_shapefile$area <- round((gde_shapefile$area), dec_place)
    
    # EDIT BELOW
    if(object.size(gde_shapefile) > 150000000) {
      gde_shapefile <- gde_shapefile %>% 
        filter(area > 18000) %>%  # larger than 2.2 acres
        st_simplify(dTolerance = 15)
    } else {
      gde_shapefile <- gde_shapefile %>% 
        filter(area > 1000) %>%  # larger than .22 acres
        st_simplify(dTolerance = 5)
    }
    # gde_shapefile <- gde_shapefile %>% 
    #   filter(area > 10000) %>%  # larger than 2.2 acres
    #   st_simplify(dTolerance = 5)
    # gde_shapefile <- st_simplify(gde_shapefile, dTolerance = 5)
    gde_list[[i]] <- st_make_valid(gde_shapefile)
  }
  
  # loading TSLF data----
  print('loading TSLF data')
  
  # getting path file names for TSLF
  path_tslf <- "data/tslf"
  tslf.files <- list.files(path_tslf, full.names = T)
  tslf.files2 <- list.files(path_tslf, full.names = F)
  tslf.files2 = gsub('.tif', '', tslf.files2)
  tslf_list <- list()
  
  length(tslf.files)
  # reading in TSLF data
  for(i in 1:length(tslf.files)){
    print(i)
    file_i = tslf.files[i]
    file_i2 = tslf.files2[i]
    tslf_list[[file_i2]] = raster(file_i)
  }
  
  
  # raster fire count layer cropped by ecoregion
  fire_count <- raster("data/fire_count.tif")
  fire_threat <- raster("data/fire_threat.tif")
  
  # loading FIRE COUNT data----
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
  
  # loading FIRE THREAT data----
  print('loading FIRE THREAT data')
  
  path_fire_threat <- "data/fire_threat"
  # path_fire_threat <- "data/fire_threat_aggregated"
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
  
  # loading BURN SEVERITY data----
  print('loading BURN SEVERITY data')
  
  burn_severity_file <- "data/burn_severity"
  burn_severity.files <- list.files(burn_severity_file, full.names = T)
  burn_severity.files2 <- list.files(burn_severity_file, full.names = F)
  burn_severity.files2 = gsub('.tif', '', burn_severity.files2)
  burn_severity_list <- list()
  
  length(burn_severity.files)
  
  for(i in 1:length(burn_severity.files)){
    print(i)
    file_i = burn_severity.files[i]
    file_i2 = burn_severity.files2[i]
    burn_severity_list[[file_i2]] = raster(file_i)
  }
  
  # loading STATS data
  print('loading STATS data')

  stats_file <- "www/plots"
  stats.files <- list.files(stats_file, full.names = T)
  stats.files2 <- list.files(stats_file, full.names = F)
  stats.files2 <- gsub('.png', '', stats.files2) # CHANGE format to whatever the format of the stats images are!!!!
  stats_list <- list()

  length(stats.files)

  for(i in 1:length(stats.files)) {
    if(startsWith(stats.files2[i], "burn_severity_histogram")) {
    print(i)
    file_i = stats.files[i]
    file_i2 = stats.files2[i]
    stats_list[[file_i2]] = image_read(file_i)}
  }
  
  
  
  # RENAMING----
  
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
  
  names_burn_severity <- names(burn_severity_list)
  names(names_burn_severity) = gsub('_burn_severity', '', names_burn_severity)
  names(names_burn_severity) = gsub('_', ' ', names(names_burn_severity))
  names(names_burn_severity) = names(names_burn_severity) %>% stringr::str_to_title()
  
  # names_stats <- names(stats_list)
  # names(names_stats) = gsub('_stats', '', names_stats)
  # names(names_stats) = gsub('_', ' ', names(names_stats))
  # names(names_stats) = names(names_stats) %>% stringr::str_to_title()
  
}

