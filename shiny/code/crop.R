
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

source("functions/raster_to_ecoregions.R")

burn_severity <- raster("data/burn_severity_mode.tif")
raster_to_ecoregions(raster_layer = burn_severity, file_name = "burn_severity", write_to_file = TRUE)


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




print('loading STATS data')

stats_file <- "www/plots"
stats.files <- list.files(stats_file, full.names = T)
stats.files2 <- list.files(stats_file, full.names = F)
stats.files2 <- gsub('.png', '', stats.files2) # CHANGE format to whatever the format of the stats images are!!!!
burn_hist_list <- list()
fire_count_hist_list <- list()


length(stats.files)

for(i in 1:length(stats.files)) {
  if(startsWith(stats.files2[i], "fire_count_histogram")) {
    print(i)
    file_i = stats.files[i]
    file_i2 = stats.files2[i]
    fire_count_hist_list[[file_i2]] = readPNG(file_i)}
}











# Decreasing Raster layer Fire Threat



# aggregate fire layers
for(i in 1:length(fire_threat.files)) {
  print(i)
  file_i = fire_threat.files[i]
  file_i2 = fire_threat.files2[i]
  fire_threat_list[[file_i2]] = raster(file_i)
  fire_threat_layer <- fire_threat_list[[i]]
  fire_threat_layer <- aggregate(fire_threat_layer, fact = 4)
  fire_threat_list[[i]] <- fire_threat_layer
  output_path <- file.path("data/fire_threat_aggregated", file_i2)
  writeRaster(fire_threat_layer, filename = output_path, format = "GTiff")
}

# 

eco_regions

eco_regions
gdes_cali

gdes_cali <- st_read("data/gde_ecoregions_california")
gde_ecoregions <- st_join(eco_regions, gdes_cali)
ecoregion_groups <- gde_ecoregions %>% 
  group_split(region)

ecoregion_groups[[1]]

gdes_cali_valid <- st_make_valid(gdes_cali)

gde_coast_range <- st_intersection(gdes_cali_valid, coast_range)
gde_northern_basin <- st_intersection(gdes_cali_valid, northern_basin)
gde_coast_range


invalid_geom <- eco_regions[!st_is_valid(eco_regions), ]

print(invalid_geom)
fixed_geom <- st_buffer(eco_regions, 0)
crs(coast_range)

crs(gdes_cali) == crs(coast_range)





for(id in 1:length(gdes_cali)){
  gdes_in_ecoregion <- gdes_cali %>%
    # filter(us_l3code == POLYGON) %>%
    select(POLYGON, WETLAND, VEGETAT, DOMINANT_S, DOMINANT_C, 
           mx_fr_c, mn_tslf, avg_fr_t, avg_fr_s, are_km2, geometry)
  
  output_file <- paste0("raster_output/gde_summary_polygons", id, ".shp")
  
  st_write(gdes_in_ecoregion, output_file)
}

# for (i in seq_along(ecoregion_groups)) {
#   st_write(ecoregion_groups[[i]], paste0("data/gde_ecoregions/new", ecoregion_groups, ".shp"))
# }
# 
# st_write(ecoregion_groups[[9]], paste0("data/gde_ecoregions/new", ecoregion_groups, ".shp"))
# 
# ecoregion_groups[[9]]

# NOTES:----
# # reading in largest gde polygon - central_foothills_coastal_mountains at 316MB
eastern_casc <- st_make_valid(st_read("data/gde_ecoregions/gde_eastern_cascades_slopes_foothills"))
eastern_casc

largest_gde <- eastern_casc %>%
  filter(area > 10000)  # more than 2.2~ acres - still 34k obs! too big! MAX 10k?

largest_gde_simp <- st_simplify(largest_gde, dTolerance = 5)

largest_gde

tmap_mode("view")

tm_shape(largest_gde_simp) +
  tm_polygons()

# for central cali foothills
central_foothills <- st_make_valid(st_read("data/gde_ecoregions/gde_central_foothills_coastal_mountains"))
central_foothills

central_foothills_gde <- central_foothills %>%
  filter(area > 10000)  # more than 2.2~ acres - still 34k obs! too big! MAX 10k?

central_foothills_gde_simp <- st_simplify(central_foothills_gde, dTolerance = 10)

central_foothills_gde_simp

tmap_mode("view")

tm_shape(largest_gde_simp) +
  tm_polygons()


# dealing with 

stats_file <- "www" # www/plots
stats.files <- list.files(stats_file, full.names = T)
stats.files2 <- list.files(stats_file, full.names = F)
# stats.files2 <- gsub('.png', '', stats.files2) # CHANGE format to whatever the format of the stats images are!!!!
stats.files2 <- gsub('.jpg', '', stats.files2)
burn_hist_list <- list()
fire_count_hist_list <- list()


length(stats.files)

for(i in 1:length(stats.files)) {
  if(startsWith(stats.files2[i], "fire_count_histogram")) {
    print(i)
    file_i = stats.files[i]
    file_i2 = stats.files2[i]
    # fire_count_hist_list[[file_i2]] = readPNG(file_i)
    fire_count_hist_list[[file_i2]] = readJPEG(file_i)
    
  }
}
# WHY NO CALIFORNIA

