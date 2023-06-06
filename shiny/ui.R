ui <- fluidPage(
  
  theme = bslib::bs_theme(bootswatch = "sandstone",
                          bg = "#ffffff",
                          fg = "#143c5c"),
  
  titlePanel(""), #BC4749 F7EDE2
  fluidPage(
    fluidRow(column(6,
                    h1("Assessing Wildfires in GDEs")),
             column(6,
                    HTML("<a href='https://www.tnc.org/'><img src='tnc_logo.png' align= 'right' height= '100' width = '240' alt='This is The Nature Conservancy logo'/></a>")))),
  
  # Navigation Bar ----
  navbarPage("",
             position = "static-top",
             
             # About tab----
             tabPanel("About", icon = icon("info-circle"),
                      fluidPage(
                        
                        fluidRow(
                          
                          column(6,
                                 tags$img(src = "gde_image.jpeg", width = "100%", height = "100%"),
                                 
                          ),
                          column(6,
                                 tags$img(src = "fire_image.jpeg", width = "100%", height = "100%")
                          )
                        ), # End IMAGES
                        
                        # Background
                        h1("Background"),
                        
                        fluidRow(
                          column(12, p("Eight of the largest 10 wildfires in California have occured in the past five years. And although there has been extensive research on wildfire models designed to predict occurence and severity, little research has been done to understand and quantify how subsurface water may effect these wildfire models. This project aims to understand how Groundwater-Dependent Ecosystems (GDEs), which are ecosystems that are dependent on groundwater year-round, might play a role in wildfires."),
                          )
                        ), # End Background
                        
                        h1("Significance"),
                        
                        fluidRow(
                          column(12, p("This app was designed to display spatial and statistical relationships between groundwater-dependent ecosystems and wildfires. It may be used as a tool to understand how GDEs play a role in lessening the severity of a wildfire or may even act as a natural fire break."),
                                 
                          ),
                          
                        ), # End Significance
                        
                        h1("How to Use This App"),
                        
                        fluidRow(
                          column(12, p("This Shiny App has 3 main tabs, the Ecoregions tab, the Map tab, and the Statistics tab. In the Ecoregions tab, you can understand more about the geography and geology of a certain ecoregion, as well as the dominant vegetation species spread throughout the ecoregion. In the Map tab, one of the 13 ecoregions in california, designated by the EPA, can be selected and will display all GDEs within that ecoregion. Click on a GDE and information including wetland type, dominant vegetation, and wildfire metrics will be shown. There are both wetland and riparian GDEs displayed in this map, and will show either wetland type or dominant vegetation species, respectively. On the left panel, 4 fire layers can be toggled on and off. These layers are: total number of fires since 1950, number of years since the last fire, fire threat (from Cal Fire), and the most-frequent severity value for a cell."),
                          )
                        ), # End How to Use This App
                        
                        h1("Data Information"),
                        
                        fluidRow(
                          column(12, p(""),
                          ),
                          
                          dataTableOutput("dataTable")
                          # tableOutput("dataTable")
                          
                        ), # End Data Policy Info
                        
                        h1("About Us"),
                        
                        fluidRow(
                          column(12, p("We are Jillian Allison, Meagan Brown, Andre Dextre, and Wade Sedgwick. This App was designed during our Master in Environmental Data Science Program for use by the Dangermond Preserve, owned by The Nature Conservancy."),
                          )
                        ), # End About Us
                        
                        h4("Sources"),
                        
                        fluidRow(
                          column(12, p("The GDE image is taken from CSIRO (https://research.csiro.au/mwe/national-atlas-of-groundwater-dependent-ecosystems/) and the wildfire image was taken from the Las Vegas Review Journal (https://www.reviewjournal.com/news/nation-and-world/fire-grows-in-northern-california-evacuation-hits-nevada-area-2396714/attachment/plumes-of-smoke-and-fire-rise-above-frenchman-lake-as-the-sugar-fire-part-of-the-beckwourth-co/)."),
                          )
                        ), # End About Us
                        
                      ), # End fluidPage
                      
             ), # End Tab Panel for About page
             
             # Ecoregion Information tab----
             tabPanel(title = "Ecoregion Information", icon = icon("layer-group"),
                      
                      mainPanel(
                        
                        h1("Ecoregion Information"),
                        
                        tmapOutput("main_map", height = 600, width = 1000) %>% withSpinner(type = 6, size = 0.8),
                        
                        fluidRow(
                          h3("Cascades (4)"),
                          column(12, p("This mountainous ecoregion stretches from the central portion of western Washington, through the spine of Oregon, and includes a disjunct area in northern California. It is underlain by Cenozoic volcanics and much of the region has been affected by alpine glaciation. In Oregon and Washington, the western Cascades are older, lower, and dissected by numerous, steep-sided stream valleys. A high plateau occurs to the east, with both active and dormant volcanoes. Some peaks reach over 14,000 feet. Soils are mostly of cryic and frigid temperature regimes, with some mesic soils at low elevations and in the south. Andisols and Inceptisols are common.")),
                          column(12, p("The Cascades have a moist, temperate climate that supports an extensive and highly productive coniferous forest that is intensively managed for logging. At lower elevations in the north, Douglas-fir, western hemlock, western red cedar, big leaf maple, and red alder are typical. At higher elevations, Pacific silver fir, mountain hemlock, subalpine fir, noble fir, and lodgepole pine occur. In southern Oregon and California, more incense cedar, white fir, and Shasta red fir occur along with other Sierran species. Subalpine meadows and rocky alpine zones occur at highest elevations."))
                        ), # End FluidRow Cascades
                        
                        fluidRow(
                          h3("Central Basin and Range (13)"),
                          column(12, p("The Central Basin and Range ecoregion is composed of northerly trending, fault-block ranges and intervening, drier basins. In the higher mountains, woodland, mountain brush, and scattered open forest are found. Lower elevation basins, slopes, and alluvial fans are either shrub- and grass-covered, shrub-covered, or barren. The potential natural vegetation, in order of decreasing elevation and ruggedness, is scattered western spruce-fir forest, juniper woodland, Great Basin sagebrush, and saltbush-greasewood.")),
                          column(12, p("The Central Basin and Range is internally-drained by ephemeral streams and once contained ancient Lake Lahontan. In general, Ecoregion 13 is warmer and drier than the Northern Basin and Range (80) and has more shrubland and less grassland than the Snake River Plain (12). Soils grade upslope from mesic Aridisols to frigid Mollisols. The land is primarily used for grazing. In addition, some irrigated cropland is found in valleys near mountain water sources. The region is not as hot as the Mojave Basin and Range (14) and Sonoran Basin and Range (81) ecoregions and it has a greater percent of land that is grazed."))
                        ), # End FluidRow Central Basin
                        
                        fluidRow(
                          h3("Central California Foothills and Coastal Mountains (6)"),
                          column(12, p("The primary distinguishing characteristic of this ecoregion is its Mediterranean climate of hot dry summers and cool moist winters, and associated vegetative cover comprising mainly chaparral and oak woodlands; grasslands occur in some lower elevations and patches of pine are found at higher elevations. ")),
                          column(12, p("Surrounding the lower and flatter Central California Valley (7), most of the region consists of open low mountains or foothills, but there are some areas of irregular plains and some narrow valleys. Large areas are in ranch lands and grazed by domestic livestock. Relatively little land has been cultivated, although some valleys are major agricultural centers such as the Salinas or the wine vineyard center of Napa and Sonoma."))
                        ), # End Central Foothills Coastal Mountains
                        
                        fluidRow(
                          h3("Central California Valley (7)"),
                          column(12, p("Flat, intensively farmed plains with long, hot dry summers and mild winters distinguish the Central California Valley from its neighboring ecoregions that are either hilly or mountainous, forest or shrub covered, and generally nonagricultural. It includes the flat valley basins of deep sediments adjacent to the Sacramento and San Joaquin rivers, as well as the fans and terraces around the edge of the valley. The two major rivers flow from opposite ends of the Central Valley, flowing into the Delta and into San Pablo Bay. ")),
                          column(12, p("It once contained extensive prairies, oak savannas, desert grasslands in the south, riparian woodlands, freshwater marshes, and vernal pools. More than half of the region is now in cropland, about three fourths of which is irrigated. Environmental concerns in the region include salinity due to evaporation of irrigation water, groundwater contamination from heavy use of agricultural chemicals, wildlife habitat loss, and urban sprawl."))
                        ), # End Central Valley
                        
                        fluidRow(
                          h3("Coast Range (1)"),
                          column(12, p("The low mountains of the Coast Range of western Washington, western Oregon, and northwestern California are covered by highly productive, rain-drenched coniferous forests. Sitka spruce forests originally dominated the fog-shrouded coast, while a mosaic of western redcedar, western hemlock, and seral Douglas-fir blanketed inland areas. Today, Douglas-fir plantations are prevalent on the intensively logged and managed landscape. In California, redwood forests are a dominant component in much of the region. In Oregon and Washington, soils are typically Inceptisols and Andisols, while Alfisols are common in the California portion.")),
                          column(12, p("Landslides and debris slides are common, and lithology influences land management strategies. In Oregon and Washington, slopes underlain by sedimentary rock are more susceptible to failure following clear-cutting and road building than those underlain by volcanic rocks. Coastal headlands, high and low marine terraces, sand dunes, and beaches also characterize the region.")),
                        ),
                        
                        fluidRow(
                          h3("Eastern Cascades Slopes and Foothills (9)"),
                          column(12, p("The Eastern Cascade Slopes and Foothills ecoregion is in the rainshadow of the Cascade Range (4). It has a more continental climate than ecoregions to the west, with greater temperature extremes and less precipitation. Open forests of ponderosa pine and some lodgepole pine distinguish this region from the higher ecoregions to the west where hemlock and fir forests are common, and the lower, drier ecoregions to the east where shrubs and grasslands are predominant.")),
                          column(12, p("The vegetation is adapted to the prevailing dry, continental climate and frequent fire. Historically, creeping ground fires consumed accumulated fuel and devastating crown fires were less common in dry forests. Volcanic cones and buttes are common in much of the region. A few areas of cropland and pastureland occur in the lake basins or larger river valleys.")) #,
                        ),
                        
                        fluidRow(
                          h3("Mojave Basin and Range (14)"),
                          column(12, p("Stretching across southeastern California, southern Nevada, southwest Utah, and northwest Arizona, Ecoregion 14 is composed of broad basins and scattered mountains that are generally lower, warmer, and drier than those of the Central Basin and Range (13). Its creosotebush-dominated shrub community is distinct from the saltbush–greasewood and sagebrush–grass associations that occur to the north in the Central Basin and Range (13) and Northern Basin and Range (80); it is also differs from the palo verde–cactus shrub and saguaro cactus that occur in the Sonoran Basin and Range (81) to the south.")),
                          column(12, p("In the Mojave, creosotebush, white bursage, Joshua-tree and other yuccas, and blackbrush are typical. On alkali flats, saltbush, saltgrass, alkali sacaton, and iodinebush are found. On mountains, sagebrush, juniper, and singleleaf pinyon occur. At high elevations, some ponderosa pine, white fir, limber pine, and bristlecone pine can be found. The basin soils are mostly Entisols and Aridisols that typically have a thermic temperature regime; they are warmer than those of Ecoregion 13 to the north. Heavy use of off-road vehicles and motorcycles in some areas has made the soils susceptible to wind and water erosion. Most of Ecoregion 14 is federally owned and grazing is constrained by the lack of water and forage for livestock."))
                        ),
                        
                        fluidRow(
                          h3("Northern Basin and Range (80)"),
                          column(12, p("The Northern Basin and Range consists of dissected lava plains, rocky uplands, valleys, alluvial fans, and scattered mountain ranges. Overall, it is cooler and has more available moisture than the Central Basin and Range (13) to the south. Ecoregion 80 is higher and cooler than the Snake River Plain (12) to the northeast in Idaho.")),
                          column(12, p("Valleys support sagebrush steppe or saltbush vegetation. Cool season grasses, such as Idaho fescue and bluebunch wheatgrass are more common than in Ecoregion 13 to the south. Mollisols are also more common than in the hotter and drier basins of the Central Basin and Range (13) where Aridisols support sagebrush, shadscale, and greasewood. Juniper woodlands occur on rugged, stony uplands. Ranges are covered by mountain brush and grasses (e.g. Idaho fescue) at lower and mid-elevations; at higher elevations aspen groves or forest dominated by subalpine fir can be found. Most of Ecoregion 80 is used as rangeland. The western part of the ecoregion is internally drained; its eastern stream network drains to the Snake River system."))
                        ),
                        
                        fluidRow(
                          h3("Sierra Nevada (5)"),
                          column(12, p("The Sierra Nevada is a mountainous, deeply dissected, and westerly tilting fault block. The central and southern part of the region is largely composed of granitic rocks that are lithologically distinct from the mixed geology of the Klamath Mountains (78) and the volcanic rocks of the Cascades (4). In the northern Sierra Nevada, however, the lithology has some similarities to the Klamath Mountains. A high fault scarp divides the Sierra Nevada from the Northern Basin and Range (80) and Central Basin and Range (13) to the east. Near this eastern fault scarp, the Sierra Nevada reaches its highest elevations. Here, moraines, cirques, and small lakes are common and are products of Pleistocene alpine glaciation. Large areas are above timberline, including Mt. Whitney in California, the highest point in the conterminous United States at nearly 14,500 feet. The Sierra Nevada casts a rain shadow over Ecoregions 13 and 80 to the east. The ecoregion slopes more gently toward the Central California Valley (7) to the west.")),
                          column(12, p(" The vegetation grades from mostly ponderosa pine and Douglas-fir at the lower elevations on the west side, pines and Sierra juniper on the east side, to fir and other conifers at the higher elevations. Alpine conditions exist at the highest elevations. Large areas are publicly-owned federal land, including several national parks."))
                        ),
                        
                        fluidRow(
                          h3("Southern California/Northern Baja Coast (85)"),
                          column(12, p("This ecoregion includes coastal and alluvial plains and some low hills in the coastal area of Southern California, and it extends over 200 miles south into Baja California.")),
                          column(12, p("Coastal sage scrub and chaparral vegetation communities with many endemic species were once widespread before overgrazing, clearance for agriculture, and massive urbanization occurred. Coastal sage scrub includes chamise, white sage, black sage, California buckwheat, golden yarrow, and coastal cholla. The chaparral-covered hills include ceanothus, buckeye, manzanita, scrub oak, and mountain-mahogany. Coast live oak, canyon live oak, poison oak, and California black walnut also occur. A small area of Torrey pine occurs near San Diego."))
                        ),
                        
                        fluidRow(
                          h3("Sonoran Basin and Range (81)"),
                          column(12, p("Similar in topography to the Mojave Basin and Range (14) to the north, this ecoregion contains scattered low mountains and has large tracts of federally owned lands, a large portion of which are used for military training.")),
                          column(12, p("However, the Sonoran Basin and Range is slightly hotter than the Mojave and contains large areas of palo verde-cactus shrub and giant saguaro cactus, whereas the potential natural vegetation in the Mojave is largely creosote bush. Other typical Sonoran plants include white bursage, ocotillo, brittlebush, creosote bush, catclaw acacia, cholla, desert saltbush, pricklypear, ironwood, and mesquite. Winter rainfall decreases from west to east, while summer rainfall decreases from east to west. Aridisols and Entisols are dominant with hyperthermic soil temperatures and extremely aridic soil moisture regimes."))
                        ),
                        
                        fluidRow(
                          h3("Southern California Mountains (8)"),
                          column(12, p("Similar to other ecoregions in central and southern California, the Southern California Mountains have a Mediterranean climate of hot dry summers and moist cool winters. Although Mediterranean types of vegetation such as chaparral and oak woodlands predominate in this region, the elevations are considerably higher, the summers are slightly cooler, and precipitation amounts are greater than in adjacent ecoregions, resulting in denser vegetation and some large areas of coniferous woodlands. In parts of the Transverse Range, a general slope effect causes distinct ecological differences.")),
                          column(12, p("The south-facing slopes typically have higher precipitation (30-40 inches) compared to many of the north slopes of the range (15-20 inches), but high evaporation rates on the south contribute to a cover of chaparral. On the north side of parts of the ecoregion, lower evaporation, lower annual temperatures, and slower snow melt allows for a coniferous forest that blends into desert montane habitats as it approaches the Mojave Desert ecoregion boundary. Woodland species such as Jeffrey, Coulter, and Ponderosa pines occur, along with sugar pine, white fir, bigcone Douglas-fir, and, at highest elevations, some lodgepole and limber pines. Severe erosion problems are common where the vegetation cover has been destroyed by fire or overgrazing. Large portions of the region are National Forest public land."))
                        ),
                        
                        # END ECOREGION DESCRIPTIONS
                        
                      ) # End mainPanel for Ecoregions
                      
             ), # End tabPanel for Ecoregion Information
             
             
             # Map tab ----
             tabPanel(title = "Map", icon = icon("map"),
                      sidebarLayout(
                        
                        sidebarPanel(width = 4,
                                     
                                     # trying cancel button----
                                     actionButton("button", "Go to Sub About page"),
                                     
                                     # ecoregion type selectInput----
                                     selectInput(inputId = "ecoregion_type_input",
                                                 label = "Select ecoregion:",
                                                 choices = names_gde,
                                                 selected = 'gde_northern_basin',
                                                 multiple = F
                                                 
                                     ), # END selectInput
                                     
                                     fluidRow(
                                       # adjusting space between raster buttons
                                       tags$style(type='text/css',"
                                                  .btn {
                                                   margin-bottom: 60px;}
                                                  "), # end CSS spacing for fire metric buttons
                                       
                                       # buttons for RASTER layers
                                       column(6,
                                              checkboxGroupButtons('type_raster',
                                                                   'Select Raster Type',
                                                                   choices = c('Fire Count', 'TSLF', 'Fire Threat', 'Burn Severity'),
                                                                   size = ('lg'),
                                                                   individual = T,
                                                                   direction = 'vertical',
                                                                   # individual = TRUE,
                                                                   checkIcon = list(
                                                                     yes = icon("square-check"),
                                                                     no = icon("square")
                                                                   ))
                                       ),
                                       
                                       # transparency for RASTER layers
                                       column(6,
                                              sliderInput('alpha1','Fire Count Transparency',
                                                          step = 0.1,
                                                          min = 0.1, max = 1, value = 0.8),
                                              sliderInput('alpha2','TSLF Transparency',
                                                          step = 0.1,
                                                          min = 0.1, max = 1, value = 0.8),
                                              sliderInput('alpha3', 'Fire Threat Transparency',
                                                          step = 0.1,
                                                          min = 0.1, max = 1, value = 0.8),
                                              sliderInput('alpha4', 'Burn Severity Transparency',
                                                          step = 0.1,
                                                          min = 0.1, max = 1, value = 0.8)
                                       )
                                     ) # End fluidRow for RASTER options
                                     
                        ), # End sidebarPanel for RASTER options
                        
                        # interactive GDE map
                        mainPanel(
                          
                          # TMAP UI
                          fluidRow(
                            h3("Groundwater-Dependent Ecosystems are automatically loaded in ",
                               span(style = "color: #0f851e;", "green"), ".")
                            
                          ),
                          
                          tmapOutput("map", height = 600, width = 800) %>% withSpinner()
                          
                        ) #, # End Leaflet main panel
                        
                      )#, # End sidebarLayout
                      
             ), # End tabPanel
             
             # Statistics tab----
             tabPanel(title = "Statistics", icon = icon("chart-simple"),
                      
                      fluidRow(
                        
                        column(6,
                               "This map shows...",
                               img(src='fire_count_map_california.png', width = "100%", height = "100%", align = "left"),
                        ),
                        column(6,
                               "This burn severity map",
                               img(src='burn_severity_map_california.jpg', width = "100%", height = "100%", align = "right"),
                        ),
                        
                      ),
                      
                      # space between california maps and statistics
                      br(),
                      br(),
                      br(),
                      br(),
                      fluidRow(
                        sidebarPanel(width = 3,
                                     
                                     selectInput(inputId = "ecoregion_stats_type_input",
                                                 label = "Select ecoregion:",
                                                 choices = names_fire_count_hist, # names_gde
                                                 selected = 'fire_count_histogram_northern_basin',
                                                 multiple = F
                                                 
                                     ), # END pickerInput
                                     
                        ), # End sidebarPanel
                        
                        # Stats Main Panel
                        mainPanel(width = 9,
                                  
                                  fluidPage(
                                    
                                    fluidRow(
                                      
                                      column(6,
                                             plotOutput("fire_count_hist")),
                                      
                                      column(6,
                                             plotOutput("burn_severity_hist")),
                                      
                                    ),
                                    headerPanel(""),
                                    
                                  ), # End fluidPage
                                  
                        ) # End mainPanel
                        
                      ) # End fluidRow for interactive histogram
                      
             ), # End tabPanel
             
             
  ), # End navbarPage
  
) # End fluidPage

