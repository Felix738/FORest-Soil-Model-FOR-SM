# Define input parameters for a fifteen layer soil
tsurf <- c(290,291,292,295)  # Surface temperature (K)
dt <- 1800  # Time step (s)

physcon <- list(
  hfus = 333500,  # Heat of fusion for water at 0°C (J/kg)
  tfrz = 273.15   # Freezing point of water (K)
)  # You need to provide appropriate values for physcon
soilvar <- list(
  method = "excess-heat",  # Choose method: "excess-heat" or "apparent-heat-capacity"
  nsoi = 15,  # Number of soil layers
  z = c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5),  # Soil depth (m)
  z_plus_onehalf = c(0.05, 0.15, 0.25, 0.35, 0.45, 0.55, 0.65, 0.75, 0.85, 0.95, 
                     1.05, 1.15, 1.25, 1.35, 1.45),  # Soil depth (m) at i+1/2 interface between layers i and i+1
  dz = rep(0.1, 15),  # Soil layer thickness (m)
  dz_plus_onehalf = rep(0.05, 15),  # Thickness (m) between between i and i+1
  tk = c(1.6, 1.6, 1.6, 1.6, 1.6, 1.6,1.6,1.6,1.6,1.6,1.6,1.6,1.6,1.6,1.6),  # Thermal conductivity (W/m/K)
  cv = c(2400, 2400, 2400, 2400, 2400,2400,2400,2400,2400,2400,2400,2400,2400,2400,2400),  # Heat capacity (J/m3/K)
  tsoi = matrix(tsurf[1],length(tsurf),15),  # Initial soil temperature (K) for each soil layer
  h2osoi_liq = c(0.5, 0.5, 0.5, 0.5, 0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5),  # Unfrozen water, liquid (kg H2O/m2)
  h2osoi_ice = c(0.01, 0.02, 0.03, 0.04, 0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05)  # Frozen water, ice (kg H2O/m2)
)


for (j in 1:length(tsurf)) {
  # Save current soil temperature for energy conservation check
  tsoi0 <- soilvar$tsoi
  
  # Thermal conductivity at interface (W/m/K)
  tk_plus_onehalf <- numeric(length = soilvar$nsoi - 1)
  for (i in 1:(soilvar$nsoi - 1)) {
    tk_plus_onehalf[i] <- soilvar$tk[i] * soilvar$tk[i + 1] * (soilvar$z[i] - soilvar$z[i + 1]) / 
      (soilvar$tk[i] * (soilvar$z_plus_onehalf[i] - soilvar$z[i + 1]) + soilvar$tk[i + 1] * (soilvar$z[i] - soilvar$z_plus_onehalf[i]))
  }
  
  # Set up tridiagonal matrix
  a <- numeric(length = soilvar$nsoi)
  b <- numeric(length = soilvar$nsoi)
  c <- numeric(length = soilvar$nsoi)
  d <- numeric(length = soilvar$nsoi)
  
  # Top soil layer with tsurf as boundary condition
  m <- soilvar$cv[1] * soilvar$dz[1] / dt
  a[1] <- 0
  c[1] <- -tk_plus_onehalf[1] / soilvar$dz_plus_onehalf[1]
  b[1] <- m - c[1] + soilvar$tk[1] / (0 - soilvar$z_plus_onehalf[1])
  d[1] <- m * soilvar$tsoi[1] + soilvar$tk[1] / (0 - soilvar$z_plus_onehalf[1]) * tsurf[j]
  
  # Layers 2 to nsoi-1
  for (i in 2:(soilvar$nsoi - 1)) {
    m <- soilvar$cv[i] * soilvar$dz[i] / dt
    a[i] <- -tk_plus_onehalf[i - 1] / soilvar$dz_plus_onehalf[i - 1]
    c[i] <- -tk_plus_onehalf[i] / soilvar$dz_plus_onehalf[i]
    b[i] <- m - a[i] - c[i]
    d[i] <- m * soilvar$tsoi[j,i]
  }
  
  # Bottom soil layer with zero heat flux
  i <- soilvar$nsoi
  m <- soilvar$cv[i] * soilvar$dz[i] / dt
  a[i] <- -tk_plus_onehalf[i - 1] / soilvar$dz_plus_onehalf[i - 1]
  c[i] <- 0
  b[i] <- m - a[i]
  d[i] <- m * soilvar$tsoi[j,i]
  
  # Solve for soil temperature
  soilvar$tsoi[j,] <- tridiagonal_solver(a, b, c, d, soilvar$nsoi)
  
  # Derive energy flux into soil (W/m2)
  soilvar$gsoi <- soilvar$tk[1] * (tsurf[1] - soilvar$tsoi[1]) / (0 - soilvar$z_plus_onehalf[1])

}  

  # Phase change for soil layers undergoing freezing or thawing
