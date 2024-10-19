library(readr)
library(geobr)
library(sf)
library(ggplot2)
library(colorspace)
library(dplyr)


#preparando a base de dados 

dengue <- sinannet_cnv_dengue

BA <- read_micro_region(code_micro = 29, year = 2010)

dengue <- merge(BA, dengue, by.x = "code_micro", by.y = "code_micro")

colunas <- c(7)

dengue <- dengue[,-colunas]

# sumarizando variaveias para construir os intervalos 

summary(dengue$Masculino)
summary(dengue$Feminino)

# criando a paleta de cores para os mapa

interval_masculino <- c(45, 719, 2605, 3119, 19929)
interval_feminino <- c(78, 1013, 3405, 4054, 26852)

interval_plot_masculino <- findInterval(dengue$Masculino, interval_masculino)
interval_plot_feminino <- findInterval(dengue$Feminino, interval_feminino)

palete_cores_masculina <- c("#FFFFC8",
                            "#F9D67E",
                            "#F39300",
                            "#DA3500",
                            "#7D0025")


palete_cores_feminina <- c("#F2F0f6",
                           "#E9C4EE",
                           "#D68ABE",
                           "#B34A78",
                           "#7D0112")

dengue <- dengue %>%
  mutate(interval_plot_masculino = factor(interval_plot_masculino))

dengue <- dengue %>%
  mutate(interval_plot_feminino = factor(interval_plot_feminino))

# plotando mapas

# mapa masculino
legenda_masculina <- c("45 a 719", "719 a 2605", "26605 a 3119", "3119 a 19929", "19929 >")

dengue %>%
  ggplot() +
  geom_sf(aes(fill = interval_plot_masculino), color = "black") +
  labs(title = "Mapa de casos notificados de dengue em homens na Bhaia", fill = "Numero de casos notificados") +
  scale_fill_manual(labels = legenda_masculina,
                    values = palete_cores) +
  theme_minimal() +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank())

# mapa feminino 
legenda_feminina <- c("78 a 1013", "1013 a 3405", "3405 a 4054", "4054 a 26851", "26851 >")

dengue %>%
  ggplot() +
  geom_sf(aes(fill = interval_plot_masculino), color = "black") +
  labs(title = "Mapa de casos notificados de dengue em mulheres na Bhaia", fill = "Numero de casos notificados") +
  scale_fill_manual(labels = legenda_feminina,
                    values = palete_cores_feminina) +
  theme_minimal() +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank())



