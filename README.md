# Dataset: Source Code, Raw Data, Processed Data, Processing Scripts, and Results of the FORest-Soil-Model-FOR-SM

# 1. Description
This dataset contains the model source code of the LWF-BROOK90 model which was used within the coupled FORest - Soil Model (FOR-SM), a forest biogeochemical model to simulate forest developments, soil hydrology, as well as C, N and P cycles. In addition to the raw model outputs, the dataset includes processed data used to generate the figures presented in the results section of the associated manuscript. 

# 2. Folder structure
- model src/ : Fortran and R source code of the edited LWF-BROOK90 model
- data/raw/: Model outputs of the coupled model system across different test sites.
- data/processed/: Simulated and observed data used to generate the figures in the result section.
- scripts/: R scripts used to prepare model input data, process raw data and generate the analytical figures.
- results/: Outcome of model calibration and validation, and results from the different test sites.

# 3. File descriptions

# 3.1 Raw data
- model src/LWFBrook90Rmasterdev/: full edited LWF-BROOK90 source code files originating from the masterdev branch of the original LWF-BROOK90 repository (https://github.com/pschmidtwalter/LWFBrook90R)
- data/raw/forest_soil_hydrology_lb_303.rds: R object containing the results of forest development and soil hydrology for the Lange Bramke site (ICP 303)
- data/raw/forest_soil_hydrology_sl_304.txt: R object containing the results of forest development and soil hydrology for the Solling site (ICP 304)
- data/raw/forest_soil_hydrology_kl_1503.txt: R object containing the results of forest development and soil hydrology for the Klötze site (ICP 1503)
- data/raw/soil_temperature_lb_303.txt: Text file containing the results of soil temperature for the Lange Bramke site (ICP 303)
- data/raw/soil_temperature_sl_304.txt: Text file containing the results of soil temperature for the Solling site (ICP 304)
- data/raw/soil_temperature_kl_1503.txt: Text file containing the results of soil temperature for the Klötze site (ICP 1503)
- data/raw/forest_biogeochemistry_lb_303.txt: Text file containing the results of forest biogeochemistry for the Lange Bramke site (ICP 303)
- data/raw/forest_biogeochemistry_sl_304.txt: Text file containing the results of forest biogeochemistry for the Solling site (ICP 304)
- data/raw/forest_biogeochemistry_kl_1503.txt: Text file containing the results of forest biogeochemistry for the Klötze site (ICP 1503)
- data/raw/sensitivity_analysis: folder structure containing the restuls of the different model runs with changed parameters

# 3.2 Processed data
- data/processed/forest_development_lb_303_processed.txt: Text file containing the processed results of forest development for the Lange Bramke site including processed observation values from the monitoring program (ICP 303)
- data/processed/forest_development_sl_304_processed.txt: Text file containing the processed results of forest development for the Solling site including processed observation values from the monitoring program (ICP 304)
- data/processed/forest_development_kl_1503_processed.txt: Text file containing the processed results of forest development for the Klötze site including processed observation values from the monitoring program (ICP 1503)
- data/processed/soil_forcing_litterfall_lb_303.dat: Text file containing the litterfall forcing for the Jena Soil Model (Lange Bramke site, ICP 303)
- data/processed/soil_forcing_litterfall_sl_304.dat: Text file containing the litterfall forcing for the Jena Soil Model (Solling site, ICP 304)
- data/processed/soil_forcing_litterfall_kl_1503.dat: Text file containing the litterfall forcing for the Jena Soil Model (Klötze site, ICP 1503)
- data/processed/soil_forcing_soilphysics_lb_303.dat: Text file containing the soil physics forcing for the Jena Soil Model (Lange Bramke site, ICP 303)
- data/processed/soil_forcing_soilphysics_sl_304.dat: Text file containing the soil physics forcing for the Jena Soil Model (Solling site, ICP 304)
- data/processed/soil_forcing_soilphysics_kl_1503.dat: Text file containing the soil physics forcing for the Jena Soil Model (Klötze site, ICP 1503)
- data/processed/forest_biogeochemistry_lb_303_processed.txt: Text file containing the processed results of forest biogeochemistry for the Lange Bramke site including observation values from the monitoring program (ICP 303)
- data/processed/forest_biogeochemistry_sl_304_processed.txt: Text file containing the processed results of forest biogeochemistry for the Solling site including the observation values from the monitoring program (ICP 304)
- data/processed/forest_biogeochemistry_kl_1503_processed.txt: Text file containing the processed results of forest biogeochemistry for the Klötze site including the observation values from the monitoring program (ICP 1503)
- data/processed/slb1_meteo_lb303.txt: Text file containing the processed meteo input data for the Lange Bramke site (ICP 303)
- data/processed/slb1_meteo_sl304.txt: Text file containing the processed meteo input data for the Solling site (ICP 304)
- data/processed/slb1_meteo_kl1503.txt: Text file containing the processed meteo input data for the Kloetze site (ICP 1503)

# 3.3 Scripts and results
- scripts/data analysis submit1.R: R script for data processing, visualization and statistical analysis
- scripts/FORMIND_LWFBrook90_coupling_script.py: python script for coupling and running the FORMIND and LW-BROOK90 models via the python package FINAM
- scripts/FORMIND_LWFBrook90_JSM_coupling_script.R: R script for the transformation of FORMIND and LWF-BROOK90 output data to JSM suitable input data

# 4. Licensing
This dataset is licensed under the Creative Commons Attribution 4.0 International License (CC BY 4.0). You are free to use, distribute, and adapt the material, provided proper attribution is given.

# 5. Citation
Sauke, F., Fischer, R., Ahrends, B., Fuchs, S., Chen, M., Rode, M. (2026). Dataset: Raw Data, Processed Data, Processing Scripts, and Results of FOR-SM. 

# 6. Contact
For questions or suggestions, please contact:

[Felix Sauke] [Helmholtz-Centre for Environmental Resarch] [felix.sauke@ufz.de]

# 7. References
