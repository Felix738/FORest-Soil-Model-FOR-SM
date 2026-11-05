################################################################################
# preparation climate input data lange bramke FORMIND simulation  ##############
################################################################################

# set working directory to external memory device because the file is too large 
# for the internal disk of this computer
getwd()
setwd("D:/ASAM UFZ soil modelling/ICP data/meteorology all monitoring sites/497_mm_20240510110800")

# read in hourly temperature data
temp_lb <- read.delim("mm_meh.csv", sep = ";", header = TRUE)
str(temp_lb)

temp_lb_303 <- subset(temp_lb, code_plot == 303)
str(temp_lb_303)

# read in daily climate data (different variables --> check abbreviations)
day_lb <- read.delim("mm_mem.csv", sep = ";", header = TRUE)
str(day_lb)

day_lb_303 <- subset(day_lb, code_plot == 303)
str(day_lb_303)
boxplot(day_lb_303$daily_mean ~ day_lb_303$code_variable)
day_lb_304 <- subset(day_lb, code_plot == 304)
str(day_lb_304)
# check data for completeness according to observation date
day_lb_303_obs <- subset(day_lb_303, date_observation == "2007-03-11")
str(day_lb_303_obs)

# read in soil solution measurements 
getwd()
setwd("D:/ASAM UFZ soil modelling/ICP data/soil solution all monitoring sites")

# create initial slb1_meteo dataframe for the lange brahmke site
library(LWFBrook90R)
data(slb1_meteo, slb1_soil)
slb1_meteo_lb303 <- slb1_meteo[1:9132,]
# transform observation dates to slb1_meteo_lb303 dataset
day_lb_303_AT <- subset(day_lb_303, code_variable == "AT")
# order values by observation dates
day_lb_303_AT <- day_lb_303_AT[order(day_lb_303_AT$date_observation),]
slb1_meteo_lb303$dates <- day_lb_303_AT$date_observation
slb1_meteo_lb303$dates <- as.Date(slb1_meteo_lb303$dates)
str(slb1_meteo_lb303$dates)

# transform daily minimum/maximum/mean temperatures to slb1_meteo_lb303
slb1_meteo_lb303$tmin <- day_lb_303_AT$daily_min
slb1_meteo_lb303$tmax <- day_lb_303_AT$daily_max
slb1_meteo_lb303$tmean <- day_lb_303_AT$daily_mean

# transform precipitation to slb1_meteo_lb303
# check mismatch in length
# form precipitation subset
day_lb_303_PR <- subset(day_lb_303, code_variable == "PR")
# order values by observation dates
day_lb_303_PR <- day_lb_303_PR[order(day_lb_303_PR$date_observation),]
slb1_meteo_lb303$prec[1:2557] <- NA
slb1_meteo_lb303$prec[2558:9132] <- day_lb_303_PR$daily_mean

# transform relative humidity to slb1_meteo_lb303
day_lb_303_RH <- subset(day_lb_303, code_variable == "RH")
# order values by observation dates
day_lb_303_RH <- day_lb_303_RH[order(day_lb_303_RH$date_observation),]
slb1_meteo_lb303$relhum <- day_lb_303_RH$daily_mean

# transform solar radiation to slb1_meteo_lb303
day_lb_303_SR <- subset(day_lb_303, code_variable == "SR")
# order values by observation dates
day_lb_303_SR <- day_lb_303_SR[order(day_lb_303_SR$date_observation),]
# transform radiation values from W m-2 hour-1 to MJ (Megajoule) m-2 day-1 and 
day_lb_303_SR$daily_mean <- day_lb_303_SR$daily_mean * 0.0036 * 24
slb1_meteo_lb303$globrad <- day_lb_303_SR$daily_mean

# transform wind speed to slb1_meteo_lb303
day_lb_303_WS <- subset(day_lb_303, code_variable == "WS")
# order values by observation dates
day_lb_303_WS <- day_lb_303_WS[order(day_lb_303_WS$date_observation),]
slb1_meteo_lb303$windspeed[1:4749] <- NA
slb1_meteo_lb303$windspeed[4750:9132] <- day_lb_303_WS$daily_mean


# approximate vapor pressure (kPa) from air temperature values and relative 
# humidity
slb1_meteo_lb303$vappres <- slb1_meteo_lb303$relhum * 0.01


# create vector for FORMIND input
rain <- slb1_meteo_lb303$prec
temperature <- slb1_meteo_lb303$tmean
# transform W m-2 to µmol sec-1 m-2 for solar radiation
irradiance <- (slb1_meteo_lb303$globrad) * 4.6 / (0.0036 * 24)
# obtain potential evapotranspiration from LW Brook 90 model results
PET <- (lwfb90_res_lb_303$output$ptran + lwfb90_res_lb_303$output$pslvp)
# obtain daylength by repetition of one year
getwd()
setwd("C:/Users/haeffner/Documents/Practical/data")
example_climate_harz <- read.delim("test_climate_temperate_general1.txt", sep = " ", header = TRUE)
str(example_climate_harz)
plot(example_climate_harz$daylength[1:365])
annual_daylength_harz <- example_climate_harz$daylength[1:365]
daylength <- rep(annual_daylength_harz, 25)
# this repetition results in a mismatch of 7 days in the last year but 
# continuously over the whole simulation period
# fill last seven daylength values via repetition of the last value
daylength[9126:9132] <- rep(daylength[9125], 7)
str(daylength)
# obtain CO2 concentration by repetition of one year
getwd()
setwd("C:/Users/haeffner/Documents/Practical/data")
example_climate_harz <- read.delim("test_climate_temperate_general1.txt", sep = " ", header = TRUE)
str(example_climate_harz)
plot(example_climate_harz$C02[1:365])
annual_CO2_harz <- example_climate_harz$C02[1:365]
CO2 <- rep(annual_CO2_harz, 25)
# this repetition results in a mismatch of 7 days in the last year but 
# continuously over the whole simulation period
# fill last seven daylength values via repetition of the last value
CO2[9126:9132] <- rep(CO2[9125], 7)
str(CO2)

# create data frame from climate vectors for the FORMIND simulation
climate_formind_lb <- data.frame(rain,temperature,irradiance,PET,daylength,CO2)
#export FORMIND climate forcing 
getwd()
setwd("C:/Users/haeffner/Documents/Practical/data")
library("readr")
write_tsv(format(climate_formind_lb, digits=3, scientific = F), file = "climate_formind_lb.txt")
# comment: use inventory file 4387_3165_10.958_51.595.inv as exemplary input for 
# FORMIND simulation of the lange bramke site, also use the above created 
# comment: in order to simulate forest diebacks a background mortality of 0.2 was 
# applied in the par file

getwd()
setwd("C:/Users/haeffner/Documents/Practical/data")
library("readr")
write_tsv(format(forest_inventory_lb_304_1995_2, digits=3, scientific = F), file = "forest_inventory_lb_304_1995_2.txt")

################################################################################
# plotting FORMIND simulation results from the lange bramke  ###################
################################################################################

#load FORMIND example data
#check if directory is right and set it right
getwd()
setwd("C:/Users/haeffner/Documents/Practical/data")

#read in FORMIND outputs in regard to biomass
#delete explanatory header with units and only leave unitless headers in FORMIND 
#output files
#BT_lb <- read.delim("working_par_File_BWI2_RF_mort.bt", sep = "\t", header = TRUE)
BT_lb <- read.delim("working_par_File_BWI2_RF.bt", sep = "\t", header = TRUE)
str(BT_lb)
#BT[1,]
#add column names from existing row
#colnames(BT) <- BT[1,]
plot(BT_lb$TotalBiomass, col="black", xlab = "Timestep[years]", 
     ylab = "Total Biomass[tons C ha-1]")
legend(40, 200, legend=c("Total", "PFT 1", "PFT 2", "PFT 3", "PFT 4", "PFT 5", 
                         "PFT 6", "PFT 7", "PFT 8"), col=c("black", "purple", 
                                                           "pink", "blue", "orange", "yellow", "green", "brown", 
                                                           "red"),lty=1, cex=0.7)
#add other plant functional types if applicable --> in this case there is only the 
#plant functional type 2
#points(BT_lb$BiomassPerPFT_1, col="purple")
#points(BT_lb$BiomassPerPFT_2, col="pink")
#points(BT_lb$BiomassPerPFT_3, col="blue")
#points(BT_lb$BiomassPerPFT_4, col="orange")
#points(BT_lb$BiomassPerPFT_5, col="yellow")
#points(BT_lb$BiomassPerPFT_6, col="green")
#points(BT_lb$BiomassPerPFT_7, col="brown")
#points(BT_lb$BiomassPerPFT_8, col="red")

#read in FORMIND outputs in regard to dead biomass
#also here delete all explanatory headers with units
#dead_BT_lb <- read.delim("working_par_File_BWI2_RF_mort.mort", sep = "\t", header = TRUE)
dead_BT_lb <- read.delim("working_par_File_BWI2_RF.mort", sep = "\t", header = TRUE)
str(dead_BT_lb)
#for some reason the values have to be multiplied by 100 due to a mistake with 
#reading in the data
#dead_BT_lb$TotB <- dead_BT_lb$TotB * 100
#BT[1,]
#add column names from existing row
#colnames(BT) <- BT[1,]
#plot total dead biomass per timestep [tODM ha-1 a-1] 
plot(dead_BT_lb$TotB, col="black")

#read in FORMIND outputs in regard to lai
#also here delete all explanatory headers with units
# LAI_lb <- read.delim("working_par_File_BWI2_RF_mort.lai_mean", sep = "\t", header = TRUE)
LAI_lb <- read.delim("working_par_File_BWI2_RF.lai_mean", sep = "\t", header = TRUE)
str(LAI_lb)
#plot mean lai per timestep
plot(LAI_lb$LAI, col="black")

#plot stem volume of FORMIND simulation for lb 303
stem_vol <- read.delim("lb_303_formind_stem_vol.txt", sep = "\t", dec = ".", header = TRUE)
str(stem_vol)
#plot(stem_vol$TotalStemVolume)


################################################################################
# 1.1 Root fraction transfer function lange bramke #############################
################################################################################

