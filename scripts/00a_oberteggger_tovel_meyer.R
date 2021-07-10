### This script is prepared by Michael F. Meyer (michael.f.meyer@wsu.edu)
### for the analysis of data submitted by Obertegger on Lake Tovel
### in Italy. This script is meant to check the submitted data for 
### QC and prepare it for an analytically-friendly format. 
### The script can be divided into the following sections:
### 1. Lake information
### 2. Station information
### 3. Water Parameters
### 4. Taxa List 
### 5. Zooplankton Abundance
### 6. Zooplankton Length
### 7. Lake Timeline
### 8. Equipment
### 9. Additional Data
### 10. Joins

# Load the proper libraries

library(tidyverse)
library(readxl)
library(janitor)

# First create directory for derived data products

derived_product_sub_dir <- "obertegger_tovel_disaggregated"
derived_product_output_dir <- file.path("../data/derived_products", derived_product_sub_dir)

if (!dir.exists(derived_product_output_dir)){
  dir.create(derived_product_output_dir)
} else {
  cat("Dir", derived_product_output_dir, "already exists!")
}

# Second create directory for figures

figure_sub_dir <- "obertegger_tovel_qc"
figure_output_dir <- file.path("../figures", figure_sub_dir)

if(!dir.exists(figure_output_dir)){
  dir.create(figure_output_dir)
} else {
  cat("Dir", figure_output_dir, "already exists!")
}

# Source script with generalized checking functions

source("functions_ZIG_data_team.R")


# 1. Lake Information -----------------------------------------------------

lake_information <- read_excel(path = "../data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", 
                               sheet = "lake", trim_ws = TRUE)

str(lake_information)

# Check provider notes for general sense of lake
lake_information$lake_comments

# Run check_lake function
check_lake(lake_information) 

# Lat and Lon contained N/S and E/W codings. Removing for consistency with other data. 
lake_information_clean <- lake_information %>%
  mutate(waterbody_lat_decdeg = as.numeric(gsub("[[:alpha:]]", "", waterbody_lat_decdeg)), 
         waterbody_lon_decdeg = as.numeric(gsub("[[:alpha:]]", "", waterbody_lon_decdeg)))

# Run check_lake function again
check_lake(lake_information_clean) 

# Export data to derived prodcuts
write.csv(x = lake_information_clean, 
          file = paste(derived_product_output_dir, "lake_information_obertegger.csv", 
                       sep = "/"),
          row.names = FALSE)


# 2. Station Information --------------------------------------------------

station_information <- read_excel(path = "../data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", 
                               sheet = "stationid")

str(station_information)

# Check provider notes for general sense of lake
station_information$sid_comments

# Check parameters with check_sid function
check_sid(station_information) 

# Data appear accurate and correctly formatted. 
station_information_clean <- station_information

# Export data to derived prodcuts
write.csv(x = station_information_clean, 
          file = paste(derived_product_output_dir, "station_information_obertegger.csv", 
                       sep = "/"),
          row.names = FALSE)


# 3. Water Paramters ------------------------------------------------------

water_parameters <- read_excel(path = "../data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", 
                                  sheet = "water_parameters", trim_ws = TRUE)

str(water_parameters)

summary(water_parameters)

# Check for surface or intergrated samples
unique(water_parameters$surf_or_int)

# Run check_water function
check_water(water_parameters)

# Correcting a formatting issue for time. Time was entered originally with a colon, 
# and formatting from excel treated at POSIXct

water_parameters_considered <- c("surface_ph", "surface_chla_ug_l", "surface_tp_ug_l",
                                "secchi_depth_m", "surface_temp_c", "hypo_temp_c",
                                "thermocline_depth", "NO2NO3_mgL", "silica_mgL", 
                                "dissolved_P_ugL", "TKN_mgL", "do_epi_mgL", 
                                "do_hypo_mgL", "conductivity_umho_cm", "DOC_um",
                                "DIC_um", "chloride_mgL", "alkalinity_mgL",
                                "hardness_mgL", "turbidity_NTU", "TN_mgL")

## HARD CODED NAs are converted to characters

# Let's identify the values that are NAs or contain a < or > symbol
find_non_digits <- water_parameters %>%
  mutate(time_hhmm = parse_time(format(time_hhmm, "%H:%M"))) %>%
  mutate(across(water_parameters_considered, .fns = as.character)) %>%
  pivot_longer(cols = water_parameters_considered, 
               names_to = "measurements",
               values_to = "values") %>%
  filter(grepl(pattern = "<|NA|>", x = values)) %>%
  select(year_yyyy, month_mm, day_of_month_dd, time_hhmm, time_of_day, 
         measurements, values)

