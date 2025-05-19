#--- Test chargement données MODIS MOD14A1  ---#


# Charger les packages requis:
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  dplyr, # data wrangling
  tidyr, # data wrangling
  data.table, # data wrangling
  remotes, # package installation from Github
  terra,
  tidyverse,
  leaflet,
  shiny, 
  shinydashboard, 
  shinyFiles,
  shinyalert,
  rappdirs,
  shinyjs,
  leafem,
  mapedit,
  magrittr
)

# Installation de MODIStsp
install_github("ropensci/MODIStsp")

library(MODIStsp)

# Liste des produits disponibles
MODIStsp_get_prodnames()

# Liste des couches
MODIStsp_get_prodlayers("M*D14A1")$bandnames

# Demande de données
MODIStsp()