#estimate 25% of tree biomass as root biomass
root_biomass_lb <- BT_lb$TotalBiomass * 0.25
str(root_biomass_lb)

#check examplary root distribution
root_dist_hainich <- c(0.21,0.162,0.13,0.11,0.118,0.11,0.085, 0.055,0.0255,0.0082,
                       0.000125,0,0,0,0)
plot(root_dist_hainich)

#try out an approach where the root anatomy is taken into account --> the 
#outcome describes the rooting depth in cm, root distribution is 
#determined by a parametrisation mix of the different tree species
#parametrisation of a in dependence of tree species (all tree species b =  
#maximum rooting depth in cm, c = total root biomass of all tree species, spruce
#a = 0.9, pine a = 0.8, beech a = 0.5, oak a =0.2, poplar = 0.4,, ash a = 0.3, 
#birch = 0.6, robinia = 0.5) --> those are very general estimates
#in case of mixed stands it could be an approach to determine as a fraction 
#of the biomass distribution of the respective tree species
#alternative values to try out: spruce a = 0.3, pine a = 0.23, beech a = 0.23, 
#oak = 0.2, poplar = 0.22, ash a = 0.21
x <- seq(1,100,1)
root_dist_cm <- exp(-a*(x/b) * a * root_biomass_lb[1]) 
#distribute roots to different soil layers
soil_depth <- 100
layer_depth <- ceiling(length(root_dist_cm) / 15)  # Depth of each layer in cm
# Loop to distribute root distribution
root_dist_layer <- matrix()
for (i in 1:15) {
  # Calculate the start and end indices for the current layer
  start_index <- (i - 1) * layer_depth + 1
  end_index <- min(i * layer_depth, length(root_dist_cm))
  # mean of the fractions within the current layer
  root_dist_layer[i] <- mean(root_dist_cm[start_index:end_index])
}

#extend from first timestep to all the other timesteps
root_dist_cm <- matrix(NA, nrow = length(root_biomass_lb), ncol = length(x))
for (j in 1:length(root_biomass_lb)) {
  x <- seq(1, 100, 1)
  for (i in 1:length(x)) {
    root_dist_cm[j, i] <- exp(-0.9 * (x[i] / 100) * 0.9 * root_biomass_lb[j]) 
  }
}
# Initialize root_dist_layer to store the mean of root biomass per layer
root_dist_layer <- matrix(NA, nrow = length(root_biomass_lb), ncol = 15)
# Define soil depth and layer depth
soil_depth <- 100
layer_depth <- ceiling(soil_depth / 15)  # Depth of each layer in cm
# Loop to distribute root distribution into soil layers
for (j in 1:length(root_biomass_lb)) {
  for (i in 1:15) {
    # Calculate the start and end indices for the current layer
    start_index <- (i - 1) * layer_depth + 1
    end_index <- min(i * layer_depth, length(x))
    
    # Mean of the fractions within the current layer for root biomass
    root_dist_layer[j, i] <- mean(root_dist_cm[j, start_index:end_index])
  }
}

#distribute to half-hourly timestepx
root_dist_layer_long_lb <- matrix(rep(root_dist_layer, each = 17520), ncol = ncol(root_dist_layer), byrow = FALSE)

#use root biomass as basis to estimate root depth --> total biomass of 200t C ha-1
#equals a root depth of 2 m --> linear function from 0m to 2m
#alternative approach 1: use mean tree height?
#alternative approach 2: make the reference of 2m rooting depth for a mature forest
#stand of 200t C ha-1 dependent on tree species composition --> calculate mean 
#root depth per forest stand?

root_depth_lb <- BT_lb$TotalBiomass * (2/200)
plot(root_depth_lb) 
#correction if root depth is greater then soil depth[m] 
soil_depth_m <- 1
for (i in 1:length(root_depth_lb)) {
  if (root_depth_lb[i] > soil_depth_m) {
    root_depth_lb[i] <- soil_depth_m
  }
}
#plot(root_depth_lb) 

#more refined approach: make root depth dependent on tree species composition
#parametrisation necessary for each plant functional type
#root_depth_lb_spec <- ((BT_lb$BiomassPerPFT_1 /  BT_lb$TotalBiomass) * (2/200)) + 
#                      ((BT_lb$BiomassPerPFT_2 /  BT_lb$TotalBiomass) * (2/200)) +
#                      ((BT_lb$BiomassPerPFT_3 /  BT_lb$TotalBiomass) * (2/200)) +
#                      ((BT_lb$BiomassPerPFT_4 /  BT_lb$TotalBiomass) * (2/200)) +
#                      ((BT_lb$BiomassPerPFT_5 /  BT_lb$TotalBiomass) * (2/200)) +
#                      ((BT_lb$BiomassPerPFT_6 /  BT_lb$TotalBiomass) * (2/200)) +
#                      ((BT_lb$BiomassPerPFT_7 /  BT_lb$TotalBiomass) * (2/200)) +
#                      ((BT_lb$BiomassPerPFT_8 /  BT_lb$TotalBiomass) * (2/200)) +
#correction if root depth is greater then soil depth[m] 
#soil_depth_m <- 1
#for (i in 1:length(root_depth_lb)) {
#  if (root_depth_lb[i] > soil_depth_m) {
#    root_depth_lb[i] <- soil_depth_m
#  }
#}
#plot(root_depth_lb_spec) 

#determine conversion factor from soil depth to soil layers
soil_conversion <- 15/1
values_root <- seq(1, 15, 1)

#calculate root fraction for frst timestep
root_fraction_lb <- (-0.22 / (root_depth_lb[1] * soil_conversion)) * values_root + 0.22
#root_fraction <- (-0.22 / (2 * soil_conversion)) * values_root + 0.22

plot(root_fraction_lb)

matrix_root_lb <- matrix(nrow = length(root_depth_lb), ncol = length(values_root))

#calculate root fraction for all timesteps
for (i in 1:(length(root_depth_lb))) {
  
  values_root <- seq(1, 15, 1)
  root_fraction_lb <- (-0.22 / (root_depth_lb[i] * soil_conversion)) * values_root + 0.22
  #plot(root_fraction)
  
  for (j in 1:15) {
    if (root_fraction_lb[j] < 0) {
      root_fraction_lb[j] <- 0
    }
  }
  
  root_fraction1_lb <- t(root_fraction_lb)
  matrix_root_lb[i,] <- root_fraction1_lb
  
}

str(matrix_root_lb)

#extend matrix to half-hourly timesteps
matrix_root_long_lb <- matrix(nrow = (length(root_depth_lb)*17520), ncol = length(values_root))
root_fraction_long_lb <- root_fraction_lb
root_depth_long_lb <- rep(root_depth_lb, each = 17520)

#calculate root fraction for all timesteps
for (i in 1:(length(root_depth_long_lb))) {
  
  values_root <- seq(1, 15, 1)
  root_fraction_long_lb <- (-0.22 / (root_depth_long_lb[i] * soil_conversion)) * values_root + 0.22
  #plot(root_fraction)
  
  for (j in 1:15) {
    if (root_fraction_long_lb[j] < 0) {
      root_fraction_long_lb[j] <- 0
    }
  }
  
  root_fraction1_long_lb <- t(root_fraction_long_lb)
  matrix_root_long_lb[i,] <- root_fraction1_long_lb
  
}

str(matrix_root_long_lb)


################################################################################
# 2.1 VegPoolFineRootCarbon ####################################################
################################################################################

#estimate fine root biomass as 10% of total biomass (estimating fine-root biomass 
#by jürgen bauhus)
#remark: develop fine root biomass development further to include seasonal dynamics 
#because this greatly influences seasonal nutrient uptake
fine_root_biomass_lb_303 <- rep((root_biomass_lb * 0.1), each = 17520)
str(fine_root_biomass_lb_303)


################################################################################
# 3.1 demandUptakeN and demandUptakeP (run this after computing litterfall) ####
################################################################################

#calculate biomass increment per timestep (for calibration issues this biomass 
#increment was fixed for only positive numbers and then corrected for the total 
#biomass again)
biomass_increment_lb_303 <- vector()

for (i in 2:(length(BT_lb$TotalBiomass))) {
  biomass_increment_lb_303[i] <- ((BT_lb$TotalBiomass[i] + dead_BT_lb$TotB[i])  - BT_lb$TotalBiomass[i-1]) * BT_lb$TotalBiomass[i]
}

biomass_increment_lb_303[1] <- 0

plot(biomass_increment_lb_303)

#calculate nutrient demand as biomass increment and litter input per timestep
nut_dem_N_lb_303 <- vector()

for (i in 2:(length(biomass_increment_lb_303))) {
  nut_dem_N_lb_303[i] <- biomass_increment_lb_303[i] #+ leaf_C[i-1] + leaf_N[i-1] + leaf_P[i-1]
}

#distribute nutrient demand over the year in half hourly timesteps
#so far the first test option works better
# Load necessary library
#install.packages("pracma")
library(pracma)

# Define your bell-shaped function (Gaussian)
#first test with for loop
# Parameters for the bell-shaped function
mu <- 8760  # Mean
sigma <- 2500  # Standard deviation
#x <- seq(1,17520,1)
bell_test <- vector()
vector_long <- numeric(17520 * length(BT_lb$TotalBiomass))

for (i in 1:length(BT_lb$TotalBiomass)) {
  
  #define function which is applied to each element of the biomass_increment vector    
  for (j in 1:17520) {
    bell_test[j] <- (exp(-(j - mu)^2 / (2 * sigma^2)) / (6265 / biomass_increment_lb_303[i]))
  }
  
  vector_long[(1:17520) + ((i-1) * 17520)] <- bell_test
  
}

plot(vector_long[1:17520])
#plot(vector_long[1000000:1400000])

#change variable name and calculate N demand based on stoichiometric relationships
biomass_demand_lb_303_half_hourly <- vector()
biomass_demand_lb_303_half_hourly <- vector_long
biomass_demand_lb_303_half_hourly[10000]
#plot(biomass_demand_lb_303_half_hourly[1:60000])

#control the outcome of the integral
bell_function <- function(x, mu, sigma) {
  bell_test <- (exp(-(x - mu)^2 / (2 * sigma^2)) / (6265 / 4))
}

