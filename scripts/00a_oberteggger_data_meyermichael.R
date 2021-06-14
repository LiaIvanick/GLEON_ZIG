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
### 7. Joins tables

# Load the proper libraries

library(tidyverse)
library(readxl)

# First create directory for derived data products

derived_product_sub_dir <- "obertegger_disaggregated"
derived_product_output_dir <- file.path("../data/derived_products", derived_product_sub_dir)

if (!dir.exists(derived_product_output_dir)){
  dir.create(derived_product_output_dir)
} else {
  cat("Dir", derived_product_output_dir, "already exists!")
}

# Second create directory for figures

figure_sub_dir <- "obertegger_qc"
figure_output_dir <- file.path("../figures", figure_sub_dir)

if (!dir.exists(figure_output_dir)){
  dir.create(figure_output_dir)
} else {
  cat("Dir", figure_output_dir, "already exists!")
}



# 1. Lake Information -----------------------------------------------------

lake_information <- read_excel(path = "../data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", 
                               sheet = "lake", trim_ws = TRUE)

str(lake_information)

# Lat and Lon contained N/S and E/W codings. Removing for consistency with other data. 

lake_information_clean <- lake_information %>%
  mutate(waterbody_lat_decdeg = as.numeric(gsub("[[:alpha:]]", "", waterbody_lat_decdeg)), 
         waterbody_lon_decdeg = as.numeric(gsub("[[:alpha:]]", "", waterbody_lon_decdeg)))

# Export data to derived prodcuts

write.csv(x = lake_information_clean, 
          file = paste(derived_product_output_dir, "lake_information_obertegger.csv", 
                       sep = "/"),
          row.names = FALSE)


# 2. Station Information --------------------------------------------------

station_information <- read_excel(path = "../data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", 
                               sheet = "stationid")

str(station_information)

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

# Correcting a formatting issue for time. Time was entered originally with a colon, 
# and formatting from excel treated at POSIXct

water_parameters_considered <- c("surface_ph", "surface_chla_ug_l", "surface_tp_ug_l",
                                "secchi_depth_m", "surface_temp_c", "hypo_temp_c",
                                "thermocline_depth", "NO2NO3_mgL", "silica_mgL", 
                                "dissolved_P_ugL", "TKN_mgL", "do_epi_mgL", 
                                "do_hypo_mgL", "conductivity_umho_cm", "DOC_um",
                                "DIC_um", "chloride_mgL", "alkalinity_mgL",
                                "hardness_mgL", "turbidity_NTU", "TN_mgL")

## MFM: FIGURE OUT A FLAG FOR NON-NUMERIC CHARACTER LIKE </> 
## HARD CODED NAs are converted to characters

find_non_digits <- water_parameters %>%
  mutate(time_hhmm = 1200) %>%
  mutate(across(water_parameters_considered, .fns = as.character)) %>%
  pivot_longer(cols = water_parameters_considered, 
               names_to = "measurements",
               values_to = "values") %>%
  filter(grepl(pattern = "<|NA|>", x = values))

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

## HOW TO HANDLE ZEROS IN THE DATASET??


# 4. Taxa List ------------------------------------------------------------


taxa_list <- read_excel(path = "../data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", 
                               sheet = "taxa_list", trim_ws = TRUE, )

str(taxa_list)

unique(taxa_list$ZIG_grouping)
unique(taxa_list$genus)
unique(taxa_list$species)

taxa_list_clean <- taxa_list %>%
  unique()

write.csv(x = taxa_list_clean, 
          file = paste(derived_product_output_dir, "taxa_list_obertegger.csv", 
                       sep = "/"),
          row.names = FALSE)



# 5. Zooplankton Abundance ------------------------------------------------

zooplankton_abundance <- read_excel(path = "../data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", 
                        sheet = "zooplankton", trim_ws = TRUE)

str(zooplankton_abundance)

# check that all taxa in taxa_list are in the dataset

zooplankton_abundance %>%
  filter(!taxa_name %in% taxa_list_clean$taxa_name)


