#--- Analayse descriptive des données des AP à Madagascar  ---#


# Charger les packages requis:
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
arrow, #lecture et écriture fichiers parquet
dplyr, # data wrangling
tidyr, # data wrangling
data.table, # data wrangling
)

# Chargement des données
donnees_ap <- arrow::read_parquet("Data/all_PAs_conso.parquet")

# Description du tibble
donnees_ap

# Nombre d'AP incluses 
donnees_ap %>% summarise(NB_AP=n_distinct(WDPAID))
donnees_ap %>% summarise(NB_AP=n_distinct(WDPA_PID))
donnees_ap %>% summarise(NB_AP=n_distinct(NAME))

# Période couverte
donnees_ap %>% summarise(MIN_YEAR=min(STATUS_YR, na.rm = TRUE), MAX_YEAR=max(STATUS_YR,  na.rm = TRUE))

# Nombre d'observations par année
donnees_ap %>% group_by(STATUS_YR) %>% summarise(OBS=n()) %>% print(n=nrow(.))

# Table STATUS * STATUS_YR
donnees_ap %>% group_by(STATUS_YR, STATUS) %>%
  summarise(NB = n()) %>%
  pivot_wider(names_from = STATUS, values_from = NB, values_fill = 0) %>%
  print(n=nrow(.))

# Table DESIG * STATUS_YR
status_table <- donnees_ap %>% group_by(STATUS_YR, DESIG) %>%
  summarise(NB = n()) %>%
  pivot_wider(names_from = DESIG, values_from = NB, values_fill = 0)

# Table IUCN_CAT * STATUS_YR
cat_table <- donnees_ap %>% group_by(STATUS_YR, IUCN_CAT) %>%
  summarise(NB = n()) %>%
  pivot_wider(names_from = IUCN_CAT, values_from = NB, values_fill = 0)



#library(tidyverse)
#library(arrow)
#library(geoarrow)
#library(sf)
#wdpa_conso <- read_parquet("sources/MDG_WDPA_Consolidated.parquet") 
#test <- wdpa_conso %>%
#  filter(NAME == "Mahialambo")