for (j in 1:17520) {
  integral_result <- quad(bell_function, -20 * sigma, j, mu = mu, sigma = sigma)
  vector[j] <- integral_result
}

str(vector)
plot(vector)
vector[17519]


################################################################################
# 3.1.1 demandUptakeN ############################################################
################################################################################

#calculate stoichiometric relationship of newly grown biomass
#assume biomass growth of 4% foliage, 25% roots and 71% woody plant parts
CN_leaf <- 19/447
CN_root <- 14/5394
CN_branch <- 11/633

#calculate average CN ratio
CN_average <- CN_leaf * 0.04 + CN_root * 0.25 + CN_branch * 0.71

#calculate N demand from half hourly biomass demand 
N_demand_lb_303_half_hourly <- biomass_demand_lb_303_half_hourly * CN_average
N_demand_lb_303_half_hourly[10000]

#transform uptake demand N to µmol m-2 half-hour-1 from tons ha-1
mol_m_N <- 28.02 #g mol-1
N_demand_lb_303_half_hourly <- ((N_demand_lb_303_half_hourly * 1000000000) / mol_m_N) * 0.0001

#set N demand 0 in case of a negative number
for (i in 1:(length(N_demand_lb_303_half_hourly))) {
  if (N_demand_lb_303_half_hourly[i] <= 0) {
    N_demand_lb_303_half_hourly[i] <- 0
  }
}

str(N_demand_lb_303_half_hourly)
N_demand_lb_303_half_hourly <- N_demand_lb_303_half_hourly[1:((length(BT_lb$TotalBiomass))*17520)]
str(N_demand_lb_303_half_hourly)

#in addition to growth requirements also nutrient uptake for maintenance should be 
#taken into account --> the nutrient uptake is updated here based on leafN of 
#previous timestep (expressed in addition nutrient demand)
maintenance_N_uptake <- c()

for (i in 1:length(fine_root_biomass_lb_303)) {
  maintenance_N_uptake[i] <- fine_root_biomass_lb_303[i]
}

#maintenance_N_uptake[1:17520] <- rep(maintenance_N_uptake[17521], 17520)
N_demand_lb_303_half_hourly <- N_demand_lb_303_half_hourly + max(N_demand_lb_303_half_hourly * 8) * (maintenance_N_uptake / 100)

#transfer N uptake into a scalar where maximum N uptake equals 1
N_demand_lb_303_half_hourly <- N_demand_lb_303_half_hourly / max(N_demand_lb_303_half_hourly)
str(N_demand_lb_303_half_hourly)
N_demand_lb_303_half_hourly[17521]
#plot(N_demand_lb_303_half_hourly[1:600000])


################################################################################
# 3.1.2 demandUptakeP ############################################################
################################################################################
#calculate stoichiometric relationship of newly grown biomass
#assume biomass growth of 4% foliage, 25% roots and 71% woody plant parts
CP_leaf <- 1/447
CP_root <- 1/5394
CP_branch <- 1/633

#calculate average CN ratio
CP_average <- CP_leaf * 0.04 + CP_root * 0.25 + CP_branch * 0.71

#calculate P demand from half hourly biomass demand 
P_demand_lb_303_half_hourly <- biomass_demand_lb_303_half_hourly * CP_average
P_demand_lb_303_half_hourly[10000]

#transform uptake demand P to µmol m-2 half-hour-1 from tons ha-1
mol_m_P <- 30.973762  #g mol-1
P_demand_lb_303_half_hourly <- ((P_demand_lb_303_half_hourly * 1000000000) / mol_m_P) * 0.0001

#set P demand 0 in case of a negative number
for (i in 1:(length(P_demand_lb_303_half_hourly))) {
  if (P_demand_lb_303_half_hourly[i] <= 0) {
    P_demand_lb_303_half_hourly[i] <- 0
  }
}

str(P_demand_lb_303_half_hourly)
P_demand_lb_303_half_hourly <- P_demand_lb_303_half_hourly[1:((length(BT_lb$TotalBiomass))*17520)]
str(P_demand_lb_303_half_hourly)

#in addition to growth requirements also nutrient uptake for maintenance should be 
#taken into account --> the nutrient uptake is updated here based on leafN of 
#previous timestep
maintenance_P_uptake <- c()

for (i in 1:length(fine_root_biomass_lb_303)) {
  maintenance_P_uptake[i] <- fine_root_biomass_lb_303[i]
}

#maintenance_P_uptake[1:17520] <- rep(maintenance_P_uptake[17521], 17520)
P_demand_lb_303_half_hourly <- P_demand_lb_303_half_hourly + max(P_demand_lb_303_half_hourly * 8) * (maintenance_P_uptake / 100)

#transfer N uptake into a scalar where maximum N uptake equals 1
P_demand_lb_303_half_hourly <- P_demand_lb_303_half_hourly / max(P_demand_lb_303_half_hourly)
str(P_demand_lb_303_half_hourly)
P_demand_lb_303_half_hourly[17521]
#plot(P_demand_lb_303_half_hourly[1:60000])


################################################################################
# 4.1 leaf litter ###############################################################
################################################################################

#calculate leaf litter input
#assume constant leaf litter input of 0.2% of total biomass for all plant 
#functional types
#remark: in its current implementation the leaf litter seems too small 
#especially in relation to dead wood inputs --> calibrate to ratio 1:2
leaf_litter_constant_lb_303 <- BT_lb$TotalBiomass * 0.04 * 0.05  # 0.002 seems to be a bit small
plot(leaf_litter_constant_lb_303)

#add leaf litter of dead trees
leaf_litter_constant_lb_303 <- leaf_litter_constant_lb_303 + (dead_BT_lb$TotB * 0.04)

#distribute equally to half hourly timesteps
leaf_litter_constant_lb_303_half_hourly <- rep((leaf_litter_constant_lb_303 / 17520), each = 17520)
# plot(leaf_litter_constant_lb_303_half_hourly[1:40000])

#calculate seasonal leaf litter input
#calculate broadleaved forest biomass

BT_broad_lb_303 <- 
  BT_lb$BiomassPerPFT_3 +
  BT_lb$BiomassPerPFT_4 +
  BT_lb$BiomassPerPFT_5 + 
  BT_lb$BiomassPerPFT_6 + 
  BT_lb$BiomassPerPFT_7 + 
  BT_lb$BiomassPerPFT_8

plot(BT_broad_lb_303)

#calculate annual litter input from broadleaved forest biomass
leaf_litter_lb_303_broad <- BT_broad_lb_303 * 0.04 # + (dead_BT_lb$TotB * 0.04)

#transform broadleaved litter input into half hourly timesteps
#leaf litter is shedded in november

leaf_litter_broad_lb_303_half_hourly <- vector()

for (i in 1:(length(BT_broad_lb_303))) {
  leaf_litter_broad_lb_303_half <- c(rep(0, 14600), 
                                     rep((leaf_litter_lb_303_broad[i] / 1460), 1460), 
                                     rep(0, 1460))
  leaf_litter_broad_lb_303_half_hourly[(1:17520) + ((i-1) * 17520)] <- leaf_litter_broad_lb_303_half
}

plot(leaf_litter_broad_lb_303_half_hourly[1:40000])


#calculate total leaf litter input from seasonal and constant inputs
leaf_litter_total_lb_303_half_hourly <- leaf_litter_constant_lb_303_half_hourly + 
  leaf_litter_broad_lb_303_half_hourly


################################################################################
# 4.1.1 leafC ####################################################################
################################################################################

leafC_lb_303 <- leaf_litter_total_lb_303_half_hourly * (1 - CN_leaf - CP_leaf)
#plot(leafC_lb_303[1:60000])

#transform leafC to mmol m-2 half-hour-1 from tons ha-1 half-hour-1
mol_m_C <- 12 #g mol-1
leafC_lb_303 <- ((leafC_lb_303 * 1000000000) / mol_m_C) * 0.0001


################################################################################
# 4.2 leafN ####################################################################
################################################################################

leafN_lb_303 <- leaf_litter_total_lb_303_half_hourly * CN_leaf
plot(leafN_lb_303[1:60000])

#transform leafN to µmol m-2 half-hour-1 from tons ha-1 half-hour-1
leafN_lb_303 <- ((leafN_lb_303 * 1000000000000) / mol_m_N) * 0.0001


################################################################################
# 4.3 leafP ####################################################################
################################################################################

leafP_lb_303 <- leaf_litter_total_lb_303_half_hourly * CP_leaf
#plot(leafP_lb_303[1:60000])

#transform leafN to µmol m-2 half-hour-1 from tons ha-1 half-hour-1
leafP_lb_303 <- ((leafP_lb_303 * 1000000000000) / mol_m_P) * 0.0001


################################################################################
# 5. leaf isotopes #############################################################
################################################################################

#take example outputs from hainich
input_hainich_litter <- read.table("soil_forcing_litterfall_hainich.dat", header = TRUE)
str(input_hainich_litter)

leafC13 <- rep(input_hainich_litter$leafC13, length(BT_lb$TotalBiomass))
str(leafC13)

leafC14 <- rep(input_hainich_litter$leafC14, length(BT_lb$TotalBiomass))
str(leafC14)

leafN15 <- rep(input_hainich_litter$leafN15, length(BT_lb$TotalBiomass))
str(leafN15)


################################################################################
# 6.1 fine root litter input ####################################################
################################################################################

#assume constant fine root litter input of 5% of fine root biomass per year
fine_root_litter_lb_303 <- root_biomass_lb * 0.1 * 0.05
#plot(fine_root_litter_lb_303)

#add fine root litter of dead trees
fine_root_litter_lb_303 <- fine_root_litter_lb_303 + (dead_BT_lb$TotB * (0.1 * 0.25))

#distribute equally to half hourly timesteps
fine_root_litter_lb_303_half_hourly <- rep((fine_root_litter_lb_303 / 17520), each = 17520)
#plot(fine_root_litter_lb_303_half_hourly[1:40000])


################################################################################
# 6.1.1 fine_rootC  ##############################################################
################################################################################

fine_rootC_lb_303 <- fine_root_litter_lb_303_half_hourly * (1 - CN_root - CP_root)
#plot(fine_rootC_lb_303[1:60000])

