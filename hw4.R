#Ready to use R
library(sf)
library(here)

#Read in 'global gender inequality data'
csv <- read.csv("HDR21-22_Composite_indices_complete_time_series.csv", na="NULL")
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

print(mapfile) #check it is WGS84 or not

##This is how to add .csv to .csv (that I did by mistake)
#csv3 <- merge(csv2, mapfile, by="con")
#csv3 <- csv3 %>% 
#  mutate(diff=hdi_2010-hdi_2019)

##This is how to join .geojson with .csv = .geojson
mapfile2 <- mapfile %>% 
  clean_names() %>% 
  left_join(.,
            csv2,
            by=c('con'='con')) %>% 
  mutate(diff=hdi_2010-hdi_2019) #DON't ADD QUTOE IN THE COLUMN NAME

#Let's remove the NA data in diff column
mapfile3 <- mapfile2 %>% 
  filter(diff != "NULL")

library(maptools)
library(sp)
library(tmap)
library(tmaptools)
library(rgdal)
library(geojsonio)
library(raster)
library(terra)

#Let's make a map
tmap_mode("plot")
qtm(mapfile3, fill = "diff")

#To use oen street map data -> The size of map is smaller than original map image
#finalmap <- mapfile3 %>% 
#  st_bbox(.) %>% 
#  tmaptools::read_osm(., type="osm", zoom = NULL)

#tm_shape(finalmap)+
#  tm_rgb()+
#  tm_shape(mapfile3)+
#  tm_polygons("diff", 
#              style="pretty",
#              palette="Pastel1",
#              midpoint=NA,
#              title="Gap between 2010 and 2019",
#              alpha = 0.5) + 
#  tm_layout(title = "Global Gender Inequality Index by UN", legend.position = c("left", "bottom"))

tm_shape(mapfile3)+
  tm_polygons("diff", 
              style="fisher",
              palette="Blues",
              midpoint=NA,
              title="Gap between 2010 and 2019",
              alpha = 0.5) + 
  tm_layout(title = "Global Gender Inequality Index by UN", legend.position = c("left", "bottom"))


#Share it with the World on GitHub
library(usethis)
use_github()

#Add your repository URL to the circulated spreadsheet on Moodle

