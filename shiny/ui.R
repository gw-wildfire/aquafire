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
                        ), # End Contact
                        
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
                        
                        tmapOutput("main_map", height = 600, width = 800),
                        
                        h3("Coast Range"),
                        
                        fluidRow(
                          column(12, p("The low mountains of the Coast Range of western Washington, western Oregon, and northwestern California are covered by highly productive, rain-drenched coniferous forests. Sitka spruce forests originally dominated the fog-shrouded coast, while a mosaic of western redcedar, western hemlock, and seral Douglas-fir blanketed inland areas. Today, Douglas-fir plantations are prevalent on the intensively logged and managed landscape. In California, redwood forests are a dominant component in much of the region. In Oregon and Washington, soils are typically Inceptisols and Andisols, while Alfisols are common in the California portion. Landslides and debris slides are common, and lithology influences land management strategies. In Oregon and Washington, slopes underlain by sedimentary rock are more susceptible to failure following clear-cutting and road building than those underlain by volcanic rocks. Coastal headlands, high and low marine terraces, sand dunes, and beaches also characterize the region."),
                                 
                          ),
                          
                        ), # End Significance
                        h3("Central Basin"),
                        
                        fluidRow(
                          column(12, p(""))
                        ),
                        
                        h3("Central Foothills and Coastal Mountains"),
                        
                        fluidRow(
                          column(12, p("The primary distinguishing characteristic of this ecoregion is its Mediterranean climate of hot dry summers and cool moist winters, and associated vegetative cover comprising mainly chaparral and oak woodlands; grasslands occur in some lower elevations and patches of pine are found at higher elevations. Surrounding the lower and flatter Central California Valley (7), most of the region consists of open low mountains or foothills, but there are some areas of irregular plains and some narrow valleys. Large areas are in ranch lands and grazed by domestic livestock. Relatively little land has been cultivated, although some valleys are major agricultural centers such as the Salinas or the wine vineyard center of Napa and Sonoma."))
                        ),
                        
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
                          
                          tmapOutput("map", height = 600) %>% withSpinner()
                          
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

