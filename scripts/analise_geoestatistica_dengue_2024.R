##
## caregando pacores
##
require(geoR)
require(geobr)
require(MASS)
require(sf)
require(ggplot2)
require(colorspace)
require(dplyr)
require(readxl)
require(tidyverse)
## caregando base de dados
dengue_micro_2024 <- read.csv("data/bruto/sinannet_cnv_denguebbr055910177_136_36_136.csv")

## Deletando linhas sem dados
dengue_2024 <- dengue_micro_2024
linhas <- c(546:572)
dengue_2024 <- dengue_2024[-linhas,]

## criando uma nova coluna com apelas o codigo da micro regiao 
dengue_2024 <- dengue_2024 %>%
  mutate(code_micro = sapply(strsplit(dengue_2024$Microrregião.IBGE.de.notificação, " "), `[`,1))

## caregando os dados do ibje para micro regioes do prasil
brasil_micro <- read_micro_region(code_micro = "all", year = 2010)

## mergiando as bases
dengue_2024 <- merge(dengue_2024, brasil_micro, by.x = "code_micro", by.y = "code_micro")

## deletando coluna Microrregião.IBGE.de.notificação
colunas <- c(2)
dengue_2024 <- dengue_2024[,-colunas]

##
## criando mapa
##

## criando intervalo

intervalo <- c(-Inf, 291, 1414,8422, Inf)

intervalo_plot <- findInterval(dengue_2024$X2024, intervalo)

dengue_2024 <- dengue_2024 %>%
  mutate(intervalo_plot = factor(intervalo_plot))

## definindo paleta de cores
q4 <- sequential_hcl(5, palette = "YlOrRd")
palete_cores <- c("#FFFFC8",
                  "#F9D67E",
                  "#F39300",
                  "#DA3500")
## criando a legenda
legend_plot <- c("-Inf a 291","292 a 1414","1414 a 8422","8423 a Inf")

## plotando o grafico
dengue_2024 %>%
  ggplot() + geom_sf(aes(geometry = geom,
                     fill = intervalo_plot),
                     color = "black",) +
  labs(title = "Casos notificadas de denque em 2024",
               fill = "Legenda") +
  scale_fill_manual(labels = legend_plot,
                    values = palete_cores) +
  theme_minimal()

##
## criando gambiara dar merge em coordenadas_brasil
##
