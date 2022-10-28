#Andy's Tip _it will be helpful!
install.packages("countrycode")
library(countrycode)

#Ready to use R
library(sf)
library(here)

#Read in 'global gender inequality data'
csv <- read.csv("HDR21-22_Composite_indices_complete_time_series.csv")
library(dplyr)
csv2 <- csv %>% 
  dplyr::select(iso3, country, hdicode, hdi_2010, hdi_2019)


#Join the global gender inequality index to 'spatial data of the World', 
#creating a new column of difference in inequality between 2010 and 2019
mapfile <- st_read("World_Countries_(Generalized).geojson")

library(janitor)
csv2 <- csv2 %>% 
  dplyr::rename(CON = 'country') %>% 
  clean_names()

mapfile <- mapfile %>% 
  dplyr::rename(CON = 'COUNTRY') %>% 
  clean_names()

print(mapfile) #WGS84 확인

csv3 <- merge(csv2, mapfile, by="con")

library(maptools)
library(sp)
library(tmap)
library(tmaptools)
library(rgdal)
library(geojsonio)

tmap_mode("plot")

library(raster)
library(terra)

  
#qtm(csv3, fill = "hdi_2010")



#Share it with the World on GitHub



#Add your repository URL to the circulated spreadsheet

