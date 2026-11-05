#stem volume
#use latest work space from February 2026
plot(stem_volume_lb_303_observed$stem_volume ~ 
         stem_volume_lb_303_observed$survey_year,
     col = "#fdae61",
     xlab = "Survey year", xlim = c(1995,2020),
     ylab = expression(paste("Stem volume [m"^3, " ha"^-1, "]"))
     , ylim = c(50,550), pch = 16, main = "Measured and simulated stem volumes")

lines(stem_volume_lb_303_observed$stem_volume ~ 
          stem_volume_lb_303_observed$survey_year, col = "#fdae61", lty = 3)

points(stem_volume_lb_303_simulated$stem_volume ~ 
           stem_volume_lb_303_simulated$survey_year,
       col = "#fdae61", pch = 20)

lines(stem_volume_lb_303_simulated$stem_volume ~ 
          stem_volume_lb_303_simulated$survey_year, col = "#fdae61", lty = 1)

points(stem_volume_sl_304_observed$stem_volume ~ 
           stem_volume_sl_304_observed$survey_year,
       col = "#2c7bb6", pch = 16)

lines(stem_volume_sl_304_observed$stem_volume ~ 
          stem_volume_sl_304_observed$survey_year,
      col = "#2c7bb6", lty = 3)

points(stem_volume_sl_304_simulated$stem_volume ~ 
           stem_volume_sl_304_simulated$survey_year,
       col = "#2c7bb6", pch = 20)

lines(stem_volume_sl_304_simulated$stem_volume ~ 
          stem_volume_sl_304_simulated$survey_year,
      col = "#2c7bb6", lty = 1)

points(stem_volume_kl_1503_observed$stem_volume ~ 
           stem_volume_kl_1503_observed$survey_year,
       col = "#d7191c", pch = 16)

lines(stem_volume_kl_1503_observed$stem_volume ~ 
          stem_volume_kl_1503_observed$survey_year,
      col = "#d7191c", lty = 3)

points(stem_volume_kl_1503_simulated$stem_volume ~ 
           stem_volume_kl_1503_simulated$survey_year,
       col = "#d7191c", pch = 20)

lines(stem_volume_kl_1503_simulated$stem_volume ~ 
          stem_volume_kl_1503_simulated$survey_year,
      col = "#d7191c", lty = 1)

legend("bottomright",
       legend = c("Lange Bramke observed",
                  "Lange Bramke simulated",
                  "Solling observed",
                  "Solling simulated",
                  "Klötze observed",
                  "Klötze simulated"),
       
       col = c("#fdae61", "#fdae61",
               "#2c7bb6", "#2c7bb6",
               "#d7191c", "#d7191c"),
       
       pch = c(16, 20,
               16, 20,
               16, 20),
       
       lty = c(3, 1,
               3, 1,
               3, 1),
       
	cex = 0.8,       

       bty = "n")


#litterfall
#use latest work space from February 2026
plot(litterfall_lb_303_observed$litterfall ~ 
         litterfall_lb_303_observed$survey_year,
     col = "#fdae61",
     xlab = "Survey year",
     ylab = expression(paste("Litterfall [kg, m"^2, " year"^-1, "]"))
     , ylim = c(0,6.2), pch = 16, main = "Measured and simulated litterfall")

lines(litterfall_lb_303_observed$litterfall ~ 
          litterfall_lb_303_observed$survey_year, col = "#fdae61", lty = 3)

points(litterfall_lb_303_simulated$litterfall ~ 
           litterfall_lb_303_simulated$survey_year,
       col = "#fdae61", pch = 20)

lines(litterfall_lb_303_simulated$litterfall ~ 
          litterfall_lb_303_simulated$survey_year, col = "#fdae61", lty = 1)

points(litterfall_sl_304_observed$litterfall ~ 
           litterfall_sl_304_observed$survey_year,
       col = "#2c7bb6", pch = 16)

lines(litterfall_sl_304_observed$litterfall ~ 
          litterfall_sl_304_observed$survey_year,
      col = "#2c7bb6", lty = 3)

points(litterfall_sl_304_simulated$litterfall ~ 
           litterfall_sl_304_simulated$survey_year,
       col = "#2c7bb6", pch = 20)

