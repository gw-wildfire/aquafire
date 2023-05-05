This README.txt file was generated on 2023-05-03 by AQUAFIRE

## Assessing Fire in Groundwater-Dependent Ecosystems

### GENERAL INFORMATION

**Abstract:** Climatic events such as drought and wildfires have become more frequent and severe in California, causing structural and ecological damage. While there is an understanding of both freshwater resource management and wildfires, there has been little work directed towards integrating groundwater data into wildfire risk models. To fill this knowledge gap, we will analyze wildfire history and severity in groundwater dependent ecosystems (GDEs) in California. In particular, we will use statewide publicly-available geospatial data of groundwater and wildfire datasets to analyze and interpret the effect that groundwater levels have on fire hazard models. Our approach will rely on existing wildfire data, including wildfire risk assessments and a database of burn perimeters, coupled with freshwater data, including mapped groundwater dependent ecosystems (GDEs) and groundwater level measurements, to conduct several spatial analyses and data products. We will produce an open-source interactive ShinyApp that will visualize how groundwater availability affects wildfire risk models.

**Author Information:**\
Jillian Allison (jilliannallison@bren.ucsb.edu)\
Meagan Brown (meagan_brown@bren.ucsb.edu)\
Andre Dextre (adextre@ucsb.edu)\
Wade Sedgwick (wsedgwick@ucsb.edu)

**Client Information:**\
Kelly Easterday\
The Nature Conservancy (TNC)\
kelly.easterday@tnc.org

**Faculty Advisor:**\
Max Moritz\
UC Santa Barbara, Bren School of Environmental Science & Management\
mmoritz@bren.ucsb.edu

**Date of data collection:** The data used for this project and analysis was collected approximately between 2023-01-15 - 2023-03-15 

**Geographic location of data collection:** Data for this project was collected for the State of California

No external funding was needed for data collection for this project

### SHARING/ACCESS INFORMATION

**Licenses/restrictions:**  There are no restrictions or licenses required to access the data used for this project.

**Links to publications that cite or use the data:**\
California Fire Perimeters (all): https://gis.data.cnra.ca.gov/datasets/CALFIRE-Forestry::california-fire-perimeters-all-1/explore?location=38.742598%2C-120.133468%2C6.82 \
GDE Pulse (TNC): https://gde.codefornature.org/#/data \
California' Ecoregions: https://www.epa.gov/eco-research/ecoregion-download-files-state-region-9 

**Recommended citation for the project:**\
Allison, J. Brown, M. Dextre, A. Easterday, K. Moritz, M. Sedgwick, W. (2023) Assessing Fire in Groundwater-Dependent Ecosystems. https://github.com/gw-wildfire/aquafire.

### DATA & FILE OVERVIEW


**California Wildfire Perimeters (All):** Data obtained through CAL FIRE Wildfire Perimeters and Prescribed Burns dataset. The service includes layers that are data subsets symbolized by size and year.

**Natural Communities Commonly Associated with Groundwater Version 2.0 (NCCAG 2.0):** Data obtained through The Nature Conservancy's (TNC) GDE Pulse Dashboard. Represents areas in California deemed most likely to be GDEs according to criteria described in Klausmeyer et al., 2018.

**Ecoregions of California (Level III):** Data obtained through the Environmental Protection Agency (EPA). Dataset includes name, area, longitude, and latitude of California's 13 ecoregions.

**California County Boundaries:** : Data obtained through California's Open Data portal. Dataset containes California country information such as name, longitute, latitude, and shape (area).

There are two versions of the California Ecoregion available. For this project, we used Level 3 (Level III) of California's ecoregion dataset which cointains 13 ecoregions within California. Additionally, for GDE data we used the Natural Communities Commonly Associated with Groundwater Version 2.0 (NCCAG 2.0) dataset. All other dataset only have ne version.

### METHODOLOGICAL INFORMATION

**All raw data used for this analysis was obtained through publicly open data sources**

Description of methods used for collection/generation of data:

**California Wildfire Perimeters (All):** The CA wildfire perimeters dataset was accessed through CA’s Natural Resources Agency GIS Dashboard. Original raw data was obtained by CAL-FIRE, USDA Forest Service, and other Federal Partners.

CA Natural Resources Agency Dashboard: https://gis.data.cnra.ca.gov/datasets/CALFIRE-Forestry::california-fire-perimeters-all-1/explore?location=36.961169%2C-117.954466%2C6.00&showTable=true 

Metadata: https://www.arcgis.com/sharing/rest/content/items/e3802d2abf8741a187e73a9db49d68fe/info/metadata/metadata.xml?format=default&output=html 

**Natural Communities Commonly Associated with Groundwater Version 2.0 (NCCAG 2.0):**  Data obtained through The Nature Conservancy's (TNC) NCCAG Dashboard. Data was collected from Groundwater Sustainability Plans (GSPs) reported by Groundwater Sustainability Agencies (GSAs) established through the CA Sustainable Groundwater Management Act (SGMA).

For more information on the methodology of this dataset: https://gis.water.ca.gov/app/NCDatasetViewer/sitedocs/# 

NCCAG Dashboard: https://gde.codefornature.org/#/methodology


**Ecoregions of California (Level III)**: Data was accessed and downloaded through the EPA’s Eco-Research website. 

For more information on EPA’s data collection: https://gaftp.epa.gov/EPADataCommons/ORD/Ecoregions/ca/ca_eco_l3.htm 

