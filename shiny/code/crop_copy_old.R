
start <- Sys.time()
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

## Load ecoregions and counties and gde shapefiles 

crs_ca <- st_crs(3310)
# Load in ecoregions shapefile
eco_regions <- read_sf(here::here('data', 'ca_eco_l3')) %>% 
  janitor::clean_names()  %>% 
  st_transform(crs_ca) %>% 
  rename(region = us_l3name)

# Read in CA county boundaries

ca_counties <- read_sf(here::here('data', 'CA_Counties')) %>%
  janitor::clean_names() %>%
  st_transform(crs_ca) # NAD27 / California Albers

# Load gde .tif file
# gde <- raster("data/gde_boundaries.tif")
# gde_sf <- st_read("/Users/Wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/data/gdes/Groundwater_dependent_ecosystems_summary.shp")

crs(gde) <- "EPSG:3310"


## Load fire perimeters data and filter, set CRS, crop to California

fire_perimeters_all <- sf::read_sf(here('data',
                                        'California_Fire_Perimeters_all')) %>%
  clean_names() %>%
  st_transform(crs_ca) %>% # NAD27 / California Albers
  mutate(val = 1) %>% # Create a column containing a value: this means each fire has a value of 1
  filter(year >= 1950) # Filter for only fires after 1950: this is when the dataset becomes reliable.

# Crop to California
fires_ca <- st_crop(fire_perimeters_all, ca_counties) %>%
  mutate(year = as.numeric(year))


## Create an empty raster to use as a template
# This valueless raster has a resolution of 30 x 30.


## Set extent
ca_ext <- extent(fires_ca)
## Create valueless raster layer w/ 30 (unit is something) resolution
ca_rast <- raster(ca_ext, resolution = 30)
crs(ca_rast) <- crs_ca$wkt

# Use fasterize::fasterize() to create a raster layer where each cell is equal to the maximum year value for that cell.
most_recent_raster <- fasterize(st_collection_extract(fires_ca, "POLYGON"), ca_rast, field = "year", fun = "max", background = NA)

# Subtract the raster layer containing the most recent fire from 2022- this will give the number of years since the most recent fire in each cell.
tslf_raster <- 2022 - most_recent_raster


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
path_raster <- "/Users/wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/data/tslf"

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

# WORKING WITH GDE DATA
#gde_polygon_8 <- st_make_valid(gde_polygon_8)
print('loading GDE data by Ecoregion')  

path_gde <- "data/gde_ecoregions"
gde.files <- list.files(path_gde, full.names = T)
gde.files2 <- list.files(path_gde, full.names = F)
# fire.files2 = gsub('.tif', '', fire.files2)
gde_list <- list()

length(gde.files)

# 
for(i in 1:length(gde.files)){
  print(i)
  file_i = gde.files[i]
  file_i2 = gde.files2[i]
  fire_count_list[[file_i2]] = st_read(file_i)
}

for(i in 1:length(gde.files)) {
  a <- list.files[i]
  file_i <- st_read(a)
}

gde_coast_range <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_coast_range/gde_polygon_1.shp")
gde_central_basin <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_central_basin/gde_polygon_13.shp")
gde_mojave_basin <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_mojave_basin/gde_polygon_14.shp")
gde_cascades <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_cascades/gde_polygon_4.shp")
gde_sierra_nevada <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_sierra_nevada/gde_polygon_5.shp")
gde_central_foothills_coastal_mountains <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_central_foothills_coastal_mountains/gde_polygon_6.shp")
gde_central_valley <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_central_valley/gde_polygon_7.shp")
gde_klamath_mountains <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_klamath_mountains/gde_polygon_78.shp")
gde_southern_mountains <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_southern_mountains/gde_polygon_8.shp")
gde_northern_basin <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_northern_basin/gde_polygon_80.shp")
gde_sonoran_basin <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_sonoran_basin/gde_polygon_81.shp")
gde_socal_norbaja_coast <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_socal_norbaja_coast/gde_polygon_85.shp")
gde_eastern_cascades_slopes_foothills <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gde_polygons/gde_eastern_cascades_slopes_foothills/gde_polygon_9.shp")

# reading in largest gde polygon - central_foothills_coastal_mountains at 316MB
largest_gde <- gde_central_foothills_coastal_mountains %>% 
  filter(area > 10000) # more than 2.2~ acres - still 34k obs! too big! MAX 10k?

# if filter GDEs less than 1 acre, what will be missing? will still be included in the ecoregion analysis

# this gde 
simp <- st_simplify(gde_cascades, dTolerance = 5) # cascades
gde_4_simp <- tm_shape(simp) + tm_polygons()
#gde_8 <- tm_shape(gde_polygon_8) + tm_polygons()




# crop gdes by county
# gde_crop <- crop(gde, socal_norbaja_coast)
# crop tslf within that county by gde layer - get fire perimeters and tslf within all gdes
# gde_tslf_crop <- crop(socal_norbaja_coast_crop, gde_crop)
# using mask
# crs(socal_norbaja_coast_crop) <- "EPSG:3310"
# crs(gde_crop) <- "EPSG:3310"
# tslf_masked <- mask(x = socal_norbaja_coast_crop, mask = gde_crop)

# crop tslf outside of the gde layer to get fire perimeters and tslf outside of gde boundaries

# intersect

# crs(tslf_masked)
# Crop the time since last burn layer to the extent of the groundwater-dependent ecosystem layer


# 
# tm_shape(gde_crop) +
#   tm_raster()
# 
# tm_shape(tslf_masked, raster.downsample = FALSE) +
#   tm_raster()


# crs(tslf_masked) <- "EPSG:3310"
# crs(tslf_masked)
# plot(tslf_masked)
start <- Sys.time()
# leaflet() %>% addTiles() %>% addRasterImage(tslf_masked)
end <- Sys.time()
print(end - start)

# plot(gde_crop)
# plot(gde_tslf_crop)
# class(socal_norbaja_coast)
# 
# tm_shape(tslf_masked) +
#   tm_raster()