lines(litterfall_sl_304_simulated$litterfall ~ 
          litterfall_sl_304_simulated$survey_year,
      col = "#2c7bb6", lty = 1)

points(litterfall_kl_1503_observed$litterfall ~ 
           litterfall_kl_1503_observed$survey_year,
       col = "#d7191c", pch = 16)

lines(litterfall_kl_1503_observed$litterfall ~ 
          litterfall_kl_1503_observed$survey_year,
      col = "#d7191c", lty = 3)

points(litterfall_kl_1503_simulated$litterfall ~ 
           litterfall_kl_1503_simulated$survey_year,
       col = "#d7191c", pch = 20)

lines(litterfall_kl_1503_simulated$litterfall ~ 
          litterfall_kl_1503_simulated$survey_year,
      col = "#d7191c", lty = 1)

legend("topleft",
       legend = c("Lange Bramke observed",
                  "Lange Bramke simulated",
                  "Solling observed",
                  "Solling simulated",
                  "Klötze observed",
                  "Klötze simulated"),
       
       col = c("#fdae61", "#fdae61",
               "#2c7bb6", "#2c7bb6",
               "#d7191c", "#d7191c"),
       
       pch = c(16, 20,
               16, 20,
               16, 20),
       
       lty = c(3, 1,
               3, 1,
               3, 1),
       
       cex = 0.9,       
       
       bty = "n")


#plotting with black Background
#use last work space from february 2026
plot(litterfall_lb_303_observed$litterfall ~ 
         litterfall_lb_303_observed$survey_year,
     col = "#fdae61",
     xlab = "Survey year",
     ylab = expression(paste("Litterfall [kg, m"^2, " year"^-1, "]"))
     , ylim = c(0,6.2), pch = 16, main = "Measured and simulated litterfall")

usr <- par("usr")
rect(usr[1], usr[3], usr[2], usr[4],
     col = "black", border = NA)

# now add all your points() and lines() calls



#use work space from 06.04.2025
plot(matric_potenital_lb_303_9_ordered$daily_mean * -1, ylim = c(-1000,0), xlab = "Survey year", ylab = "Matric potential[hPa]", main = "Model fit soil matric potential at 20 cm depth")
lines(lwfb90_res_lb_303$layer_output$psimi[1:6210], col = "forestgreen", lwd = 2.5)

#use work space from 02.04.2026
plot(day_lb_304_WC_19$daily_mean * 0.01, xlab = "Survey year", ylab = "Volumetric soil water content", main = "Model fit soil moisture at 20 m depth")
lines(lwfb90_res_lb_303_2000_2017$theta[23014:29223], col = "forestgreen", lwd = 2)
23014

#plot with dates
day_lb_304_WC_19$date_observation <- as.Date(day_lb_304_WC_19$date_observation)
plot((day_lb_304_WC_19$daily_mean * 0.01) ~ day_lb_304_WC_19$date_observation, xlab = "Survey year", ylab = "Volumetric soil water content", main = "Model fit soil moisture at 20 m depth")
lines((lwfb90_res_lb_303_2000_2017$theta[23014:35000]) ~ seq(
    from = as.Date("2000-01-01"),
    to   = as.Date("2019-12-31"),
    by   = "day"
)[1:11987], col = "#2c7bb6", lwd = 2)

#use work space from 22.12.2025
plot(day_lb_1503_WC_31$daily_mean * 0.01, xlab = "Survey year", ylab = "Volumetric soil water content", main = "Model fit soil moisture at 20 m depth")
lines(lwfb90_res_lb_1503$layer_output$theta[366:2191], col = "forestgreen")
2191

#use work space from 19.04.2025 12.47 o'clock
plot(day_lb_303_ST_8$daily_mean, xlab = "Survey year", ylab = "Soil temperature[°C]", main = "Model fit soil temperature at 30 cm Depth")
lines(soilvar$tsoi[(1450:6198),5] - 273.15, col = "forestgreen")
4749

#use work space from 22.05.2025
plot(day_lb_304_ST_12$daily_mean, xlab = "Survey year", ylab = "Soil temperature[°C]", main = "Model fit soil temperature at 170 cm Depth")
lines(soilvar$tsoi[(1425:8000),10] - 273.15, col = "forestgreen")
6575