**California County Boundaries:** Data was accessed through California's Open Data Portal. Original raw data was obtained from the US Census Bureau's 2016 MAF/TIGER database.

Source: https://data.ca.gov/dataset/ca-geographic-boundaries

### Methods for processing the data:

**California Wildfire Perimeters (All), wildfire_perimeters**


Janitor package was used to convert data column names to snake case
Transformed data to NAD83 / California Albers - EPSG:3310
Created a column called ‘val’ with a value of 1 to assign each fire a value
Filtered for years 1950 or after
Cropped fires to only the California state boundary


**Natural Communities Commonly Associated with Groundwater (NCCAG Dataset), gde**


Transformed data to NAD83 / California Albers - EPSG:3310
Created a column called ‘gde’ with a value of 1 to assign each gde a value


**Ecoregions of California (Level III), ca_eco_l3**


Janitor package was used to convert data column names to snake case
Transformed data to NAD83 / California Albers - EPSG:3310
Renamed ‘us_l3name’ column to ‘region’

**California County Boundaries, CA_Counties**


Janitor package was used to convert data column names to snake case
Transformed data to NAD83 / California Albers - EPSG:3310


### Instrument- or software-specific information needed to interpret the data:

**Software:** R/Rstudio Version 4.2.2


**Packages:** tidyverse, sf, here, janitor, raster, rgdal, fasterize, terra


### Standards and calibration information:

The standard coordinate reference system used for our spatial data was NAD83 / California Albers - EPSG:3310. We also used a 30 x 30 meter resolution for raster layers as a standard. 


### Describe any quality-assurance procedures performed on the data:

1. Data profiling: Analyzed the data to understand its structure, content, relationships, and quality issues. This involved assessing data distributions, value       frequencies, missing values, and outlier detection.

2. Data cleansing: Made sure datasets were tidy and were projected in the same coordinate reference system. 

3. Data lineage and traceability: Documented the sources, transformations, and dependencies of data throughout its lifecycle to ensure accountability, and transparency.

4. Metadata management: Captured, stored, and managed metadata (data about data) to ensure data consistency, discoverability, and usability.


### Processing, analysis, and submission:

Jillian Allison (jilliannallison@bren.ucsb.edu)


Meagan Brown (meagan_brown@bren.ucsb.edu)


Andre Dextre (adextre@ucsb.edu)


Wade Sedgwick (wsedgwick@ucsb.edu)


### DATA-SPECIFIC INFORMATION FOR:

\[California Wildfire Perimeters (All)\]

**Number of variables:** 22

**Number of cases/rows:** 16,446

**Variable List:**\
Objectid: unique identifier for each fire occurrence\
Year: year that fire occurred in\
State: State that fire occurred in\
Agency: Reporting agency of fire\
Unit_id: Reporting unit\
Fire_name: Common name of fire\
Inc_num: Incident number\
Alarm_date: Date that fire was reported\
Cont_date: Containment date\
Cause: Code for cause of fire\
Comments: User comments\
Report_ac: reported acres burned\
Gis_acres: acres burned according to GIS\
Fire_num: Fire number\
Complex_na: Fire complex name\ 
Complex_in: Complex identification number\
Shape_leng: Shape length of fire perimeter\
Shape_area: shape area of fire perimeter\
Geometry: Spatial outline of fire, polygon


**Missing data codes:** “NA”, 0000000, empty 

**Specialized formats or other abbreviations used:** NA


\[GDE\]

**Number of variables:** 13

**Number of cases/rows:** 591,217 

**Variable List:**\
POLYGON_ID: Unique identifier for each GDE\
WETLAND_NA: Description of GDE, wetland, or spring\
ORIGINAL_C: Code or name for GDE\
SOURCE_COD: Code for source\
DATE_DATA_: Year the imagery was taken for mapping this wetland type\
COMMENTS: User provided comments\
LAST_MODIF: Date record was last modified\
MODIFIED_B: The person who modified the data\
VEGETATION: Vegetation type in wetland\
DOMINANT_S: Dominant species in the wetland\
Geometry: Spatial outline of GDE

**Missing data codes:** “NA”

**Specialized formats or other abbreviations used:** NA


\[Ecoregions of California (Level III)\]

**Number of variables:** 14

**Number of cases/rows:** 13

**Variable List:**\
Us_l3code: United States Level 3 Ecoregion Code\
Region: United States Ecoregion Name\
Na_l3: North American Level 3 Ecoregion Code\
Na_l3name: North American Level 3 Ecoregion Name\
Na_l2code: North American Level 2 Ecoregion Code\
Na_l2name: North American Level 2 Ecoregion Name\
Na_l1code: North American Level 1 Ecoregion Code\
Na_l2name: North American Level 1 Ecoregion Name\
State_name: State Name\
Epa_region: EPA Region\
L3_key: Level 3 Key (Ecoregion number and name)\
L2_key: Level 2 Key (Ecoregion number and name)\
L1_key: Level 1 Key (Ecoregion number and name)\
Geometry: Spatial outline of ecoregion

**Missing data codes:** No missing data

**Specialized formats or other abbreviations used:** NA

\[California County Boundaries\]

**Number of variables:** 18

**Number of cases/rows:** 58

**Variable List:**\
statefp: State FIP ID\
countyfp: County FIP ID\
name: Name of CA county\
intptlat: Latitude\
intptlon: Longitude\
geomtry: Spatial outline of county\

**Missing data codes:** No missing data

**Specialized formats or other abbreviations used:** NA