unique(find_non_digits$measurements)
unique(find_non_digits$values)

water_parameters_clean <- water_parameters %>%
  mutate(time_hhmm = 1200) %>%
  mutate(across(water_parameters_considered, .fns = as.character)) %>%
  pivot_longer(cols = water_parameters_considered, 
               names_to = "measurements",
               values_to = "values") %>%
  mutate(values = ifelse(test = grepl(pattern = "NA", x = values),
                         yes = NA, no = values),
         values = ifelse(test = grepl(pattern = "<", x = values),
                         yes = as.numeric(gsub(pattern = "<", replacement = "", x = values))/2, 
                         no = values)) %>%
  pivot_wider(names_from = measurements, 
              values_from = values) %>%
  mutate(across(water_parameters_considered, .fns = as.numeric))


# Rerun check_water function
check_water(water_parameters_clean)

# Be sure to check for zeroes in the data
# These should be identified and replaced with half the MDL

water_zeros <- water_parameters_clean %>% 
  pivot_longer(cols = water_parameters_considered, 
               names_to = "measurement", 
               values_to = "values") %>%
  filter(values == 0) %>%
  select(year_yyyy, month_mm, day_of_month_dd, time_hhmm, time_of_day, 
         measurement, values)

water_zeros
  
qc_figures <- map(.x = water_parameters_considered, 
                  .f = ~ water_parameters_clean %>%
                    ggplot(mapping = aes(x = .data[[.x]])) +
                    geom_histogram(na.rm = TRUE) +
                    ggtitle(paste("Histogram of ", .x, sep = " ")) +
                    theme_minimal() +
                    theme(text = element_text(size = 18)))

walk2(.x = qc_figures, 
     .y = water_parameters_considered,
    .f = ~ ggsave(filename = paste("histogram_", .y, ".png"), 
                  plot = .x,
                  path = paste(figure_output_dir)))

# This dataset has no data for: 
# thermocline_depth, TKN_mgL, DOC_um, DIC_um, turbidity_NTU

monthly_qc_figures <- map(.x = water_parameters_considered[!(water_parameters_considered 
                                                             %in% c("thermocline_depth", "TKN_mgL", 
                                                                    "DOC_um", "DIC_um", 
                                                                    "turbidity_NTU"))], 
                          .f = ~ water_parameters_clean %>%
                            ggplot(mapping = aes(x = as.factor(month_mm),
                                                 y = .data[[.x]])) +
                            geom_boxplot(na.rm = TRUE) +
                            ggtitle(paste("Boxplots of monthly", .x, sep = " ")) +
                            theme_minimal() +
                            theme(text = element_text(size = 18)))

walk2(.x = monthly_qc_figures, 
      .y = water_parameters_considered[!(water_parameters_considered 
                                         %in% c("thermocline_depth", "TKN_mgL", 
                                                "DOC_um", "DIC_um", 
                                                "turbidity_NTU"))],
      .f = ~ ggsave(filename = paste("boxplots_monthly_", .y, ".png"), 
                    plot = .x,
                    path = paste(figure_output_dir)))

monthly_comp_figures <- map(.x = water_parameters_considered[!(water_parameters_considered 
                                                             %in% c("thermocline_depth", "TKN_mgL", 
                                                                    "DOC_um", "DIC_um", 
                                                                    "turbidity_NTU"))], 
                          .f = ~ water_parameters_clean %>%
                            pivot_longer(cols = water_parameters_considered, 
                                         names_to = "measurements",
                                         values_to = "values") %>%
                            filter(measurements == .x) %>%
                            group_by(waterbody_name, stationid, measurements) %>%
                            mutate(lagged_values = lag(x = values, n = 1L)) %>%
                            ggplot(mapping = aes(x = values,
                                                 y = lagged_values)) +
                            geom_point() +
                            geom_smooth(method = "lm") + 
                            geom_abline(slope = 1, intercept = 0, size = 3) +
                            ggtitle(paste("1:1 plot of", .x, sep = " ")) +
                            theme_minimal() +
                            theme(text = element_text(size = 18)))


walk2(.x = monthly_comp_figures, 
      .y = water_parameters_considered[!(water_parameters_considered 
                                         %in% c("thermocline_depth", "TKN_mgL", 
                                                "DOC_um", "DIC_um", 
                                                "turbidity_NTU"))],
      .f = ~ ggsave(filename = paste("one_to_one_monthly_", .y, ".png"), 
                    plot = .x,
                    path = paste(figure_output_dir)))

