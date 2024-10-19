library(geobr)
library(ggplot2)
library(rio)
library(readr)
library(sf)
library(dplyr)
library(readxl)


??geobr

??read_municipality

ba <- read_municipality(code_muni = "BA", year = 2020)
plot(BA)

sp <- read_municipality(code_muni = "SP", year = 2020)
plot(SP)

all_mun_ba <- read_municipality(code_muni = 29, year = 2020)
plot(all_mun_ba)

class(all_mun_ba)


#####################


estados <- c("AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA",
             "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RR", "RO",
             "RJ", "RN", "RS", "SC", "SP", "SE", "TO")
estados
length(estados)

amostra <- sample(estados, 1000, replace = TRUE)
amostra

table_amostra <- table(amostra)

??as.tibble

# Converter a amostra em tibble
amostra <- as_tibble(amostra)
amostra

dados_estados <- amostra %>%
  mutate(abbrev_state = factor(value)) %>%
  group_by(abbrev_state) %>%
  summarise(n = n())
dados_estados

dados_mapa <- read_state(year = 2019, showProgress = FALSE) %>%
  left_join(dados_estados)
dados_mapa

dados_mapa %>%
  ggplot() +
  geom_sf(aes(fill = n)) +
  labs(title = "Mapa Brasil", fill = "Frequ�ncia") +
  theme_minimal() +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank())


# Criar e utilizar legenda:

# Descobrindo o maximo e minimo para definir a quantidade de intervalos
max(dados_mapa$n) # Calculando o m�ximo
min(dados_mapa$n) # Calculando o m�nimo
max(dados_mapa$n) - min(dados_mapa$n) # Diferen�a

# Dividir em tres categorias:
# 1 - < 30
# 2 - 30 a 40
# 3 - > 40

# Intervalos para a Legenda
classes <- c(-Inf, 30, 40, Inf)
classes
classes_plot <- findInterval(dados_mapa$n, classes)
classes_plot

# Criar legenda
legenda <-  c("< 30", "30 a 40", "> 40")
legenda

palette()

cores <- c("blue",
           "yellow",
           "red")


dados_mapa <- dados_mapa %>%
  mutate(classes_plot = factor(classes_plot))
dados_mapa

# Mapa
dados_mapa %>%
  ggplot() +
  geom_sf(aes(fill = classes_plot), color = "black") +
  labs(title = "Mapa Brasil", fill = "Frequ�ncia Criada") +
  scale_fill_manual(labels = legenda,
                    values = cores) +
  theme_minimal() +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank())