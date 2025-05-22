#--- Test carte feux actifs MODIS ---#



# Charger les packages requis:
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  arrow, #lecture et écriture fichiers parquet
  tidyverse, #manipulation de données
  dplyr, #manipulation de données
  tidyr, #manipulation de données
  data.table, #manipulation de données
  sf, #traitement données spatiales
  tmap, #production de cartes
  geodata, #accès aux frontières administratives
  mapme.biodiversity
)

#Charger les données
sapm_2017 <- read_rds("Data/sapm_2017.rds")

#Générer la carte SAPM 2017
tm_shape(sapm_2017) +
  tm_polygons(col = "CATEG_IUCN")