#transform fine_rootC to mmol m-2 half-hour-1 from tons ha-1 half-hour-1
fine_rootC_lb_303 <- ((fine_rootC_lb_303 * 1000000000) / mol_m_C) * 0.0001


################################################################################
# 6.2.1 fine_rootN #############################################################
################################################################################

fine_rootN_lb_303 <- fine_root_litter_lb_303_half_hourly * CN_root
#plot(fine_rootN_lb_303[1:60000])

#transform fine_rootN to µmol m-2 half-hour-1 from tons ha-1 half-hour-1
fine_rootN_lb_303 <- ((fine_rootN_lb_303 * 1000000000000) / mol_m_P) * 0.0001


################################################################################
# 6.3.1 fine_rootP #############################################################
################################################################################

fine_rootP_lb_303 <- fine_root_litter_lb_303_half_hourly * CP_root
#plot(fine_rootP_lb_303[1:60000])

#transform fine_rootP to µmol m-2 half-hour-1 from tons ha-1 half-hour-1
fine_rootP_lb_303 <- ((fine_rootP_lb_303 * 1000000000000) / mol_m_P) * 0.0001


################################################################################
# 7. fine root isotopes ########################################################
################################################################################

#take example outputs from hainich
input_hainich_litter <- read.table("soil_forcing_litterfall_hainich.dat", header = TRUE)
str(input_hainich_litter)

fine_rootC13 <- rep(input_hainich_litter$fine_rootC13, length(BT_lb$TotalBiomass))
str(fine_rootC13)

fine_rootC14 <- rep(input_hainich_litter$fine_rootC14, length(BT_lb$TotalBiomass))
str(fine_rootC14)

fine_rootN15 <- rep(input_hainich_litter$fine_rootN15, length(BT_lb$TotalBiomass))
str(fine_rootN15)


################################################################################
# 8.1 coarse root litter input ##################################################
################################################################################

#assume constant coarse root litter input of 5% of coarse root biomass per year
coarse_root_litter_lb_303 <- root_biomass_lb * 0.85 * 0.05
#plot(coarse_root_litter_lb_303)

#add coarse root litter of dead trees
coarse_root_litter_lb_303 <- coarse_root_litter_lb_303 + (dead_BT_lb$TotB * (0.25 * 0.85)) 

#distribute equally to half hourly timesteps
coarse_root_litter_lb_303_half_hourly <- rep((coarse_root_litter_lb_303 / 17520), each = 17520)
plot(coarse_root_litter_lb_303_half_hourly[1:40000])


################################################################################
# 8.1.1 coarse_rootC  ##############################################################
################################################################################

coarse_rootC_lb_303 <- coarse_root_litter_lb_303_half_hourly * (1 - CN_root - CP_root)
#plot(coarse_rootC_lb_303[1:60000])

#transform coarse_rootC to mmol m-2 half-hour-1 from tons ha-1 half-hour-1
coarse_rootC_lb_303 <- ((coarse_rootC_lb_303 * 1000000000) / mol_m_C) * 0.0001


################################################################################
# 8.2.1 coarse_rootN #############################################################
################################################################################

coarse_rootN_lb_303 <- coarse_root_litter_lb_303_half_hourly * CN_root
plot(coarse_rootN_lb_303[1:60000])

#transform coarse_rootN to µmol m-2 half-hour-1 from tons ha-1 half-hour-1
coarse_rootN_lb_303 <- ((coarse_rootN_lb_303 * 1000000000000) / mol_m_N) * 0.0001


################################################################################
# 8.3.1 coarse_rootP #############################################################
################################################################################

coarse_rootP_lb_303 <- coarse_root_litter_lb_303_half_hourly * CP_root
#plot(coarse_rootP_lb_303[1:60000])

#transform coarse_rootP to µmol m-2 half-hour-1 from tons ha-1 half-hour-1
coarse_rootP_lb_303 <- ((coarse_rootP_lb_303 * 1000000000000) / mol_m_P) * 0.0001


################################################################################
# 9. coarse root isotopes ########################################################
################################################################################

#take example outputs from hainich
input_hainich_litter <- read.table("soil_forcing_litterfall_hainich.dat", header = TRUE)
str(input_hainich_litter)

coarse_rootC13 <- rep(input_hainich_litter$coarse_rootC13, length(BT_lb$TotalBiomass))
str(coarse_rootC13)

coarse_rootC14 <- rep(input_hainich_litter$coarse_rootC14, length(BT_lb$TotalBiomass))
str(coarse_rootC14)

coarse_rootN15 <- rep(input_hainich_litter$coarse_rootN15, length(BT_lb$TotalBiomass))
str(coarse_rootN15)


################################################################################
# 10.1 sapwood litter input ##################################################
################################################################################

#assume constant sapwood litter input of 5% of sapwood biomass per year
#more refined: calculate sapwood in dependence of plant functional type
wood_biomass_PFT1_lb_303 <- BT_lb$BiomassPerPFT_1 * 0.71
sapwood_biomass_PFT1_lb_303 <- wood_biomass_PFT1_lb_303 * 0.8
sapwood_litter_PFT1_lb_303 <- sapwood_biomass_PFT1_lb_303 * 0.05

wood_biomass_PFT2_lb_303 <- BT_lb$BiomassPerPFT_2 * 0.71
sapwood_biomass_PFT2_lb_303 <- wood_biomass_PFT2_lb_303 * 0.8
sapwood_litter_PFT2_lb_303 <- sapwood_biomass_PFT2_lb_303 * 0.05

wood_biomass_PFT3_lb_303 <- BT_lb$BiomassPerPFT_3 * 0.71
sapwood_biomass_PFT3_lb_303 <- wood_biomass_PFT3_lb_303 * 0.8
sapwood_litter_PFT3_lb_303 <- sapwood_biomass_PFT3_lb_303 * 0.02

wood_biomass_PFT4_lb_303 <- BT_lb$BiomassPerPFT_4 * 0.71
sapwood_biomass_PFT4_lb_303 <- wood_biomass_PFT4_lb_303 * 0.8
sapwood_litter_PFT4_lb_303 <- sapwood_biomass_PFT4_lb_303 * 0.05

wood_biomass_PFT5_lb_303 <- BT_lb$BiomassPerPFT_5 * 0.71
sapwood_biomass_PFT5_lb_303 <- wood_biomass_PFT5_lb_303 * 0.8
sapwood_litter_PFT5_lb_303 <- sapwood_biomass_PFT5_lb_303 * 0.05

wood_biomass_PFT6_lb_303 <- BT_lb$BiomassPerPFT_6 * 0.71
sapwood_biomass_PFT6_lb_303 <- wood_biomass_PFT6_lb_303 * 0.8
sapwood_litter_PFT6_lb_303 <- sapwood_biomass_PFT6_lb_303 * 0.05

wood_biomass_PFT7_lb_303 <- BT_lb$BiomassPerPFT_7 * 0.71
sapwood_biomass_PFT7_lb_303 <- wood_biomass_PFT7_lb_303 * 0.8
sapwood_litter_PFT7_lb_303 <- sapwood_biomass_PFT7_lb_303 * 0.05

wood_biomass_PFT8_lb_303 <- BT_lb$BiomassPerPFT_8 * 0.71
sapwood_biomass_PFT8_lb_303 <- wood_biomass_PFT8_lb_303 * 0.8
sapwood_litter_PFT8_lb_303 <- sapwood_biomass_PFT8_lb_303 * 0.05

plot(wood_biomass_PFT2_lb_303)

#calculate total sapwood litter input
sapwood_litter_lb_303 <- sapwood_litter_PFT1_lb_303 + sapwood_litter_PFT2_lb_303 + sapwood_litter_PFT3_lb_303 + 
  sapwood_litter_PFT5_lb_303 + sapwood_litter_PFT6_lb_303 + sapwood_litter_PFT7_lb_303 + 
  sapwood_litter_PFT8_lb_303 + sapwood_litter_PFT4_lb_303

#calculate sapwood litter of dead biomass per plant functional type
wood_biomass_PFT1_dead_lb_303 <- dead_BT_lb$TotB * (BT_lb$BiomassPerPFT_1 / BT_lb$TotalBiomass) * 0.71
sapwood_biomass_PFT1_dead_lb_303 <- wood_biomass_PFT1_dead_lb_303 * 0.8
sapwood_litter_PFT1_dead_lb_303 <- sapwood_biomass_PFT1_dead_lb_303 

wood_biomass_PFT2_dead_lb_303 <- dead_BT_lb$TotB * (BT_lb$BiomassPerPFT_2 / BT_lb$TotalBiomass) * 0.71
sapwood_biomass_PFT2_dead_lb_303 <- wood_biomass_PFT2_dead_lb_303 * 0.8
sapwood_litter_PFT2_dead_lb_303 <- sapwood_biomass_PFT2_dead_lb_303 

wood_biomass_PFT3_dead_lb_303 <- dead_BT_lb$TotB * (BT_lb$BiomassPerPFT_3 / BT_lb$TotalBiomass) * 0.71
sapwood_biomass_PFT3_dead_lb_303 <- wood_biomass_PFT3_dead_lb_303 * 0.8
sapwood_litter_PFT3_dead_lb_303 <- sapwood_biomass_PFT3_dead_lb_303 

wood_biomass_PFT4_dead_lb_303 <- dead_BT_lb$TotB * (BT_lb$BiomassPerPFT_4 / BT_lb$TotalBiomass) * 0.71
sapwood_biomass_PFT4_dead_lb_303 <- wood_biomass_PFT4_dead_lb_303 * 0.8
sapwood_litter_PFT4_dead_lb_303 <- sapwood_biomass_PFT4_dead_lb_303 

wood_biomass_PFT5_dead_lb_303 <- dead_BT_lb$TotB * (BT_lb$BiomassPerPFT_5 / BT_lb$TotalBiomass) * 0.71
sapwood_biomass_PFT5_dead_lb_303 <- wood_biomass_PFT5_dead_lb_303 * 0.8
sapwood_litter_PFT5_dead_lb_303 <- sapwood_biomass_PFT5_dead_lb_303 

