# Definir os vetores
a <- c(2,1,3)
b <- c(0,0,1)

# Calcular o produto vetorial
produto_vetorial <- c(
  a[2] * b[3] - a[3] * b[2], # Componente x
  a[3] * b[1] - a[1] * b[3], # Componente y
  a[1] * b[2] - a[2] * b[1]  # Componente z
)

# Exibir o resultado
print(produto_vetorial)

modulo_produto_v <- sqrt((produto_vetorial[1])^2 + (produto_vetorial[2])^2 + (produto_vetorial[3])^2)


## para calcular determinantee de produto misto de matrix 3x3

x <- c(0,0,0)
y <- c(0,0,0)
z <- c(0,0,0)
matrix1 <- c(x,y,z)
misto <- matrix(matrix1, nrow = 3)
det(misto)




## Calcular vetor diretor da reta 

i <- c(-1,1,2)
j <- c(3,-1,1)

diretor_r <- c(j[1] - i[1], j[2] - i[2], j[3] - i[3])
diretor_r
