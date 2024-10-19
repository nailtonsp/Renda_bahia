dados_estados <- amostra %>%
  mutate(Estados = factor(value)) %>%
  group_by(Estados) %>%
  summarise(frequancia = n())