wood_biomass_PFT6_dead_lb_303 <- dead_BT_lb$TotB * (BT_lb$BiomassPerPFT_6 / BT_lb$TotalBiomass) * 0.71
sapwood_biomass_PFT6_dead_lb_303 <- wood_biomass_PFT6_dead_lb_303 * 0.8
sapwood_litter_PFT6_dead_lb_303 <- sapwood_biomass_PFT6_dead_lb_303 

wood_biomass_PFT7_dead_lb_303 <- dead_BT_lb$TotB * (BT_lb$BiomassPerPFT_7 / BT_lb$TotalBiomass) * 0.71
sapwood_biomass_PFT7_dead_lb_303 <- wood_biomass_PFT7_dead_lb_303 * 0.8
sapwood_litter_PFT7_dead_lb_303 <- sapwood_biomass_PFT7_dead_lb_303 

wood_biomass_PFT8_dead_lb_303 <- dead_BT_lb$TotB * (BT_lb$BiomassPerPFT_8 / BT_lb$TotalBiomass) * 0.71
sapwood_biomass_PFT8_dead_lb_303 <- wood_biomass_PFT8_dead_lb_303 * 0.8
sapwood_litter_PFT8_dead_lb_303 <- sapwood_biomass_PFT8_dead_lb_303 

plot(sapwood_litter_PFT1_dead_lb_303)

#add sapwood litter of dead trees
sapwood_litter_dead_lb_303 <- sapwood_litter_PFT1_dead_lb_303 + sapwood_litter_PFT2_dead_lb_303 + 
  sapwood_litter_PFT3_dead_lb_303 + sapwood_litter_PFT4_dead_lb_303 + sapwood_litter_PFT5_dead_lb_303 + 
  sapwood_litter_PFT6_dead_lb_303 + sapwood_litter_PFT7_dead_lb_303 + sapwood_litter_PFT8_dead_lb_303

#calculate total sapwood litter input
sapwood_litter_lb_303 <- sapwood_litter_lb_303 + sapwood_litter_dead_lb_303

#distribute equally to half hourly timesteps
sapwood_litter_lb_303_half_hourly <- rep((sapwood_litter_lb_303 / 17520), each = 17520)
#plot(sapwood_litter_lb_303_half_hourly[1:400000])


################################################################################
# 10.1.1 sap_woodC  ##############################################################
################################################################################

sap_woodC_lb_303 <- sapwood_litter_lb_303_half_hourly * (1 - CN_branch - CP_branch)
#plot(sap_woodC_lb_303[1:60000])

#transform sap_woodC to mmol m-2 half-hour-1 from tons ha-1 half-hour-1
sap_woodC_lb_303 <- ((sap_woodC_lb_303 * 1000000000) / mol_m_C) * 0.0001


################################################################################
# 10.2.1 sap_woodN ###############################################################
################################################################################

sap_woodN_lb_303 <- sapwood_litter_lb_303_half_hourly * CN_branch
#plot(sap_woodN_lb_303[1:60000])

#transform sap_woodN to µmol m-2 half-hour-1 from tons ha-1 half-hour-1
sap_woodN_lb_303 <- ((sap_woodN_lb_303 * 1000000000000) / mol_m_N) * 0.0001


################################################################################
# 10.3.1 sap_woodP ###############################################################
################################################################################

sap_woodP_lb_303 <- sapwood_litter_lb_303_half_hourly * CP_branch
#plot(sap_woodP_lb_303[1:60000])

#transform sap_woodP to µmol m-2 half-hour-1 from tons ha-1 half-hour-1
sap_woodP_lb_303 <- ((sap_woodP_lb_303 * 1000000000000) / mol_m_P) * 0.0001


################################################################################
# 11. sap_wood isotopes ########################################################
################################################################################

#take example outputs from hainich
input_hainich_litter <- read.table("soil_forcing_litterfall_hainich.dat", header = TRUE)
str(input_hainich_litter)

sap_woodC13 <- rep(input_hainich_litter$sap_woodC13, length(BT_lb$TotalBiomass))
str(sap_woodC13)

sap_woodC14 <- rep(input_hainich_litter$sap_woodC14, length(BT_lb$TotalBiomass))
str(sap_woodC14)

sap_woodN15 <- rep(input_hainich_litter$sap_woodN15, length(BT_lb$TotalBiomass))
str(sap_woodN15)


################################################################################
# 12.1 heartwood litter input ##################################################
################################################################################

#assume constant heartwood litter input of 5% of heartwood biomass per year
#more refined: calculate heartwood in dependence of plant functional type
wood_biomass_PFT1_lb_303 <- BT_lb$BiomassPerPFT_1 * 0.71
heartwood_biomass_PFT1_lb_303 <- wood_biomass_PFT1_lb_303 * 0.2
heartwood_litter_PFT1_lb_303 <- heartwood_biomass_PFT1_lb_303 * 0.05

wood_biomass_PFT2_lb_303 <- BT_lb$BiomassPerPFT_2 * 0.71
heartwood_biomass_PFT2_lb_303 <- wood_biomass_PFT2_lb_303 * 0.2
heartwood_litter_PFT2_lb_303 <- heartwood_biomass_PFT2_lb_303 * 0.05

wood_biomass_PFT3_lb_303 <- BT_lb$BiomassPerPFT_3 * 0.71
heartwood_biomass_PFT3_lb_303 <- wood_biomass_PFT3_lb_303 * 0.2
heartwood_litter_PFT3_lb_303 <- heartwood_biomass_PFT3_lb_303 * 0.05

wood_biomass_PFT4_lb_303 <- BT_lb$BiomassPerPFT_4 * 0.71
heartwood_biomass_PFT4_lb_303 <- wood_biomass_PFT4_lb_303 * 0.2
heartwood_litter_PFT4_lb_303 <- heartwood_biomass_PFT4_lb_303 * 0.02

wood_biomass_PFT5_lb_303 <- BT_lb$BiomassPerPFT_5 * 0.71
heartwood_biomass_PFT5_lb_303 <- wood_biomass_PFT5_lb_303 * 0.2
heartwood_litter_PFT5_lb_303 <- heartwood_biomass_PFT5_lb_303 * 0.05

wood_biomass_PFT6_lb_303 <- BT_lb$BiomassPerPFT_6 * 0.71
heartwood_biomass_PFT6_lb_303 <- wood_biomass_PFT6_lb_303 * 0.2
heartwood_litter_PFT6_lb_303 <- heartwood_biomass_PFT6_lb_303 * 0.05

wood_biomass_PFT7_lb_303 <- BT_lb$BiomassPerPFT_7 * 0.71
heartwood_biomass_PFT7_lb_303 <- wood_biomass_PFT7_lb_303 * 0.2
heartwood_litter_PFT7_lb_303 <- heartwood_biomass_PFT7_lb_303 * 0.05

wood_biomass_PFT8_lb_303 <- BT_lb$BiomassPerPFT_8 * 0.71
heartwood_biomass_PFT8_lb_303 <- wood_biomass_PFT8_lb_303 * 0.2
heartwood_litter_PFT8_lb_303 <- heartwood_biomass_PFT8_lb_303 * 0.05

plot(heartwood_litter_PFT2_lb_303)

#calculate total heartwood litter input
heartwood_litter_lb_303 <- heartwood_litter_PFT1_lb_303 + heartwood_litter_PFT2_lb_303 + 
  heartwood_litter_PFT3_lb_303 + heartwood_litter_PFT4_lb_303 + 
  heartwood_litter_PFT5_lb_303 + heartwood_litter_PFT6_lb_303 + 
  heartwood_litter_PFT7_lb_303 + heartwood_litter_PFT8_lb_303

#calculate heartwood litter of dead biomass per plant functional type
wood_biomass_PFT1_dead_lb_303 <- dead_BT_lb$TotB * (BT_lb$BiomassPerPFT_1 / BT_lb$TotalBiomass) * 0.71
heartwood_biomass_PFT1_dead_lb_303 <- wood_biomass_PFT1_dead_lb_303 * 0.2
heartwood_litter_PFT1_dead_lb_303 <- heartwood_biomass_PFT1_dead_lb_303

wood_biomass_PFT2_dead_lb_303 <- dead_BT_lb$TotB * (BT_lb$BiomassPerPFT_2 / BT_lb$TotalBiomass) * 0.71
heartwood_biomass_PFT2_dead_lb_303 <- wood_biomass_PFT2_dead_lb_303 * 0.2
heartwood_litter_PFT2_dead_lb_303 <- heartwood_biomass_PFT2_dead_lb_303

wood_biomass_PFT3_dead_lb_303 <- dead_BT_lb$TotB * (BT_lb$BiomassPerPFT_3 / BT_lb$TotalBiomass) * 0.71
heartwood_biomass_PFT3_dead_lb_303 <- wood_biomass_PFT3_dead_lb_303 * 0.2
heartwood_litter_PFT3_dead_lb_303 <- heartwood_biomass_PFT3_dead_lb_303

wood_biomass_PFT4_dead_lb_303 <- dead_BT_lb$TotB * (BT_lb$BiomassPerPFT_4 / BT_lb$TotalBiomass) * 0.71
heartwood_biomass_PFT4_dead_lb_303 <- wood_biomass_PFT4_dead_lb_303 * 0.2
heartwood_litter_PFT4_dead_lb_303 <- heartwood_biomass_PFT4_dead_lb_303

wood_biomass_PFT5_dead_lb_303 <- dead_BT_lb$TotB * (BT_lb$BiomassPerPFT_5 / BT_lb$TotalBiomass) * 0.71
heartwood_biomass_PFT5_dead_lb_303 <- wood_biomass_PFT5_dead_lb_303 * 0.2
heartwood_litter_PFT5_dead_lb_303 <- heartwood_biomass_PFT5_dead_lb_303

wood_biomass_PFT6_dead_lb_303 <- dead_BT_lb$TotB * (BT_lb$BiomassPerPFT_6 / BT_lb$TotalBiomass) * 0.71
heartwood_biomass_PFT6_dead_lb_303 <- wood_biomass_PFT6_dead_lb_303 * 0.2
heartwood_litter_PFT6_dead_lb_303 <- heartwood_biomass_PFT6_dead_lb_303

