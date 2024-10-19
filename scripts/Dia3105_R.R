require(geoR)
borda <- read.table("data/bruto/contorno_bahia.txt", header = TRUE, sep = ",")
plot(borda)
summary(borda)

dados=read.table("data/bruto/Bahia_G.txt", head=T, dec=",")
dados
plot(dados)
dadosgeo <- as.geodata(dados, coords.col = 1:2, data.col = 3)
dadosgeo$borders <- borda
plot(dadosgeo)
borders <- borda
dadosgeo <- as.geodata(dados, coords.col = 1:2, data.col = 3, borders=borda)
plot(dadosgeo)
dadosgeo <- as.geodata(dados, coords.col = 1:2, data.col = 4, borders=borda)
plot(dadosgeo)
