# -------------------------------------------------------------------------
# Example script for cleaning a dataset for ZIG. This was devloped using the dataset: CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx
# S Figary
# -------------------------------------------------------------------------
library(tidyverse)
library(readxl)
source("scripts/functions_ZIG_data_team.R")

# read data ---------------------------------------------------------------
org_lake <- read_excel("data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", sheet = "lake")

org_sid <- read_excel("data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", sheet = "stationid")

org_water <- read_excel("data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", sheet = "water_parameters")

org_taxa <- read_excel("data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", sheet = "taxa_list")

org_zoop <- read_excel("data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", sheet = "zooplankton")

org_zlen <- read_excel("data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", sheet = "zoop_length")

org_time <- read_excel("data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", sheet = "lake_timeline")

org_equip <- read_excel("data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", sheet = "equipment")

org_add <- read_excel("data/inputs/CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx", sheet = "additional_data")


# coordinate check --------------------------------------------------------
# check against satellite imagery

# Checked: waterbody lat/lon are in the waterbody
# Checked: stationid lat/lon are not -> check with data provider

# check provider notes ----------------------------------------------------
org_lake$lake_comments 
org_sid$sid_comments
unique(org_water$surf_or_int)

# variable checks and corrections -----------_-----------------------------
# checking each worksheet for the number of variables and variable types. This was done using the sourced functions.

### lake
check_lake(org_lake) #check parameters

lake <- org_lake %>% # make corrections
  mutate(waterbody_lat_decdeg = parse_number(waterbody_lat_decdeg),
         waterbody_lon_decdeg = parse_number(waterbody_lon_decdeg)) 

check_lake(lake) #recheck

### stationid
check_sid(org_sid) #check parameters
sid <- org_sid #no corrections needed

### water_parameters
check_water(org_water)

water <- org_water %>% #water parameter corrections
  mutate(time_hhmm = parse_time(format(time_hhmm, "%H:%M"))) 

water$surface_ph <- as.numeric(water$surface_ph)
water$surface_chla_ug_l <- as.numeric(water$surface_chla_ug_l)
water$surface_tp_ug_l[water$surface_tp_ug_l == "<1" ] <- 0.5
water$surface_tp_ug_l <- as.numeric(water$surface_tp_ug_l)
water$secchi_depth_m <- as.numeric(water$secchi_depth_m)
water$thermocline_depth <- as.numeric(water$thermocline_depth)
water$NO2NO3_mgL <- as.numeric(water$NO2NO3_mgL)
water$silica_mgL <- as.numeric(water$silica_mgL)
water$dissolved_P_ugL[water$dissolved_P_ugL == "<1" ] <- 0.5
water$dissolved_P_ugL <- as.numeric(water$dissolved_P_ugL)
water$TKN_mgL <- as.numeric(water$TKN_mgL)
water$DOC_um <- as.numeric(water$DOC_um)
water$DIC_um <- as.numeric(water$DIC_um)
water$turbidity_NTU <- as.numeric(water$turbidity_NTU)
water$TN_mgL <- as.numeric(water$TN_mgL)

check_water(water)

#check for zeros in water parameters
water_zeros <- water %>% pivot_longer(surface_ph:TN_mgL) %>%
  filter(value == 0) #These should be followed up on with the data provider 
# and should be replaced as half of the method detection limit

### taxa_list 
check_taxa(org_taxa)
taxa <-org_taxa
taxa$other_grouping <- as.character(taxa$other_grouping) #corrections
check_taxa(taxa)

### zooplankton 
check_zoop(org_zoop)

zoop <- org_zoop %>% separate(sample_depth_m, 
                              into = c("top_tow_m", "bottom_tow_m")) %>%
  mutate(min_counts = parse_number(min_counts),
         time_zone = parse_number(time_zone),
         time_hhmm = parse_time(format(time_hhmm, "%H:%M"))
         ) #zooplankton corrections
unique(zoop$min_counts) #follow up with data provide


#create new zooplankton columns
zoop$top_tow_m <- as.numeric(zoop$top_tow_m)  
zoop$bottom_tow_m <- as.numeric(zoop$bottom_tow_m) 
  
