##
## Análises exploratórias inicias e expaciais
##

## A análise expçoratoria expacial tenta identificar:
## 1. presença de dependencia espacial
## 2. existencia da dados discrepantes (globais ou locais)
## 3. assimetria, nescecidade de transformação, etc
## 4. tendências com coordenadas ou covariáveis

## carregando o pacote geoR
require(geoR)

## carregando o conjunto de dados "s100" (distribuído com a geoR)
data(s100)

## um resumo dos dados 
summary(s100)

## inspacionando o objeto
names(s100)

## ilustrando algumas operaçoes que podem ser feitas com os dados
var(s100$data)
boxplot(s100$data)

##
## análise exploratoria expacial
##

##
## Usando a função points.geodata(), e ilistrando algumas das suas operaçoes
##
points(s100)
## controlando o tamanho dos pontos
points(s100, pt.divide = "equal")
points(s100, cex.min = .6, cex.max = .6)
points(s100, pt.div="equal")
points(s100, cex.min=.6, cex.max=.6)
points(s100, cex.min=.3, cex.max=3)
## dividindo os dads em quartis
points(s100, cex.min = 1, cex.max = 1, pt.divide = "quart")
points(s100, pt.divide = "quart")
points(s100, pt.divide = 4)
points(s100, pt.divide = "dec")
points(s100, cex.min = 1, cex.max = 1, pt.divide = "quart")
## opiçoes para cor dos pontos
points(s100, cex.min = 1, cex.max = 1, col = "gray")
points(s100, cex.min = 1, cex.max = 1, col = rainbow(100))
points(s100, cex.min = 1, cex.max = 1, col = terrain.colors(100))
##opções de modificar caracter dos pontos
points(s100, pt.divide = "equal", pch.seq = "+")


## virificando o aspecto do grafico para dados sem corelação espacial
##  (permitando a posição dos dados para garantir dados espacialmente independentes)
points(s100, data = sample(s100$data), cex.min = 1, cex.max = 1, pt.divide = "quart")
## e agora compara com o padrao dos dados originais
x11(); points(s100)
dev.off()

## verificando aspectos de dados assimetricos
## (expecionando dados para gerar dados log-normais 
points(s100, data = exp(s100$data))

## inspecionando argumentos de outras opções da função
class(s100)
args(points.geodata)
help("points.geodata")

## caregando um outro conjunto de dados 
data("parana")
summary(parana)

## Note a tendencia nesses dados:
points(parana, borders = parana$borders, pt.divide = "quart")
## agora "removendo" a tendencia,isso é, fazendo o grafico de residuos 
## de uma regressão linear nas coordenadas 
points(parana, borders = parana$borders, trend = "1st")
points(parana, borders = parana$borders, pt.divide = "quart", trend = "1st")
## permutando os graficos nas posições para ver asprctos do grafico
## sem coordenada espacial
x11();points(parana, data = sample(parana$data), borders = parana$borders,
             trend = "1st", pt.divide = "quart")
dev.off()

##
## Um outro grafico descritico: Usando a função plot.geodata()
##
plot(s100)
plot(parana)
## alguns argumentos adicionais 
plot(parana, bor = parana$borders, lowess = TRUE)
points(parana, pt.divide = "quart")
x11(); plot(parana, trend = "1st", borders = parana$borders, lowess = TRUE)
dev.off()

## caregando um outro conjunto de dados que passue covariaveis
data(ca20)
summary(ca20)
names(ca20)
points(ca20, cex.min = .05, cex.max = .05, borders = ca20$borders)
polygon(ca20$reg1)
polygon(ca20$reg2)
polygon(ca20$reg3)

plot(ca20, borders = ca20$border)
plot(ca20, borders = ca20$borders, trend = ~area)
plot(ca20, borders = ca20$borders, trend = ~area+altitude)

## caregando outro conjunto de dados com comportamento assimetrico
ksat <- read.geodata("http://www.leg.ufpr.br/geoR/tutorials/datasets/Cruciani.dat",
                     header = TRUE, row.names = 1)
summary(ksat)
plot(ksat)

require(MASS)
boxcox(ksat)
## o grafico produzido mostra que a transformação recomendada é lambda = 0 (log)

## visualizando dados dados transformados 
plot(ksat, lambda = 0)

## melhorando os dados 
## caregando as bordas
kbor <- read.table("http://www.leg.ufpr.br/geoR/tutorials/datasets/Cruciani.border",
                   head = TRUE, row.names = 1)
kbor
plot(ksat, lambda = 0, borders = kbor)

##
## Explorando a dependencia espacial atraves dos variogramas
## Variograma exploratorio empirico
##
s100.v <- variog(s100, max.dist = 1)
plot(s100.v)

## dados comtendencia:observando variograma dos residuos
parana.v <- variog(parana, max.dist = 400, trend = "1st")
plot(parana.v)

## dados com tendencias em covariaveis: variograma dos residuos
ca20.v <- variog(ca20, trend = ~area, max.dist = 800)
plot(ca20.v)

## variograma de dados transformados 
ksat.v <- variog(ksat, max.dist = 10, lambda = 0)
plot(ksat.v)
