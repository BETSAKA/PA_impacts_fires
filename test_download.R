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
MODIStsp() ## Open GUI

MODIStsp(gui             = FALSE,
         out_folder      = 'big_data/',
         out_folder_mod  = 'big_data/',
         selprod         = 'LandCover_Type_Yearly_500m (MCD12Q1)',
         bandsel         = 'LC1',
         sensor          = 'Terra',
         user            = 'tthivillon' , # your username for NASA http server
         password        = '!Octopus440?',  # your password for NASA http server
         start_date      = '2004.01.01',
         end_date        = '2004.12.31',
         verbose         = TRUE,
         bbox            =  c(-5596641.0845, -6673508.6914, 4698677.0087, 4157242.8202), #bbox of Latam
         spatmeth        = 'bbox',
         out_format      = 'GTiff',
         compress        = 'LZW',
         out_projsel     = 'User Defined',
         output_proj     = '+proj=laea +lon_0=-73.125 +lat_0=0 +datum=WGS84 +units=m +no_defs',
         delete_hdf      = TRUE,
         parallel        = TRUE
)

