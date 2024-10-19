require(geoR)

## caregando base
data(s100)
s100

plot(s100)
points(s100)


##
##caregando pacote
require(MASS)
##

## criando as bosdas 
bor <- s100$coords[chull(s100$coords),]
s100$borders <- bor
plot(s100)
names(s100)

## criando o variograma
s100.bin <- variog(s100)
plot(s100.bin)
## reduzindo a distancia maxima para 1
s100.bin <- variog(s100, max.dist=1)
## envelope simulado para verificar padrao espacial nos dados 
s100.vario.env <- variog.mc.env(s100, obj=s100.bin)
plot(s100.bin, env=s100.vario.env)

?variofit
s100.fit.exp <- variofit(s100.bin, ini.cov.pars = c(0.9,.35), cov.model= "exp", nugget = FALSE, fix.kappa = FALSE )
summary(s100.fit.exp)
s100.fit.exp
plot(s100.bin)
lines(s100.fit.exp,col="green")
s100.fit.exp

s100.fit.sph <- variofit(s100.bin, ini=c(0.9,.35), cov.model="sph",nug=FALSE, fix.kappa=FALSE)
summary(s100.fit.sph)
s100.fit.sph
plot(s100.bin)
lines(s100.fit.sph,col="red")
s100.fit.sph

s100.fit.gau <- variofit(s100.bin, ini=c(0.9,.35), cov.model="gau",nug=FALSE, fix.kappa=FALSE)
summary(s100.fit.gau)
s100.fit.gau
plot(s100.bin)
lines(s100.fit.gau,col="blue")
s100.fit.gau

s100.fit.mat <- variofit(s100.bin, ini=c(0.9,.35), cov.model="matern",nug=FALSE, fix.kappa=FALSE)
summary(s100.fit.mat)
s100.fit.mat
plot(s100.bin)
lines(s100.fit.mat,col="yellow3")
s100.fit.mat

plot(s100.bin)
lines(s100.fit.exp,col="green")
lines(s100.fit.sph,col="red")
lines(s100.fit.gau,col="blue")
lines(s100.fit.mat,col="yellow3")

loci0 <- expand.grid(seq(0,1,l=100), seq(0,1, l=100))
plot(loci0)
points(loci0, pch="+")
pred.s100.sph <- krige.conv(s100, loc=loci0, krige=krige.control(obj=s100.fit.sph))
names(pred.s100.sph)
pred.s100.sph$predict

image(pred.s100.sph,col=gray(seq(0.95,0.2, l=10)))

?image

image(pred.s100.sph)


