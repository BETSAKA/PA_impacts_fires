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
  tmaptools, #accès à la fonction read_osm()
  OpenStreetMap, #fonds de carte OSM
  geodata, #accès aux frontières administratives,
  maptiles, #accès aux tuiles de carte avec tmap
  magick #gifs animés
)


### 1. Création d'une carte statique pour l'année 2001

#Charger les données des AP
sapm_2017 <- read_rds("Data/sapm_2017.rds")

#Générer la carte SAPM 2017
tmap_mode("view")
  tm_shape(sapm_2017) +
  tm_polygons(col = "CATEG_IUCN")

#Ajout des données MODIS
#Requête de données manuelle à : https://firms.modaps.eosdis.nasa.gov/download/create.php
fires_2001 <- read_csv("Data/fire_archive_M-C61_615652.csv") %>%
    st_as_sf(coords = c("longitude", "latitude"), crs = 4326) %>%
    filter(grepl('2001', acq_date), confidence > 50)

sapm_filter2001 <- sapm_2017 %>% filter(year(ymd(DATE_CREAT)) < 2002)

#Générer la carte avec les feux actifs pour 2001
breaks_frp_5 <- quantile(fires_2001$frp, probs = seq(0, 1, by = 0.25), 
                         na.rm = TRUE)

tm_shape(sapm_filter2001) +
  tm_polygons(col = "CATEG_IUCN")+
  tm_shape(fires_2001) +
  tm_dots(col = "frp", size = 0.2, alpha = 1,
          palette =  colorRampPalette(c("yellow", "red"))(5),
          border.col = NULL, breaks = breaks_frp_5,
          popup.vars = c("acq_date", "confidence", "frp"),
          title = "Fire radiative power") +
  tm_layout(title = "Feux détectés à Madagascar en 2001") 






### 2. Création d'une série de cartes statiques pour la période 2001-2024


# Fonction pour générer une carte pour une année donnée
gen_fire_map <- function(year, sapm_data, fire_data, out_dir = "fire_maps", palette, breaks, bbox) {
  
  tmap_mode("plot")  # mode nécessaire pour tmap_save()
  message("Création de la carte pour ", year, "...")
  
  # Filtrer les données
  sapm_y <- sapm_data %>% filter(lubridate::year(DATE_CREAT) <= year)
  fires_y <- fire_data %>% filter(lubridate::year(acq_date) == year, confidence > 50)
  
  
  # Télécharger le fond OSM comme raster (via {tmaptools})
  #osm_bg <- read_osm(bbox, zoom = 10, type = "osm")

  # Créer la carte
  p <- tm_shape(sapm_y, bbox = bbox) +
    #tm_shape(osm_bg) +
    #tm_rgb() +  # afficher le fond de carte
    tm_basemap() +
    tm_polygons(col = "CATEG_IUCN") +
    tm_shape(fires_y) +
    tm_dots(col = "frp", size = 0.03, palette = palette,
            breaks = breaks, border.col = NA) +
    tm_layout(title = paste("Feux et aires protégées à Madagascar -", year))
  
  # Créer le répertoire si nécessaire
  if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)
  
  # Sauvegarder
  filename <- file.path(out_dir, str_glue("firemap_{year}.png"))
  tmap_save(p, filename = filename, width = 8, height = 6)
}


#Palette de couleurs et seuils pour frp
fire_palette <- colorRampPalette(c("yellow", "red"))(5)

# Chargement des données complètes pour les feux
modis_fires <- read_csv("Data/fire_archive_M-C61_615652.csv") %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

#Définition du bounding box
bbox_mada <- c(xmin = 40.488278, ymin = -26.720163, xmax = 56.250000, ymax = -9.949521)

# Choix de la période
years <- 2011:2024

# Générer toutes les cartes avec purrr::walk()
walk(years, gen_fire_map,
     sapm_data = sapm_2017,
     fire_data = modis_fires,
     out_dir = "fire_maps",
     palette = fire_palette,
     breaks = breaks_frp_5,
     bbox = bbox_mada)



### 3.Création de l'animation avec magick

imgs <- list.files("fire_maps", pattern = "firemap_\\d+\\.png", full.names = TRUE) %>%
  image_read() %>%
  image_join() %>%
  image_animate(fps = 1)  # 1 image par seconde

image_write(imgs, "fire_maps/fire_animation.gif")