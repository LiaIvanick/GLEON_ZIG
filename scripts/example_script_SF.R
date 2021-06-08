# -------------------------------------------------------------------------
# Example script for cleaning a dataset for ZIG. This was devloped using the dataset: CORRECTED_ZIG_data_Obertegger_Tovel_vs2 - Ulrike Obertegger.xlsx
# S Figary
# -------------------------------------------------------------------------
library(tidyverse)
library(readxl)
source("scripts/ZIG_data_team_functions.R")

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
# check against satellite imagery, such as Google Earth
# waterbody lat/lon are in the waterbody
# stationid lat/lon are not -> check with data provider

# provider notes check ----------------------------------------------------
org_lake$lake_comments 
org_sid$sid_comments

# variable checks and corrections ----------------------------------------------------------
# checking each worksheet for the number of variables and variable types. This was done using the sourced functions.

#lake
check_lake(org_lake) #check parameters

lake <- org_lake %>% # make corrections
  mutate(waterbody_lat_decdeg = parse_number(waterbody_lat_decdeg),
         waterbody_lon_decdeg = parse_number(waterbody_lon_decdeg))

check_lake(lake) #recheck

#stationid
check_sid(org_sid) #check parameters
sid <- org_sid #no corrections needed

#water_parameters
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
water$surf_or_int_notes <- "none"

check_water(water)

#taxa_list 
check_taxa(org_taxa)
taxa <-org_taxa
taxa$other_grouping <- as.character(taxa$other_grouping) #corrections
check_taxa(taxa)

#zooplankton 
check_zoop(org_zoop)

zoop <- org_zoop %>% separate(sample_depth_m, into = c("top_tow_m", "bottom_tow_m")) %>%
  mutate(min_counts = parse_number(min_counts),#ask about this
         time_zone = parse_number(time_zone),
         time_hhmm = parse_time(format(time_hhmm, "%H:%M"))
         ) #zooplankton corrections
zoop$top_tow_m <- as.numeric(zoop$top_tow_m)  
zoop$bottom_tow_m <- as.numeric(zoop$bottom_tow_m) 
  
check_zoop(zoop) #errors make sense. 

#zoop_length 
check_zlen(org_zlen)

zlen<-org_zlen

zlen$year_yyyy <- as.numeric(zlen$year_yyyy) #all NAs. Still correctting
zlen$month_mm <- as.numeric(zlen$month_mm)
zlen$day_of_month_dd <- as.numeric(zlen$day_of_month_dd)
zlen$length_raw_ID <- as.numeric(zlen$length_raw_ID)
zlen$length_mm <- as.numeric(zlen$length_mm)

check_zlen(zlen)

#lake_timeline
check_time(org_time)

time <- org_time %>% #lake_timeline corrections
  rename(events = timeline_year,
         timeline_year = events) %>%
  select(waterbody_name, timeline_year, events)

check_time(time)

#equipment original 
check_equip(org_equip)
equip <- org_equip 
equip$turbidity_sensor <- as.character(equip$turbidity_sensor)
check_equip(equip)

#additional_data
check_add(org_add)
add <- org_add  #no corrections needed


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
                             "time_of_day")) #add column to say no zoop here?

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


# methods check -----------------------------------------------------------
# Confirm that all data in water_parameters have a method listed in the equipment worksheet. For instance, if the water_paramter datasheet includes TP, chl, and silica then the equipment worksheet should have data for these column.

equip

# plan: come up with an automated way of doing this. may need a function
# for this dataset: I think the method references should be added to the lake_comments field. 


# qc check ----------------------------------------------------------------
x <- water %>% pivot_longer(cols = surface_ph:TN_mgL)

ggplot(na.omit(x)) +
  geom_histogram(aes(value), bins = 100) +
  facet_wrap(name~., scales = "free")

#epi do = 0? tp = 0?

#ggsave()
#need naming conventions

# write clean .csv --------------------------------------------------------

# Need naming conventions
write_csv(lake, "data/derived/example/Obertegger_Tovel_wklake_clean_figary.csv")
#etc etc


# generate notes ----------------------------------------------------------

#fill this in
