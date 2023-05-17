
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

crs_ca <- st_crs(3309)
eco_regions <- read_sf(here::here('data', 'ca_eco_l3')) %>% 
  janitor::clean_names()  %>% 
  st_transform(crs_ca)

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
gde <- raster("/Users/Wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/gde_boundaries.tif")
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

# coast_range_crop <- crop(tslf_raster_masked, coast_range)
# central_basin_crop <- crop(tslf_raster_masked, central_basin)
# mojave_basin_crop <- crop(tslf_raster_masked, mojave_basin)
# cascades_crop <- crop(tslf_raster_masked, cascades)
# sierra_nevada_crop <- crop(tslf_raster_masked, sierra_nevada)
# central_foothills_coastal_mountains_crop <- crop(tslf_raster_masked, central_foothills_coastal_mountains)
# central_valley_crop <- crop(tslf_raster_masked, central_valley)
# klamath_mountains_crop <- crop(tslf_raster_masked, klamath_mountains)
# southern_mountains_crop <- crop(tslf_raster_masked, southern_mountains)
# northern_basin_crop <- crop(tslf_raster_masked, northern_basin)
# sonoran_basin_crop <- crop(tslf_raster_masked, sonoran_basin)
# socal_norbaja_coast_crop <- crop(tslf_raster_masked, socal_norbaja_coast)
# eastern_cascades_slopes_foothills_crop <- crop(tslf_raster_masked, eastern_cascades_slopes_foothills)


# raster time since last burn (TSLB) layers cropped by ecoregion
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

writeRaster(eastern_cascades_slopes_foothills_fire_count, filename = "shiny/www/fire_count/eastern_cascades_slopes_foothills_fire_count.tif", format = "GTiff")

plot(coast_range_fire_count)


beepr::beep()

end <- Sys.time()
print(end - start)
beepr::beep()

plot(gde_crop)

writeRaster(coast_range_crop, "coast_range_crop.tif", format = "GTiff")

# trying to read in GDE data with tslf as a shapefile
a <- st_read("/Users/wsedgwick/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/socal_norbaja_gde_tslf/socal_norbaja_gde_tslf.shp")
a <- st_read("~/Desktop/bren_meds/courses/capstone/ecoregion_wrangling/gdes/socal_norbaja_gde_tslf/socal_norbaja_gde_tslf.shp")

tm_shape(a) +
  tm_polygons()

# crop gdes by county
gde_crop <- crop(gde, socal_norbaja_coast)
# crop tslf within that county by gde layer - get fire perimeters and tslf within all gdes
gde_tslf_crop <- crop(socal_norbaja_coast_crop, gde_crop)
# using mask
crs(socal_norbaja_coast_crop) <- "EPSG:3310"
crs(gde_crop) <- "EPSG:3310"
tslf_masked <- mask(x = socal_norbaja_coast_crop, mask = gde_crop)

# crop tslf outside of the gde layer to get fire perimeters and tslf outside of gde boundaries

# intersect

crs(tslf_masked)
# Crop the time since last burn layer to the extent of the groundwater-dependent ecosystem layer



tm_shape(gde_crop) +
  tm_raster()

tm_shape(tslf_masked, raster.downsample = FALSE) +
  tm_raster()


crs(tslf_masked) <- "EPSG:3310"
crs(tslf_masked)
plot(tslf_masked)
start <- Sys.time()
leaflet() %>% addTiles() %>% addRasterImage(tslf_masked)
end <- Sys.time()
print(end - start)

# plot(gde_crop)
# plot(gde_tslf_crop)
# class(socal_norbaja_coast)
# 
# tm_shape(tslf_masked) +
#   tm_raster()