check_zoop(zoop) #errors make sense. 

### zoop_length 
check_zlen(org_zlen)

zlen<-org_zlen %>% na_if(y = "NA")# change "NA" to NA

zlen$year_yyyy <- as.numeric(zlen$year_yyyy) #all NAs. Still need to be corrected
zlen$month_mm <- as.numeric(zlen$month_mm)
zlen$day_of_month_dd <- as.numeric(zlen$day_of_month_dd)
zlen$length_raw_ID <- as.numeric(zlen$length_raw_ID)
zlen$length_mm <- as.numeric(zlen$length_mm)

check_zlen(zlen)

### lake_timeline
check_time(org_time)

time <- org_time %>% #lake_timeline corrections
  rename(events = timeline_year,
         timeline_year = events) %>%
  select(waterbody_name, timeline_year, events)

check_time(time)

### equipment 
check_equip(org_equip)
equip <- org_equip[1,]  %>%  #remove extra information
  na_if(y = "NA") #change from "NA" to NA
equip$turbidity_sensor <- as.character(equip$turbidity_sensor) 

check_equip(equip)

#move extra information to lake_comments
x <-na.omit(org_equip[3:7,1])
lake[1, "lake_comments"] <- paste0(lake[1, "lake_comments"], ". ",
                                   "Method notes:", x[1,], x[2,], "; ",
                                   x[3,], x[4,])

lake$lake_comments

### additional_data
check_add(org_add)
add <- org_add %>% na_if(y = "NA") #change from "NA" to NA



# check for completeness --------------------------------------------------
# The output will be a tibble with zero rows if the data is represented in both dataframes

#waterbody_name
anti_join(lake, sid, by = "waterbody_name")
anti_join(lake, water, by = "waterbody_name")
anti_join(lake, zoop, by = "waterbody_name")
anti_join(lake, zlen, by = "waterbody_name") #because no info in zlen; okay
anti_join(lake, time, by = "waterbody_name")

anti_join(sid, water, by = "waterbody_name")
anti_join(sid, zoop, by = "waterbody_name")
anti_join(sid, zlen, by = "waterbody_name") #because no info in zlen; okay
anti_join(sid, time, by = "waterbody_name")

anti_join(water, zoop, by = "waterbody_name")
anti_join(water, zlen, by = "waterbody_name") #because no info in zlen; okay
anti_join(water, time, by = "waterbody_name")

anti_join(zoop, zlen, by = "waterbody_name") #because no info in zlen; okay
anti_join(zoop, time, by = "waterbody_name")

anti_join(zlen, time, by = "waterbody_name") #because no info in zlen; okay

#stationid
anti_join(sid, water, by = "stationid")
anti_join(sid, zoop, by = "stationid")
anti_join(sid, zlen, by = "stationid") #because no info in zlen; okay
anti_join(water, zoop, by = "stationid")
anti_join(water, zlen, by = "stationid") #because no info in zlen; okay
anti_join(zoop, zlen, by = "stationid") #because no info in zlen; okay

#sampleid
anti_join(water, zoop, by = c("stationid", "year_yyyy", "month_mm",
                             "day_of_month_dd", "time_hhmm",
                             "time_of_day")) #Two sampling events without matched zooplankton data.

anti_join(water, zlen, by = c("stationid", "year_yyyy", "month_mm",
                             "day_of_month_dd", "time_hhmm", 
                             "time_of_day")) #because no info in zlen; okay

anti_join(zoop, zlen, by = c("stationid", "year_yyyy", "month_mm",
                              "day_of_month_dd", "time_hhmm", 
                             "time_of_day")) #because no info in zlen; okay

#taxa_name                       
anti_join(taxa, zoop, by = "taxa_name")
anti_join(taxa, zlen, by = "taxa_name") #because no info in zlen; okay
anti_join(zoop, zlen, by = "taxa_name") #because no info in zlen; okay

#zoop_sampler_type
anti_join(zoop, zlen, by = "zoop_sampler_type") #because no info in zlen; okay


# check zoop units --------------------------------------------------------

# Abundance (convert to: ind_L)
# All abundance should be individuals/L using "ind_L"
unique(zoop$density_units) #check the current abundance units