#  switch(soilvar$method,
#         "apparent-heat-capacity" = {
#           # No explicit phase change energy flux. This is included in the heat capacity.
#           soilvar$hfsoi <- 0
#         },
#         "excess-heat" = {
#           # Adjust temperatures for phase change. Freeze or melt ice using energy
#           # excess or deficit needed to change temperature to the freezing point.
#           # The variable hfsoi is returned as the energy flux from phase change (W/m2).
#           soilvar <- phase_change(physcon, soilvar, dt)
#         }
#  )
  
  # Check for energy conservation
  # Sum change in energy (W/m2)
  edif <- 0
  for (i in 1:soilvar$nsoi) {
    edif <- edif + soilvar$cv[i] * soilvar$dz[i] * (soilvar$tsoi[i] - tsoi0[i]) / dt
  }
  
  # Error check
  err <- edif - soilvar$gsoi - soilvar$hfsoi
  if (abs(err) > 1e-03) {
    stop("Soil temperature energy conservation error")
  }

  
#rename matrix for JSM forcing
soil_temp <- soilvar$tsoi
soil_temp


################################################################################
# 1. soil temperature simulation lange bramke ##################################
################################################################################

#check beforehand if air temperatures from day_lb_303_AT, solar radiation values
#from day_lb_303_SR and lai from FORMIND simulation are available
#calculate surface temperatures based on air temperatures, solar radiation and 
#lai
#create a for loop which calculates increased surface temperature values if 
#solar radiation is above mean solar radiation of the simulated time period 
#--> also takes lai into account
#repeat lai from FORMIND simulation 365 times to obtain daily from annual values
#--> this is only a preliminary result --> also possible to obtain daily 
#simulation outputs from FORMIND directly
LAI_lb_lai_daily <- rep(LAI_lb$LAI[1:25], each = 365)

# also estimate the snow cover to include it in the calculation of surface temp
# Parameters
snow_threshold_temp <- 0  # °C, threshold for snow vs rain
melt_factor <- 3  # mm/°C/day, tune this (2–5 is typical)

# Initialize vector
estimated_snow_mm <- numeric(length(slb1_meteo_lb303$tmean))
snowpack <- 0

for (i in 1:length(slb1_meteo_lb303$tmean)) {
  temp <- slb1_meteo_lb303$tmean[i]
  precip <- slb1_meteo_lb303$prec[i]  # mm/day
  
  # Snowfall
  if (temp <= snow_threshold_temp) {
    snowfall <- precip
  } else {
    snowfall <- 0
  }
  
  # Melt (only when above 0°C)
  if (temp > snow_threshold_temp) {
    melt <- min(snowpack, melt_factor * (temp - snow_threshold_temp))
  } else {
    melt <- 0
  }
  
  # Update snowpack
  snowpack <- snowpack + snowfall - melt
  snowpack <- max(snowpack, 0)  # prevent negative values
  
  # Store estimated snow water equivalent
  estimated_snow_mm[i] <- snowpack
  
  if (is.na(estimated_snow_mm[i])) {
    estimated_snow_mm[i] <- 0
  }
}

#calculate surface temperature with preliminary factors
surf_temp_lb_303 <- c()
for (i in 1:(length(LAI_lb_lai_daily))) {
  if (slb1_meteo_lb303$globrad[i] > mean(slb1_meteo_lb303$globrad, na.rm = TRUE)) {
    surf_temp_lb_303[i] <- slb1_meteo_lb303$tmean[i] + ((1 + (((mean(slb1_meteo_lb303$globrad) / 100) * slb1_meteo_lb303$globrad[i]))) * ((LAI_lb_lai_daily[i]) * (-1 / 4) + 0.25))
  } else {
    surf_temp_lb_303[i] <- slb1_meteo_lb303$tmean[i]
  }
}

# also include a snow cover insulation effect
for (i in 1:(length(LAI_lb_lai_daily))) {
  if (estimated_snow_mm[i] > 0) {
    surf_temp_lb_303[i] <- surf_temp_lb_303[i] + 6  # or whatever offset makes sense
  }
}

str(surf_temp_lb_303)
plot(surf_temp_lb_303, col = "white")
lines(surf_temp_lb_303, col = "black")
#plot(surf_temp, ylim = c(-7,35))
#points(slb1_meteo_lb303$tmean, col = "white")
lines(slb1_meteo_lb303$tmean, col = "blue")
#comment: this function should definitely be inproved but it is used for now as 
#a preliminary output