#use work space from 22.12.2025
plot(day_lb_1503_ST_46$daily_mean, xlab = "Survey year", ylab = "Soil temperature[°C]", main = "Model fit soil temperature at 20 cm Depth")
lines(soilvar$tsoi[(350:2175),5] - 273.15, col = "forestgreen")
1826


# match temporal resolution of observed data 
keep_matric_potential_lb_303 <- complete.cases(matric_potenital_lb_303_9_ordered$daily_mean * -1, lwfb90_res_lb_303$layer_output$psimi[1:6210])
obs_matric_potential_lb_303 <-
    matric_potenital_lb_303_9_ordered$daily_mean[keep_matric_potential_lb_303] * -1
sim__matric_potential_lb_303 <- 
  lwfb90_res_lb_303$layer_output$psimi[1:6210][keep_matric_potential_lb_303]

keep_soil_moisture_sol_304 <- complete.cases(day_lb_304_WC_19$daily_mean * 0.01, lwfb90_res_lb_303_2000_2017$theta[23014:29223])
obs_soil_moisture_sol_304 <-
    day_lb_304_WC_19$daily_mean[keep_soil_moisture_sol_304] * 0.01
sim__soil_moisture_sol_304 <- 
    lwfb90_res_lb_303_2000_2017$theta[23014:29223][keep_soil_moisture_sol_304]

keep_soil_moisture_kl_1503 <- complete.cases(day_lb_1503_WC_31$daily_mean * 0.01, lwfb90_res_lb_1503$layer_output$theta[366:2191])
obs_soil_moisture_kl_1503 <-
    day_lb_1503_WC_31$daily_mean[keep_soil_moisture_kl_1503] * 0.01
sim__soil_moisture_kl_1503 <- 
    lwfb90_res_lb_1503$layer_output$theta[366:2191][keep_soil_moisture_kl_1503]

keep_soil_temp_lb_303 <- complete.cases(day_lb_303_ST_8$daily_mean, soilvar$tsoi[(1450:6198),5] - 273.15)
obs_soil_temp_lb_303 <-
    day_lb_303_ST_8$daily_mean[keep_soil_temp_lb_303]
sim__soil_temp_lb_303 <- 
    soilvar$tsoi[(1450:7000),5][keep_soil_temp_lb_303] - 273.15

keep_soil_temp_sol_304 <- complete.cases(day_lb_304_ST_12$daily_mean, soilvar$tsoi[(1425:7999),10] - 273.15)
obs_soil_temp_sol_304 <-
    day_lb_304_ST_12$daily_mean[keep_soil_temp_sol_304]
sim__soil_temp_sol_304 <- 
    soilvar$tsoi[(1425:7999),10][keep_soil_temp_sol_304] - 273.15

keep_soil_temp_kl_1503 <- complete.cases(day_lb_1503_ST_46$daily_mean, soilvar$tsoi[(350:2175),5] - 273.15)
obs_soil_temp_kl_1503 <-
    day_lb_1503_ST_46$daily_mean[keep_soil_temp_kl_1503]
sim__soil_temp_kl_1503 <- 
    soilvar$tsoi[(350:2175),5][keep_soil_temp_kl_1503] - 273.15

#use work space from 03.02.2026
keep_DOC_lb_303 <- complete.cases(ss_lb_303_2_203_ordered$doc, reduced_df_doc$DOC_L3_1309_corrected)
obs_DOC_lb_303 <-
    ss_lb_303_2_203_ordered$doc[keep_DOC_lb_303]
sim__DOC_lb_303 <- 
    reduced_df_doc$DOC_L3_1309_corrected[keep_DOC_lb_303]

ss_simulated_sol_304$date <- as.Date(ss_simulated_sol_304$year[1], format = "%Y") +
    0:(nrow(ss_simulated_sol_304) - 1)
# Define number of desired measurements per year
n_points <- 247
# Assuming 365 rows per year — get evenly spaced indices
keep_idx <- round(seq(1, nrow(ss_simulated_sol_304), length.out = n_points))
# Extract rows at those indices
reduced_df_sol_304_doc <- ss_simulated_sol_304[keep_idx, ]

keep_DOC_sol_304 <- complete.cases(ss_sol_304_2_203_ordered$doc, reduced_df_sol_304_doc$DOC_L3_1309_corrected)
obs_DOC_sol_304 <-
    ss_sol_304_2_203_ordered$doc[keep_DOC_sol_304]
sim__DOC_sol_304 <- 
    reduced_df_sol_304_doc$DOC_L3_1309_corrected[keep_DOC_sol_304]

#use work space from 03.02.2026
set.seed(123)  # for reproducibility

balanced_df_kl_1503_doc <- do.call(
    rbind,
    lapply(
        split(plot_df_kl_1503_doc, plot_df_kl_1503_doc$survey_year),
        function(df_year) {
            
            # split by type
            obs <- df_year[df_year$type == "Measured", ]
            sim <- df_year[df_year$type == "Simulated", ]
            
            # skip years where one type is missing
            if (nrow(obs) == 0 || nrow(sim) == 0) return(NULL)
            
            # number to keep
            n_keep <- min(nrow(obs), nrow(sim))
            
            # sample equally
            rbind(
                obs[sample(nrow(obs), n_keep), ],
                sim[sample(nrow(sim), n_keep), ]
            )
        }
    )
)

library(dplyr)
library(tidyr)

paired_df_kl_1503_doc <- balanced_df_kl_1503_doc %>%
    group_by(survey_year, type) %>%
    summarise(doc = mean(doc, na.rm = TRUE), .groups = "drop") %>%
    pivot_wider(
        names_from = type,
        values_from = doc
    ) %>%
    drop_na()

obs_DOC_kl_1503 <- paired_df_kl_1503_doc$Measured
sim_DOC_kl_1503 <- paired_df_kl_1503_doc$Simulated

#alternative way
library(dplyr)
library(tidyr)

set.seed(123)

# 1. Balance data by year and type, keep all sampled rows
balanced_df_kl_1503_doc <- plot_df_kl_1503_doc %>%
    group_by(survey_year) %>%
    group_modify(~{
        obs <- .x %>% filter(type == "Measured")
        sim <- .x %>% filter(type == "Simulated")
        
        if (nrow(obs) == 0 | nrow(sim) == 0) return(NULL)
        
        n_keep <- min(nrow(obs), nrow(sim))
        
        obs_sample <- obs[sample(nrow(obs), n_keep), ] %>% mutate(pair_id = row_number())
        sim_sample <- sim[sample(nrow(sim), n_keep), ] %>% mutate(pair_id = row_number())
        
        # Join sampled rows by pair_id
        inner_join(obs_sample, sim_sample, by = "pair_id", suffix = c("_obs", "_sim"))
    }) %>%
    ungroup()

# 2. Extract vectors
obs_DOC_kl_1503 <- balanced_df_kl_1503_doc$doc_obs
sim_DOC_kl_1503 <- balanced_df_kl_1503_doc$doc_sim


#use work space from 03.02.2026
keep_NH4_lb_303 <- complete.cases(ss_lb_303_1_101_ordered$n_nh4, reduced_df_nh4$NH4_L3_1809_corrected)
obs_NH4_lb_303 <-
    ss_sol_304_2_203_ordered$n_nh4[keep_NH4_lb_303]
sim__NH4_lb_303 <- 
    reduced_df_nh4$NH4_L3_1809_corrected[keep_NH4_lb_303]

#use work space from 03.02.2026
keep_NH4_sol_304 <- complete.cases(ss_sol_304_1_103_ordered$n_nh4, reduced_df_304$NH4_L3_2109_corrected)
obs_NH4_sol_304 <-
    ss_sol_304_1_103_ordered$n_nh4[keep_NH4_sol_304]
sim__NH4_sol_304 <- 
    reduced_df_304$NH4_L3_2109_corrected[keep_NH4_sol_304]


#use work space from 03.02.2026
library(dplyr)
library(tidyr)

set.seed(123)

# 1. Balance data by year and type, keep all sampled rows
balanced_df_kl_1503_nh4 <- plot_df_kl_1503_nh4 %>%
    group_by(survey_year) %>%
    group_modify(~{
        obs <- .x %>% filter(type == "Measured")
        sim <- .x %>% filter(type == "Simulated")
        
        if (nrow(obs) == 0 | nrow(sim) == 0) return(NULL)
        
        n_keep <- min(nrow(obs), nrow(sim))
        
        obs_sample <- obs[sample(nrow(obs), n_keep), ] %>% mutate(pair_id = row_number())
        sim_sample <- sim[sample(nrow(sim), n_keep), ] %>% mutate(pair_id = row_number())
        
        # Join sampled rows by pair_id
        inner_join(obs_sample, sim_sample, by = "pair_id", suffix = c("_obs", "_sim"))
    }) %>%
    ungroup()

# 2. Extract vectors
obs_NH4_kl_1503 <- balanced_df_kl_1503_nh4$n_nh4_obs
sim_NH4_kl_1503 <- balanced_df_kl_1503_nh4$n_nh4_sim



#use work space from 03.02.2026
keep_NO3_lb_303 <- complete.cases(ss_lb_303_1103_ordered$n_no3, reduced_df_303$NO3_L3_1809_corrected)
obs_NO3_lb_303 <-
    ss_lb_303_1103_ordered$n_no3[keep_NO3_lb_303]
sim__NO3_lb_303 <- 
    reduced_df_303$NO3_L3_1809_corrected[keep_NO3_lb_303]

#use work space from 03.02.2026
keep_NO3_sol_304 <- complete.cases(ss_sol_304_1_103_ordered$n_no3, reduced_df_304$NO3_L3_2209_corrected)
obs_NO3_sol_304 <-
    ss_sol_304_1_103_ordered$n_no3[keep_NO3_sol_304]
sim__NO3_sol_304 <- 
    reduced_df_304$NO3_L3_2209_corrected[keep_NO3_sol_304]



#use work space from 03.02.2026
library(dplyr)
library(tidyr)

set.seed(123)

# 1. Balance data by year and type, keep all sampled rows
balanced_df_kl_1503_no3 <- plot_df_kl_1503_no3 %>%
  group_by(survey_year) %>%
  group_modify(~{
    obs <- .x %>% filter(type == "Measured")
    sim <- .x %>% filter(type == "Simulated")
    
    if (nrow(obs) == 0 | nrow(sim) == 0) return(NULL)
    
    n_keep <- min(nrow(obs), nrow(sim))
    
    obs_sample <- obs[sample(nrow(obs), n_keep), ] %>% 
      mutate(pair_id = row_number())
    
    sim_sample <- sim[sample(nrow(sim), n_keep), ] %>% 
      mutate(pair_id = row_number())
    
    # Pair measured and simulated values
    inner_join(
      obs_sample,
      sim_sample,
      by = "pair_id",
      suffix = c("_obs", "_sim")
    )
  }) %>%
  ungroup()

# 2. Extract vectors
obs_NO3_kl_1503 <- balanced_df_kl_1503_no3$n_no3_obs
sim_NO3_kl_1503 <- balanced_df_kl_1503_no3$n_no3_sim

# Sanity checks
length(obs_NO3_kl_1503)
length(sim_NO3_kl_1503)



#use work space from 03.02.2026
keep_PO4_lb_303 <- complete.cases(ss_lb_303_1103_ordered$p, reduced_df_303$PO4_L3_1309_corrected)
obs_PO4_lb_303 <-
    ss_lb_303_1103_ordered$p[keep_PO4_lb_303]
sim__PO4_lb_303 <- 
    reduced_df_303$PO4_L3_1309_corrected[keep_PO4_lb_303]


#use work space from 03.02.2026
keep_PO4_sol_304 <- complete.cases(ss_sol_304_1_103_ordered$p, reduced_df_304$PO4_L3_2009_corrected)
obs_PO4_sol_304 <-
    ss_sol_304_1_103_ordered$p[keep_PO4_sol_304]
sim__PO4_sol_304 <- 
    reduced_df_304$PO4_L3_2009_corrected[keep_PO4_sol_304]



#use work space from 03.02.2026
library(dplyr)
library(tidyr)

set.seed(123)

# 1. Balance data by year and type, keep all sampled rows
balanced_df_kl_1503_p <- plot_df_kl_1503_p %>%
    group_by(survey_year) %>%
    group_modify(~{
        obs <- .x %>% filter(type == "Measured")
        sim <- .x %>% filter(type == "Simulated")
        
        if (nrow(obs) == 0 | nrow(sim) == 0) return(NULL)
        
        n_keep <- min(nrow(obs), nrow(sim))
        
        obs_sample <- obs[sample(nrow(obs), n_keep), ] %>%
            mutate(pair_id = row_number())
        
        sim_sample <- sim[sample(nrow(sim), n_keep), ] %>%
            mutate(pair_id = row_number())
        
        # Pair measured and simulated values
        inner_join(
            obs_sample,
            sim_sample,
            by = "pair_id",
            suffix = c("_obs", "_sim")
        )
    }) %>%
    ungroup()

# 2. Extract vectors
obs_P_kl_1503 <- balanced_df_kl_1503_p$p_obs
sim_P_kl_1503 <- balanced_df_kl_1503_p$p_sim

# Sanity checks
length(obs_P_kl_1503)
length(sim_P_kl_1503)


# example calculation of statistical metrics
nRMSE(plot_df_lb_303_doc_timeseries_BA$doc[1:297], plot_df_lb_303_doc_timeseries_BA$doc[298:594])
IOA(plot_df_lb_303_doc_timeseries_BA$doc[1:297], plot_df_lb_303_doc_timeseries_BA$doc[298:594])

library(dplyr)
library(tidyr)

plot_df_lb_303_nh4_atm_dep_meas_clean <- plot_df_lb_303_nh4_atm_dep_meas %>%
    select(-Simulated_stat) %>%
    rowwise() %>%
    mutate(
        keep = list(!is.na(unlist(Measured))),
        Measured = list(unlist(Measured)[unlist(keep)]),
        Simulated = list(unlist(Simulated)[unlist(keep)])
    ) %>%
    select(-keep) %>%
    ungroup()

df_blubb <- plot_df_lb_303_nh4_atm_dep_meas %>%
    filter(type != "Simulated_stat")

measured <- df_blubb %>%
    filter(type == "Measured") %>%
    pull(n_nh4)

simulated <- df_blubb %>%
    filter(type == "Simulated") %>%
    pull(n_nh4)


# nh4 soil solution concentrations with measured atmospheric Deposition
# use work space from june 2026
# lb 303
str(plot_df_lb_303_nh4_atm_dep_meas)
'data.frame':	930 obs. of  3 variables:
 $ survey_year: int  1996 1996 1996 1996 1996 1996 1996 1996 1996 1996 ...
 $ n_nh4      : num  NA NA NA NA NA NA NA NA NA NA ...
 $ type       : chr  "Measured" "Measured" "Measured" "Measured" ...
df_blubb <- plot_df_lb_303_nh4_atm_dep_meas %>%
    filter(type != "Simulated_stat")
measured <- df_blubb %>%
    filter(type == "Measured") %>%
    pull(n_nh4)
 
simulated <- df_blubb %>%
    filter(type == "Simulated") %>%
    pull(n_nh4)
length(measured)
length(simulated)

keep <- !is.na(measured)

obs <- measured[keep]
sim <- simulated[keep]

length(obs)
length(sim)

sum(is.na(obs))
sum(is.na(sim))

measured <- df_blubb %>%
    filter(type == "Measured") %>%
    pull(n_nh4)

simulated <- df_blubb %>%
    filter(type == "Simulated") %>%
    pull(n_nh4)

length(measured)
length(simulated)

keep <- !is.na(measured)

obs <- measured[keep]
sim <- simulated[keep]

length(obs)
length(sim)

sum(is.na(obs))
sum(is.na(sim))

> nRMSE <- function(obs, sim) {
+     rmse <- sqrt(mean((sim - obs)^2, na.rm = TRUE))
+     rmse / (max(obs, na.rm = TRUE) - min(obs, na.rm = TRUE))
+ }
> 
> nRMSE(obs, sim)
[1] 0.1960701
> IOA <- function(obs, sim) {
+     num <- sum((sim - obs)^2, na.rm = TRUE)
+     den <- sum((abs(sim - mean(obs, na.rm = TRUE)) +
+                     abs(obs - mean(obs, na.rm = TRUE)))^2, na.rm = TRUE)
+     1 - num / den
+ }
> 
> IOA(obs, sim)
[1] 0.4710868


# nh4 soil solution concentrations with measured atmospheric Deposition
# use work space from june 2026
# sol 304
df_blubb <- plot_df_sol_304_nh4_atm_dep_meas %>%
    filter(type != "Simulated_stat")
measured <- df_blubb %>%
    filter(type == "Measured") %>%
    pull(n_nh4)

simulated <- df_blubb %>%
    filter(type == "Simulated") %>%
    pull(n_nh4)
length(measured)
length(simulated)

keep <- !is.na(measured)

obs <- measured[keep]
sim <- simulated[keep]

length(obs)
length(sim)

sum(is.na(obs))
sum(is.na(sim))

measured <- df_blubb %>%
    filter(type == "Measured") %>%
    pull(n_nh4)

simulated <- df_blubb %>%
    filter(type == "Simulated") %>%
    pull(n_nh4)

length(measured)
length(simulated)

keep <- !is.na(measured)

obs <- measured[keep]
sim <- simulated[keep]

length(obs)
length(sim)

sum(is.na(obs))
sum(is.na(sim))


# no3 soil solution concentrations with measured atmospheric Deposition
# use work space from june 2026
# lb 303
df_blubb <- plot_df_lb_303_no3_atm_dep_meas %>%
    filter(type != "Simulated_stat")
measured <- df_blubb %>%
    filter(type == "Measured") %>%
    pull(n_no3)

simulated <- df_blubb %>%
    filter(type == "Simulated") %>%
    pull(n_no3)
length(measured)
length(simulated)

keep <- !is.na(measured)

obs <- measured[keep]
sim <- simulated[keep]

length(obs)
length(sim)

sum(is.na(obs))
sum(is.na(sim))

measured <- df_blubb %>%
    filter(type == "Measured") %>%
    pull(n_no3)

simulated <- df_blubb %>%
    filter(type == "Simulated") %>%
    pull(n_no3)

length(measured)
length(simulated)

keep <- !is.na(measured)

obs <- measured[keep]
sim <- simulated[keep]

length(obs)
length(sim)

sum(is.na(obs))
sum(is.na(sim))


# no3 soil solution concentrations with measured atmospheric Deposition
# use work space from june 2026
# sol 304
df_blubb <- plot_df_sol_304_no3_atm_dep_meas_L2 %>%
    filter(type != "Simulated_stat")
measured <- df_blubb %>%
    filter(type == "Measured") %>%
    pull(n_no3)

simulated <- df_blubb %>%
    filter(type == "Simulated") %>%
    pull(n_no3)
length(measured)
length(simulated)

keep <- !is.na(measured)

obs <- measured[keep]
sim <- simulated[keep]

length(obs)
length(sim)

sum(is.na(obs))
sum(is.na(sim))

measured <- df_blubb %>%
    filter(type == "Measured") %>%
    pull(n_no3)

simulated <- df_blubb %>%
    filter(type == "Simulated") %>%
    pull(n_no3)

length(measured)
length(simulated)

keep <- !is.na(measured)

obs <- measured[keep]
sim <- simulated[keep]

length(obs)
length(sim)

sum(is.na(obs))
sum(is.na(sim))


# po4 soil solution concentrations from layer 3
# use work space from june 2026
# sol 304
df_blubb <- plot_df_sol_304_p_L2 %>%
    filter(type != "Simulated_stat")
measured <- df_blubb %>%
    filter(type == "Measured") %>%
    pull(p)

simulated <- df_blubb %>%
    filter(type == "Simulated") %>%
    pull(p)
length(measured)
length(simulated)

keep <- !is.na(measured)

obs <- measured[keep]
sim <- simulated[keep]

length(obs)
length(sim)

sum(is.na(obs))
sum(is.na(sim))

measured <- df_blubb %>%
    filter(type == "Measured") %>%
    pull(p)

simulated <- df_blubb %>%
    filter(type == "Simulated") %>%
    pull(p)

length(measured)
length(simulated)

keep <- !is.na(measured)

obs <- measured[keep]
sim <- simulated[keep]

length(obs)
length(sim)

sum(is.na(obs))
sum(is.na(sim))