zooplankton_abundance_possible <- c("density_value", "biomass_value")

zooplankton_abundance_clean <- zooplankton_abundance %>%
  mutate(time_hhmm = 1200) %>%
  mutate_at(zooplankton_abundance_possible, .fun = as.character) %>%
  mutate_at(zooplankton_abundance_possible, .fun = as.numeric) %>%
  separate(col = taxa_name, into = c("genus", "species")) %>%
  pivot_longer(cols = c(biomass_value, density_value), 
               names_to = "measurement", values_to = "value") 

test <- zooplankton_abundance_clean %>%
  select(measurement, genus) %>%
  distinct() 
  
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
          file = "../data/derived_products/obertegger_disaggregated/zooplankton_abundance.csv", 
          row.names = FALSE)


# 6. Zooplankton Length ---------------------------------------------------

# This dataset does not contain zooplankton length data.

# 7. Joins ----------------------------------------------------------------

rm(list = ls())
gc()

lake_info <- read.csv("../data/derived_products/obertegger_disaggregated/lake_information_obertegger.csv")

station_info <- read.csv("../data/derived_products/obertegger_disaggregated/station_information_obertegger.csv")

water_parameters <- read.csv("../data/derived_products/obertegger_disaggregated/water_parameters_obertegger.csv")

zoop_abundance <- read.csv("../data/derived_products/obertegger_disaggregated/zooplankton_abundance.csv")

lake_station <- inner_join(x = lake_info, 
                           y = station_info, 
                           by = "waterbody_name")

lake_station_water <- inner_join(x = lake_station,
                                 y = water_parameters, by = c("waterbody_name", "stationid"))

anti_join(x = lake_station, y = water_parameters, by = c("waterbody_name", "stationid"))

lake_station_water_zoop <- inner_join(x = lake_station_water, 
                                      y = zoop_abundance %>%
                                        mutate(day_of_month_dd = ifelse(year_yyyy == 2002 & month_mm == 7 & day_of_month_dd == 15,
                                                                        yes = 16, no = day_of_month_dd),
                                               day_of_month_dd = ifelse(year_yyyy == 2003 & month_mm == 8 & day_of_month_dd == 21,
                                                                        yes = 27, no = day_of_month_dd)), 
                                      by = c("waterbody_name", "stationid", "year_yyyy",
                                             "month_mm"), 
                                      suffix = c("water", "zoop"))

anti_join(x = lake_station_water, 
           y = zoop_abundance %>%
            mutate(day_of_month_dd = ifelse(year_yyyy == 2002 & month_mm == 7 & day_of_month_dd == 15,
                                            yes = 16, no = day_of_month_dd),
                   day_of_month_dd = ifelse(year_yyyy == 2003 & month_mm == 8 & day_of_month_dd == 21,
                                            yes = 27, no = day_of_month_dd)), 
           by = c("waterbody_name", "stationid", "year_yyyy",
                  "month_mm", "day_of_month_dd", "time_hhmm")) %>%
  distinct(waterbody_name, stationid, year_yyyy,
           month_mm, day_of_month_dd, time_hhmm)

anti_join(x = zoop_abundance%>%
            mutate(day_of_month_dd = ifelse(year_yyyy == 2002 & month_mm == 7 & day_of_month_dd == 15,
                                            yes = 16, no = day_of_month_dd),
                   day_of_month_dd = ifelse(year_yyyy == 2003 & month_mm == 8 & day_of_month_dd == 21,
                                            yes = 27, no = day_of_month_dd)), 
          y = lake_station_water, 
          by = c("waterbody_name", "stationid", "year_yyyy",
                 "month_mm", "day_of_month_dd", "time_hhmm")) %>%
  distinct(waterbody_name, stationid, year_yyyy,
             month_mm, day_of_month_dd, time_hhmm)

write.csv(x = lake_station_water_zoop, 
          file = "../data/derived_products/obertegger_disaggregated/complete_lake_station_water_zoop.csv", 
          row.names = TRUE)