################################################################################
# 1.1 apply soil temperature script for lange bramke ###########################
################################################################################

# comment: soilvar list contains preliminary values --> have to be adjusted again
# especially the water content and the thermal conductivity
# Define input parameters for a fifteen layer soil
# remark: the time step seems to play a really big role for the scope of the 
# output values --> check if this is a mistake
tsurf <- surf_temp_lb_303 + 273.15  # Surface temperature (K)
dt <- 600  # Time step (s) 

physcon <- list(
  hfus = 333500,  # Heat of fusion for water at 0°C (J/kg)
  tfrz = 273.15   # Freezing point of water (K)
)  # You need to provide appropriate values for physcon
soilvar <- list(
  method = "excess-heat",  # Choose method: "excess-heat" or "apparent-heat-capacity"
  nsoi = 15,  # Number of soil layers
  z = c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.1, 1.2, 1.3, 1.4, 1.5),  # Soil depth (m)
  z_plus_onehalf = c(0.05, 0.15, 0.25, 0.35, 0.45, 0.55, 0.65, 0.75, 0.85, 0.95, 
                     1.05, 1.15, 1.25, 1.35, 1.45),  # Soil depth (m) at i+1/2 interface between layers i and i+1
  dz = rep(0.1, 15),  # Soil layer thickness (m)
  dz_plus_onehalf = rep(0.05, 15),  # Thickness (m) between between i and i+1
  tk = c(1.2, 1.2, 1.2, 1.2, 1.2, 1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.2,1.2),  # Thermal conductivity (W/m/K)
  cv = c(240, 2400, 2400, 2400, 2400,2400,2400,2400,2400,2400,2400,2400,2400,2400,2400),  # Heat capacity (J/m3/K)
  tsoi = matrix(tsurf[1],length(tsurf),15),  # Initial soil temperature (K) for each soil layer
  h2osoi_liq = c(0.5, 0.5, 0.5, 0.5, 0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5),  # Unfrozen water, liquid (kg H2O/m2)
  h2osoi_ice = c(0.01, 0.02, 0.03, 0.04, 0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05)  # Frozen water, ice (kg H2O/m2)
)


for (j in 1:length(tsurf)) {
  # Save current soil temperature for energy conservation check
  tsoi0 <- soilvar$tsoi
  
  # Thermal conductivity at interface (W/m/K)
  tk_plus_onehalf <- numeric(length = soilvar$nsoi - 1)
  for (i in 1:(soilvar$nsoi - 1)) {
    tk_plus_onehalf[i] <- soilvar$tk[i] * soilvar$tk[i + 1] * (soilvar$z[i] - soilvar$z[i + 1]) / 
      (soilvar$tk[i] * (soilvar$z_plus_onehalf[i] - soilvar$z[i + 1]) + soilvar$tk[i + 1] * (soilvar$z[i] - soilvar$z_plus_onehalf[i]))
  }
  
  # calculate heat capacity as a function of soil texture and soil moisture
  # cv quartz = 2120
  # cv clay = 2440
  # cv organic matter = 2500
  # cv water = 4190
  # cv ice = 1880
  # cv air = 0.0012
  soilvar$cv[i] <- (slb1_soil_lb_303$sand[i] * 2120) + (slb1_soil_lb_303$clay[i] * 2440) + (slb1_soil_lb_303$c_org[i] * 2500) + (lwfb90_res_lb_303$layer_output$theta[j + i * (length(lwfb90_res_lb_303$layer_output$theta) / 15)] * 4190) + (1 - (lwfb90_res_lb_303$layer_output$theta[j + i * (length(lwfb90_res_lb_303$layer_output$theta) / 15))] * 0.0012))
  
  # calculate thermal conductivity as a function of soil texture and soil moisture
  # tk quartz = 8.8
  # tk clay = 2.92
  # tk organic matter = 0.25
  # tk water = 0.57
  # tk ice = 2.18
  # tk air = 0.025
  soilvar$tk[i] <- (slb1_soil_lb_303$sand[i] * 8.8) + (slb1_soil_lb_303$clay[i] * 2.92) + (slb1_soil_lb_303$c_org[i] * 0.25) + (lwfb90_res_lb_303$layer_output$theta[j + i * (length(lwfb90_res_lb_303$layer_output$theta) / 15)] * 0.57) + (1 - (lwfb90_res_lb_303$layer_output$theta[j + i * (length(lwfb90_res_lb_303$layer_output$theta) / 15))] * 0.025))
  
  # Set up tridiagonal matrix
  a <- numeric(length = soilvar$nsoi)
  b <- numeric(length = soilvar$nsoi)
  c <- numeric(length = soilvar$nsoi)
  d <- numeric(length = soilvar$nsoi)
  
  # Top soil layer with tsurf as boundary condition
  m <- soilvar$cv[1] * soilvar$dz[1] / dt
  a[1] <- 0
  c[1] <- -tk_plus_onehalf[1] / soilvar$dz_plus_onehalf[1]
  b[1] <- m - c[1] + soilvar$tk[1] / (0 - soilvar$z_plus_onehalf[1])
  d[1] <- m * soilvar$tsoi[1] + soilvar$tk[1] / (0 - soilvar$z_plus_onehalf[1]) * tsurf[j]
  
  # Layers 2 to nsoi-1
  for (i in 2:(soilvar$nsoi - 1)) {
    m <- soilvar$cv[i] * soilvar$dz[i] / dt
    a[i] <- -tk_plus_onehalf[i - 1] / soilvar$dz_plus_onehalf[i - 1]
    c[i] <- -tk_plus_onehalf[i] / soilvar$dz_plus_onehalf[i]
    b[i] <- m - a[i] - c[i]
    d[i] <- m * soilvar$tsoi[j,i]
  }
  
  # Bottom soil layer with zero heat flux
  i <- soilvar$nsoi
  m <- soilvar$cv[i] * soilvar$dz[i] / dt
  a[i] <- -tk_plus_onehalf[i - 1] / soilvar$dz_plus_onehalf[i - 1]
  c[i] <- 0
  b[i] <- m - a[i]
  d[i] <- m * soilvar$tsoi[j,i]
  
  # Solve for soil temperature
  soilvar$tsoi[1,] <- tsurf[1] - i * 2  # Example: decrease by 2 K per layer
  soilvar$tsoi[j,] <- tridiagonal_solver(a, b, c, d, soilvar$nsoi)
  
  # Derive energy flux into soil (W/m2)
  soilvar$gsoi <- soilvar$tk[1] * (tsurf[1] - soilvar$tsoi[1]) / (0 - soilvar$z_plus_onehalf[1])
  
}  

