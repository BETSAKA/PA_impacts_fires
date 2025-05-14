#--- Analayse descriptive des données des AP à Madagascar  ---#


# Charger les packages requis:
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
arrow, #lecture et écriture fichiers parquet
dplyr, # data wrangling
tidyr, # data wrangling
data.table, # data wrangling
)

# Connexion aux données
donnees_ap <- open_dataset("Data/all_PAs_conso.parquet")