wood_biomass_PFT7_dead_lb_303 <- dead_BT_lb$TotB * (BT_lb$BiomassPerPFT_7 / BT_lb$TotalBiomass) * 0.71
heartwood_biomass_PFT7_dead_lb_303 <- wood_biomass_PFT7_dead_lb_303 * 0.2
heartwood_litter_PFT7_dead_lb_303 <- heartwood_biomass_PFT7_dead_lb_303

wood_biomass_PFT8_dead_lb_303 <- dead_BT_lb$TotB * (BT_lb$BiomassPerPFT_8 / BT_lb$TotalBiomass) * 0.71
heartwood_biomass_PFT8_dead_lb_303 <- wood_biomass_PFT8_dead_lb_303 * 0.2
heartwood_litter_PFT8_dead_lb_303 <- heartwood_biomass_PFT8_dead_lb_303

#plot(heartwood_litter_PFT2_dead_lb_303)

#add heartwood litter of dead trees for all plant functional types
heartwood_litter_dead_lb_303 <- heartwood_litter_PFT1_dead_lb_303 + heartwood_litter_PFT2_dead_lb_303 + 
  heartwood_litter_PFT3_dead_lb_303 + heartwood_litter_PFT4_dead_lb_303 + 
  heartwood_litter_PFT5_dead_lb_303 + heartwood_litter_PFT6_dead_lb_303 + 
  heartwood_litter_PFT7_dead_lb_303 + heartwood_litter_PFT8_dead_lb_303

#calculate total heartwood litter input
heartwood_litter_lb_303 <- heartwood_litter_lb_303 + heartwood_litter_dead_lb_303

#distribute equally to half hourly timesteps
heartwood_litter_lb_303_half_hourly <- rep((heartwood_litter_lb_303 / 17520), each = 17520)
plot(heartwood_litter_lb_303_half_hourly[1:40000])


################################################################################
# 12.1.1 heart_woodC  ##############################################################
################################################################################

heart_woodC_lb_303 <- heartwood_litter_lb_303_half_hourly * (1 - CN_branch - CP_branch)
#plot(heart_woodC_lb_303[1:60000])

#transform heart_woodC to mmol m-2 half-hour-1 from tons ha-1 half-hour-1
heart_woodC_lb_303 <- ((heart_woodC_lb_303 * 1000000000) / mol_m_C) * 0.0001


################################################################################
# 12.2.1 heart_woodN #############################################################
################################################################################

heart_woodN_lb_303 <- heartwood_litter_lb_303_half_hourly * CN_branch
#plot(heart_woodN_lb_303[1:60000])

#transform sap_woodN to µmol m-2 half-hour-1 from tons ha-1 half-hour-1
heart_woodN_lb_303 <- ((heart_woodN_lb_303 * 1000000000000) / mol_m_N) * 0.0001


################################################################################
# 12.3.1 heart_woodP #############################################################
################################################################################

heart_woodP_lb_303 <- heartwood_litter_lb_303_half_hourly * CP_branch
#plot(heart_woodP_lb_303[1:60000])

#transform sap_woodP to µmol m-2 half-hour-1 from tons ha-1 half-hour-1
heart_woodP_lb_303 <- ((heart_woodP_lb_303 * 1000000000000) / mol_m_P) * 0.0001


################################################################################
# 13. heart_wood isotopes ######################################################
################################################################################

#take example outputs from hainich
input_hainich_litter <- read.table("soil_forcing_litterfall_hainich.dat", header = TRUE)
str(input_hainich_litter)

heart_woodC13 <- rep(input_hainich_litter$heart_woodC13, length(BT_lb$TotalBiomass))
str(heart_woodC13)

heart_woodC14 <- rep(input_hainich_litter$heart_woodC14, length(BT_lb$TotalBiomass))
str(heart_woodC14)

heart_woodN15 <- rep(input_hainich_litter$heart_woodN15, length(BT_lb$TotalBiomass))
str(heart_woodN15)


################################################################################
# 14.1 fruit litter input #######################################################
################################################################################

#assume a fruit litter input of 0.18% of total biomass
fruit_litter_lb_303 <- BT_lb$TotalBiomass * 0.0018
#plot(fruit_litter_lb_303)

#add leaf litter of dead trees
fruit_litter_lb_303 <- fruit_litter_lb_303 + (dead_BT_lb$TotB * 0.018) 

#transform fruit litter input into half hourly timesteps
#fruit litter is shedded in october
fruit_litter_lb_303_half_hourly <- vector()

for (i in 1:(length(BT_lb$TotalBiomass))) {
  fruit_litter_half <- c(rep(0, 13140), 
                         rep((fruit_litter_lb_303[i] / 1460), 1460), 
                         rep(0, 2920))
  fruit_litter_lb_303_half_hourly[(1:17520) + ((i-1) * 17520)] <- fruit_litter_half
}

#plot(fruit_litter_lb_303_half_hourly[1:40000])


################################################################################
# 14.1.1 fruitC  #################################################################
################################################################################


fruitC_lb_303 <- fruit_litter_lb_303_half_hourly * (1 - CN_branch - CP_branch)
#plot(fruitC_lb_303[1:60000])

#transform fruitC to mmol m-2 half-hour-1 from tons ha-1 half-hour-1
fruitC_lb_303 <- ((fruitC_lb_303 * 1000000000) / mol_m_C) * 0.0001


################################################################################
# 14.2.1 fruitN ##################################################################
################################################################################

fruitN_lb_303 <- fruit_litter_lb_303_half_hourly * CN_branch
#plot(fruitN_lb_303[1:60000])

#transform fruitN to mmol m-2 half-hour-1 from tons ha-1 half-hour-1
fruitN_lb_303 <- ((fruitN_lb_303 * 1000000000000) / mol_m_N) * 0.0001


################################################################################
# 14.3.1 fruitP ##################################################################
################################################################################

fruitP_lb_303 <- fruit_litter_lb_303_half_hourly * CP_branch
#plot(fruitP_lb_303[1:60000])

#transform fruitP to mmol m-2 half-hour-1 from tons ha-1 half-hour-1
fruitP_lb_303 <- ((fruitP_lb_303 * 1000000000000) / mol_m_P) * 0.0001


################################################################################
# 15. fruit isotopes ###########################################################
################################################################################

#take example outputs from hainich
input_hainich_litter <- read.table("soil_forcing_litterfall_hainich.dat", header = TRUE)
str(input_hainich_litter)

fruitC13 <- rep(input_hainich_litter$fruitC13 , length(BT_lb$TotalBiomass))
str(fruitC13)

fruitC14 <- rep(input_hainich_litter$fruitC14, length(BT_lb$TotalBiomass))
str(fruitC14)

fruitN15 <- rep(input_hainich_litter$fruitN15, length(BT_lb$TotalBiomass))
str(fruitN15)


################################################################################
# 16.1 seed litter input ########################################################
################################################################################

#assume a seed litter input of 0.02% of total biomass
seed_litter_lb_303 <- BT_lb$TotalBiomass * 0.0002
#plot(seed_litter_lb_303)

#add leaf litter of dead trees
seed_litter_lb_303 <- seed_litter_lb_303 + (dead_BT_lb$TotB * 0.002)

#transform fruit litter input into half hourly timesteps
#fruit litter is shedded in october

seed_litter_lb_303_half_hourly <- vector()

for (i in 1:(length(BT_lb$TotalBiomass))) {
  seed_litter_half <- c(rep(0, 13140), 
                        rep((seed_litter_lb_303[i] / 1460), 1460), 
                        rep(0, 2920))
  seed_litter_lb_303_half_hourly[(1:17520) + ((i-1) * 17520)] <- seed_litter_half
}

#plot(seed_litter_lb_303_half_hourly[1:60000])


################################################################################
# 16.1.1 seed_bedC  ###############################################################
################################################################################

seed_bedC_lb_303 <- seed_litter_lb_303_half_hourly * (1 - CN_leaf - CP_leaf)
#plot(seed_bedC_lb_303[1:60000])

#transform seed_bedC to mmol m-2 half-hour-1 from tons ha-1 half-hour-1
seed_bedC_lb_303 <- ((seed_bedC_lb_303 * 1000000000) / mol_m_C) * 0.0001


################################################################################
# 16.2.1 seed_bedN ################################################################
################################################################################

seed_bedN_lb_303 <- seed_litter_lb_303_half_hourly * CN_leaf
#plot(seed_bedN_lb_303[1:60000])

#transform seed_bedN to mmol m-2 half-hour-1 from tons ha-1 half-hour-1
seed_bedN_lb_303 <- ((seed_bedN_lb_303 * 1000000000000) / mol_m_N) * 0.0001


################################################################################
# 16.3.1 seed_bedP ################################################################
################################################################################

seed_bedP_lb_303 <- seed_litter_lb_303_half_hourly * CP_leaf
#plot(seed_bedP_lb_303[1:60000])

#transform seed_bedP to mmol m-2 half-hour-1 from tons ha-1 half-hour-1
seed_bedP_lb_303 <- ((seed_bedP_lb_303 * 1000000000000) / mol_m_P) * 0.0001


################################################################################
# 17. seed isotopes ############################################################
################################################################################

#take example outputs from hainich
input_hainich_litter <- read.table("soil_forcing_litterfall_hainich.dat", header = TRUE)
str(input_hainich_litter)

seed_bedC13 <- rep(input_hainich_litter$seed_bedC13 , length(BT_lb$TotalBiomass))
str(fruitC13)

seed_bedC14 <- rep(input_hainich_litter$seed_bedC14, length(BT_lb$TotalBiomass))
str(seed_bedC14)

seed_bedN15 <- rep(input_hainich_litter$seed_bedN15, length(BT_lb$TotalBiomass))
str(seed_bedN15)


################################################################################
# 18.1 labile litter input ######################################################
################################################################################

# assume that labile litter amounts to 5% of all other litter types combined

labile_litter_lb_303_half_hourly <- (leaf_litter_total_lb_303_half_hourly + 
                                       fine_root_litter_lb_303_half_hourly + 
                                       coarse_root_litter_lb_303_half_hourly + 
                                       sapwood_litter_lb_303_half_hourly + 
                                       heartwood_litter_lb_303_half_hourly +
                                       fruit_litter_lb_303_half_hourly + 
                                       seed_litter_lb_303_half_hourly) * 0.05


