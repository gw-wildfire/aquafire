ui <- fluidPage(
  
  theme = bs_theme(bootswatch = "sandstone",
                   bg = "#BC4749", # light blue
                   fg = "#F7EDE2", # MCR dark blue from bottom of page
                   primary = "#a9a9a9", # MCR dark blue font
                   secondary = "#0f4d76", # blue controls the clear buttons
                   success = "#397B1E", # light green
                   info = "#0076a0", # light blue from bar
                   warning = "#C3512C",# yellow
                   danger = "#FACE00", # orange red
                   base_font = font_google("Open Sans"), 
                   heading_font = font_google("Source Sans Pro")),
  
  titlePanel(""), #BC4749 F7EDE2
  fluidPage(
    fluidRow(column(6,
                    h1("Aquafire")),
             column(6,
                    HTML("<a href='https://www.tnc.org/'><img src='tnc_logo.png' align= 'right' height= '60' width = '180' alt='This is The Nature Conservancy logo'/></a>")))),
  
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
                          column(12, p("Eight of the largest 10 wildfires in California have occured in the past five years. And although there has been extensive research on wildfire hazard, little research has been done to understand and quantify the relationship between the two. (Groundwater-Dependent Ecosystems are ecosystems that are dependent on groundwater year-round.) As climate change gets worse, it is imperitive to understand all factors contributing to worsening wildfires."),
                          )
                        ), # End Background
                        
                        h1("Significance"),
                        
                        fluidRow(
                          column(12, p("This App was designed to display statistical and spatial relationships between Groundwater-Dependent Ecosystems and Wildfires. It may be used as a tool to understand how Groundwater-Dependent Ecosystems play a role in lessening the severity of a wildfire or may even act as a natural fire break."),
                          )
                        ), # End Significance
                        
                        h1("Contact"),
                        
                        fluidRow(
                          column(12, p("..."),
                          )
                        ), # End Contact
                        
                        h1("Data Policy Information"),
                        
                        fluidRow(
                          column(12, p("Maybe make a graph for displaying the data and metadata?"),
                          )
                        ), # End Data Policy Info
                        
                        h1("About Us"),
                        
                        fluidRow(
                          column(12, p("We are Jillian Allison, Meagan Brown, Andre Dextre, and Wade Sedgwick. This App was designed during our Master in Environmental Data Science Program for use by the Dangermond Preserve, owned by The Nature Conservancy."),
                          )
                        ), # End Significance
                        
                      ), # End fluidPage
                      
             ), # End Tab Panel for About page
             
             # California Map ----
             tabPanel(title = "California", icon = icon("map"),
                      
                      
                      sidebarLayout(
                        
                        sidebarPanel(width = 3,
                                     
                                     
                                     # ecoregion type pickerInput ----
                                     # EDIT SO THAT APPLIES TO ECOREGIONS
                                     selectInput(inputId = "ecoregion_type_input",
                                                 label = "Select ecoregion:",
                                                 choices = c("socal_norbaja_coast_gdes",
                                                             "southern_mountains_gdes",
                                                             "sonoran_basin_gdes"), #?? would I need a tm df where ecoregion_type is a column??
                                                 # options = list(pickerOptions(actionsBox = TRUE)),
                                                 selected = "socal_norbaja_coast_gdes",
                                                 multiple = TRUE
                                                 
                                     ), # END pickerInput
                                     
                                     checkboxInput("socal_norbaja_coast_gdes", "So Cal GDEs", value = TRUE),
                                     checkboxInput("southern_mountains_gdes", "So Cal Mountain GDEs", value = TRUE),
                                     
                                     # checkboxGroupInput(inputId = "map",
                                     #                    label = "Select fire layers:",
                                     #                    choices = c("socal_norbaja_coast_gdes", "southern_mountains_gdes"),
                                     #                    selected = c("socal_norbaja_coast_gdes", "southern_mountains_gdes"))
                                     
                        ), # End sidebarPanel
                        
                      
                      
                      # interactive map of TSLB
                      mainPanel(
                        
                        # TMAP UI
                        
                        tmapOutput("map")
                        
                        
                        # LEAFLET UI
                        
                        # leafletOutput(outputId = "map",
                        #                       width = 800,
                        #                       height = 500), position = c("right"),
                        #         # toggle layer on and off
                        #         checkboxInput(inputId = "overlay", label = "Toggle layer on/off", value = TRUE),
                        #         # toggle layer opacity
                        #         sliderInput(inputId = "opacity", label = "Layer opacity", value = 1, min = 0, max = 1, step = 0.1)
                                
                      )#, # End Leaflet main panel
                      
                      )#, # End sidebarLayout
                      
             ), # End tabPanel
             
             
             
             navbarMenu("Statistical Analysis", icon = icon("chart-simple"),
                        
                        # California Map ----
                        tabPanel(title = "California statistics",
                                 
                                 # sidebarLayout ----
                                 #                                  sidebarLayout(
                                 
                                 sidebarPanel(width = 3,
                                              
                                              # Put inputs & variables to change here!
                                              # GDEs, Wildfire Hazard
                                              "For California statistical analysis inputs"
                                              
                                 ), 
                                 #                                  ), # End sidebarLayout ----
                        ), # End tabPanel
                        
                        tabPanel(title = "Santa Barbara County Statistics",
                                 
                                 # sidebarLayout for county map----
                                 #                                 sidebarLayout(
                                 
                                 
                                 sidebarPanel(width = 3,
                                              
                                              
                                              # Put inputs & vartiables here
                                              "For County-level statistical analysis inputs"
                                              
                                 ),
                                 #                                 ), # End sidebarLayout
                                 #                                  position = ("left"),
                                 
                                 mainPanel(
                                   
                                   "County Statistical Analysis"
                                   
                                 ),
                                 
                        ), # End tabPanel
             ), # End mainPanel
             
             
  ), # End navbarMenu for Statistical Analysis
  
  
) # End Navigation Bar