## Yearly checking 

annual_qc_figures <- map(.x = water_parameters_considered[!(water_parameters_considered 
                                                             %in% c("thermocline_depth", "TKN_mgL", 
                                                                    "DOC_um", "DIC_um", 
                                                                    "turbidity_NTU"))], 
                          .f = ~ water_parameters_clean %>%
                            ggplot(mapping = aes(x = as.factor(year_yyyy),
                                                 y = .data[[.x]])) +
                            geom_boxplot(na.rm = TRUE) +
                            ggtitle(paste("Boxplots of annual", .x, sep = " ")) +
                            theme_minimal() +
                            theme(text = element_text(size = 18)))

walk2(.x = annual_qc_figures, 
      .y = water_parameters_considered[!(water_parameters_considered 
                                         %in% c("thermocline_depth", "TKN_mgL", 
                                                "DOC_um", "DIC_um", 
                                                "turbidity_NTU"))],
      .f = ~ ggsave(filename = paste("boxplots_annual_", .y, ".png"), 
                    plot = .x,
                    path = paste(figure_output_dir)))

## Checking abnormalities in certain years for missing data. 

summary(water_parameters_clean %>%
          filter(year_yyyy == 2005))

write.csv(x = water_parameters_clean, 
          file = paste(derived_product_output_dir, "water_parameters_obertegger.csv", 
                       sep = "/"),
          row.names = FALSE)

# 4. Taxa List ------------------------------------------------------------


taxa_list <- read_excel(path = "../data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", 
                               sheet = "taxa_list", trim_ws = TRUE)

str(taxa_list)

# Run check_taxa function
check_taxa(taxa_list)

taxa_list_clean <- taxa_list %>%
  mutate(other_grouping = as.character(other_grouping))

# Rerun check_taxa function
check_taxa(taxa_list_clean)

unique(taxa_list_clean$ZIG_grouping)
unique(taxa_list_clean$genus)
unique(taxa_list_clean$species)

taxa_list_clean <- taxa_list_clean %>%
  unique()

write.csv(x = taxa_list_clean, 
          file = paste(derived_product_output_dir, "taxa_list_obertegger.csv", 
                       sep = "/"),
          row.names = FALSE)



# 5. Zooplankton Abundance ------------------------------------------------

zooplankton_abundance <- read_excel(path = "../data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", 
                        sheet = "zooplankton", trim_ws = TRUE)

str(zooplankton_abundance)

# Run check_zoop functions 
check_zoop(zooplankton_abundance)

# check that all taxa in taxa_list are in the dataset
zooplankton_abundance %>%
  filter(!taxa_name %in% taxa_list_clean$taxa_name)

# Check units
unique(zooplankton_abundance$density_units)
unique(zooplankton_abundance$biomass_units)

zooplankton_abundance_possible <- c("density_value", "biomass_value")

zooplankton_abundance_clean <- zooplankton_abundance %>%
  mutate(min_counts = parse_number(min_counts),
         time_zone = parse_number(time_zone),
         time_hhmm = parse_time(format(time_hhmm, "%H:%M"))) %>%
  separate(col = sample_depth_m, 
           into = c("top_tow_m", "bottom_tow_m"), 
           sep = "-", 
           remove = TRUE) %>%
  mutate_at(zooplankton_abundance_possible, .fun = as.character) %>%
  mutate_at(zooplankton_abundance_possible, .fun = as.numeric) %>%
  mutate_at(c("top_tow_m", "bottom_tow_m"), .fun = as.numeric) %>%
  mutate(density_units = "ind_L") %>%
  separate(col = taxa_name, into = c("genus", "species")) %>%
  pivot_longer(cols = c(biomass_value, density_value), 
               names_to = "measurement", values_to = "value") 

unique(zooplankton_abundance_clean$top_tow_m)
unique(zooplankton_abundance_clean$bottom_tow_m)
unique(zooplankton_abundance_clean$density_units)

test <- zooplankton_abundance_clean %>%
  select(measurement, genus) %>%
  distinct() 

# Rerun check_zoop function
check_zoop(zooplankton_abundance_clean %>%
             pivot_wider(names_from = "measurement",
                         values_from = "value"))

# Issues are okay because we separated taxa_name and sample_depth_m
  
