# pacotes

library(geobr)
library(ggplot2)
library(rio)
library(readr)
library(sf)
library(dplyr)
library(readxl)

# criando lista_de comando
comandos_dados <- list_geobr()

salvador <- read_state(code_state = 29 , year = 2018)

ggplot() + geom_sf(data = salvador, fill = "#2d3E50", color = "#FEBF57", size = .15,
                   show.legend = FALSE)

micro <- read_micro_region()
meso <- read_meso_region()

micro_reg <- read_micro_region(code_micro = "29021")
ggplot() + geom_sf(data = micro_reg,
                   fill = "#2D3E50",
                   color = "#FEBF57",
                   size = .15,
                   show.legend = FALSE)

meso_regi <- read_meso_region(code_meso = "RS", year = 2015)

ggplot() + geom_sf(data = meso_regi,
                 fill = "#2D3E50",
                 color = "#FEBF57",
                 size = .15,
                 show.legend = F) 


muni <- read_municipality()
municipios <- read_municipality(code_muni = 2913507, year = 2015)

ggplot() + geom_sf(data = municipios,
                   fill = "#2d3e50",
                   color = "#FEBF57",
                   size = .15,
                   show.legend = F)

# brincando com biomas 

bio_read <- read_biomes()

biomas <- read_biomes(year = 2019)
plot(biomas)

biomas$name_biome
biomas$code_biome
biomas$geom

pampa = bio_read [5,]
plot(pampa)

ggplot() + geom_sf(data = pampa,
                fill = "#2d3e50",
                color = "#FEBF57",
                size = .15,
                show.legend = F)

caatinga <- bio_read [2,]
plot(caatinga)

ggplot() + geom_sf(data = caatinga,
                   fill = "#2d3e50",
                   color = "#FEBF57",
                   size = .15,
                   show.legend = F) 

# plotando grafico de dois biomas pampas e caatinga
ggplot() + geom_sf(data = pampa,
                   fill = "#5F3e50",
                   color = "#FEBF57",
                   size = .15,
                   show.legend = F) + geom_sf(data = caatinga,
                                                         fill = "#2d3e50",
                                                         color = "#FEBF57",
                                                         size = .15,
                                                         show.legend = F) +
  ggtitle("Biomas Pampa e Caatinga")

#brincando com intermediate 

dados_intermediate <- read_intermediate_region()
plot(dados_intermediate)

inter_salvador <- read_intermediate_region(2901, year = 2019)
ggplot() + geom_sf(data = inter_salvador,
                   fill = "#5F3e50",
                   color = "#FEBF57",
                   size = .15,
                   show.legend = F) +
  ggtitle("Meso region Salvador")



micro <- read_micro_region(29021,2018)
plot(micro)

ggplot() + geom_sf(data = micro,
                   fill = "#5F3e50",
                   color = "#FEBF57",
                   size = .15,
                   show.legend = F)







