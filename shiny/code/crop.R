
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

# Mask to California's boundary
tslf_raster_masked <- mask(tslf_raster, ca_counties)



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

coast_range_crop <- crop(tslf_raster_masked, coast_range)
central_basin_crop <- crop(tslf_raster_masked, central_basin)
mojave_basin_crop <- crop(tslf_raster_masked, mojave_basin)
cascades_crop <- crop(tslf_raster_masked, cascades)
sierra_nevada_crop <- crop(tslf_raster_masked, sierra_nevada)
central_foothills_coastal_mountains_crop <- crop(tslf_raster_masked, central_foothills_coastal_mountains)
central_valley_crop <- crop(tslf_raster_masked, central_valley)
klamath_mountains_crop <- crop(tslf_raster_masked, klamath_mountains)
southern_mountains_crop <- crop(tslf_raster_masked, southern_mountains)
northern_basin_crop <- crop(tslf_raster_masked, northern_basin)
sonoran_basin_crop <- crop(tslf_raster_masked, sonoran_basin)
socal_norbaja_coast_crop <- crop(tslf_raster_masked, socal_norbaja_coast)
eastern_cascades_slopes_foothills_crop <- crop(tslf_raster_masked, eastern_cascades_slopes_foothills)

end <- Sys.time()
print(end - start)
beepr::beep()

# crop gdes by county
gde_crop <- crop(gde, socal_norbaja_coast)
# crop tslf within that county by gde layer
gde_tslf_crop <- crop(socal_norbaja_coast_crop, gde_crop)
# cropping tslf with gde raster

leaflet() %>% addTiles() %>% addRasterImage(gde_tslf_crop)
plot(gde_crop)
plot(gde_tslf_crop)
class(socal_norbaja_coast)