qc_figures <- map(.x = test$genus, 
                    .f = ~ zooplankton_abundance_clean %>%
                      filter(genus == .x) %>%
                    ggplot(mapping = aes(x = as.factor(month_mm), y = value)) +
                    geom_boxplot(na.rm = TRUE) +
                    ggtitle(paste("Boxplots for", .x, sep = " ")) +
                    facet_wrap(~ measurement, scales = "free") +
                    theme_bw() +
                    theme(text = element_text(size = 18)))

walk2(.x = qc_figures, 
      .y = test$genus,
      .f = ~ ggsave(filename = paste("boxplots_monthly_", .y, ".png", sep = ""), 
                    plot = .x,
                    path = paste(figure_output_dir)))



## Yearly checking 

qc_figures <- map(.x = test$genus, 
                  .f = ~ zooplankton_abundance_clean %>%
                    filter(genus == .x) %>%
                    ggplot(mapping = aes(x = as.factor(year_yyyy), y = value)) +
                    geom_boxplot(na.rm = TRUE) +
                    ggtitle(paste("Boxplots for", .x, sep = " ")) +
                    facet_wrap(~ measurement, scales = "free") +
                    theme_bw() +
                    theme(text = element_text(size = 18)))

walk2(.x = qc_figures, 
      .y = test$genus,
      .f = ~ ggsave(filename = paste("boxplots_annual_", .y, ".png", sep = ""), 
                    plot = .x,
                    path = paste(figure_output_dir)))

monthly_comp_figures <- map(.x = test$genus, 
                            .f = ~ zooplankton_abundance_clean %>%
                              filter(genus == .x) %>%
                              group_by(waterbody_name, stationid, genus, measurement) %>%
                              mutate(lagged_values = lag(x = value, n = 1L)) %>%
                              ggplot(mapping = aes(x = value,
                                                   y = lagged_values)) +
                              geom_point() +
                              geom_smooth(method = "lm") + 
                              geom_abline(slope = 1, intercept = 0, size = 2) +
                              facet_wrap(~ measurement, scales = "free") +
                              ggtitle(paste("1:1 plot of", .x, sep = " ")) +
                              theme_minimal() +
                              theme(text = element_text(size = 18)))

walk2(.x = monthly_comp_figures, 
      .y = test$genus,
      .f = ~ ggsave(filename = paste("one_to_one_monthly", .y, ".png", sep = ""), 
                    plot = .x,
                    path = paste(figure_output_dir)))


zooplankton_abundance_clean <- zooplankton_abundance_clean %>%
  pivot_wider(names_from = "measurement", values_from = "value")

write.csv(x = zooplankton_abundance_clean, 
          file = paste(derived_product_output_dir, "zooplankton_abundance_obertegger.csv", 
                       sep = "/"),
          row.names = FALSE)


# 6. Zooplankton Length ---------------------------------------------------

# This dataset does not contain zooplankton length data.

zooplankton_length <- read_excel(path = "../data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", 
                                    sheet = "zoop_length", trim_ws = TRUE)

# Run check_zlen function 
check_zlen(zooplankton_length)

zooplankton_length_clean <- zooplankton_length %>% 
  na_if(y = "NA") %>%
  mutate(across(.cols = c("year_yyyy", "month_mm", "day_of_month_dd",
                          "length_mm", "length_raw_ID"),
                .fns = as.numeric))

check_zlen(zooplankton_length_clean)

write.csv(x = zooplankton_length_clean, 
          file = paste(derived_product_output_dir, "zooplankton_length_obertegger.csv", 
                       sep = "/"),
          row.names = FALSE)

# 7. Lake Timeline --------------------------------------------------------

lake_timeline <- read_excel(path = "../data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", 
                                 sheet = "lake_timeline", trim_ws = TRUE)

# Run check_time function
check_time(lake_timeline)

lake_timeline_clean <- lake_timeline %>% #lake_timeline corrections
  rename("events" = "timeline_year",
         "timeline_year" = "events") %>%
  select(waterbody_name, timeline_year, events)

check_time(lake_timeline_clean)


write.csv(x = lake_timeline_clean, 
          file = paste(derived_product_output_dir, "lake_timeline_obertegger.csv", 
                       sep = "/"),
          row.names = FALSE)


# 8. Equipment ------------------------------------------------------------

equipment <- read_excel(path = "../data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", 
                            sheet = "equipment", trim_ws = TRUE)

check_equip(equipment)

head(equipment)

