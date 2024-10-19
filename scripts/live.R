# live do covid
#loading pakages
require(geobr)
library(ggplot2)
require(magrittr)
library(leaflet)
library(sf)
library(dplyr)
library(gifski)
require(colorspace)
library(gganimate)

rs <- read_municipality(code_muni = 'RS', year = 2021)
ggplot(rs) + geom_sf(fill = "#2d3e50", color = "#FEBF57", size = .15, show.legend = F)

# retirar linhas 

linhas <- c(1,2)
rs <- rs[-linhas,]
rs

casosRS <- covid19_6fde9fbda6674d9ba7663b49ecb8b74a

#removel colonas 

colunas <- c()
rs <- rs[,-colunas]

# removendo colunas de casosRS
colunas <- c(1,2,4,7)
casosRS <- casosRS[,-colunas]

# juntando as dias bases
rsCasosCovid <- merge(rs, casosRS, by.x="code_muni", by.y="city_ibge_code")
# removendo colunas 
colunas <- c(3,4,5)
rsCasosCovid <- rsCasosCovid[,-colunas]

# iniciando o trabalho

map <-leaflet(rsCasosCovid) %>% addTiles()
map %>% addPolygons()

map %>% addPolygons(
  weight =  1,
  opacity = 0.5,
  color = "blue",
  dashArray = "1",
  fillOpacity = 0
)

# Bins e colors

binss <- c(0,10,20,50,100,200,500,1000,Inf)
pale <- colorBin("YlOrRd", domain = rsCasosCovid$deaths, bins = binss)

map %>% addPolygons(
  fillColor = ~paleta_cores(deaths),
  weight = 1,
  opacity = 1,
  color = "black",
  dashArray = "1",
  fillOpacity = 0.7
)
# adicionar intiratividade

map %>% addPolygons(
  fillColor = ~pale(deaths),
  weight = 1,
  opacity = 1,
  color = "black",
  dashArray = "1",
  fillOpacity = 0.7,
  highlightOptions = highlightOptions(
    weight = 5,
    color = "#666",
    dashArray =  "",
    fillOpacity = 0.7,
    bringToFront = T))
# Customizando informções 

lebel1 <- sprintf(
  "<strong>%s</strong></br>%g Confirmados</br>%g Obitos",
  rsCasosCovid$name_muni,rsCasosCovid$confirmed,rsCasosCovid$deaths
  ) %>% lapply(htmltools::HTML)

map %>% addPolygons(
  fillColor = ~pale(deaths),
  weight = 1,
  opacity = 1,
  color = "black",
  dashArray = "1",
  fillOpacity = 0.7,
  highlightOptions = highlightOptions(
    weight = 5,
    color = "#666",
    dashArray =  "",
    fillOpacity = 0.7,
    bringToFront = TRUE),
    label = lebel1,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px, 8"),
      textsize = "15px",
      direction = "auto"
    ))

# adicionando legendas 

map %>% addPolygons(
  fillColor = ~pale(deaths),
  weight = 1,
  opacity = 1,
  color = "black",
  dashArray = "1",
  fillOpacity = 0.7,
  highlightOptions = highlightOptions(
    weight = 5,
    color = "#666",
    dashArray =  "",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = lebel1,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px, 8"),
    textsize = "15px",
    direction = "auto"
  )) %>% addLegend(pal = pale, values = ~deaths, opacity = 0.7,
                   title = "Casos de Obitos",
                   position = "topright")

