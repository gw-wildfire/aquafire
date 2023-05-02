# sidebarLayout ----
#                                  sidebarLayout(

sidebarPanel(width = 3,
             
             # Put inputs & variables to change here!
             # GDEs, Wildfire Hazard
             "For California spatial analysis inputs"
             
)# ,
#                                  ), # End sidebarLayout ----

# ABOVE AFTER LEAFLET MAP



tslf <- raster("/Users/Wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/tslf.tif")
gde <- raster("/Users/Wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/shiny/www/gde_boundaries.tif")
eco <- st_read("/Users/Wsedgwick/Desktop/bren_meds/courses/capstone/aquafire/data/ca_eco_l3/ca_eco_l3.shp")

# getting coastal mountain ecoregion
coastal_mountain <- eco[6,]

coastal_mountain <- st_transform(coastal_mountain, crs = st_crs(3309))

coastal_mountain_sf <- st_as_sf(coastal_mountain, crs = st_crs(3309))
eco_sf <- st_as_sf(eco, crs = st_crs(3309))



# plot the coastal mountain polygon
leaflet() %>%
#  addTiles() %>%
  addPolygons(data = eco_sf)


leaflet() %>% addTiles() %>% 
  addPolygons(coastal_mountain, lng = -120, lat = 37)



tm_shape(coastal_mountain) +
  tm_polygons()

# raster::crs(r) <- "EPSG:3309"
# ext <- extent(-121, -119, 34.43, 40)

# Specify the extent of the subset
ext <- extent(-50500, 50000, -410000, -290000)
# ext <- extent(r)


# Subset the raster using the extent
tslf_sub <- crop(tslf, ext)
gde_sub <- crop(gde, ext)

# subsetting by eco-region
tslf_sub <- crop(tslf, coastal_mountain)
coastal_mountain

raster::crs(tslf_sub) <- "EPSG:3309"
raster::crs(gde_sub) <- "EPSG:3309"

# Create a leaflet map
leaflet() %>%
#  addTiles() %>%
#  addRasterImage(gde_sub) %>% 
  addRasterImage(tslf_sub)

leaflet() %>% 
  addRasterImage(tslf_sub)


plot(tslf_sub)

  
  
pryr::object_size(r)


leaflet() %>% 
  addProviderTiles("Esri.WorldImagery") %>%
  setView(-120.829529, 37.538843, zoom = 6) %>%
  addRasterImage(r_sub) %>% 
  addLayersControl(overlayGroups = "rasterLayer", options = layersControlOptions(collapsed = FALSE)) %>% 
  addMouseCoordinates() %>% 
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "miles",
    primaryAreaUnit = "sqmiles",
    activeColor = "#3D535D",
    completedColor = "#36454F")

# subsetting


 
leaflet() %>% addTiles() %>%
  addRasterImage(r, colors = pal, opacity = 0.8) %>%
  addLegend(pal = pal, values = values(r),
            title = "Surface temp")



# Create a tmap layer from the raster object
r_layer <- tm_raster(r)

# Create a tmap object and add the raster layer
tm_shape(r_layer) + 
  tm_raster()

# View the tmap object interactively
tmap_mode("view")
tm_view(tm_obj)
class(r_layer)

pal <- colorNumeric(c("#d73027", "#fc8d59", "#fee090", "#e0f3f8", "#91bfdb", "#4575b4"), values(r), na.color = "transparent")

leaflet() %>% 
  addRasterImage(r)

# vector memory exhausted - 



