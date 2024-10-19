require(geoR)
require(geobr)
require(dplyr)
require(readxl)
require(tidyverse)
library(tools)

renda_data <- read_csv("data/tratado/distribuicao_de_renda.csv")

distibuicao_renda <- renda_data

##
## trantando dados
##

## renomeando variaveis

distibuicao_renda <- distibuicao_renda |>
  rename(adolecentes_15_17 = `% de adolescentes de 15 a 17 anos de idade que tiveram filhos 2016`)

distibuicao_renda <- distibuicao_renda |>
  rename(meninas_10_14 = `% de meninas de 10 a 14 anos de idade que tiveram filhos 2016`)

distibuicao_renda <- distibuicao_renda |>
  rename(PIB_2016 = `Produto Interno Bruto per capita 2016`)

## editanda a variavel Territorialidades para mergiar com a base com geo-data

distibuicao_renda$Territorialidades <- gsub("\\(BA\\)", "", distibuicao_renda$Territorialidades)

distibuicao_renda$Territorialidades <- trimws(distibuicao_renda$Territorialidades)

distibuicao_renda$Territorialidades <- toTitleCase(distibuicao_renda$Territorialidades)



##
## inportando geo data
##

ba_geo_data <- read_municipality(code_muni = "BA", year = 2016)

distribuicao_renda_geo_data <- merge(distibuicao_renda, ba_geo_data, by.x = "Territorialidades", by.y = "name_muni")





write.csv(distribuicao_renda_geo_data, "data/tratado/distribuicao_de_renda.csv", row.names = FALSE, sep = ",")
