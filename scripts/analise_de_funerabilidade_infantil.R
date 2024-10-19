## caregando pacotes
require(geoR)
require(geobr)
require(tidyverse)
require(ggplot2)
require(sf)
require(readxl)
require(dplyr)
require(colorspace)
##
## iniciando a construção do mapa
##

## caregando base de com dados de vunerabilidade infantil

Dados_vunerabilidade_infantil <- read.csv("data/bruto/Dados_vulnerabilidade_AtlasBrasil_V6_criancas.csv")

## Dicionário:
##   Variável1: % de crianças em domicílios em que ninguém tem fundamental completo (2010);
## Variável2: % de crianças de 0 a 5 anos fora da escola (2010);
## Variável3: % de crianças de 6 a 14 fora da escola (2010);
## Variável4: Mortalidade infantil (2010);
## Variável5: IDH-M (2010);
## Variável6: % de crianças extremamente pobres (2010)

## caregando base com dados do IBGE
brasil_muni <- read_municipality(code_muni = "all", year = 2010)

## merge das bases com dados de vunerabilidade e do IBJE
dados_vunerabilidade <- Dados_vunerabilidade_infantil

dados_vunerabilidade <- merge(dados_vunerabilidade, brasil_muni, by.x = "CD_IBGE", by.y = "code_muni")

## criando o intervalo para o preencimento usando a variavel 3

interval_plot_v3 <- c(-Inf,1.5,2.4,3.4,Inf)
interval_plot <- findInterval(dados_vunerabilidade$variavel3, interval_plot_v3)

dados_vunerabilidade <- dados_vunerabilidade %>%
  mutate(interval_plot = factor(interval_plot))

## criando paleta de cores
q4 <- sequential_hcl(5, palette = "YlOrRd")

palete_cores <- c("#FFFFC8",
                  "#F9D67E",
                  "#F39300",
                  "#DA3500")

dados_vunerabilidade %>%
  ggplot() + geom_sf(aes(geometry = geom, fill = interval_plot)
                     collor = "black")