equipment_clean <- equipment[1,]  %>%  #remove extra information
  na_if(y = "NA")  %>% #change from "NA" to NA
  mutate(turbidity_sensor = as.character(turbidity_sensor))

# Rerun check_equip function
check_equip(equipment_clean)

write.csv(x = equipment_clean, 
          file = paste(derived_product_output_dir, "equipment_clean_obertegger.csv", 
                       sep = "/"),
          row.names = FALSE)

equip_check <- data.frame(mean = water_parameters_clean %>% 
                            select(surface_ph:TN_mgL) %>%
                            colMeans(na.rm = TRUE), 
                          equipment = c(equipment_clean$ph_sensor_model, 
                                        paste(equipment_clean$chla_method, equipment_clean$chla_sensor_model),
                                        equipment_clean$ph_sensor_model, 
                                        "secchi", 
                                        equipment_clean$temp_sensor_model,
                                        equipment_clean$temp_sensor_model,
                                        equipment_clean$temp_sensor_model,
                                        equipment_clean$NO2NO3_method,
                                        equipment_clean$silica_method,
                                        equipment_clean$dissolved_P_method,
                                        equipment_clean$TKN_method,
                                        "ZIG_mistake", # Get DO method for provider
                                        "ZIG_mistake", # Get DO method for provider
                                        equipment_clean$cond_sensor_model,
                                        equipment_clean$DOC_method,
                                        equipment_clean$DIC_method,
                                        equipment_clean$chloride_method,
                                        equipment_clean$alkalinity_method,
                                        equipment_clean$hardness_method,
                                        equipment_clean$turbidity_sensor,
                                        equipment_clean$TN_method))

equip_check # Looks like each measurement has a method except for DO

#move extra information to lake_comments
x <-na.omit(equipment[3:7,1])

### Extra methods included in document
### Transfer this information to the README 
### for obertegger_data

# APHA, AWWA & WEF. 1992. Standard methods for the examination of water and                
# wastewater. 18th ed., Washington D.C. 
#
# I.R.S.A. - C.N.R. 1994. Metodi analitici per le acque. Quaderni, 100. Istituto di Ricerca
# sulle Acque, Roma: 342 pp.  


# 9. Additional data ------------------------------------------------------

additional_data <- read_excel(path = "../data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", 
                        sheet = "additional_data", trim_ws = TRUE)

# Run check_add
check_add(additional_data)

additional_data_clean <- additional_data %>% 
  na_if(y = "NA") %>%
  janitor::clean_names() #change from "NA" to NA

# Rerun check_add
check_add(additional_data_clean)

write.csv(x = additional_data_clean, 
          file = paste(derived_product_output_dir, "additional_data_obertegger.csv", 
                       sep = "/"),
          row.names = FALSE)

# 10. Joins ----------------------------------------------------------------

# Clear memory
rm(list = ls())
gc()

derived_product_sub_dir <- "obertegger_tovel_disaggregated"
derived_product_output_dir <- file.path("../data/derived_products", derived_product_sub_dir)

lake_info <- read.csv("../data/derived_products/obertegger_tovel_disaggregated/lake_information_obertegger.csv")

station_info <- read.csv("../data/derived_products/obertegger_tovel_disaggregated/station_information_obertegger.csv")

water_parameters <- read.csv("../data/derived_products/obertegger_tovel_disaggregated/water_parameters_obertegger.csv")

zoop_abundance <- read.csv("../data/derived_products/obertegger_tovel_disaggregated/zooplankton_abundance_obertegger.csv")

lake_station <- inner_join(x = lake_info, 
                           y = station_info, 
                           by = "waterbody_name")

anti_join(x = lake_info, 
           y = station_info, 
           by = "waterbody_name")

lake_station_water <- inner_join(x = lake_station,
                                 y = water_parameters, by = c("waterbody_name", "stationid"))

anti_join(x = lake_station, y = water_parameters, by = c("waterbody_name", "stationid"))

lake_station_zoop <- inner_join(x = lake_station, 
                                      y = zoop_abundance, 
                                      by = c("waterbody_name", "stationid"))

anti_join(x = lake_station, 
           y = zoop_abundance, 
           by = c("waterbody_name", "stationid"))

write.csv(x = lake_station_water, 
          file = paste(derived_product_output_dir, "complete_lake_station_water_obertegger.csv", 
                       sep = "/"),
          row.names = FALSE)

write.csv(x = lake_station_zoop, 
          file = paste(derived_product_output_dir, "complete_lake_station_zooplankton.csv", 
                       sep = "/"),
          row.names = FALSE)


