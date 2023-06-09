# load packages ----
library(shiny)
library(tidyverse)
library(shinycssloaders)
library(raster)
library(sf)
library(shinyWidgets)
library(tmap)
library(rgdal)


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
    
    # 3 IF statements for loading the larger files faster
    if(object.size(gde_shapefile) > 120000000) {
      gde_shapefile <- gde_shapefile %>%
        filter(area > 25000) %>%  # larger than 2.2 acres
        st_simplify(dTolerance = 40)
    } else if(object.size(gde_shapefile) <= 120000000 & object.size(gde_shapefile) > 50000000) {
      gde_shapefile <- gde_shapefile %>%
        filter(area > 15000) %>%  # larger than .22 acres
        st_simplify(dTolerance = 20)
    } else {
      gde_shapefile <- gde_shapefile %>%
        filter(area > 10000) %>%  # larger than .22 acres
        st_simplify(dTolerance = 5)
    }
    
    print(i)
    
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
    
    # making largest 3 rasters a smaller resolution
    # if(file_size_mb > 15) {
    #   tslf_list[[i]] <- aggregate(tslf_list[[i]], fact = 4)
    # }
  }
  
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
    # Get the file name of the raster layer
    file_name <- fire_count_list[[i]]@file@name
    
    # Get the file size information
    file_info <- file.info(file_name)
    
    # Extract the file size in bytes
    file_size <- file_info$size
    file_size_mb <- file_size / 1048576
    # if(file_size_mb > 15) {
    # fire_count_list[[i]] <- aggregate(fire_count_list[[i]], fact = 4)
    # }
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
    
    # Get the file name of the raster layer
    file_name <- fire_threat_list[[i]]@file@name
    
    # Get the file size information
    file_info <- file.info(file_name)
    
    # Extract the file size in bytes
    file_size <- file_info$size
    file_size_mb <- file_size / 1048576
    # if(file_size_mb > 15) {
    # fire_threat_list[[i]] <- aggregate(fire_threat_list[[i]], fact = 4)
    # }
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
    
    # Get the file name of the raster layer
    file_name <- burn_severity_list[[i]]@file@name
    
    # Get the file size information
    file_info <- file.info(file_name)
    
    # Extract the file size in bytes
    file_size <- file_info$size
    file_size_mb <- file_size / 1048576
    # if(file_size_mb > 15) {
    # burn_severity_list[[i]] <- aggregate(burn_severity_list[[i]], fact = 4)
    # }
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
  
  # naming fire count histogram list
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
    "fire_count_histogram_sierra_nevada",
    "fire_count_histogram_socal_norbaja_coast",
    "fire_count_histogram_sonoran_basin",
    "fire_count_histogram_southern_mountains"
  )
  
  # renaming fire count histograms
  names_fire_count_hist <- fire_count_hist_list
  names(names_fire_count_hist) = gsub('fire_count_histogram', '', names_fire_count_hist)
  names(names_fire_count_hist) = gsub('_', ' ', names(names_fire_count_hist))
  names(names_fire_count_hist) = names(names_fire_count_hist) %>% stringr::str_to_title()
  
  # creating data table on main page
  data_df <- data.frame(Data = c("Groundwater-Dependent Ecosystems", "Fire Count", "Time Since Last Fire (TSLF)", "Fire Threat", "Burn Severity"),
                        Source = c("The Nature Conservancy (TNC)", "Cal Fire (layer produced by us)", "Cal Fire (layer produced by us)", "Cal Fire", "USGS and USFS"),
                        Information = c("Groundwater-dependent Ecosystem data comes from the Natural Communities Commonly Associated with Groundwater v.2 dataset produced by The Nature Conservancy (TNC). It is a compilation of 48 publicly available State and federal agency datasets that map vegetation, wetlands, springs, and seeps in California. A working group comprised of DWR, the California Department of Fish and Wildlife (CDFW), and The Nature Conservancy (TNC) reviewed the compiled dataset and conducted a screening process to exclude vegetation and wetland types less likely to be associated with groundwater and retain types commonly associated with groundwater, based on criteria described in Klausmeyer et al., 2018.",
                                        "This layer was created from the CAL FIRE Wildfire Perimeters and Prescribed Burns. The service includes layers that are data subsets symbolized by size and year.
It contains raster layers where each cell is the total number of fires that occured since 1950.",
"This layer was created from the CAL FIRE Wildfire Perimeters and Prescribed Burns. The service includes layers that are data subsets symbolized by size and year.
It contains raster layers where each cell is the total number of fires that occured since 1950.",
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

  # change values from GDE/NonGDE to 1/0
  fire_count_hist_df_messy$gde_status[fire_count_hist_df_messy$gde_status == 'NonGDE'] <- '0'
  fire_count_hist_df_messy$gde_status[fire_count_hist_df_messy$gde_status == 'GDE'] <- '1'
  burn_severity_hist_df_messy$gde_status[burn_severity_hist_df_messy$gde_status == 'NonGDE'] <- '0'
  burn_severity_hist_df_messy$gde_status[burn_severity_hist_df_messy$gde_status == 'GDE'] <- '1'

  # renaming fire count for histogram
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
                              "fire_count_histogram_socal_norbaja_coast", ecoregion),
           ecoregion = ifelse(ecoregion == "fire_count_histogram_eastern_cascades_slopes_and_foothills",
                              "fire_count_histogram_eastern_cascades_slopes_foothills", ecoregion),
           ecoregion = ifelse(ecoregion == "fire_count_histogram_mojave_basin_and_range",
                              "fire_count_histogram_mojave_basin", ecoregion),
           ecoregion = ifelse(ecoregion == "fire_count_histogram_sonoran_basin_and_range",
                              "fire_count_histogram_sonoran_basin", ecoregion))

  # renaming burn severity to display with fire count
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
                              "fire_count_histogram_socal_norbaja_coast", ecoregion),
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
  
  # column names for info about histograms
  column_names <- c(
    "fire_count_histogram_cascades",
    "fire_count_histogram_central_basin",
    "fire_count_histogram_central_foothills_coastal_mountains",
    "fire_count_histogram_central_valley",
    "fire_count_histogram_coast_range",
    "fire_count_histogram_eastern_cascades_slopes_foothills",
    "fire_count_histogram_klamath_mountains",
    "fire_count_histogram_mojave_basin",
    "fire_count_histogram_northern_basin",
    "fire_count_histogram_sierra_nevada",
    "fire_count_histogram_socal_norbaja_coast",
    "fire_count_histogram_sonoran_basin",
    "fire_count_histogram_southern_mountains"
  )
  
  # text for info about fire count histogram
  values_fire <- c("The mean fire count for our sample of cells across the entire ecoregion was found to be 0.307. When analyzing GDE cells specifically, the mean fire count was slightly lower at 0.292, while non-GDE cells had a slightly higher mean fire count of 0.321.
Investigating the maximum number of fires in a single cell, it was observed that both GDE and non-GDE cells experienced a maximum count of 3 fires. When excluding cells that did not burn, the mode (most common) fire count for both GDE and non-GDE cells was 1, indicating that most cells that did experience fires did so only once.
To assess if there was a significant difference in mean fire counts between GDE and non-GDE cells, a difference in means bootstrapping approach was utilized. This involved resampling the data 1000 times and calculating the difference in means (non-GDE mean fire count minus GDE mean fire count) for each sample. The resulting p-value for this difference in means test was 0.204, and the 95% confidence interval for the difference in means ranged from -0.017 to 0.074.
Based on these statistical findings, the study concluded that there is insufficient evidence to reject the null hypothesis, suggesting no significant difference in mean fire counts between GDE and non-GDE cells in the Cascades Ecoregion of California.",

"The mean fire count for our sample of cells across the entire ecoregion was found to be 0.097. When examining GDE cells specifically, the mean fire count was 0.041, while non-GDE cells had a higher mean fire count of 0.134.
Analyzing the maximum number of fires in a single cell, it was observed that both GDE and non-GDE cells had a maximum count of 3 fires. When excluding cells that did not burn, the mode (most common) fire count for both GDE and non-GDE cells was 1, indicating that most cells that experienced fires did so only once.
To assess if there was a significant difference in mean fire counts between GDE and non-GDE cells, a difference in means bootstrapping approach was employed. This involved resampling the data 1000 times and calculating the difference in means (non-GDE mean fire count minus GDE mean fire count) for each sample. The resulting p-value for this difference in means test was remarkably low, at 1 x 10^(-16), and the 95% confidence interval for the difference in means ranged from 0.060 to 0.125.",
"The mean fire count for our sample of cells across the entire ecoregion was found to be 0.447. When examining GDE cells specifically, the mean fire count was 0.409, while non-GDE cells had a slightly higher mean fire count of 0.463.

Analyzing the maximum number of fires in a single cell, it was observed that GDE cells experienced a maximum count of 4 fires, whereas non-GDE cells had a higher maximum of 9 fires. When excluding cells that did not burn, the mode (most common) fire count for both GDE and non-GDE cells was 1, indicating that most cells that experienced fires did so only once.
To assess if there was a significant difference in mean fire counts between GDE and non-GDE cells, a difference in means bootstrapping approach was employed. This involved resampling the data 1000 times and calculating the difference in means (non-GDE mean fire count minus GDE mean fire count) for each sample. The resulting p-value for this difference in means test was 0.242, and the 95% confidence interval for the difference in means ranged from -0.03 to 0.143.
Based on these statistical findings, the study concluded that there is insufficient evidence to reject the null hypothesis, suggesting no significant difference in mean fire counts between GDE and non-GDE cells in the Central California Foothills and Coastal Mountains ecoregion.",
"The mean fire count for our sample of cells across the entire ecoregion was found to be 0.041. When examining GDE cells specifically, the mean fire count was 0.027, while non-GDE cells had a slightly higher mean fire count of 0.047.

Analyzing the maximum number of fires in a single cell, it was observed that GDE cells experienced a maximum count of 2 fires, whereas non-GDE cells had a higher maximum of 4 fires. When excluding cells that did not burn, the mode (most common) fire count for both GDE and non-GDE cells was 1, indicating that most cells that experienced fires did so only once.
To assess if there was a significant difference in mean fire counts between GDE and non-GDE cells, a difference in means bootstrapping approach was employed. This involved resampling the data 1000 times and calculating the difference in means (non-GDE mean fire count minus GDE mean fire count) for each sample. The resulting p-value for this difference in means test was 0.091, and the 95% confidence interval for the difference in means ranged from -0.004 to 0.043.
Based on these statistical findings, the study concluded that there is insufficient evidence to reject the null hypothesis, suggesting no significant difference in mean fire counts between GDE and non-GDE cells in the Central California Valley ecoregion.",
"The mean fire count for our sample of cells across the entire ecoregion was found to be 0.117. However, when considering GDE cells specifically, the mean fire count was slightly lower at 0.109, while non-GDE cells had a slightly higher mean fire count of 0.124.

Examining the maximum number of fires in a single cell, it was observed that the highest count of fires (3) occurred in a non-GDE cell, while GDE cells experienced a maximum of 2 fires. When excluding cells that did not burn, the mode (most common) fire count for both GDE and non-GDE cells was 1, indicating that most cells that did experience fires did so only once.
To determine if there was a significant difference in mean fire counts between GDE and non-GDE cells, a difference in means bootstrapping approach was employed. This involved resampling the data 1000 times and calculating the difference in means (non-GDE mean fire count minus GDE mean fire count) for each sample. The resulting p-value for this difference in means test was 0.341, and the 95% confidence interval for the difference in means ranged from -0.02 to 0.05.
Based on these statistical findings, the study concluded that there is insufficient evidence to reject the null hypothesis, which suggests no significant difference in mean fire counts between GDE and non-GDE cells in the Coast Range Ecoregion.",
"The mean fire count for our sample of cells across the entire ecoregion was found to be 0.174. When examining GDE cells specifically, the mean fire count was 0.081, while non-GDE cells had a higher mean fire count of 0.266.

Analyzing the maximum number of fires in a single cell, it was observed that GDE cells experienced a maximum count of 2 fires, whereas non-GDE cells had a higher maximum of 4 fires. When excluding cells that did not burn, the mode (most common) fire count for both GDE and non-GDE cells was 1, indicating that most cells that experienced fires did so only once.
To assess if there was a significant difference in mean fire counts between GDE and non-GDE cells, a difference in means bootstrapping approach was employed. This involved resampling the data 1000 times and calculating the difference in means (non-GDE mean fire count minus GDE mean fire count) for each sample. The resulting p-value for this difference in means test was remarkably low, at 1 x 10^(-12), and the 95% confidence interval for the difference in means ranged from 0.148 to 0.221.
Based on these statistical findings, the study concluded that there is strong evidence to reject the null hypothesis, indicating a significant difference in mean fire counts between GDE and non-GDE cells in the Eastern Cascades slopes and foothills ecoregion. Specifically, GDE cells exhibited a lower mean fire count, suggesting that GDEs experienced less frequent fire occurrences compared to non-GDEs since 1950.",
"The mean fire count for our sample of cells across the entire ecoregion was found to be 0.642. When examining GDE cells specifically, the mean fire count was 0.574, while non-GDE cells had a higher mean fire count of 0.710.

Analyzing the maximum number of fires in a single cell, it was observed that both GDE and non-GDE cells had a maximum count of 4 fires. When excluding cells that did not burn, the mode (most common) fire count for both GDE and non-GDE cells was 1, indicating that most cells that experienced fires did so only once.
To assess if there was a significant difference in mean fire counts between GDE and non-GDE cells, a difference in means bootstrapping approach was employed. This involved resampling the data 1000 times and calculating the difference in means (non-GDE mean fire count minus GDE mean fire count) for each sample. The resulting p-value for this difference in means test was remarkably low, at 1 x 10^(-16), and the 95% confidence interval for the difference in means ranged from 0.067 to 0.206.
Based on these statistical findings, the study concluded that there is strong evidence to reject the null hypothesis, indicating a significant difference in mean fire counts between GDE and non-GDE cells in the Klamath Mountains ecoregion. Specifically, GDE cells exhibited a lower mean fire count, suggesting that GDEs experienced less frequent fire occurrences compared to non-GDEs since 1950. ",
"The mean fire count for our sample of cells across the entire ecoregion was found to be 0.0125. When examining GDE cells specifically, the mean fire count was 0.006, while non-GDE cells had a slightly higher mean fire count of 0.019.

Analyzing the maximum number of fires in a single cell, it was observed that GDE cells experienced a maximum count of 2 fires, whereas non-GDE cells had a higher maximum of 3 fires. When excluding cells that did not burn, the mode (most common) fire count for both GDE and non-GDE cells was 1, indicating that most cells that experienced fires did so only once.
To assess if there was a significant difference in mean fire counts between GDE and non-GDE cells, a difference in means bootstrapping approach was employed. This involved resampling the data 1000 times and calculating the difference in means (non-GDE mean fire count minus GDE mean fire count) for each sample. The resulting p-value for this difference in means test was 0.030, and the 95% confidence interval for the difference in means ranged from 0.001 to 0.025.
Based on these statistical findings, the study concluded that there is evidence to reject the null hypothesis, indicating a significant difference in mean fire counts between GDE and non-GDE cells in the Mojave Basin and Range ecoregion. Specifically, GDE cells exhibited a lower mean fire count, suggesting that GDEs experienced less frequent fire occurrences compared to non-GDEs since 1950. ",
"The mean fire count for our sample of cells across the entire ecoregion was found to be 0.208. When examining GDE cells specifically, the mean fire count was 0.057, while non-GDE cells had a significantly higher mean fire count of 0.359.

Analyzing the maximum number of fires in a single cell, it was observed that GDE cells experienced a maximum count of 1 fire, whereas non-GDE cells had a slightly higher maximum of 2 fires. When excluding cells that did not burn, the mode (most common) fire count for both GDE and non-GDE cells was 1, indicating that most cells that experienced fires did so only once.
To assess if there was a significant difference in mean fire counts between GDE and non-GDE cells, a difference in means bootstrapping approach was employed. This involved resampling the data 1000 times and calculating the difference in means (non-GDE mean fire count minus GDE mean fire count) for each sample. The resulting p-value for this difference in means test was remarkably low, at 1 x 10^(-16), and the 95% confidence interval for the difference in means ranged from 0.267 to 0.337.
Based on these statistical findings, the study concluded that there is strong evidence to reject the null hypothesis, indicating a significant difference in mean fire counts between GDE and non-GDE cells in the Northern Basin and Range ecoregion. Specifically, GDE cells exhibited a lower mean fire count, suggesting that GDEs experienced less frequent fire occurrences compared to non-GDEs since 1950.",
"The mean fire count for our sample of cells across the entire ecoregion was found to be 0.401. When examining GDE cells specifically, the mean fire count was 0.264, while non-GDE cells had a higher mean fire count of 0.492.

Analyzing the maximum number of fires in a single cell, it was observed that GDE cells experienced a maximum count of 3 fires, whereas non-GDE cells had a higher maximum of 4 fires. When excluding cells that did not burn, the mode (most common) fire count for both GDE and non-GDE cells was 1, suggesting that most cells that experienced fires did so only once.
To assess if there was a significant difference in mean fire counts between GDE and non-GDE cells, a difference in means bootstrapping approach was employed. This involved resampling the data 1000 times and calculating the difference in means (non-GDE mean fire count minus GDE mean fire count) for each sample. The resulting p-value for this difference in means test was remarkably low, at 1 X 10^(-12), and the 95% confidence interval for the difference in means ranged from 0.172 to 0.286.
Based on these statistical findings, the study concluded that there is strong evidence to reject the null hypothesis, indicating a significant difference in mean fire counts between GDE and non-GDE cells in the Sierra Nevada Ecoregion. Specifically, GDE cells exhibited a lower mean fire count, suggesting that GDEs experienced less frequent fire occurrences compared to non-GDEs since 1950.",
"The mean fire count for our sample of cells across the entire ecoregion was found to be 0.974. When analyzing GDE cells specifically, the mean fire count was higher at 1.101, whereas non-GDE cells had a slightly lower mean fire count of 0.903.

Examining the maximum number of fires in a single cell, GDE cells experienced a maximum count of 6 fires, while non-GDE cells had a slightly higher maximum of 7 fires. When excluding cells that did not burn, the mode (most common) fire count for both GDE and non-GDE cells was 1, indicating that most cells that experienced fires did so only once.
To assess if there was a significant difference in mean fire counts between GDE and non-GDE cells, a difference in means bootstrapping approach was employed. Resampling the data 1000 times and calculating the difference in means (non-GDE mean fire count minus GDE mean fire count) for each sample, the resulting p-value for this difference in means test was 1 x 10^(-16). The 95% confidence interval for the difference in means ranged from -0.322 to -0.072.
Based on these statistical findings, the study concluded that there is substantial evidence to reject the null hypothesis, indicating a significant difference in mean fire counts between GDE and non-GDE cells in the Southern California/Northern Baja Coast ecoregion. Specifically, GDE cells exhibited a higher mean fire count, suggesting that GDEs experienced more frequent fire occurrences compared to non-GDEs since 1950.",

"The mean fire count for our sample of cells across the entire ecoregion was found to be 0.053. When examining GDE cells specifically, the mean fire count was slightly higher at 0.065, while non-GDE cells had a slightly lower mean fire count of 0.041.
Analyzing the maximum number of fires in a single cell, it was observed that GDE cells experienced a maximum count of 6 fires, whereas non-GDE cells had a slightly higher maximum of 7 fires. When excluding cells that did not burn, the mode (most common) fire count for both GDE and non-GDE cells was 1, indicating that most cells that experienced fires did so only once.
To assess if there was a significant difference in mean fire counts between GDE and non-GDE cells, a difference in means bootstrapping approach was employed. This involved resampling the data 1000 times and calculating the difference in means (non-GDE mean fire count minus GDE mean fire count) for each sample. The resulting p-value for this difference in means test was 0.100, and the 95% confidence interval for the difference in means ranged from -0.05 to 0.003.
Based on these statistical findings, the study concluded that there is insufficient evidence to reject the null hypothesis, indicating no significant difference in mean fire counts between GDE and non-GDE cells in the Sonoran Basin and Range ecoregion.",

"The mean fire count for our sample of cells across the entire ecoregion was found to be 1.093. When examining GDE cells specifically, the mean fire count was significantly lower at 0.093, while non-GDE cells had a higher mean fire count of 1.143.
Analyzing the maximum number of fires in a single cell, it was observed that GDE cells experienced a maximum count of 5 fires, whereas non-GDE cells had a higher maximum of 7 fires. When excluding cells that did not burn, the mode (most common) fire count for both GDE and non-GDE cells was 1, indicating that most cells that experienced fires did so only once.
To assess if there was a significant difference in mean fire counts between GDE and non-GDE cells, a difference in means bootstrapping approach was employed. This involved resampling the data 1000 times and calculating the difference in means (non-GDE mean fire count minus GDE mean fire count) for each sample. The resulting p-value for this difference in means test was 0.003, and the 95% confidence interval for the difference in means ranged from 0.094 to 0.341.
Based on these statistical findings, the study concluded that there is strong evidence to reject the null hypothesis, indicating a significant difference in mean fire counts between GDE and non-GDE cells in the Southern California Mountains ecoregion. Specifically, GDE cells exhibited a lower mean fire count, suggesting that GDEs experienced less frequent fire occurrences compared to non-GDEs since 1950."
)
  
  # creating fire count histogram info data frame
  fire_count_text_df <- data.frame(column_names = column_names, values = values_fire)
  
  # text for info about burn severity histogram
  values_burn <- c("Analyzing the burn severity distributions, the maximum severity observed in GDEs was 4, while for non-GDEs it was 3, indicating a higher maximum burn severity in GDEs. The minimum severity recorded for both groups was 2.
Examining the mode burn severity, GDEs had a mode severity of 2, while non-GDEs had a mode severity of 3. This suggests that the most frequently occurring severity value in GDEs was lower compared to non-GDEs.
To statistically compare the distribution of burn severities between GDEs and non-GDEs, a Mann-Whitney U test was conducted. The resulting p-value from this test was 0.013. Based on this value, the study concluded that there is sufficient evidence to reject the null hypothesis, which states that there is no significant difference in the distribution of burn severity values between GDEs and non-GDEs in the Cascades ecoregion. Therefore, the analysis suggests that GDEs experience a decrease in burn severity compared to non-GDEs in this ecoregion.",

"There was not enough burn severity data in this ecoregion to analyze burn severity. This is due to a low number of fire occurrences in the MTBS data in this arid ecoregion.",

"Analyzing the burn severity distributions, the maximum severity observed in both GDEs and non-GDEs was 3, indicating a moderate level of burn severity. The minimum severity recorded for both groups was 2.
Examining the mode burn severity, GDEs had a mode severity of 2, while non-GDEs had a mode severity of 3. This suggests that the most frequently occurring severity value in GDEs was lower compared to non-GDEs.
To statistically compare the distribution of burn severities between GDEs and non-GDEs, a Mann-Whitney U test was conducted. The resulting p-value from this test was 0.309. Based on this value, the study concluded that there is insufficient evidence to reject the null hypothesis, which states that there is no significant difference in the distribution of burn severity values between GDEs and non-GDEs in the Central California Foothills and Coastal Mountains ecoregion. Therefore, the analysis suggests that the burn severity distributions in these two groups are similar in this ecoregion.",

"There was not enough burn severity data in this ecoregion to analyze burn severity. This is due to a low number of fire occurrences in the MTBS data in this mainly agricultural area.",

"Analyzing the burn severity distributions, the maximum severity observed in both GDEs and non-GDEs was 3, indicating a moderate level of burn severity. The minimum severity recorded for both groups was 2.
Examining the mode burn severity, which represents the most frequently occurring severity value in each group, both GDEs and non-GDEs had a mode severity of 2. This suggests that the majority of cells experienced a low level of burn severity during the observed fires.
To statistically compare the distribution of burn severities between GDEs and non-GDEs, a Mann-Whitney U test was conducted. The resulting p-value from this test was 0.401. Based on this value, the study concluded that there is insufficient evidence to reject the null hypothesis, which states that there is no significant difference in the distribution of burn severity values between GDEs and non-GDEs in the Coast Range ecoregion. Therefore, the analysis suggests that the burn severity distributions in these two groups are similar.",

"Analyzing the burn severity distributions, the maximum severity observed in both GDEs and non-GDEs was 4, indicating a high level of burn severity. The minimum severity recorded for both groups was 2.
Examining the mode burn severity, both GDEs and non-GDEs had a mode severity of 2. This suggests that the most frequently occurring severity value in both groups was a low level of burn severity.
To statistically compare the distribution of burn severities between GDEs and non-GDEs, a Mann-Whitney U test was conducted. The resulting p-value from this test was 0.584. Based on this value, the study concluded that there is insufficient evidence to reject the null hypothesis, which states that there is no significant difference in the distribution of burn severity values between GDEs and non-GDEs in the Eastern Cascades Slopes and Foothills ecoregion. Therefore, the analysis suggests that the burn severity distributions in these two groups are similar in this ecoregion.",

"Analyzing the burn severity distributions, the maximum severity observed in both GDEs and non-GDEs in the Klamath Mountains / California High North Coast Range ecoregion was 3, indicating a moderate level of burn severity. The minimum severity recorded for both groups was 2.
Examining the mode burn severity, both GDEs and non-GDEs had a mode severity of 3. This suggests that the most frequently occurring severity value in both groups was a moderate level of burn severity.
To statistically compare the distribution of burn severities between GDEs and non-GDEs, a Mann-Whitney U test was conducted. The resulting p-value from this test was 0.607. Based on this value, the study concluded that there is insufficient evidence to reject the null hypothesis, which states that there is no significant difference in the distribution of burn severity values between GDEs and non-GDEs in the Klamath Mountains / California High North Coast Range ecoregion. Therefore, the analysis suggests that the burn severity distributions in these two groups are similar in this ecoregion.",

"There was not enough burn severity data in this ecoregion to analyze burn severity. This is due to a low number of fire occurrences in the MTBS data in this arid ecoregion.",

"Analyzing the burn severity distributions, the maximum severity observed in both GDEs and non-GDEs in the Northern Basin and Range ecoregion was 4, indicating a relatively high level of burn severity. The minimum severity recorded for both groups was 2, suggesting that even the least severe burns had a moderate impact in this ecoregion.
Examining the mode burn severity, both GDEs and non-GDEs had a mode severity of 2, indicating that the most frequently occurring severity value in both groups was a moderate level of burn severity.
To statistically compare the distribution of burn severities between GDEs and non-GDEs, a Mann-Whitney U test was conducted. The resulting p-value from this test was 0.158. Based on this value, the study concluded that there is insufficient evidence to reject the null hypothesis, which states that there is no significant difference in the distribution of burn severity values between GDEs and non-GDEs in the Northern Basin and Range ecoregion. Therefore, the analysis suggests that the burn severity distributions in these two groups are similar in this ecoregion.",

"Analyzing the burn severity distributions, the maximum severity observed in GDEs was 4, while for non-GDEs it was 3, indicating a potential higher maximum burn severity in GDEs. The minimum severity recorded for both groups was 2.
Examining the mode burn severity, both GDEs and non-GDEs had a mode severity of 3. This suggests that the most frequently occurring severity value in both groups was the same.
To statistically compare the distribution of burn severities between GDEs and non-GDEs, a Mann-Whitney U test was conducted. The resulting p-value from this test was 0.377. Based on this value, the study concluded that there is insufficient evidence to reject the null hypothesis, which states that there is no significant difference in the distribution of burn severity values between GDEs and non-GDEs in the Sierra Nevada ecoregion. Therefore, the analysis suggests that the burn severity distributions in these two groups are similar in this ecoregion.",

"Examining the burn severity distributions in the Southern California / Northern Baja Coast ecoregion, the maximum severity observed for GDEs was 4, while for non-GDEs it was 3. This indicates that GDEs experienced a slightly higher maximum burn severity compared to non-GDEs.
The minimum burn severity recorded for both GDEs and non-GDEs was 2, suggesting that even the least severe burns had a moderate impact in this ecoregion.
Analyzing the mode burn severity, both GDEs and non-GDEs had a mode severity of 2. This implies that the most frequently occurring severity value in both groups was at a low level, indicating that the majority of cells experienced relatively low burn severity during the observed fires.
To statistically compare the distribution of burn severities between GDEs and non-GDEs, a Mann-Whitney U test was conducted. The resulting p-value from this test was 0.375. Based on this value, the study concluded that there is insufficient evidence to reject the null hypothesis. Therefore, the analysis suggests that there is no significant difference in the distribution of burn severity values between GDEs and non-GDEs in the Southern California / Northern Baja Coast ecoregion.",

"Analyzing the burn severity distributions in the Sonoran Basin and Range ecoregion, the maximum severity observed for GDEs was 4, while for non-GDEs it was 3. This suggests that GDEs experienced slightly higher maximum burn severity compared to non-GDEs.
The minimum burn severity recorded for both GDEs and non-GDEs was 2, indicating that even the least severe burns had a moderate impact in this ecoregion.
Examining the mode burn severity, GDEs had a mode severity of 3, while non-GDEs had a mode severity of 2. This indicates that the most frequently occurring severity value in GDEs was higher compared to non-GDEs, suggesting that GDEs may have experienced more instances of moderate burn severity.
To statistically compare the distribution of burn severities between GDEs and non-GDEs, a Mann-Whitney U test was conducted. The resulting p-value from this test was 0.00001, which is below the typical threshold for statistical significance (e.g., 0.05). Therefore, the study concluded that there is sufficient evidence to reject the null hypothesis. This implies that there is a significant difference in the distribution of burn severity values between GDEs and non-GDEs in the Sonoran Basin and Range ecoregion. Specifically, the analysis suggests that GDEs tend to experience increased burn severity compared to non-GDEs in this ecoregion.",

"Analyzing the burn severity distributions, the maximum severity observed in GDEs was 4, while for non-GDEs it was 3, indicating a more severe level of burn severity in GDEs compared to non-GDEs. The minimum severity recorded for both groups was 2.
Examining the mode burn severity, both GDEs and non-GDEs had a mode severity of 2. This suggests that the most frequently occurring severity value in both groups was a low level of burn severity.
To statistically compare the distribution of burn severities between GDEs and non-GDEs, a Mann-Whitney U test was conducted. The resulting p-value from this test was 0.375. Based on this value, the study concluded that there is insufficient evidence to reject the null hypothesis, which states that there is no significant difference in the distribution of burn severity values between GDEs and non-GDEs in the Southern California Mountains ecoregion. Therefore, the analysis suggests that the burn severity distributions in these two groups are similar in this ecoregion."
)
  
  # creating fire count histogram info data frame
  burn_severity_text_df <- data.frame(column_names = column_names, values = values_burn)
  
}

