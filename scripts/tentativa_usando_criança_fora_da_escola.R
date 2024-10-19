## Caregando pacotes

require(geoR)
require(geobr)
require(MASS)
require(dplyr)
require(colorspace)
require(sf)
require(ggplot2)
require(readxl)

## inportando a base 
Dados_vulnerabilidade_AtlasBrasil <- read.csv("data/bruto/Dados_vulnerabilidade_AtlasBrasil_V6_criancas.csv")

## tratando base
vunerabilidade_infantil  <- Dados_vulnerabilidade_AtlasBrasil
colunas <- c(3,4,5,6,8,10,11,12)
vunerabilidade_infantil <- vunerabilidade_infantil[,-colunas]

## caregando municipios do brasil
brasil_muni <- read_municipality(code_muni = "all", year = 2010)
colunas <- c(2,3,4)
brasil_muni <- brasil_muni[,-colunas]

## mergiando as bases 
vunerabilidade_infantil <- merge(vunerabilidade_infantil, brasil_muni, by.x = "CD_IBGE", by.y = "code_muni")

linhas <- c(1:1826)
vunerabilidade_infantil <- vunerabilidade_infantil[-linhas,]

linhas <- c(418:3739)
vunerabilidade_infantil <- vunerabilidade_infantil[-linhas,]

colunas <- c(4)
vunerabilidade_infantil <- vunerabilidade_infantil[,-colunas]


## calculando intervalo
interval_variavel2 <- c(-Inf,54,59,64,Inf)

interval_plot <- findInterval(vunerabilidade_infantil$variavel2, interval_variavel2)

vunerabilidade_infantil <- vunerabilidade_infantil %>%
  mutate(interval_plot = factor(interval_plot))

## criando paleta de cores
palete_cores <- c("#FFFFC8",
                  "#F9D67E",
                  "#F39300",
                  "#DA3500",
                  "#7D0025")


## criando legenda 
legend_plot <- c("-inf a 53", "54 a 58", "59  a 63", "63 a inf")

vunerabilidade_infantil %>%
  ggplot() +
  geom_sf(aes(geometry = geom, fill = interval_plot),
          color = "black") +
  labs(title = "Crianças fora da escola",
       fill = "legenda") +
  scale_fill_manual(labels = legend_plot,
                    values = palete_cores) +
  theme_minimal()


##
## caregando base com latitude e longitude para plotar grafico de pontos
##

## caregando base com dados de latitude e logituto
coordenadas_brasil_muni <- read_xls("data/bruto/anexo_16261_Coordenadas_Sedes_5565_Municípios_2010.xls")

##tratando a base 

linhas <- c(1:1826)
coordenadas_brasil_muni <- coordenadas_brasil_muni[-linhas,]

linhas <- c(418:3739)
coordenadas_brasil_muni <- coordenadas_brasil_muni[-linhas,]

colunas <- c(2)
coordenadas_brasil_muni <- coordenadas_brasil_muni[,-colunas]

## mergiando vunerabilidade_infantil e coordenasds_brasil_muni

vunerabilidade_infantil <- merge(vunerabilidade_infantil, coordenadas_brasil_muni, by.x = "CD_IBGE", by.y = "GEOCODIGO_MUNICIPIO")


## criando a variavel 

coordenadas_vunera <- as.geodata(data.frame(coords = cbind(vunerabilidade_infantil$LONGITUDE, vunerabilidade_infantil$LATITUDE), 
                        data = vunerabilidade_infantil$variavel2))


## plotando grafico de pontos
points(coordenadas_vunera, pt.divide = "quart", cex.min = .8, cex.max = .8, borders = coordenadas_vunera$borda)

plot(coordenadas_vunera)


## tentando fazer a borda
## bor <- coordenadas_vunera$coords[chull(coordenadas_vunera$coords),]
## corordenadas_vunera$borders <- bor

## fazebdo variograna e teste de dependencia espacil

coordenadas_vunera.v <- variog(coordenadas_vunera, max.dist = 6)
plot(coordenadas_vunera.v)

## encelope simulado
coordenadas_vunera_var_env <- variog.mc.env(coordenadas_vunera, obj.variog = coordenadas_vunera.v)
plot(coordenadas_vunera.v, env = coordenadas_vunera_var_env)

##
## Usando a função variofit
##

## usando a função variofit para fazer o ajuste do modelo exponencial
vunerabilidade.exp <- variofit(coordenadas_vunera.v, ini.cov.pars = c(6,46), cov.model = "exp", nugget = FALSE, fix.kappa = FALSE)
summary(vunerabilidade.exp)
vunerabilidade.exp
plot(coordenadas_vunera.v)
lines(vunerabilidade.exp, col = "blue")
s100.fit.exp