zoop$density_units[zoop$density_units == "ind_l" ] <- "ind_L" #correct capitalization

# Biomass (convert to: *_m3)
### Do not convert between µg and mg. 
unique(zoop$biomass_dry_wet) #Check that the biomass type matches the units. Wet biomass should be in mg_* and dry should be in ug_*
unique(zoop$biomass_units)  #check the current abundance units
# no change, correct units

#Example code for converting data

### Density: ind_m3 to ind_L
# zoop %>% mutate(density_value = 1000*abundance_value)
# zoop$density_units[zoop$density_units == "ind_m3" ] <- "ind_L"

### Density: ind_m2 to ind_L
# zoop %>% mutate(density_value = (abundance_value/(bottom_tow_m-top_tow_m))*1000)
# zoop$density_units[zoop$density_units == "ind_m2" ] <- "ind_L"

### Biomass: µg_L or mg_L to µg_m3 or mg_m3
# zoop %>% mutate(biomass_value = biomass_value/1000)
# zoop$biomass_units[zoop$biomass_units == "ug_L" ] <- "ug_m3"
# zoop$biomass_units[zoop$biomass_units == "mg_L" ] <- "mg_m3"

### Biomass: µg_m2 or mg_m2 to µg_m3 or mg_m3
# zoop %>% mutate(biomass_value = biomass_value/(bottom_tow_m-top_tow_m))
# zoop$biomass_units[zoop$biomass_units == "ug_m2" ] <- "ug_m3"
# zoop$biomass_units[zoop$biomass_units == "mg_m2" ] <- "mg_m3"


# methods check ---------------------------------------------------------
# Confirm that all data in water_parameters have a method listed in the equipment worksheet. For instance, if the water_paramter datasheet includes TP, chl, and silica then the equipment worksheet should have data for these column.

equip_check <- data.frame(mean = water %>% select(surface_ph:TN_mgL) %>%
  colMeans(na.rm = TRUE), 
  equipment = c(equip$ph_sensor_model, 
                paste(equip$chla_method, equip$chla_sensor_model),
                equip$ph_sensor_model, 
                "secchi", 
                equip$temp_sensor_model,
                equip$temp_sensor_model,
                equip$temp_sensor_model,
                equip$NO2NO3_method,
                equip$silica_method,
                equip$dissolved_P_method,
                equip$TKN_method,
                "ZIG_mistake",
                "ZIG_mistake",
                equip$cond_sensor_model,
                equip$DOC_method,
                equip$DIC_method,
                equip$chloride_method,
                equip$alkalinity_method,
                equip$hardness_method,
                equip$turbidity_sensor,
                equip$TN_method))

#check that all water quality data has an associated method
equip_check #all good


# Things to follow up on ---------------------------------------------------

# Check: stationid lat/lon
# Check: Zeros in water parameters
# Check: min_counts is an unexpected value. 
# Two sampling events do not have zooplankton data associated with them

# See Script folder readme for a 'how-to' on following up with providers

# See Michael's script for QC checks and README for an example readme

# after everything is followed up on, write the .csv


# write clean .csv --------------------------------------------------------
write.csv(lake, "data/derived_products/Tovel_Figary_disaggregated/tovel_lake.csv")
write.csv(sid, "data/derived_products/Tovel_Figary_disaggregated/tovel_stationid.csv")
write.csv(water, "data/derived_products/Tovel_Figary_disaggregated/tovel_water_parameters.csv")
write.csv(taxa, "data/derived_products/Tovel_Figary_disaggregated/tovel_taxa_list.csv")
write.csv(zoop, "data/derived_products/Tovel_Figary_disaggregated/tovel_zooplankton.csv")
write.csv(zlen, "data/derived_products/Tovel_Figary_disaggregated/tovel_zoop_length.csv")
write.csv(time, "data/derived_products/Tovel_Figary_disaggregated/tovel_take_timeline.csv")
write.csv(equip, "data/derived_products/Tovel_Figary_disaggregated/tovel_equipment.csv")
write.csv(add, "data/derived_products/Tovel_Figary_disaggregated/tovel_additional_data.csv")
