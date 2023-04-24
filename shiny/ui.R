ui <- fluidPage(
  
  titlePanel(""),
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
                          column(12, p("Although there has been extensive research on both groundwater dependent ecosystems and wildfire hazard, little research has been done to understand and quantify the relationship between the two."),
                          )
                        ), # End Background
                        
                        h1("Significance"),
                        
                        fluidRow(
                          column(12, p("This App was designed to display statistical and spatial relationships between Groundwater-Dependent Ecosystems and Wildfires. It may be used as a tool to understand how Groundwater-Dependent Ecosystems.."),
                          )
                        ), # End Significance
                        
                      ), # End fluidPage
                      
             ), # End Tab Panel for About page
             
             # California Map ----
             tabPanel(title = "California", icon = icon("map"),
                      h1("Hello"),
                      
                      # BELOW IS OUTPUT OF MAP
                      mainPanel(leafletOutput(outputId = "map",
                                              width = 800,
                                              height = 500), position = c("right")),
                      
                      
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
                        
                        
             ), # End mainPanel
             
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
             
  ), # End navbarMenu for Statistical Analysis
  
  
) # End Navigation Bar