################################################################################
# 18.1.1 labileC  ################################################################
################################################################################

labileC_lb_303 <- (leafC_lb_303 + fine_rootC_lb_303 + coarse_rootC_lb_303 + sap_woodC_lb_303 + heart_woodC_lb_303 + 
                     fruitC_lb_303 + seed_bedC_lb_303) * 0.05 
#plot(labileC_lb_303[1:600000])

#transform labileC to mmol m-2 half-hour-1 from tons ha-1 half-hour-1
#labileC_lb_303 <- ((labileC_lb_303 * 1000000000) / mol_m_C) * 0.0001


################################################################################
# 18.2.1 labileN #################################################################
################################################################################

labileN_lb_303 <- (leafN_lb_303 + fine_rootN_lb_303 + coarse_rootN_lb_303 + sap_woodN_lb_303 + heart_woodN_lb_303 + 
                     fruitN_lb_303 + seed_bedN_lb_303) * 0.05 
#plot(labileN_lb_303[1:60000])

#transform labileN to mmol m-2 half-hour-1 from tons ha-1 half-hour-1
#labileN_lb_303 <- ((labileN_lb_303 * 1000000000000) / mol_m_N) * 0.0001


################################################################################
# 18.3.1 labileP #################################################################
################################################################################

labileP_lb_303 <- (leafP_lb_303 + fine_rootP_lb_303 + coarse_rootP_lb_303 + sap_woodP_lb_303 + heart_woodP_lb_303 + 
                     fruitP_lb_303 + seed_bedP_lb_303) * 0.05 
#plot(labileP_lb_303[1:60000])

#transform labileP to mmol m-2 half-hour-1 from tons ha-1 half-hour-1
#labileP_lb_303 <- ((labileP_lb_303 * 1000000000000) / mol_m_P) * 0.0001


################################################################################
# 19. labile isotopes ##########################################################
################################################################################

#take example outputs from hainich
input_hainich_litter <- read.table("soil_forcing_litterfall_hainich.dat", header = TRUE)
str(input_hainich_litter)

labileC13 <- rep(input_hainich_litter$labileC13 , length(BT_lb$TotalBiomass))
str(labileC13)

labileC14 <- rep(input_hainich_litter$labileC14, length(BT_lb$TotalBiomass))
str(labileC14)

labileN15 <- rep(input_hainich_litter$labileN15, length(BT_lb$TotalBiomass))
str(labileN15)


################################################################################
# 20.1 reserve litter input ####################################################
################################################################################

# assume that reserve litter amounts to 5% of all other litter types combined

labile_litter_lb_303_half_hourly <- (leaf_litter_total_lb_303_half_hourly + 
                                       fine_root_litter_lb_303_half_hourly + 
                                       coarse_root_litter_lb_303_half_hourly + 
                                       sapwood_litter_lb_303_half_hourly + 
                                       heartwood_litter_lb_303_half_hourly + 
                                       fruit_litter_lb_303_half_hourly + 
                                       seed_litter_lb_303_half_hourly) * 0.05


################################################################################
# 20.1.1 reserveC  #############################################################
################################################################################

reserveC_lb_303 <- (leafC_lb_303 + fine_rootC_lb_303 + coarse_rootC_lb_303 + sap_woodC_lb_303 + heart_woodC_lb_303 + 
                      fruitC_lb_303 + seed_bedC_lb_303) * 0.05 
#plot(reserveC_lb_303[1:60000])

#transform reserveC to mmol m-2 half-hour-1 from tons ha-1 half-hour-1
#reserveC_lb_303 <- ((reserveC_lb_303 * 1000000000) / mol_m_C) * 0.0001


################################################################################
# 20.2.1 reserveN ##############################################################
################################################################################

reserveN_lb_303 <- (leafN_lb_303 + fine_rootN_lb_303 + coarse_rootN_lb_303 + sap_woodN_lb_303 + heart_woodN_lb_303 + 
                      fruitN_lb_303 + seed_bedN_lb_303) * 0.05 
#plot(reserveN_lb_303[1:60000])

#transform labileN to mmol m-2 half-hour-1 from tons ha-1 half-hour-1
#reserveN_lb_303 <- ((reserveN_lb_303 * 1000000000000) / mol_m_N) * 0.0001


################################################################################
# 20.3.1 reserveP ##############################################################
################################################################################

reserveP_lb_303 <- (leafP_lb_303 + fine_rootP_lb_303 + coarse_rootP_lb_303 + sap_woodP_lb_303 + heart_woodP_lb_303 + 
                      fruitP_lb_303 + seed_bedP_lb_303) * 0.05 
#plot(reserveP_lb_303[1:60000])

#transform labileP to mmol m-2 half-hour-1 from tons ha-1 half-hour-1
#reserveP_lb_303 <- ((reserveP_lb_303 * 1000000000000) / mol_m_P) * 0.0001


################################################################################
# 21. reserve isotopes #########################################################
################################################################################

#take example outputs from hainich
input_hainich_litter <- read.table("soil_forcing_litterfall_hainich.dat", header = TRUE)
str(input_hainich_litter)

reserveC13 <- rep(input_hainich_litter$reserveC13 , length(BT_lb$TotalBiomass))
str(reserveC13)

reserveC14 <- rep(input_hainich_litter$reserveC14, length(BT_lb$TotalBiomass))
str(reserveC14)

reserveN15 <- rep(input_hainich_litter$reserveN15, length(BT_lb$TotalBiomass))
str(reserveN15)


################################################################################
# 22. transform soil hydrology results to JSM inputs ###########################
################################################################################

# transformation of model results for JSM forcing
# bind matrix with water content per soil layer
# repeat water content values 48 times for each daily timestep to transform it 
# to half-hourly time steps

lwfb90_res_lb_303_layer_theta_half_hourly <- rep(lwfb90_res_lb_303$layer_output$theta, each = 48)

# bind matrix with row number as number of time steps --> in this case for one 
# year with half hourly time steps

wat_cont_lb_303_half_hourly <- matrix(0, (length(lwfb90_res_lb_303_layer_theta_half_hourly) / 15), 15)

for (i in 0:14) {
  wat_cont_lb_303_half_hourly[,(i+1)] <- lwfb90_res_lb_303_layer_theta_half_hourly[((i*(length(lwfb90_res_lb_303_layer_theta_half_hourly) / 15))+1):((i+1)*(length(lwfb90_res_lb_303_layer_theta_half_hourly) / 15))]
}

str(wat_cont_lb_303_half_hourly)

# bind matrix with percolation per soil layer
# divide daily vertical water fluxes by 48 and repeat 48 times to disaggregate 
# for half-hourly time steps

lwfb90_res_lb_303_layer_vrfln <- rep(lwfb90_res_lb_303$layer_output$vrfl, each = 48)

# bind matrix with row number as number of time steps --> in this case for one 
# year with half hourly time steps --> also transform to mm

perc_lb_303_half_hourly <- matrix(0, (length(lwfb90_res_lb_303_layer_vrfln) / 15), 15)

for (i in 0:14) {
  perc_lb_303_half_hourly[,(i+1)] <- lwfb90_res_lb_303_layer_vrfln[((i*(length(lwfb90_res_lb_303_layer_vrfln) / 15))+1):((i+1)*(length(lwfb90_res_lb_303_layer_vrfln) / 15))] /48000
}

str(perc_lb_303_half_hourly)

# bind matrix with lateral water losses per soil layer
# divide daily lateral water fluxes by 48 and repeat 48 times to disaggregate 
# for half-hourly time steps

lwfb90_res_lb_303_layer_dsfl <- rep(lwfb90_res_lb_303$layer_output$dsfl, each = 48)

# bind matrix with row number as number of time steps --> in this case for one 
# year with half hourly time steps --> also transform to mm

lateral_loss_lb_303_half_hourly <- matrix(0, (length(lwfb90_res_lb_303_layer_dsfl) / 15), 15)

for (i in 0:14) {
  lateral_loss_lb_303_half_hourly[,(i+1)] <- lwfb90_res_lb_303_layer_dsfl[((i*(length(lwfb90_res_lb_303_layer_dsfl) / 15))+1):((i+1)*(length(lwfb90_res_lb_303_layer_dsfl) / 15))] /48000
}

str(lateral_loss_lb_303_half_hourly)


# update JSM forcing so that the water flows are fractions of the total soil 
# water content of the respective soil layer
# obtain water volume per soil layer
str(lwfb90_res_lb_303$layer_output$swati)
# plot(lwfb90_res_lb_303$layer_output$swati)

# obtain vertical water fluxes as a fraction of total water volume
lwfb90_res_lb_303_layer_vrfln_frac <- lwfb90_res_lb_303$layer_output$vrfl / lwfb90_res_lb_303$layer_output$swati
# plot(lwfb90_res_lb_303_layer_vrfln_frac)
lwfb90_res_lb_303_layer_vrfln_frac <- rep(lwfb90_res_lb_303_layer_vrfln_frac, each = 48)

# bind matrix with row number as number of time steps --> in this case for one 
# year with half hourly time steps

perc_lb_303_half_hourly_frac <- matrix(0, (length(lwfb90_res_lb_303_layer_vrfln_frac) / 15), 15)

for (i in 0:14) {
  perc_lb_303_half_hourly_frac[,(i+1)] <- lwfb90_res_lb_303_layer_vrfln_frac[((i*(length(lwfb90_res_lb_303_layer_vrfln_frac) / 15))+1):((i+1)*(length(lwfb90_res_lb_303_layer_vrfln_frac) / 15))] /48
}

str(perc_lb_303_half_hourly_frac)
# plot(perc_lb_303_half_hourly_frac[11555,])

# adjust fraction to unit 1000/s
perc_lb_303_half_hourly_frac <- perc_lb_303_half_hourly_frac * 0.000556 * 1000 
str(perc_lb_303_half_hourly_frac)

# try to set fluxes manually
# perc_lb_303_half_hourly_frac <- perc_lb_303_half_hourly_frac * 100000
# str(perc_lb_303_half_hourly_frac)


