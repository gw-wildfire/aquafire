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
                          column(12, p("The Cascades have a moist, temperate climate that supports an extensive and highly productive coniferous forest that is intensively managed for logging. At lower elevations in the north, Douglas-fir, western hemlock, western red cedar, big leaf maple, and red alder are typical. At higher elevations, Pacific silver fir, mountain hemlock, subalpine fir, noble fir, and lodgepole pine occur. In southern Oregon and California, more incense cedar, white fir, and Shasta red fir occur along with other Sierran species. Subalpine meadows and rocky alpine zones occur at highest elevations.")),
                          column(12, p("In the Cascades ecoregion, groundwater is vital for groundwater-dependent ecosystems (GDEs) due to the mountainous terrain and presence of aquifers. Fire significantly impacts vegetation composition, with some GDEs relying on periodic fires for regeneration. Fire regimes, historically characterized by low- to moderate-intensity fires, have been altered by fire suppression and land use changes. Fires can affect groundwater recharge, potentially impacting GDEs' access to water. After a fire, GDEs undergo recovery influenced by soil, seed availability, and groundwater, supporting post-fire vegetation reestablishment."))
                        ), # End FluidRow Cascades
                        
                        fluidRow(
                          h3("Central Basin and Range (13)"),
                          column(12, p("The Central Basin and Range ecoregion is composed of northerly trending, fault-block ranges and intervening, drier basins. In the higher mountains, woodland, mountain brush, and scattered open forest are found. Lower elevation basins, slopes, and alluvial fans are either shrub- and grass-covered, shrub-covered, or barren. The potential natural vegetation, in order of decreasing elevation and ruggedness, is scattered western spruce-fir forest, juniper woodland, Great Basin sagebrush, and saltbush-greasewood.")),
                          column(12, p("The Central Basin and Range is internally-drained by ephemeral streams and once contained ancient Lake Lahontan. In general, Ecoregion 13 is warmer and drier than the Northern Basin and Range (80) and has more shrubland and less grassland than the Snake River Plain (12). Soils grade upslope from mesic Aridisols to frigid Mollisols. The land is primarily used for grazing. In addition, some irrigated cropland is found in valleys near mountain water sources. The region is not as hot as the Mojave Basin and Range (14) and Sonoran Basin and Range (81) ecoregions and it has a greater percent of land that is grazed.")),
                          column(12, p("In the Central Basin and Range ecoregion, the relationship between groundwater-dependent ecosystems (GDEs) and wildfires is complex. The ecoregion consists of diverse vegetation types, each with varying adaptations to fire. The warmer and drier climate of the ecoregion contributes to the potential for more frequent and intense wildfires, with shrubland and grassland fueling the fire risk. Wildfires can directly impact GDEs by altering vegetation composition and structure, while also affecting hydrological conditions such as runoff patterns and groundwater recharge rates. Grazing activities and land use, primarily focused on grazing and irrigated cropland, can influence vegetation patterns and fire risk. Understanding the specific interactions between wildfires and GDEs in this ecoregion would require further research and analysis."))
                        ), # End FluidRow Central Basin
                        
                        fluidRow(
                          h3("Central California Foothills and Coastal Mountains (6)"),
                          column(12, p("The primary distinguishing characteristic of this ecoregion is its Mediterranean climate of hot dry summers and cool moist winters, and associated vegetative cover comprising mainly chaparral and oak woodlands; grasslands occur in some lower elevations and patches of pine are found at higher elevations. ")),
                          column(12, p("Surrounding the lower and flatter Central California Valley (7), most of the region consists of open low mountains or foothills, but there are some areas of irregular plains and some narrow valleys. Large areas are in ranch lands and grazed by domestic livestock. Relatively little land has been cultivated, although some valleys are major agricultural centers such as the Salinas or the wine vineyard center of Napa and Sonoma.")),
                          column(12, p("In the Central California Foothills and Coastal Mountains ecoregion, groundwater-dependent ecosystems and fire are closely connected due to the Mediterranean climate and vegetation patterns. Vegetation types like chaparral and oak woodlands rely on groundwater availability. Groundwater plays a vital role in supporting vegetation, particularly during dry periods. Fire is a natural occurrence in this ecoregion, with certain plant species adapted to and reliant on periodic burning. Fire can affect groundwater dynamics through increased runoff and erosion, but it can also enhance groundwater recharge by altering infiltration rates. Groundwater-dependent ecosystems are vulnerable to fire impacts, including changes in vegetation composition and structure. Human activities, such as land use changes and groundwater extraction, can further influence this relationship."))
                        ), # End Central Foothills Coastal Mountains
                        
                        fluidRow(
                          h3("Central California Valley (7)"),
                          column(12, p("Flat, intensively farmed plains with long, hot dry summers and mild winters distinguish the Central California Valley from its neighboring ecoregions that are either hilly or mountainous, forest or shrub covered, and generally nonagricultural. It includes the flat valley basins of deep sediments adjacent to the Sacramento and San Joaquin rivers, as well as the fans and terraces around the edge of the valley. The two major rivers flow from opposite ends of the Central Valley, flowing into the Delta and into San Pablo Bay. ")),
                          column(12, p("It once contained extensive prairies, oak savannas, desert grasslands in the south, riparian woodlands, freshwater marshes, and vernal pools. More than half of the region is now in cropland, about three fourths of which is irrigated. Environmental concerns in the region include salinity due to evaporation of irrigation water, groundwater contamination from heavy use of agricultural chemicals, wildlife habitat loss, and urban sprawl.")),
                          column(12, p("In the Central California Valley ecoregion, the relationship between groundwater-dependent ecosystems (GDEs) and fire is complex. GDEs rely on groundwater and can include habitats like riparian woodlands and freshwater marshes. Wildfires pose a threat to GDEs, causing habitat loss and impacting species dependent on these areas. However, fire can also be a natural process, benefiting GDEs by controlling invasive species and promoting diversity. Land use changes, such as agriculture and irrigation, can alter fire dynamics and groundwater availability. Fire management strategies aim to balance fire control and GDE conservation, using prescribed burns cautiously to mimic natural fire regimes."))
                        ), # End Central Valley
                        
                        fluidRow(
                          h3("Coast Range (1)"),
                          column(12, p("The low mountains of the Coast Range of western Washington, western Oregon, and northwestern California are covered by highly productive, rain-drenched coniferous forests. Sitka spruce forests originally dominated the fog-shrouded coast, while a mosaic of western redcedar, western hemlock, and seral Douglas-fir blanketed inland areas. Today, Douglas-fir plantations are prevalent on the intensively logged and managed landscape. In California, redwood forests are a dominant component in much of the region. In Oregon and Washington, soils are typically Inceptisols and Andisols, while Alfisols are common in the California portion.")),
                          column(12, p("Landslides and debris slides are common, and lithology influences land management strategies. In Oregon and Washington, slopes underlain by sedimentary rock are more susceptible to failure following clear-cutting and road building than those underlain by volcanic rocks. Coastal headlands, high and low marine terraces, sand dunes, and beaches also characterize the region.")),
                          column(12, p("In the Coast Range ecoregion, vegetation composition varies with coniferous forests dominating the landscape, each with different fire regimes and responses. Fire suppression has disrupted natural fire regimes, altering vegetation and impacting groundwater-dependent ecosystems (GDEs). Groundwater plays a vital role in supporting GDEs, but fire can have both direct and indirect effects on groundwater resources. Post-fire, GDEs undergo changes in vegetation and hydrology, influenced by fire severity and management practices. Human activities like logging and road building can further impact GDEs' susceptibility to fire and alter their hydrological functioning."))
                        ),
                        
                        fluidRow(
                          h3("Eastern Cascades Slopes and Foothills (9)"),
                          column(12, p("The Eastern Cascade Slopes and Foothills ecoregion is in the rainshadow of the Cascade Range (4). It has a more continental climate than ecoregions to the west, with greater temperature extremes and less precipitation. Open forests of ponderosa pine and some lodgepole pine distinguish this region from the higher ecoregions to the west where hemlock and fir forests are common, and the lower, drier ecoregions to the east where shrubs and grasslands are predominant.")),
                          column(12, p("The vegetation is adapted to the prevailing dry, continental climate and frequent fire. Historically, creeping ground fires consumed accumulated fuel and devastating crown fires were less common in dry forests. Volcanic cones and buttes are common in much of the region. A few areas of cropland and pastureland occur in the lake basins or larger river valleys.")),
                          column(12, p("Groundwater-dependent ecosystems (GDEs) in the Eastern Cascade Slopes and Foothills ecoregion include riparian areas, wetlands, and springs, which are supported by groundwater from the region's volcanic cones and buttes, river valleys, and lake basins. Fire management practices in this region, given its history of frequent ground fires, can also affect GDEs. Controlled burns are often used to reduce accumulated fuel loads and prevent more severe fires. However, if not carefully managed, these controlled burns can impact GDEs through the mechanisms mentioned above. Given the prevailing dry, continental climate and the likely intensification of these conditions due to climate change, maintaining the health of GDEs and their resilience to fire is an important consideration for ecological management and conservation in this region."))
                        ),
                        
                        fluidRow(
                          h3("Mojave Basin and Range (14)"),
                          column(12, p("Stretching across southeastern California, southern Nevada, southwest Utah, and northwest Arizona, Ecoregion 14 is composed of broad basins and scattered mountains that are generally lower, warmer, and drier than those of the Central Basin and Range (13). Its creosotebush-dominated shrub community is distinct from the saltbush–greasewood and sagebrush–grass associations that occur to the north in the Central Basin and Range (13) and Northern Basin and Range (80); it is also differs from the palo verde–cactus shrub and saguaro cactus that occur in the Sonoran Basin and Range (81) to the south.")),
                          column(12, p("In the Mojave, creosotebush, white bursage, Joshua-tree and other yuccas, and blackbrush are typical. On alkali flats, saltbush, saltgrass, alkali sacaton, and iodinebush are found. On mountains, sagebrush, juniper, and singleleaf pinyon occur. At high elevations, some ponderosa pine, white fir, limber pine, and bristlecone pine can be found. The basin soils are mostly Entisols and Aridisols that typically have a thermic temperature regime; they are warmer than those of Ecoregion 13 to the north. Heavy use of off-road vehicles and motorcycles in some areas has made the soils susceptible to wind and water erosion. Most of Ecoregion 14 is federally owned and grazing is constrained by the lack of water and forage for livestock.")),
                          column(12, p("In the Mojave Basin and Range, fire regimes are typically characterized by infrequent, low-intensity fires. The vegetation in this region has adapted to these fire regimes, with certain plants having fire-adaptive traits like resprouting or producing fire-resistant seeds. Fire plays important roles in Groundwater-Dependent Ecosystems (GDEs) in this area. Firstly, it can reduce the density of woody vegetation, creating open conditions that benefit native plant species. This is particularly crucial for GDEs that face encroachment by woody plants, which can outcompete and displace groundwater-dependent vegetation. Secondly, fire can enhance nutrient cycling and soil fertility by releasing nutrients back into the soil, stimulating vegetation growth. However, fire also presents risks and challenges for GDEs. It can alter the hydrology of the landscape by reducing vegetation cover and increasing surface runoff, potentially affecting groundwater levels and flows."))
                        ),
                        
                        fluidRow(
                          h3("Northern Basin and Range (80)"),
                          column(12, p("The Northern Basin and Range consists of dissected lava plains, rocky uplands, valleys, alluvial fans, and scattered mountain ranges. Overall, it is cooler and has more available moisture than the Central Basin and Range (13) to the south. Ecoregion 80 is higher and cooler than the Snake River Plain (12) to the northeast in Idaho.")),
                          column(12, p("Valleys support sagebrush steppe or saltbush vegetation. Cool season grasses, such as Idaho fescue and bluebunch wheatgrass are more common than in Ecoregion 13 to the south. Mollisols are also more common than in the hotter and drier basins of the Central Basin and Range (13) where Aridisols support sagebrush, shadscale, and greasewood. Juniper woodlands occur on rugged, stony uplands. Ranges are covered by mountain brush and grasses (e.g. Idaho fescue) at lower and mid-elevations; at higher elevations aspen groves or forest dominated by subalpine fir can be found. Most of Ecoregion 80 is used as rangeland. The western part of the ecoregion is internally drained; its eastern stream network drains to the Snake River system.")),
                          column(12, p("In the Northern Basin and Range ecoregion, the vegetation composition varies, including sagebrush steppe, saltbush, juniper woodlands, mountain brush, grasses, aspen groves, and subalpine fir forests, each with different fire adaptations. The ecoregion's fire regimes are influenced by its cooler climate and moisture availability, potentially impacting the frequency, intensity, and extent of fires. Groundwater availability, especially in valleys and alluvial fans, affects GDEs by influencing vegetation density, fuel moisture content, and fire behavior. Fires can alter the vegetation and structure of GDEs and impact their hydrological dynamics, including infiltration rates and surface runoff patterns."))
                        ),
                        
                        fluidRow(
                          h3("Sierra Nevada (5)"),
                          column(12, p("The Sierra Nevada is a mountainous, deeply dissected, and westerly tilting fault block. The central and southern part of the region is largely composed of granitic rocks that are lithologically distinct from the mixed geology of the Klamath Mountains (78) and the volcanic rocks of the Cascades (4). In the northern Sierra Nevada, however, the lithology has some similarities to the Klamath Mountains. A high fault scarp divides the Sierra Nevada from the Northern Basin and Range (80) and Central Basin and Range (13) to the east. Near this eastern fault scarp, the Sierra Nevada reaches its highest elevations. Here, moraines, cirques, and small lakes are common and are products of Pleistocene alpine glaciation. Large areas are above timberline, including Mt. Whitney in California, the highest point in the conterminous United States at nearly 14,500 feet. The Sierra Nevada casts a rain shadow over Ecoregions 13 and 80 to the east. The ecoregion slopes more gently toward the Central California Valley (7) to the west.")),
                          column(12, p(" The vegetation grades from mostly ponderosa pine and Douglas-fir at the lower elevations on the west side, pines and Sierra juniper on the east side, to fir and other conifers at the higher elevations. Alpine conditions exist at the highest elevations. Large areas are publicly-owned federal land, including several national parks.")),
                          column(12, p("In the Sierra Nevada ecoregion, the vegetation is diverse, including ponderosa pine, Douglas-fir, pines, Sierra juniper, fir, and other conifers. Fire regimes vary based on elevation, vegetation composition, and climate, with lower elevations experiencing more frequent fires and higher elevations experiencing less frequent but more intense fires. Wildfires can directly damage vegetation within groundwater-dependent ecosystems (GDEs), impacting hydrological processes and groundwater availability. Indirect effects include changes in post-fire vegetation composition, nutrient cycling, and ecosystem structure. GDEs, especially riparian areas and wetlands, can serve as refugia for species during fires due to their higher moisture levels. Fire management practices aim to balance fire control and GDE conservation, employing prescribed burns and other strategies to mimic natural fire regimes, reduce fuel loads, and promote the health and diversity of GDEs."))
                        ),
                        
                        fluidRow(
                          h3("Southern California/Northern Baja Coast (85)"),
                          column(12, p("This ecoregion includes coastal and alluvial plains and some low hills in the coastal area of Southern California, and it extends over 200 miles south into Baja California.")),
                          column(12, p("Coastal sage scrub and chaparral vegetation communities with many endemic species were once widespread before overgrazing, clearance for agriculture, and massive urbanization occurred. Coastal sage scrub includes chamise, white sage, black sage, California buckwheat, golden yarrow, and coastal cholla. The chaparral-covered hills include ceanothus, buckeye, manzanita, scrub oak, and mountain-mahogany. Coast live oak, canyon live oak, poison oak, and California black walnut also occur. A small area of Torrey pine occurs near San Diego.")),
                          column(12, p("In the Southern California/Northern Baja Coast ecoregion, vegetation communities like coastal sage scrub and chaparral have evolved fire-resistant traits to thrive in fire-prone environments. Frequent, low-intensity fires historically maintained species diversity and prevented non-native plant encroachment. Fire regulates vegetation dynamics by clearing debris, promoting germination of fire-adapted species, and creating diverse habitats. Groundwater availability influences fire occurrence, with higher groundwater areas experiencing more fire-prone conditions. Groundwater-dependent ecosystems aid post-fire recovery by providing moisture, supporting vegetation reestablishment, and acting as refugia for plants and animals."))
                        ),
                        
                        fluidRow(
                          h3("Sonoran Basin and Range (81)"),
                          column(12, p("Similar in topography to the Mojave Basin and Range (14) to the north, this ecoregion contains scattered low mountains and has large tracts of federally owned lands, a large portion of which are used for military training.")),
                          column(12, p("However, the Sonoran Basin and Range is slightly hotter than the Mojave and contains large areas of palo verde-cactus shrub and giant saguaro cactus, whereas the potential natural vegetation in the Mojave is largely creosote bush. Other typical Sonoran plants include white bursage, ocotillo, brittlebush, creosote bush, catclaw acacia, cholla, desert saltbush, pricklypear, ironwood, and mesquite. Winter rainfall decreases from west to east, while summer rainfall decreases from east to west. Aridisols and Entisols are dominant with hyperthermic soil temperatures and extremely aridic soil moisture regimes.")),
                          column(12, p("In the Sonoran Basin and Range ecoregion, vegetation types like palo verde-cactus shrub, giant saguaro cactus, and various other plant species have different adaptations to fire. Fire regimes in the region are influenced by seasonal rainfall patterns, with winter rainfall decreasing from west to east and summer rainfall decreasing from east to west. Groundwater availability affects vegetation density, fuel moisture content, and fire behavior, with limited groundwater leading to sparser vegetation and potentially reducing the occurrence of large-scale fires. Human activities, particularly military training and controlled burns, can also impact the vegetation and fire dynamics in the ecoregion."))
                        ),
                        
                        fluidRow(
                          h3("Southern California Mountains (8)"),
                          column(12, p("Similar to other ecoregions in central and southern California, the Southern California Mountains have a Mediterranean climate of hot dry summers and moist cool winters. Although Mediterranean types of vegetation such as chaparral and oak woodlands predominate in this region, the elevations are considerably higher, the summers are slightly cooler, and precipitation amounts are greater than in adjacent ecoregions, resulting in denser vegetation and some large areas of coniferous woodlands. In parts of the Transverse Range, a general slope effect causes distinct ecological differences.")),
                          column(12, p("The south-facing slopes typically have higher precipitation (30-40 inches) compared to many of the north slopes of the range (15-20 inches), but high evaporation rates on the south contribute to a cover of chaparral. On the north side of parts of the ecoregion, lower evaporation, lower annual temperatures, and slower snow melt allows for a coniferous forest that blends into desert montane habitats as it approaches the Mojave Desert ecoregion boundary. Woodland species such as Jeffrey, Coulter, and Ponderosa pines occur, along with sugar pine, white fir, bigcone Douglas-fir, and, at highest elevations, some lodgepole and limber pines. Severe erosion problems are common where the vegetation cover has been destroyed by fire or overgrazing. Large portions of the region are National Forest public land.")),
                          column(12, p("In the Southern California Mountains ecoregion, the vegetation consists of Mediterranean types such as chaparral, oak woodlands, and coniferous woodlands at higher elevations. The region's hot, dry summers make it prone to wildfires, with highly flammable chaparral vegetation on south-facing slopes. GDEs in the ecoregion are impacted by wildfires, with direct effects on vegetation loss and habitat alteration. Indirect effects include changes in hydrological processes, potentially affecting groundwater recharge patterns and causing erosion issues. The ecoregion's large portions of National Forest public land require effective land management practices to mitigate wildfire risks, including fire suppression, controlled burns, and grazing management, to protect GDEs and maintain their health and functioning."))
                        ),
                        
                        # END ECOREGION DESCRIPTIONS
                        
                      ) # End mainPanel for Ecoregions
                      
             ), # End tabPanel for Ecoregion Information
             
             
             # Map tab ----
             tabPanel(title = "Map", icon = icon("map"),
                      sidebarLayout(
                        
                        sidebarPanel(width = 4,
                                     
                                     # ecoregion type selectInput----
                                     selectInput(inputId = "ecoregion_type_input",
                                                 label = "Select ecoregion:",
                                                 choices = names_gde,
                                                 selected = 'gde_socal_norbaja_coast', # gde_northern_basin
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
                      
                      tabsetPanel(
                        tabPanel(title = "California Stats",
                                 
                                 
                                 
                                 fluidRow(
                                   
                                   column(6,
                                          h3("Fire Frequency Map of California"),
                                   ),
                                   column(6,
                                          h3("Burn Severity Map of California"),
                                   ),
                                   
                                 ),
                                 
                                 fluidRow(
                                   
                                   column(6,
                                          img(src='fire_count_map_california.png', width = "90%", height = "100%", align = "left"),
                                   ),
                                   column(6,
                                          img(src='burn_severity_map_california.png', width = "90%", height = "100%", align = "right"),
                                          
                                   ),
                                   
                                 ),
                                 
                                 fluidRow(
                                   column(6,
                                          p("The map above shows how groundwater dependent ecosystems (GDEs) affect fire frequency across the 13 different ecoregions of California. Areas in teal represent ecoregions where there were fewer fires in GDEs than in non-GDEs since 1950. There were 8 ecoregions that saw a decreased fire frequency in GDEs: the Central Basin & Range, Mojave Basin & Range, Cascades, Sierra Nevada, Klamath Mountains, Southern California Mountains, Northern Basin & Range, and Eastern Cascades and Foothills. These ecoregions tend to be higher elevation or forested regions, where GDEs may be more moist and surrounding vegetation may be drier and more readily flammable. One ecoregion, Southern California / the Northern Baja Coast, saw an increase in fire frequency in GDEs. This may be due to flammable invasive species such as Arundo, which grows extensively in riparian ecosystems such as GDEs. Areas in light blue indicate that we found no significant difference in the number of fires since 1950 in GDEs and non-GDEs. More information for each ecoregion can be found using the dropdown menus below."),
                                          p("These results were obtained using a difference in means bootstrapping approach to test if the difference in mean fire count since 1950 was significantly different in GDEs and non-GDEs. This approach involved resampling our sample dataset 1000 times with replacement, and the difference in mean fire count in GDEs vs. non-GDEs (non-GDE mean minus GDE mean) was calculated for each resample. Then, we analyzed the distribution of the 1000 differences in means, and determined if the estimated population difference in means was significantly different from 0 or not. For example: If the difference in means was 0, that would mean that there was no difference in fire counts in GDEs when compared to non-GDEs in that ecoregion. Our fire frequency data was obtained from CalFire’s Wildfire Perimeters dataset, which contains wildfire perimeters between 1950 and 2022. The number of times a cell has burned since 1950 was calculated by summing the number of fires that have occurred in a cell for this time period. We obtained a random sample of 1000 points within and outside of GDEs in each ecoregion with a 1 kilometer buffer distance. We rejected the null hypothesis- that there was no difference in fire frequency between GDEs and non-GDEs in that ecoregion- if the resulting p-value of our difference in means hypothesis testing was less than 0.05."),
                                   ),
                                   column(6,
                                          p("The map above (ON THE RIGHT / LEFT) shows how groundwater dependent ecosystems (GDEs) affect burn severity across the 13 ecoregions of California. Areas in teal represent ecoregions in which we found that the presence of GDEs decreases burn severity. The Cascades ecoregion, the teal area highlighted in Northern California, saw a decreased fire severity in GDEs, potentially because of its temperate and moist climate with high amounts of snowfall. Areas in red represent ecoregions in which we found that the presence of GDEs increases burn severity. The Sonoran Basin and Range, the red area highlighted in Southern California, is the only ecoregion in which we saw an increased burn severity in GDEs. This result may be due to higher vegetation densities in and around GDEs in arid ecosystems like the Sonoran Basin and Range. Areas in light blue indicate that we found no significant difference between burn severities in GDEs and non-GDEs, and areas in light gray were not studied due to insufficient burn severity data. More information for each ecoregion is available using the drop down menus below."),
                                          p("These results were obtained using a Mann-Whitney U Test to compare distributions of fire severities in GDEs and non-GDEs. The Mann-Whitney U Test is a non-parametric test that works well with ordinal data. This test compares the medians of two different groups to test if they appear to come from the same population. Our burn severity data was obtained from the MTBS dataset, which contains calculated burn severity values for fires that have occurred in California since 1984. The value can be 2 (low), 3 (moderate), or 4 (high). The burn severity value used in this analysis was calculated by taking the mode, or most common, burn severity for each 30 meter cell in California between 1984 and 2021. We then obtained a random sample of 30 points within GDEs and 30 points outside of GDEs with a 1 kilometer buffer distance. We rejected the null hypothesis- that there was no difference in burn severity between GDEs and non-GDEs- if the resulting p-value was less than 0.05."),
                                   )
                                 ),
                                 
                                 # space between california maps and statistics
                                 br(),
                                 br(),
                                 tags$hr(
                                   style = "border: none; border-top: 2px solid black; margin: 20px 0;"
                                 ),
                                 br(),
                                 br(),
                        ), # END tabPanel for california stats
                        
                        tabPanel(title = "Ecoregion Stats",
                                 
                                 
                                 
                                 fluidRow(
                                   sidebarPanel(width = 2,
                                                
                                                selectInput(inputId = "ecoregion_stats_type_input",
                                                            label = "Select ecoregion:",
                                                            choices = names_fire_count_hist, # names_gde
                                                            selected = 'fire_count_histogram_central_foothills_coastal_mountains',
                                                            multiple = F
                                                            
                                                ), # END pickerInput
                                                
                                   ), # End sidebarPanel
                                   
                                   # Stats Main Panel
                                   mainPanel(width = 10,
                                             
                                             fluidPage(
                                               
                                               fluidRow(
                                                 
                                                 column(6,
                                                        plotOutput("fire_count_hist"),
                                                        # textOutput("fire_count_text"),
                                                 ),
                                                 
                                                 column(6,
                                                        plotOutput("burn_severity_hist"),
                                                        # textOutput("burn_severity_text"),
                                                 ),
                                                 
                                               ),
                                               
                                               fluidRow(
                                                 
                                                 column(6,
                                                        textOutput("fire_count_text")),
                                                 column(6,
                                                        textOutput("burn_severity_text")),
                                                 
                                               ),
                                               headerPanel(""),
                                               
                                             ), # End fluidPage
                                             
                                   ) # End mainPanel
                                   
                                 ) # End fluidRow for interactive histogram
                                 
                        ) # End tabPanel for Ecoregion statistics
                        
                      ), # End tabSetPanel for Statistics
                      
             ), # End tabPanel
             
             
  ), # End navbarPage
  
) # End fluidPage

