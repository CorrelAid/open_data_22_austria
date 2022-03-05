# CorrelAid Open Data Day
# 2022-03-05

# Hunde / Baum pro Bezirk

# Baumkataster Wien

library(tidyverse)

# Daten laden

dat_baum <- read.csv2("data/FME_BaumdatenBearbeitet_OGD_20220202.csv", sep=";")

getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

dat_baum <- dat_baum %>% 
  mutate(hoehe_cat = case_when(
    Hoehe <= 5 ~ "0-5",
    Hoehe > 5 & Hoehe <= 10 ~ "6-10",
    Hoehe > 10 & Hoehe <= 15 ~ "11-15",
    Hoehe > 15 ~ ">15")) %>% 
  mutate(krone_cat = case_when(
    Schirmdurchmesser <= 3 ~ "0-3",
    Schirmdurchmesser > 3 & Schirmdurchmesser <= 6 ~ "4-6",
    Schirmdurchmesser > 6 & Schirmdurchmesser <= 9 ~ "7-9",
    Schirmdurchmesser > 9 ~ ">9"))


dat_baum <- dat_baum %>%
  summarise(bezirk = "99",
            lieblings_art = getmode(NameDeutsch),
            lieblings_freq = max(table(NameDeutsch)),
            total_freq = n(),
            umfang_median = median(Stammumfang, na.rm = TRUE),
            umfang_mean =  mean(Stammumfang, na.rm = TRUE),
            mode_hoehe = getmode(hoehe_cat), 
            mode_krone = getmode(krone_cat)) %>% 
  mutate(bezirk = as.numeric(bezirk))

baum_wien <- read_csv("open_data_22_austria/data/baum/baum.csv")

baum <- bind_rows(dat_baum, baum_wien)

write.csv(baum, "data/baum_wien_linz.csv")