library(tidyverse)
library(openxlsx)

observers <- c("Bill", "Angus", "Jean", "Hermione", "Rab", "Finlay", "Siobhan")
species <- c("Osprey", "Heron", "Kingfisher", "Pigeon", "Falcon", "Grackle", "Cormorant", "Pelican")
dates <- seq(as.Date("2022/1/1"), as.Date("2023/12/31"), by = "day")

df_master <- NULL

for(observer in observers) {
  # for each observer, generate a random number that represent the number of days they observed birds
  obs_count <- sample(c(100:150), 1)
  obs_dates <- sample(dates, size = obs_count)
  
  df <- tibble(
    observer = rep(observer, times=obs_count),
    obs_date = obs_dates
  )
  
  for(bird_type in species) {
    df[bird_type] = NA
  }
  
  df <- df |> 
    mutate(
      Osprey = rbinom(obs_count, 8, 0.15),
      Heron = rbinom(obs_count, 12, 0.10),
      Kingfisher = rbinom(obs_count, 5, 0.1),
      Pigeon = rbinom(obs_count, 25, 0.25),
      Falcon = rbinom(obs_count, 8, 0.15),
      Grackle = rbinom(obs_count, 25, 0.20),
      Cormorant = rbinom(obs_count, 25, 0.30),
      Pelican = rbinom(obs_count, 12, 0.15),
    )
  
  if (is.null(df_master)) {
    df_master <- df
  } else {
    df_master <- bind_rows(df_master, df)
  }
}

df_master <- df_master |> 
  arrange(obs_date)

df_master_pivot <- df_master |> 
  pivot_longer(cols=-c(observer,obs_date), names_to = "species", values_to = "observations")

openxlsx::write.xlsx(df_master_pivot, "datasets/bird-watchers.xlsx")