# obtain lateral water fluxes as a fraction of total water volume
lwfb90_res_lb_303_layer_dsfl_frac <- lwfb90_res_lb_303$layer_output$dsfl / lwfb90_res_lb_303$layer_output$swati
# plot(lwfb90_res_lb_303_layer_dsfl_frac)
lwfb90_res_lb_303_layer_dsfl_frac <- rep(lwfb90_res_lb_303_layer_dsfl_frac, each = 48)

# bind matrix with row number as number of time steps --> in this case for one 
# year with half hourly time steps --> also transform to mm

lateral_loss_lb_303_half_hourly_frac <- matrix(0, (length(lwfb90_res_lb_303_layer_dsfl_frac) / 15), 15)

for (i in 0:14) {
  lateral_loss_lb_303_half_hourly_frac[,(i+1)] <- lwfb90_res_lb_303_layer_dsfl_frac[((i*(length(lwfb90_res_lb_303_layer_dsfl_frac) / 15))+1):((i+1)*(length(lwfb90_res_lb_303_layer_dsfl_frac) / 15))] /48
}

str(lateral_loss_lb_303_half_hourly_frac)
# plot(lateral_loss_lb_303_half_hourly_frac[2,])

# adjust fraction to unit 1000/s
lateral_loss_lb_303_half_hourly_frac <- lateral_loss_lb_303_half_hourly_frac * 0.000556 #* 0.001 
str(lateral_loss_lb_303_half_hourly_frac)

# try to set fluxes manually
# lateral_loss_lb_303_half_hourly_frac <- lateral_loss_lb_303_half_hourly_frac * 100000
# str(lateral_loss_lb_303_half_hourly_frac)


#calculate soil water content in m
lwfb90_res_lb_303_layer_wat_cont_m <- lwfb90_res_lb_303$layer_output$swati * 0.001
# plot(lwfb90_res_lb_303_layer_vrfln_frac)
lwfb90_res_lb_303_layer_wat_cont_m_half_hourly <- rep(lwfb90_res_lb_303_layer_wat_cont_m, each = 48)

# bind matrix with row number as number of time steps --> in this case for one 
# year with half hourly time steps

wat_cont_lb_303_half_hourly_m <- matrix(0, (length(lwfb90_res_lb_303_layer_wat_cont_m_half_hourly) / 15), 15)

for (i in 0:14) {
  wat_cont_lb_303_half_hourly_m[,(i+1)] <- lwfb90_res_lb_303_layer_wat_cont_m_half_hourly[((i*(length(lwfb90_res_lb_303_layer_wat_cont_m_half_hourly) / 15))+1):((i+1)*(length(lwfb90_res_lb_303_layer_wat_cont_m_half_hourly) / 15))] 
}

str(wat_cont_lb_303_half_hourly_m)
# plot(perc_lb_303_half_hourly_frac[11555,])


################################################################################
# create JSM forcing data for lange bramke site 303 ############################
################################################################################

################################################################################
# soil_forcing_soilphysics lange bramke site 303 ###############################
################################################################################

#take example values from test script for abiotic conditions and replace root 
#fraction, demandN and demandP by values of this script

#create header 
#comment: only five soil layers available for water content and percolation from 
#LWF Brook 90 model
header <- c("Time", "TemperatureSoil_L1", "TemperatureSoil_L2", "TemperatureSoil_L3", 
            "TemperatureSoil_L4", "TemperatureSoil_L5", "TemperatureSoil_L6", 
            "TemperatureSoil_L7", "TemperatureSoil_L8", "TemperatureSoil_L9", 
            "TemperatureSoil_L10", "TemperatureSoil_L11", "TemperatureSoil_L12", 
            "TemperatureSoil_L13", "TemperatureSoil_L14", "TemperatureSoil_L15", 
            "WaterContentSoil_L1", "WaterContentSoil_L2", "WaterContentSoil_L3", 
            "WaterContentSoil_L4", "WaterContentSoil_L5", "WaterContentSoil_L6", 
            "WaterContentSoil_L7", "WaterContentSoil_L8", "WaterContentSoil_L9", 
            "WaterContentSoil_L10", "WaterContentSoil_L11", "WaterContentSoil_L12", 
            "WaterContentSoil_L13", "WaterContentSoil_L14", "WaterContentSoil_L15", 
            "PercolationSoil_L1", "PercolationSoil_L2", "PercolationSoil_L3", 
            "PercolationSoil_L4", "PercolationSoil_L5", "PercolationSoil_L6", 
            "PercolationSoil_L7", "PercolationSoil_L8", "PercolationSoil_L9", 
            "PercolationSoil_L10", "PercolationSoil_L11", "PercolationSoil_L12", 
            "PercolationSoil_L13", "PercolationSoil_L14", "PercolationSoil_L15", 
            "LateralLoss_L1", "LateralLoss_L2", "LateralLoss_L3", "LateralLoss_L4", 
            "LateralLoss_L5", "LateralLoss_L6", "LateralLoss_L7", "LateralLoss_L8", 
            "LateralLoss_L9", "LateralLoss_L10", "LateralLoss_L11", "LateralLoss_L12", 
            "LateralLoss_L13", "LateralLoss_L14", "LateralLoss_L15", 
            "RootFractionSoil_L1", "RootFractionSoil_L2", "RootFractionSoil_L3", 
            "RootFractionSoil_L4", "RootFractionSoil_L5", "RootFractionSoil_L6", 
            "RootFractionSoil_L7", "RootFractionSoil_L8", "RootFractionSoil_L9", 
            "RootFractionSoil_L10", "RootFractionSoil_L11", "RootFractionSoil_L12", 
            "RootFractionSoil_L13", "RootFractionSoil_L14", "RootFractionSoil_L15", 
            "VegPoolFineRootCarbon", "nhx_deposition", "noy_deposition", 
            "nhx_dn15_deposition", "noy_dn15_deposition", "p_deposition", 
            "demandUptakeN", "demandUptakeP")

#create vector of time in days with half hourly timesteps --> use the time 
#denotation of hainich forcing data
time <- vector()
getwd()
setwd("C:/Users/haeffner/Documents/Practical/data")
hainich_soilphysics <- read.table("soil_forcing_soilphysics_hainich.dat", header = TRUE)
time <- hainich_soilphysics$Time
str(time)
#repeat time frame to account for a hundred years
time <- rep(time, length(BT_lb$TotalBiomass))
str(time)

#create data frames of different soil physics matrices
#at the moment modelled outputs from soil_temperature2 and LWF Brook 90_FORMIND_JSM_test
#scripts are used
soil_physics_lb_303_df <- data.frame()
soil_physics_lb_303_df <- data.frame(time[1:438000], soil_temp_lb_303[1:438000,], wat_cont_lb_303_half_hourly_m[1:438000,], perc_lb_303_half_hourly_frac[1:438000,], 
                                     lateral_loss_lb_303_half_hourly_frac[1:438000,], matrix_root_long_lb[1:438000,], fine_root_biomass_lb_303[1:438000], nlhx_deposition[1:438000], 
                                     noy_deposition[1:438000], nhx_dn15_deposition[1:438000], 
                                     noy_dn15_deposition[1:438000], p_deposition[1:438000], 
                                     N_demand_lb_303_half_hourly[1:438000], P_demand_lb_303_half_hourly[1:438000])
colnames(soil_physics_lb_303_df) <- header
str(soil_physics_lb_303_df)

#export soil physics test forcing
getwd()
setwd("D:/Practical/data")
library(readr)
write_tsv(format(soil_physics_lb_303_df, digits=6, scientific = F), 
          file = "soil_physics_lb_303_df_init_1.txt")


################################################################################
# soil_forcing_litterfall ######################################################
################################################################################

#create header and time variable
getwd()
setwd("C:/Users/haeffner/Documents/Practical/data")
hainich_litter <- read.table("soil_forcing_litterfall.dat", header = TRUE)
str(hainich_litter)

header_litter_forcing <- colnames(hainich_litter)

time <- hainich_litter$Time
str(time)
#repeat time frame to account for a hundred years
time <- rep(time, length(BT_lb$Time))
str(time)

#create data frames of different litter input vectors
litter_input_lb_303_df <- data.frame()
litter_input_lb_303_df <- data.frame(time, leafC_lb_303, leafN_lb_303, leafP_lb_303, leafC13, 
                                     leafC14, leafN15, fine_rootC_lb_303, fine_rootN_lb_303, 
                                     fine_rootP_lb_303, fine_rootC13, fine_rootC14, 
                                     fine_rootN15, coarse_rootC_lb_303, coarse_rootN_lb_303, 
                                     coarse_rootP_lb_303, coarse_rootC13, coarse_rootC14, 
                                     coarse_rootN15, sap_woodC_lb_303, sap_woodN_lb_303, 
                                     sap_woodP_lb_303, sap_woodC13, sap_woodC14, 
                                     sap_woodN15, heart_woodC_lb_303, heart_woodN_lb_303, 
                                     heart_woodP_lb_303, heart_woodC13, heart_woodC14, 
                                     heart_woodN15, labileC_lb_303, labileN_lb_303, labileP_lb_303, 
                                     labileC13, labileC14, labileN15, reserveC_lb_303, 
                                     reserveN_lb_303, reserveP_lb_303, reserveC13, reserveC14, 
                                     reserveN15, fruitC_lb_303, fruitN_lb_303, fruitP_lb_303, fruitC13, 
                                     fruitC14, fruitN15, seed_bedC_lb_303, seed_bedN_lb_303, 
                                     seed_bedP_lb_303, seed_bedC13, seed_bedC14, 
                                     seed_bedN15)
colnames(litter_input_lb_303_df) <- header_litter_forcing
str(litter_input_lb_303_df)

#only take first 25 years of input to match the soil_forcing_soil_physics_lb_303
#data
litter_input_lb_303_df <- litter_input_lb_303_df[1:438000,]
str(litter_input_lb_303_df)

#export litterfall test forcing
getwd()
setwd("D:/Practical/data")
library(readr)
write_tsv(format(litter_input_lb_303_df, digits=6, scientific = F), file = "litter_input_lb_303_df_init_1.txt")
