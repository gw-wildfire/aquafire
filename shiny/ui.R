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
             tabPanel("About", icon = icon("info-circle"),
                      fluidPage(
                        fluidRow(
                          
                          # Some nice images or maps about our project
                          
                        ), # End fluidRow
                        
                        # Background ----
                        h1("Background"),
                        
                        fluidRow(
                          column(12, p("Eight of the largest 10 wildfires in California have occured in the past five years. And although there has been extensive research on wildfire models designed to predict occurence and severity, little research has been done to understand and quantify how subsurface water may effect these wildfire models. This project aims to understand how Groundwater-Dependent Ecosystems (GDEs), which are ecosystems that are dependent on groundwater year-round, might play a role in wildfires."),
                          )
                        ), # End Background
                        
                        h1("Significance"),
                        
                        fluidRow(
                          column(12, p("This app was designed to display statistical and spatial relationships between groundwater-dependent ecosystems and wildfires. It may be used as a tool to understand how GDEs play a role in lessening the severity of a wildfire or may even act as a natural fire break."),
                                 
                          ),
                          
                        ), # End Significance
                        
                        h1("How to Use This App"),
                        
                        fluidRow(
                          column(12, p("This Shiny App has 2 main tabs, the Map tab and the Statistics tap. In the Map tab, one of the 13 ecoregions in california, designated by the EPA, can be selected and will display all GDEs within that ecoregion. Click on a GDE and information including wetland type, dominant vegetation, and wildfire metrics will be shown. On the left panel, 4 fire layers can be toggled on and off. These layers are: fire count"),
                          )
                        ), # End How to Use This App
                        
                        h1("Data Policy Information"),
                        
                        fluidRow(
                          column(12, p("Maybe make a graph for displaying the data and metadata?"),
                          ),
                          
                          tableOutput("dataTable")
                          
                        ), # End Data Policy Info
                        
                        h1("About Us"),
                        
                        fluidRow(
                          column(12, p("We are Jillian Allison, Meagan Brown, Andre Dextre, and Wade Sedgwick. This App was designed during our Master in Environmental Data Science Program for use by the Dangermond Preserve, owned by The Nature Conservancy."),
                          )
                        ), # End About Us
                        
                        
                        
                      ), # End fluidPage
                      
             ), # End Tab Panel for About page
             
             # Ecoregion Information ----
             tabPanel(title = "Ecoregion Information", icon = icon("layer-group"),
                      
                      # Stats Main Panel----
                      mainPanel(
                        
                        h1("Ecoregion Information"),
                        
                        tmapOutput("main_map", height = 600, width = 1000),
                        
                        fluidRow(
                          h3("4. Cascades"),
                          column(12, p("This mountainous ecoregion stretches from the central portion of western Washington, through the spine of Oregon, and includes a disjunct area in northern California. It is underlain by Cenozoic volcanics and much of the region has been affected by alpine glaciation. In Oregon and Washington, the western Cascades are older, lower, and dissected by numerous, steep-sided stream valleys. A high plateau occurs to the east, with both active and dormant volcanoes. Some peaks reach over 14,000 feet. Soils are mostly of cryic and frigid temperature regimes, with some mesic soils at low elevations and in the south. Andisols and Inceptisols are common.")),
                          column(12, p("The Cascades have a moist, temperate climate that supports an extensive and highly productive coniferous forest that is intensively managed for logging. At lower elevations in the north, Douglas-fir, western hemlock, western red cedar, big leaf maple, and red alder are typical. At higher elevations, Pacific silver fir, mountain hemlock, subalpine fir, noble fir, and lodgepole pine occur. In southern Oregon and California, more incense cedar, white fir, and Shasta red fir occur along with other Sierran species. Subalpine meadows and rocky alpine zones occur at highest elevations."))
                        ), # End FluidRow Cascades
                        
                        fluidRow(
                          h3("13. Central Basin and Range"),
                          column(12, p("The Central Basin and Range ecoregion is composed of northerly trending, fault-block ranges and intervening, drier basins. In the higher mountains, woodland, mountain brush, and scattered open forest are found. Lower elevation basins, slopes, and alluvial fans are either shrub- and grass-covered, shrub-covered, or barren. The potential natural vegetation, in order of decreasing elevation and ruggedness, is scattered western spruce-fir forest, juniper woodland, Great Basin sagebrush, and saltbush-greasewood.")),
                          column(12, p("The Central Basin and Range is internally-drained by ephemeral streams and once contained ancient Lake Lahontan. In general, Ecoregion 13 is warmer and drier than the Northern Basin and Range (80) and has more shrubland and less grassland than the Snake River Plain (12). Soils grade upslope from mesic Aridisols to frigid Mollisols. The land is primarily used for grazing. In addition, some irrigated cropland is found in valleys near mountain water sources. The region is not as hot as the Mojave Basin and Range (14) and Sonoran Basin and Range (81) ecoregions and it has a greater percent of land that is grazed."))
                        ), # End FluidRow Central Basin
                        
                        fluidRow(
                          h3("6. Central California Foothills and Coastal Mountains"),
                          column(12, p("The primary distinguishing characteristic of this ecoregion is its Mediterranean climate of hot dry summers and cool moist winters, and associated vegetative cover comprising mainly chaparral and oak woodlands; grasslands occur in some lower elevations and patches of pine are found at higher elevations. ")),
                          column(12, p("Surrounding the lower and flatter Central California Valley (7), most of the region consists of open low mountains or foothills, but there are some areas of irregular plains and some narrow valleys. Large areas are in ranch lands and grazed by domestic livestock. Relatively little land has been cultivated, although some valleys are major agricultural centers such as the Salinas or the wine vineyard center of Napa and Sonoma."))
                        ),
                        
                        fluidRow(
                          h3("Central California Valley"),
                          column(12, p("Flat, intensively farmed plains with long, hot dry summers and mild winters distinguish the Central California Valley from its neighboring ecoregions that are either hilly or mountainous, forest or shrub covered, and generally nonagricultural. It includes the flat valley basins of deep sediments adjacent to the Sacramento and San Joaquin rivers, as well as the fans and terraces around the edge of the valley. The two major rivers flow from opposite ends of the Central Valley, flowing into the Delta and into San Pablo Bay. ")),
                          column(12, p("It once contained extensive prairies, oak savannas, desert grasslands in the south, riparian woodlands, freshwater marshes, and vernal pools. More than half of the region is now in cropland, about three fourths of which is irrigated. Environmental concerns in the region include salinity due to evaporation of irrigation water, groundwater contamination from heavy use of agricultural chemicals, wildlife habitat loss, and urban sprawl."))
                        ),
                        
                        fluidRow(
                          h3("Coast Range"),
                          column(12, p("The low mountains of the Coast Range of western Washington, western Oregon, and northwestern California are covered by highly productive, rain-drenched coniferous forests. Sitka spruce forests originally dominated the fog-shrouded coast, while a mosaic of western redcedar, western hemlock, and seral Douglas-fir blanketed inland areas. Today, Douglas-fir plantations are prevalent on the intensively logged and managed landscape. In California, redwood forests are a dominant component in much of the region. In Oregon and Washington, soils are typically Inceptisols and Andisols, while Alfisols are common in the California portion.")),
                          column(12, p("Landslides and debris slides are common, and lithology influences land management strategies. In Oregon and Washington, slopes underlain by sedimentary rock are more susceptible to failure following clear-cutting and road building than those underlain by volcanic rocks. Coastal headlands, high and low marine terraces, sand dunes, and beaches also characterize the region.")),
                          
                          fluidRow(
                            h3("Eastern Cascades Slopes and Foothills"),
                            column(12, p(""))
                          ),
                          
                          fluidRow(
                            h3("Mojave Basin and Range"),
                            column(12, p(""))
                          ),
                          
                          fluidRow(
                            h3("Northern Basin and Range"),
                            column(12, p(""))
                          ),
                          
                          fluidRow(
                            h3("Sierra Nevada"),
                            column(12, p(""))
                          ),
                          
                          fluidRow(
                            h3("Southern California/Northern Baja Coast"),
                            column(12, p(""))
                          ),
                          
                          fluidRow(
                            h3("Sonoran Basin and Range"),
                            column(12, p(""))
                          ),
                          
                          fluidRow(
                            h3("Southern California Mountains"),
                            column(12, p(""))
                          ),
                          
                        ), # End FluidRow Coast Range
                        
                        
                        # END ECOREGION DESCRIPTIONS
                        
                        
                        fluidRow(
                          column(12, p("ecoregion information"),
                                 
                          ),
                          
                        ), # End Ecoregion Information
                        # ecoregion info GO HERE
                        
                      ) # End mainPanel
                      
             ), # End tabPanel for Ecoregion Information
             
             
             # Map ----
             tabPanel(title = "Map", icon = icon("map"),
                      sidebarLayout(
                        
                        sidebarPanel(width = 3,
                                     
                                     # ),----
                                     # ecoregion type pickerInput
                                     selectInput(inputId = "ecoregion_type_input",
                                                 label = "Select ecoregion:",
                                                 choices = names_gde,
                                                 selected = 'gde_northern_basin',
                                                 multiple = F
                                                 
                                     ), # END pickerInput
                                     
                                     fluidRow(
                                       tags$style(type='text/css',"
                                                  .btn {
                                                   margin-bottom: 60px; /* Add a margin-bottom of 10px */ }
                                                  "), # end CSS spacing for fire metric buttons
                                       
                                       column(6,
                                              checkboxGroupButtons('type_raster',
                                                                   'Select Raster Type',
                                                                   choices = c('Fire Count Raster', 'TSLF Raster', 'Fire Threat Raster', 'Burn Severity Raster'),
                                                                   size = ('lg'),
                                                                   individual = T,
                                                                   direction = 'vertical',
                                                                   # individual = TRUE,
                                                                   checkIcon = list(
                                                                     yes = icon("square-check"),
                                                                     no = icon("square")
                                                                   ))
                                       ),
                                       
                                       column(6,
                                              sliderInput('alpha1','Fire Count Alpha',
                                                          step = 0.1,
                                                          min = 0.1, max = 1, value = 0.8),
                                              sliderInput('alpha2','TSLF Alpha',
                                                          step = 0.1,
                                                          min = 0.1, max = 1, value = 0.8),
                                              sliderInput('alpha3', 'Fire Threat Alpha',
                                                          step = 0.1,
                                                          min = 0.1, max = 1, value = 0.3),
                                              sliderInput('alpha4', 'Burn Severity Alpha',
                                                          step = 0.1,
                                                          min = 0.1, max = 1, value = 0.8)
                                       )
                                     )
                                     
                                     
                                     
                                     
                        ), # End sidebarPanel
                        
                        # interactive map of TSLB
                        mainPanel(
                          
                          # TMAP UI
                          
                          tmapOutput("map", height = 600, width = 800) %>% withSpinner()
                          
                        )#, # End Leaflet main panel
                        
                      )#, # End sidebarLayout
                      
             ), # End tabPanel
             
             
             
             # Statistics ----
             tabPanel(title = "Statistics", icon = icon("chart-simple"),
                      
                      # sidebarLayout
                      #                                  sidebarLayout(
                      
                      sidebarPanel(width = 3,
                                   
                                   selectInput(inputId = "ecoregion_stats_type_input",
                                               label = "Select ecoregion:",
                                               choices = names_gde,
                                               selected = 'gde_northern_basin',
                                               #choices = names(gde_list), #?? would I need a tm df where ecoregion_type is a column??
                                               # options = list(pickerOptions(actionsBox = TRUE)),
                                               #selected = "socal_norbaja_coast_gdes",
                                               multiple = F
                                               
                                   ), # END pickerInput
                                   
                      ), # End sidebarPanel 
                      
                      # Stats Main Panel----
                      mainPanel(
                        
                        imageOutput("stats"),
                        
                        # STATS GO HERE
                        # img(stats)
                        img(src='fire_count_8_kable.png', align = "right", height = 200, width = 350),
                        img(src='fire_count_8_violin.png', align = "right", height = 200, width = 500)
                        
                      ) # End mainPanel
                      
             ), # End tabPanel
             
  ), # End navbarPage
  
) # End Navigation Bar