for(i in 1:length(stats.files)) {
  if(startsWith(stats.files2[i], "burn_severity_histogram")) {
    print(i)
    file_i = stats.files[i]
    file_i2 = stats.files2[i]
    # burn_hist_list[[file_i2]] = readPNG(file_i)
    burn_hist_list[[file_i2]] = readJPEG(file_i)
  }
}

# NOT NEEDED BELOW BECAUSE USING A DF
# renaming fire count list


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


# burn_severity_hist_reactive <- reactive({
#   
#   print(input$ecoregion_stats_type_input)
#   req(!is.null(input$ecoregion_stats_type_input))
#   
#   selected_hist_ecoregion <- input$ecoregion_stats_type_input
#   burn_hist_ecoregion <- burn_severity_histogram_df %>% filter(ecoregion == selected_hist_ecoregion)
#   plot_title <- unique(burn_hist_ecoregion$ecoregion_name)
#   
#   burn_hist_ecoregion$value[burn_hist_ecoregion$value == 2] <- 'Low'
#   burn_hist_ecoregion$value[burn_hist_ecoregion$value == 3] <- 'Medium'
#   burn_hist_ecoregion$value[burn_hist_ecoregion$value == 4] <- 'High'
#   
#   # burn_hist_ecoregion$value <- factor(burn_hist_ecoregion$value, levels = burn_hist_ecoregion$value)
#   
#   ggplot(burn_hist_ecoregion, aes(x = value, y = proportion, fill = as.factor(gde_status))) +
#     geom_bar(stat = "identity", position = "dodge") +
#     scale_fill_manual(values = c("#A3B18A", "#DDA15E"),
#                       labels = c("Non-GDE", "GDE")) +
#     labs(x = "Burn Severity",
#          y = "Relative Frequency (%)",
#          fill = "GDE Status",
#          title = str_wrap(paste0("Relative Burn Severity Frequency for ", plot_title), 30)) +
#     theme_classic() +
#     theme(legend.position = 'right',
#           plot.title = element_text(hjust = 0.5,
#                                     size = 15),
#           axis.text = element_text(size = 13,
#                                    color = 'black'),
#           axis.title = element_text(size = 15,
#                                     color = 'black'),
#           axis.title.x = element_text(vjust = -1.1),
#           axis.text.x = element_text(vjust = -1.5)) +
#     scale_y_continuous(expand = c(0,0)) + scale_x_discrete(limits=burn_hist_ecoregion$value)
#   
# })


# names_fire_count_hist <- names(fire_count_hist_list)
# names(names_fire_count_hist) = gsub('fire_count_histogram', '', names_fire_count_hist)
# names(names_fire_count_hist) = gsub('_', ' ', names(names_fire_count_hist))
# names(names_fire_count_hist) = names(names_fire_count_hist) %>% stringr::str_to_title()
# 
# # renaming burn severity list
# names_burn_hist <- names(burn_hist_list)
# names(names_burn_hist) = gsub('burn_severity_histogram', '', names_burn_hist)
# names(names_burn_hist) = gsub('_', ' ', names(names_burn_hist))
# names(names_burn_hist) = names(names_burn_hist) %>% stringr::str_to_title()



# IMAGE DISPLAYS

# if filter GDEs less than 1 acre, what will be missing? will still be included in the ecoregion analysis

# fluidRow(
#   column(6,
#          tags$img(src = "burn_severity_map_california.jpg", width = "100%", )
#   ),
#   column(6,
#          tags$img(src = "fire_count_map_california.png", width = "100%")
#   )
# ), # End IMAGES
# 
# h3("Cascades"),
# 
# fluidRow(
#   column(6,
#          tags$img(src = "burn_severity_histogram_cascades.jpg", width = "100%", )
#   ),
#   column(6,
#          tags$img(src = "fire_count_histogram_cascades.jpg", width = "100%")
#   )
# ), # End IMAGES
# 
# h3("Central Foothills & Coastal Mountains"),
# 
# fluidRow(
#   column(6,
#          tags$img(src = "burn_severity_histogram_central_foothills_coastal_mountains.jpg", width = "100%", )
#   ),
#   column(6,
#          tags$img(src = "fire_count_histogram_central_foothills_coastal_mountains.jpg", width = "100%")
#   )
# ), # End IMAGES
# 
# h3("Coast Range"),
# 
# fluidRow(
#   column(6,
#          tags$img(src = "burn_severity_histogram_coast_range.jpg", width = "100%", )
#   ),
#   column(6,
#          tags$img(src = "fire_count_histogram_coast_range.jpg", width = "100%")
#   )
# ), # End IMAGES
# 
# h3("Eastern Cascade Slopes & Foothills"),
# 
# fluidRow(
#   column(6,
#          tags$img(src = "burn_severity_histogram_eastern_cascades_slopes_foothills.jpg", width = "100%", )
#   ),
#   column(6,
#          tags$img(src = "fire_count_histogram_eastern_cascades_slopes_foothills.jpg", width = "100%")
#   )
# ), # End IMAGES
# 
# h3("Eastern Cascade Slopes and Foothills"),
# 
# fluidRow(
#   column(6,
#          tags$img(src = "burn_severity_histogram_eastern_cascades_slopes_foothills.jpg", width = "100%", )
#   ),
#   column(6,
#          tags$img(src = "fire_count_histogram_eastern_cascades_slopes_foothills.jpg", width = "100%")
#   )
# ), # End IMAGES

