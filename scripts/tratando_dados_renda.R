library(geoR)
library(geobr)
library(dplyr)
library(readxl)
library(colorspace)
library(ggplot2)
library(sf)
library(tools)
library(tidyverse)



renda_data <- read_xlsx("data/bruto/data1.xlsx")



##
## trantando dados
##

## renomeando variaveis

renda_data <- renda_data |>
  rename(adolecentes_15_17 = `% de adolescentes de 15 a 17 anos de idade que tiveram filhos 2016`)

renda_data <- renda_data |>
  rename(meninas_10_14 = `% de meninas de 10 a 14 anos de idade que tiveram filhos 2016`)

renda_data <- renda_data |>
  rename(PIB_2016 = `Produto Interno Bruto per capita 2016`)

## editanda a variavel Territorialidades para mergiar com a base com geo-data

renda_data$Territorialidades <- gsub("\\(BA\\)", "", renda_data$Territorialidades)

renda_data$Territorialidades <- trimws(renda_data$Territorialidades)

renda_data$Territorialidades <- toTitleCase(renda_data$Territorialidades)



##
## inportando geo data
##

ba_geo_data <- read_municipality(code_muni = "BA", year = 2016)

distribuicao_renda <- merge(renda_data, ba_geo_data, by.x = "Territorialidades", by.y = "name_muni")



##
## criando mapa
##

## intervalos

summary(distribuicao_renda$PIB_2016)

intervalo <- c(-Inf,4.522,5.485 ,7.058,Inf)
intervalo <- findInterval(distribuicao_renda$PIB_2016, intervalo)

distribuicao_renda <- distribuicao_renda |>
  mutate(interval_plot = factor(intervalo))

## criando paleta de cores


palete_cores <- c("#FFFFC8",
                  "#F9D67E",
                  "#F39300",
                  "#DA3500",
                  "#7D0025")
## criando legenda

legend <- c("-Inf a 4.52", "4.52 a 5.48", "5.48, a 7.05", "7.05, a Inf")


## plot mapa

distribuicao_renda |>
  ggplot() +
  geom_sf(aes(geometry = geom, fill = interval_plot),
          color = "black") +
  labs(title = "Distribuicao De Renda",
       fill = "Legenda") +
  scale_fill_manual(values = palete_cores, labels = legend) +
  theme_minimal()