# Phase change for soil layers undergoing freezing or thawing
#  switch(soilvar$method,
#         "apparent-heat-capacity" = {
#           # No explicit phase change energy flux. This is included in the heat capacity.
#           soilvar$hfsoi <- 0
#         },
#         "excess-heat" = {
#           # Adjust temperatures for phase change. Freeze or melt ice using energy
#           # excess or deficit needed to change temperature to the freezing point.
#           # The variable hfsoi is returned as the energy flux from phase change (W/m2).
#           soilvar <- phase_change(physcon, soilvar, dt)
#         }
#  )

# Check for energy conservation
# Sum change in energy (W/m2)
# edif <- 0
# for (i in 1:soilvar$nsoi) {
#   edif <- edif + soilvar$cv[i] * soilvar$dz[i] * (soilvar$tsoi[i] - tsoi0[i]) / dt
# }

# Error check
# err <- edif - soilvar$gsoi - soilvar$hfsoi
# if (abs(err) > 1e-03) {
#   stop("Soil temperature energy conservation error")
# }


# check outputs
str(soilvar$tsoi)
# first soil layer
plot(soilvar$tsoi[,1] - 273.15)
points(tsurf - 273.15, col = "blue")
# last soil layer
plot(soilvar$tsoi[,15] - 273.15)
points(tsurf - 273.15, col = "blue")
# soil layers combined
plot(tsurf - 273.15, col = "black", ylim = c(-20,50))
points(soilvar$tsoi[,1] - 273.15, col = "blue")
points(soilvar$tsoi[,15] - 273.15, col = "brown")

# check acutual soil temperature
day_lb_303_ST <- subset(day_lb_303, code_variable == "ST")
# order values by observation dates
day_lb_303_ST <- day_lb_303_ST[order(day_lb_303_ST$date_observation),]
str(day_lb_303_ST)
plot(day_lb_303_ST$daily_mean)

# repeat values to obtain half hourly values and rename matrix for JSM forcing
soilvar$tsoi_half_hourly <- matrix(0, (nrow(soilvar$tsoi)*48), 15)

for (i in 1:(ncol(soilvar$tsoi))) {
  soilvar$tsoi_half_hourly[,i] <- rep(soilvar$tsoi[,i], each = 48)
}

str(soilvar$tsoi_half_hourly)
soil_temp_lb_303 <- soilvar$tsoi_half_hourly
str(soil_temp_lb_303)
