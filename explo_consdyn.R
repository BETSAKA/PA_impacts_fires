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

