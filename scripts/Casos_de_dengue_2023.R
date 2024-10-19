## Caregando pacotes
require(geobr)
require(geoR)
require(dplyr)
require(sf)
require(colorspace)
require(ggplot2)
require(tidyverse)
require(readxl)

## caregando as bases e mesclando elas
base_dengue_2023_ano <- read.csv("data/bruto/sinannet_cnv_dengue_br_ano-de-notificacao.csv")
base_dengue_2023_idade <- read.csv("data/bruto/sinannet_cnv_dengue_br-faxa-etaria.csv")
base_dengue_2023_raca <- read.csv("data/bruto/sinannet_cnv_dengue_br-raca.csv")
ibje_brasil_muni <- read_municipality(code_muni = "all", year = 2010)

## mergiando as bases
base_dengue_2023_final <- merge(base_dengue_2023_ano, base_dengue_2023_idade, by.x = "Munic.pio.de.resid.ncia", by.y = "Munic.pio.de.resid.ncia")
base_dengue_2023_final <- merge(base_dengue_2023_final, base_dengue_2023_raca, by.x = "Munic.pio.de.resid.ncia", by.y = "Munic.pio.de.resid.ncia")

## deletando linhas
dengue_2023 <- base_dengue_2023_final

linhas <- c(1:3)
dengue_2023 <- dengue_2023[-linhas,]

## tratando base para mesclar com dados do ibje
dengue_2023 <- dengue_2023 %>%
  mutate(nome_muni = gsub("\\d+", "", dengue_2023$Munic.pio.de.resid.ncia))

dengue_2023 <- dengue_2023 %>%
  mutate(nome_muni = str_to_title(dengue_2023$nome_muni))

dengue_2023 <- dengue_2023 %>%
  mutate(nome_muni = trimws(dengue_2023$nome_muni))

## mergeando dengue_2023 com dados do ibje
dengue_2023 <- merge(ibje_brasil_muni, dengue_2023, by.x = "name_muni", by.y = "nome_muni")

##
## construindo mapa 
##

## construindo paleta de cores
palete_cores <- c("#FFFFC8",
                  "#F9D67E",
                  "#F39300",
                  "#DA3500")

## intervalo plot

intervalo <-c(-Inf,5,21,119,Inf)
interval_pllot <- findInterval(dengue_2023$X2023, intervalo)

dengue_2023 <- dengue_2023 %>%
  mutate(interval_plot = factor(interval_pllot))

##
legend_plot <- c("-Inf a 291","292 a 1414","1414 a 8422","8423 a Inf")

## plotando mapa
dengue_2023 %>%
  ggplot() + geom_sf(aes(fill = interval_pllot),
                     color = "black") +
  labs(title = "Casos de dengue 2023",
       fill = "legenda") +
  scale_fill_manual(labels = legend_plot,
                    values = palete_cores) +
  theme_minimal()
