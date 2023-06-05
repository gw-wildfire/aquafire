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
library(jpeg)

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
  
  # reading in counties data
  
  ca_counties <- read_sf("data/CA_Counties") %>%
    janitor::clean_names() %>%
    st_transform(crs_ca)
  
  # creating california polygon
  california_polygon <- st_union(ca_counties)
  
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
  
  # land cover data frame
  land_cover_df <- data.frame(
    nlcd = c(11, 12, 21, 22, 23, 24, 31, 41, 42, 43, 51, 52, 71, 72, 73, 74, 81, 82, 90, 95),
    land_cover_type = c(
      "Open Water",
      "Perennial Ice/Snow",
      "Developed, Open Space",
      "Developed, Low Intensity",
      "Developed, Medium Intensity",
      "Developed High Intensity",
      "Barren Land (Rock/Sand/Clay)",
      "Deciduous Forest",
      "Evergreen Forest",
      "Mixed Forest",
      "Dwarf Scrub",
      "Shrub/Scrub",
      "Grassland/Herbaceous",
      "Sedge/Herbaceous",
      "Lichens",
      "Moss",
      "Pasture/Hay",
      "Cultivated Crops",
      "Woody Wetlands",
      "Emergent Herbaceous Wetlands"
    )
  )
  
  
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
    gde_shapefile$are_km2 <- round((gde_shapefile$are_km2), dec_place)
    gde_shapefile$mx_fr_c <- round((gde_shapefile$mx_fr_c), dec_place)
    gde_shapefile$avg_fr_t <- round((gde_shapefile$avg_fr_t), dec_place)
    gde_shapefile$avg_fr_s <- round((gde_shapefile$avg_fr_s), dec_place)
    
    gde_shapefile$are_km2 <- format(gde_shapefile$are_km2, nsmall = dec_place)
    gde_shapefile$mx_fr_c <- format(gde_shapefile$mx_fr_c, nsmall = 0)
    gde_shapefile$avg_fr_t <- format(gde_shapefile$avg_fr_t, nsmall = dec_place)
    gde_shapefile$avg_fr_s <- format(gde_shapefile$avg_fr_s, nsmall = dec_place)
    
    
    # data wrangling - including land cover data, removing irrelevant columns
    gde_shapefile <- gde_shapefile %>% 
      merge(land_cover_df, by = 'nlcd') %>% 
      dplyr::select(!c('nlcd', 'ORIGINA', 'SOURCE_', 'MODIFIE', 'us_l3cd', 'na_l3cd', 'na_l3nm', 'na_l2nm', 'na_l1cd', 'l3_key', 'l2_key', 'l1_key'))
    
    # 2 IF STATEMENT
    # if(object.size(gde_shapefile) > 80000000) {
    #   gde_shapefile <- gde_shapefile %>%
    #     filter(area > 18000) %>%  # larger than 2.2 acres
    #     st_simplify(dTolerance = 15)
    # } else {
    #   gde_shapefile <- gde_shapefile %>%
    #     filter(area > 10000) %>%  # larger than .22 acres
    #     st_simplify(dTolerance = 5)
    # }
    
    # 3 IF STATEMENT
    if(object.size(gde_shapefile) > 120000000) {
      gde_shapefile <- gde_shapefile %>%
        filter(area > 25000) %>%  # larger than 2.2 acres
        st_simplify(dTolerance = 20)
    } else if(object.size(gde_shapefile) <= 120000000 & object.size(gde_shapefile) > 50000000) {
      gde_shapefile <- gde_shapefile %>%
        filter(area > 15000) %>%  # larger than .22 acres
        st_simplify(dTolerance = 10)
    } else {
      gde_shapefile <- gde_shapefile %>%
        filter(area > 10000) %>%  # larger than .22 acres
        st_simplify(dTolerance = 5)
    }
    
    
    # gde_shapefile <- gde_shapefile %>%
    #   filter(area > 10000) %>%  # larger than 2.2 acres
    #   st_simplify(dTolerance = 5)
    # gde_shapefile <- st_simplify(gde_shapefile, dTolerance = 5)
    
    
    gde_list[[i]] <- st_make_valid(gde_shapefile)
  } # End edit GDE polygons
  
  # loading 4 RASTER FIRE METRIC data----
  
  
  # loading TSLF data----
  # 3, 4 and 10 are above 15 MB
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
    
    # Get the file name of the raster layer
    file_name <- tslf_list[[i]]@file@name
    
    # Get the file size information
    file_info <- file.info(file_name)
    
    # Extract the file size in bytes
    file_size <- file_info$size
    file_size_mb <- file_size / 1048576
    if(file_size_mb > 15) {
      tslf_list[[i]] <- aggregate(tslf_list[[i]], fact = 4)
    }
  }
  
  for (i in 1:length(tslf_list)) {
    # Get the file name of the raster layer
    file_name <- tslf_list[[i]]@file@name
    
    # Get the file size information
    file_info <- file.info(file_name)
    
    # Extract the file size in bytes
    file_size <- file_info$size
    
    file_size_mb <- file_size / 1048576
    
    # Print the file size
    cat("Layer", file_name, i, "file size:", file_size_mb, "megabytes\n")
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
    # fire_count_list[[i]] <- aggregate(fire_count_list[[i]], fact = 5)
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
    # fire_threat_list[[i]] <- aggregate(fire_threat_list[[i]], fact = 5)
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
  
  
  # RENAMING----
  
  names_gde <- names(gde_list)
  names(names_gde) = gsub('gde_', '', names_gde)
  names(names_gde) = gsub('_', ' ', names(names_gde))
  names(names_gde) = names(names_gde) %>% stringr::str_to_title()
  names(names_gde)[names(names_gde) == "Socal Norbaja Coast"] <- "Southern California/Northern Baja Coast"
  
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
  
  
  fire_count_hist_list <- c(
    "fire_count_histogram_cascades",
    "fire_count_histogram_central_basin",
    "fire_count_histogram_central_foothills_coastal_mountains",
    "fire_count_histogram_central_valley",
    "fire_count_histogram_coast_range",
    "fire_count_histogram_eastern_cascades_slopes_foothills",
    "fire_count_histogram_klamath_mountains",
    "fire_count_histogram_mojave_basin",
    "fire_count_histogram_northern_basin",
    "fire_count_histogram_sierra_nevada"
  )
  
  names_fire_count_hist <- fire_count_hist_list
  names(names_fire_count_hist) = gsub('fire_count_histogram', '', names_fire_count_hist)
  names(names_fire_count_hist) = gsub('_', ' ', names(names_fire_count_hist))
  names(names_fire_count_hist) = names(names_fire_count_hist) %>% stringr::str_to_title()
  
  
  
  
  
  # creating data table on main page
  data_df <- data.frame(Data = c("Groundwater-Dependent Ecosystems", "Fire Count", "Time Since Last Fire (TSLF)", "Fire Threat", "Burn Severity"),
                        Source = c("The Nature Conservancy", "Cal Fire (layer produced by us)", "Cal Fire (layer produced by us)", "Cal Fire", "USGS and USFS"),
                        Information = c("Groundwater-Dependent Ecosystems are from The Nature Conservancy",
                                        "This layer was created from the fire perimeter data from Cal Fire, and is a raster layer where each cell is the total number of fires that occured since 1950.",
                                        "This layer was created from the fire perimeter data from Cal Fire, and is a raster layer where each cell is the time in years since the last fire occured since 1950.",
                                        "Fire Threat is a layer created by Cal Fire that represents the relative vulnerability of an area to wildfires. Some variables that are used in this modeled fire layer are fire occurance, vegetation type and density, topography and weather conditions.",
                                        "The Burn Severity layer was adapted to apply the mode of the severity (most frequent severity level) of all previous fires in a single cell. The originial layers were derived from satellite data, which uses the difference Normalized Burn Ratio to calculate the severity of each fire. (NIR - SWIR) / (NIR + SWIR)."),
                        link_address = c(
                          "https://www.nature.org/",
                          "https://gis.data.ca.gov/datasets/CALFIRE-Forestry::california-fire-perimeters-all-1/explore",
                          "https://gis.data.ca.gov/datasets/CALFIRE-Forestry::california-fire-perimeters-all-1/explore",
                          "https://www.fire.ca.gov/Home/What-We-Do/Fire-Resource-Assessment-Program/GIS-Mapping-and-Data-Analytics",
                          "https://www.mtbs.gov/")
  )
  
  
  
  # read in fire count txt file for histograms
  fire_count_hist_df_messy <- read.table("data/fire_count_shiny_histogram_df.txt", sep = ",", header = TRUE)
  burn_severity_hist_df_messy <- read.table("data/burnsev_shiny_histogram_df.txt", sep = ",", header = TRUE)
  
  fire_count_hist_df_messy$gde_status[fire_count_hist_df_messy$gde_status == 'NonGDE'] <- '0'
  fire_count_hist_df_messy$gde_status[fire_count_hist_df_messy$gde_status == 'GDE'] <- '1'
  
  burn_severity_hist_df_messy$gde_status[burn_severity_hist_df_messy$gde_status == 'NonGDE'] <- '0'
  burn_severity_hist_df_messy$gde_status[burn_severity_hist_df_messy$gde_status == 'GDE'] <- '1'
  
  
  fire_count_histogram_df <- fire_count_hist_df_messy %>% 
    rename(ecoregion_name = eco_region) %>% 
    mutate(ecoregion = paste0("fire_count_histogram_", gsub(" ", "_", tolower(ecoregion_name)))) %>% 
    mutate(ecoregion = ifelse(ecoregion == "fire_count_histogram_central_basin_and_range",
                              "fire_count_histogram_central_basin", ecoregion),
           ecoregion = ifelse(ecoregion == "fire_count_histogram_central_california_foothills_and_coastal_mountains",
                              "fire_count_histogram_central_foothills_coastal_mountains", ecoregion),
           ecoregion = ifelse(ecoregion == "fire_count_histogram_central_california_valley",
                              "fire_count_histogram_central_valley", ecoregion),
           ecoregion = ifelse(ecoregion == "fire_count_histogram_klamath_mountains/california_high_north_coast_range",
                              "fire_count_histogram_klamath_mountains", ecoregion),
           ecoregion = ifelse(ecoregion == "fire_count_histogram_southern_california_mountains",
                              "fire_count_histogram_southern_mountains", ecoregion),
           ecoregion = ifelse(ecoregion == "fire_count_histogram_northern_basin_and_range",
                              "fire_count_histogram_northern_basin", ecoregion),
           ecoregion = ifelse(ecoregion == "fire_count_histogram_southern_california/northern_baja_coast",
                              "fire_count_histogram_nocal_sobaja_coast", ecoregion),
           ecoregion = ifelse(ecoregion == "fire_count_histogram_eastern_cascades_slopes_and_foothills",
                              "fire_count_histogram_eastern_cascades_slopes_foothills", ecoregion),
           ecoregion = ifelse(ecoregion == "fire_count_histogram_mojave_basin_and_range",
                              "fire_count_histogram_mojave_basin", ecoregion),
           ecoregion = ifelse(ecoregion == "fire_count_histogram_sonoran_basin_and_range",
                              "fire_count_histogram_sonoran_basin", ecoregion))
  
  
  
  # DID NOT LOAD mojave, central basin and central valley - not enough data
  
  burn_severity_histogram_df <- burn_severity_hist_df_messy %>% 
    rename(ecoregion_name = eco_region) %>% 
    mutate(ecoregion = paste0("burn_severity_histogram_", gsub(" ", "_", tolower(ecoregion_name)))) %>% 
    mutate(ecoregion = ifelse(ecoregion == "burn_severity_histogram_central_basin_and_range",
                              "fire_count_histogram_central_basin", ecoregion),
           ecoregion = ifelse(ecoregion == "burn_severity_histogram_central_california_foothills_and_coastal_mountains",
                              "fire_count_histogram_central_foothills_coastal_mountains", ecoregion), # EDITING THISSSSS
           ecoregion = ifelse(ecoregion == "burn_severity_histogram_central_california_valley",
                              "fire_count_histogram_central_valley", ecoregion),
           ecoregion = ifelse(ecoregion == "burn_severity_histogram_klamath_mountains/california_high_north_coast_range",
                              "fire_count_histogram_klamath_mountains", ecoregion),
           ecoregion = ifelse(ecoregion == "burn_severity_histogram_southern_california_mountains",
                              "fire_count_histogram_southern_mountains", ecoregion),
           ecoregion = ifelse(ecoregion == "burn_severity_histogram_northern_basin_and_range",
                              "fire_count_histogram_northern_basin", ecoregion),
           ecoregion = ifelse(ecoregion == "burn_severity_histogram_southern_california/northern_baja_coast",
                              "fire_count_histogram_nocal_sobaja_coast", ecoregion),
           ecoregion = ifelse(ecoregion == "burn_severity_histogram_eastern_cascades_slopes_and_foothills",
                              "fire_count_histogram_eastern_cascades_slopes_foothills", ecoregion),
           ecoregion = ifelse(ecoregion == "burn_severity_histogram_coast_range",
                              "fire_count_histogram_coast_range", ecoregion),
           ecoregion = ifelse(ecoregion == "burn_severity_histogram_cascades",
                              "fire_count_histogram_cascades", ecoregion),
           ecoregion = ifelse(ecoregion == "burn_severity_histogram_sierra_nevada",
                              "fire_count_histogram_sierra_nevada", ecoregion),
           ecoregion = ifelse(ecoregion == "burn_severity_histogram_sonoran_basin_and_range",
                              "fire_count_histogram_sonoran_basin", ecoregion)
    )
  
  # central basin, central valley, coast range, klamath, mojave
  
}

