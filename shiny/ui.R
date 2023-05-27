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
                          column(12, p("Eight of the largest 10 wildfires in California have occured in the past five years. And although there has been extensive research on wildfire models designed to predict occurance and severity, little research has been done to understand and quantify how subsurface water may effect these wildfire models. This project aims to understand how Groundwater-Dependent Ecosystems, which are ecosystems that are dependent on groundwater year-round, might play a role in wildfires."),
                          )
                        ), # End Background
                        
                        h1("Significance"),
                        
                        fluidRow(
                          column(12, p("This App was designed to display statistical and spatial relationships between Groundwater-Dependent Ecosystems and Wildfires. It may be used as a tool to understand how Groundwater-Dependent Ecosystems play a role in lessening the severity of a wildfire or may even act as a natural fire break."),
                                 
                          ),
                          
                        ), # End Significance
                        
                        tmapOutput("main_map", height = 600),
                        
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
                                                                   choices = c('Fire Count Raster', 'TSLF Raster', 'Fire Threat Raster'),
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
                                              sliderInput('alpha1','Fire Alpha',
                                                          step = 0.1,
                                                          min = 0.1, max = 1, value = 0.8),
                                              sliderInput('alpha2','TSLF Alpha',
                                                          step = 0.1,
                                                          min = 0.1, max = 1, value = 0.8),
                                              sliderInput('alpha3', 'Fire Count Alpha',
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
             
  ), # End mainPanel
  
) # End Navigation Bar

