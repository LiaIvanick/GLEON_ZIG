# -------------------------------------------------------------------------
# Functions for the data cleaning process. Use source().
# -------------------------------------------------------------------------


# variable check/worksheet functions --------------------------------------
# this section include one function/worksheet. Each function checks the number of variables in the sheet and if the type of each variable matches the expected variable type. Each function outputs a vector with the parameters that need to be checked and/or corrected.
# Note: These functions were developed using a dataset that followed the data submission guidelines closely. These functions may not work well on data submissions that deviated significantly from the data submission guidelines.

# lake worksheet
check_lake <- function(df_lake) {
  out = numeric(27) #create an empty vector
  
  ifelse(length(df_lake) == 26, #number expected varibles
         yes = out[1] <- "okay", #write to the vector
         no = out[1] <- "check number of variables")
  ifelse(typeof(df_lake$waterbody_name)  == "character",  #check the first varible type
         yes = out[2] <- "okay", #write to the vector
         no = out[2] <- "check waterbody_name")
  ifelse(typeof(df_lake$yr_start_yyyy)   == "integer" | typeof(df_lake$yr_start_yyyy)  == "double", 
         yes = out[3] <- "okay",
         no = out[3] <- "check yr_start_yyyy")
  ifelse(typeof(df_lake$yr_end_yyyy)   == "integer" | typeof(df_lake$yr_end_yyyy)  == "double", 
         yes = out[4] <- "okay",
         no = out[4] <- "check yr_end_yyyy")
  ifelse(typeof(df_lake$waterbody_type)  == "character", 
         yes = out[5] <- "okay",
         no = out[5] <- "check waterbody_type")
  ifelse(typeof(df_lake$waterbody_lat_decdeg)== "double", 
         yes = out[6] <- "okay",
         no = out[6] <- "check waterbody_lat_decdeg")
  ifelse(typeof(df_lake$waterbody_lon_decdeg)== "double", 
         yes = out[7] <- "okay",
         no = out[7] <- "check waterbody_lon_decdeg")
  ifelse(typeof(df_lake$country)== "character", 
         yes = out[8] <- "okay",
         no = out[8] <- "check country")
  ifelse(typeof(df_lake$avg_depth_m)  == "integer" | typeof(df_lake$avg_depth_m)  == "double", 
         yes = out[9] <- "okay",
         no = out[9] <- "check avg_depth_m")
  ifelse(typeof(df_lake$max_depth_m)  == "integer" | typeof(df_lake$max_depth_m)  == "double", 
         yes = out[10] <- "okay",
         no = out[10] <- "check max_depth_m")
  ifelse(typeof(df_lake$mixing_type)  == "character", 
         yes = out[11] <- "okay",
         no = out[11] <- "check mixing_type")
  ifelse(typeof(df_lake$waterbody_area_ha)  == "integer" | typeof(df_lake$waterbody_area_ha)  == "double", 
         yes = out[12] <- "okay",
         no = out[12] <- "check waterbody_area_ha")
  ifelse(typeof(df_lake$watershed_area_ha)  == "integer" | typeof(df_lake$watershed_area_ha)  == "double", 
         yes = out[13] <- "okay",
         no = out[13] <- "check watershed_area_ha")
  ifelse(typeof(df_lake$elevation_m)  == "integer" | typeof(df_lake$elevation_m)  == "double", 
         yes = out[14] <- "okay",
         no = out[14] <- "check elevation_m")
  ifelse(typeof(df_lake$trophic_state)  == "character", 
         yes = out[15] <- "okay",
         no = out[15] <- "check trophic_state")
  ifelse(typeof(df_lake$dom_land_use)  == "character", 
         yes = out[16] <- "okay",
         no = out[16] <- "check dom_land_use")
  ifelse(typeof(df_lake$human_impacts)  == "character", 
         yes = out[17] <- "okay",
         no = out[17] <- "check human_impacts")
  ifelse(typeof(df_lake$human_impacts_other)  == "character", 
         yes = out[18] <- "okay",
         no = out[18] <- "check human_impacts_other")
  ifelse(typeof(df_lake$num_basins)  == "integer" | typeof(df_lake$num_basins)  == "double", 
         yes = out[19] <- "okay",
         no = out[19] <- "check num_basins")
  ifelse(typeof(df_lake$dom_planktivore)  == "character", 
         yes = out[20] <- "okay",
         no = out[20] <- "check dom_planktivore")
  ifelse(typeof(df_lake$dom_piscivore)  == "character", 
         yes = out[21] <- "okay",
         no = out[21] <- "check dom_piscivore")
  ifelse(typeof(df_lake$invasive_species_list)  == "character", 
         yes = out[22] <- "okay",
         no = out[22] <- "check invasive_species_list")
  ifelse(typeof(df_lake$data_provider)  == "character", 
         yes = out[23] <- "okay",
         no = out[23] <- "check data_provider")
  ifelse(typeof(df_lake$contact)  == "character", 
         yes = out[24] <- "okay",
         no = out[24] <- "check contact")
  ifelse(typeof(df_lake$email)  == "character", 
         yes = out[25] <- "okay",
         no = out[25] <- "check email")
  ifelse(typeof(df_lake$website)  == "character", 
         yes = out[26] <- "okay",
         no = out[26] <- "check website")
  ifelse(typeof(df_lake$lake_comments)  == "character", 
         yes = out[27] <- "okay",
         no = out[27] <- "check lake_comments")
  
  return(out) #output the vector 
}

# stationid worksheet
check_sid <- function(df_sid) {
  out = numeric(12)
  
  ifelse(length(df_sid) == 11, 
         yes = out[1] <- "okay",
         no = out[1] <- "check number of variables")
  ifelse(typeof(df_sid$waterbody_name)  == "character", 
         yes = out[2] <- "okay",
         no = out[2] <- "check waterbody_name")
  ifelse(typeof(df_sid$stationid)  == "character", 
         yes = out[3] <- "okay",
         no = out[3] <- "check stationid")
  ifelse(typeof(df_sid$stationid_lat_decdeg)== "double", 
         yes = out[4] <- "okay",
         no = out[4] <- "check stationid_lat_decdeg")
  ifelse(typeof(df_sid$stationid_lon_decdeg)== "double", 
         yes = out[5] <- "okay",
         no = out[5] <- "check stationid_lon_decdeg")
  ifelse(typeof(df_sid$stationid_depth_m)  == "integer" | typeof(df_sid$stationid_depth_m)  == "double", 
         yes = out[6] <- "okay",
         no = out[6] <- "check stationid_depth_m")
  ifelse(typeof(df_sid$stationid_year_start)   == "integer" | typeof(df_sid$stationid_year_start)  == "double", 
         yes = out[7] <- "okay",
         no = out[7] <- "check stationid_year_start")
  ifelse(typeof(df_sid$stationid_year_finish)   == "integer" | typeof(df_sid$stationid_year_finish)  == "double", 
         yes = out[8] <- "okay",
         no = out[8] <- "check stationid_year_finish")
  ifelse(typeof(df_sid$stationid_zone)  == "character", 
         yes = out[9] <- "okay",
         no = out[9] <- "check stationid_zone")
  ifelse(typeof(df_sid$sampling_frequency)  == "character", 
         yes = out[10] <- "okay",
         no = out[10] <- "check sampling_frequency")
  ifelse(typeof(df_sid$hypo_oxygen)  == "character", 
         yes = out[11] <- "okay",
         no = out[11] <- "check hypo_oxygen")
  ifelse(typeof(df_sid$sid_comments) == "character", 
         yes = out[12] <- "okay",
         no = out[12] <- "check sid_comments")

  return(out)
}


# water_parameter worksheet
check_water <- function(df_water) {
  out = numeric(30)
  
  ifelse(length(df_water) == 29, 
         yes = out[1] <- "okay",
         no = out[1] <- "check number of variables")
  ifelse(typeof(df_water$waterbody_name)  == "character", 
         yes = out[2] <- "okay",
         no = out[2] <- "check waterbody_name")
  ifelse(typeof(df_water$stationid)  == "character", 
         yes = out[3] <- "okay",
         no = out[3] <- "check stationid")
  ifelse(typeof(df_water$year_yyyy) == "integer" | typeof(df_water$year_yyyy)  == "double", 
         yes = out[4] <- "okay",
         no = out[4] <- "check year_yyyy")
  ifelse(typeof(df_water$month_mm) == "integer" | typeof(df_water$month_mm)  == "double", 
         yes = out[5] <- "okay",
         no = out[5] <- "check month_mm")
  ifelse(typeof(df_water$day_of_month_dd) == "integer" | typeof(df_water$day_of_month_dd)  == "double", 
         yes = out[6] <- "okay",
         no = out[6] <- "check month_mm")
  ifelse(typeof(df_water$time_hhmm) == "integer" | typeof(df_water$time_hhmm)  == "double", 
         yes = out[7] <- "okay",
         no = out[7] <- "check time_hhmm")
  ifelse(typeof(df_water$time_of_day)   == "character", 
         yes = out[8] <- "okay",
         no = out[8] <- "check time_of_day")
  ifelse(typeof(df_water$surface_ph) == "integer" | typeof(df_water$surface_ph)  == "double", 
         yes = out[9] <- "okay",
         no = out[9] <- "check surface_ph")
  ifelse(typeof(df_water$surface_chla_ug_l) == "integer" | typeof(df_water$surface_chla_ug_l)  == "double", 
         yes = out[10] <- "okay",
         no = out[10] <- "check surface_chla_ug_l")
  ifelse(typeof(df_water$surface_tp_ug_l) == "integer" | typeof(df_water$surface_tp_ug_l)  == "double", 
         yes = out[11] <- "okay",
         no = out[11] <- "check surface_tp_ug_l")
  ifelse(typeof(df_water$secchi_depth_m) == "integer" | typeof(df_water$secchi_depth_m)  == "double", 
         yes = out[12] <- "okay",
         no = out[12] <- "check secchi_depth_m")
  ifelse(typeof(df_water$surface_temp_c) == "integer" | typeof(df_water$surface_temp_c)  == "double", 
         yes = out[13] <- "okay",
         no = out[13] <- "check surface_temp_c")
  ifelse(typeof(df_water$hypo_temp_c) == "integer" | typeof(df_water$hypo_temp_c)  == "double", 
         yes = out[14] <- "okay",
         no = out[14] <- "check hypo_temp_c")
  ifelse(typeof(df_water$thermocline_depth) == "integer" | typeof(df_water$thermocline_depth)  == "double", 
         yes = out[15] <- "okay",
         no = out[15] <- "check thermocline_depth")
  ifelse(typeof(df_water$NO2NO3_mgL) == "integer" | typeof(df_water$NO2NO3_mgL)  == "double", 
         yes = out[16] <- "okay",
         no = out[16] <- "check NO2NO3_mgL")
  ifelse(typeof(df_water$silica_mgL) == "integer" | typeof(df_water$silica_mgL)  == "double", 
         yes = out[17] <- "okay",
         no = out[17] <- "check silica_mgL")
  ifelse(typeof(df_water$dissolved_P_ugL) == "integer" | typeof(df_water$dissolved_P_ugL)  == "double", 
         yes = out[18] <- "okay",
         no = out[18] <- "check dissolved_P_ugL")
  ifelse(typeof(df_water$TKN_mgL) == "integer" | typeof(df_water$TKN_mgL)  == "double", 
         yes = out[19] <- "okay",
         no = out[19] <- "check TKN_mgL")
  ifelse(typeof(df_water$do_epi_mgL) == "integer" | typeof(df_water$do_epi_mgL)  == "double", 
         yes = out[20] <- "okay",
         no = out[20] <- "check do_epi_mgL")
  ifelse(typeof(df_water$do_hypo_mgL) == "integer" | typeof(df_water$do_hypo_mgL)  == "double", 
         yes = out[21] <- "okay",
         no = out[21] <- "check do_hypo_mgL")
  ifelse(typeof(df_water$conductivity_umho_cm) == "integer" | typeof(df_water$conductivity_umho_cm)  == "double", 
         yes = out[22] <- "okay",
         no = out[22] <- "check conductivity_umho_cm")
  ifelse(typeof(df_water$DOC_um) == "integer" | typeof(df_water$DOC_um)  == "double", 
         yes = out[23] <- "okay",
         no = out[23] <- "check DOC_um")
  ifelse(typeof(df_water$DIC_um) == "integer" | typeof(df_water$DIC_um)  == "double", 
         yes = out[24] <- "okay",
         no = out[24] <- "check DIC_um")
  ifelse(typeof(df_water$chloride_mgL) == "integer" | typeof(df_water$chloride_mgL)  == "double", 
         yes = out[25] <- "okay",
         no = out[25] <- "check chloride_mgL")
  ifelse(typeof(df_water$alkalinity_mgL) == "integer" | typeof(df_water$alkalinity_mgL)  == "double", 
         yes = out[26] <- "okay",
         no = out[26] <- "check alkalinity_mgL")
  ifelse(typeof(df_water$hardness_mgL) == "integer" | typeof(df_water$hardness_mgL)  == "double",
         yes = out[27] <- "okay",
         no = out[27] <- "check hardness_mgL")
  ifelse(typeof(df_water$turbidity_NTU) == "integer" | typeof(df_water$turbidity_NTU)  == "double",
         yes = out[28] <- "okay",
         no = out[28] <- "check turbidity_NTU")
  ifelse(typeof(df_water$TN_mgL) == "integer" | typeof(df_water$TN_mgL) == "double",
         yes = out[29] <- "okay",
         no = out[29] <- "check TN_mgL")
  ifelse(typeof(df_water$surf_or_int)  == "character",
         yes = out[30] <- "okay",
         no = out[30] <- "check surf_or_int")
  
  return(out)
}

#taxa_list worksheet
check_taxa <- function(df_taxa) {
  out = numeric(7)
  
  ifelse(length(df_taxa) == 6, 
         yes = out[1] <- "okay",
         no = out[1] <- "check number of variables")
  ifelse(typeof(df_taxa$taxa_name) == "character", 
         yes = out[2] <- "okay",
         no = out[2] <- "check taxa_name")
  ifelse(typeof(df_taxa$ZIG_grouping)  == "character", 
         yes = out[3] <- "okay",
         no = out[3] <- "check ZIG_grouping")
  ifelse(typeof(df_taxa$other_grouping)  == "character", 
         yes = out[4] <- "okay",
         no = out[4] <- "check other_grouping")
  ifelse(typeof(df_taxa$genus)  == "character", 
         yes = out[5] <- "okay",
         no = out[5] <- "check genus")
  ifelse(typeof(df_taxa$species)  == "character", 
         yes = out[6] <- "okay",
         no = out[6] <- "check species")
  ifelse(typeof(df_taxa$invasive)  == "character", 
         yes = out[7] <- "okay",
         no = out[7] <- "check invasive")
  
  return(out)
}


# zooplankton worksheet
check_zoop <- function(df_zoop) {
  out = numeric(20)
  
  ifelse(length(df_zoop) == 19, 
         yes = out[1] <- "okay",
         no = out[1] <- "check number of variables")
  ifelse(typeof(df_zoop$waterbody_name) == "character", 
         yes = out[2] <- "okay",
         no = out[2] <- "check waterbody_name")
  ifelse(typeof(df_zoop$stationid) == "character", 
         yes = out[3] <- "okay",
         no = out[3] <- "check stationid")
  ifelse(typeof(df_zoop$year_yyyy)== "integer" | typeof(df_zoop$year_yyyy)  == "double", 
         yes = out[4] <- "okay",
         no = out[4] <- "check year_yyyy")
  ifelse(typeof(df_zoop$month_mm)== "integer" | typeof(df_zoop$month_mm)  == "double", 
         yes = out[5] <- "okay",
         no = out[5] <- "check month_mm")
  ifelse(typeof(df_zoop$day_of_month_dd)== "integer" | typeof(df_zoop$day_of_month_dd)  == "double", 
         yes = out[6] <- "okay",
         no = out[6] <- "check day_of_month_dd")
  ifelse(typeof(df_zoop$time_hhmm)== "integer" | typeof(df_zoop$time_hhmm)  == "double", 
         yes = out[7] <- "okay",
         no = out[7] <- "check time_hhmm")
  ifelse(typeof(df_zoop$time_of_day)== "character", 
         yes = out[8] <- "okay",
         no = out[8] <- "check time_hhmm")
  ifelse(typeof(df_zoop$taxa_name) == "character", 
         yes = out[9] <- "okay",
         no = out[9] <- "check taxa_name")
  ifelse(typeof(df_zoop$sample_depth_m)== "integer" | typeof(df_zoop$sample_depth_m)  == "double", 
         yes = out[10] <- "okay",
         no = out[10] <- "check sample_depth_m")
  ifelse(typeof(df_zoop$zoop_sampler_type) == "character", 
         yes = out[11] <- "okay",
         no = out[11] <- "check zoop_sampler_type")
  ifelse(typeof(df_zoop$zoop_mesh_um)== "integer" | typeof(df_zoop$zoop_mesh_um)  == "double", 
         yes = out[12] <- "okay",
         no = out[12] <- "check zoop_mesh_um")
  ifelse(typeof(df_zoop$zoop_net_mouth_area_cm2)== "integer" | typeof(df_zoop$zoop_net_mouth_area_cm2)== "double", 
         yes = out[13] <- "okay",
         no = out[13] <- "check zoop_net_mouth_area_cm2")
  ifelse(typeof(df_zoop$min_counts)== "integer" | typeof(df_zoop$min_counts)  == "double", 
         yes = out[14] <- "okay",
         no = out[14] <- "check min_counts")
  ifelse(typeof(df_zoop$density_value)== "integer" | typeof(df_zoop$density_value)  == "double", 
         yes = out[15] <- "okay",
         no = out[15] <- "check density_value")
  ifelse(typeof(df_zoop$density_units) == "character", 
         yes = out[16] <- "okay",
         no = out[16] <- "check density_units")
  ifelse(typeof(df_zoop$biomass_value)== "integer" |typeof(df_zoop$biomass_value)  == "double", 
         yes = out[17] <- "okay",
         no = out[17] <- "check biomass_value")
  ifelse(typeof(df_zoop$biomass_dry_wet)=="character", 
         yes = out[18] <- "okay",
         no = out[18] <- "check biomass_dry_wet")
  ifelse(typeof(df_zoop$biomass_units) == "character", 
         yes = out[19] <- "okay",
         no = out[19] <- "check biomass_units")
  ifelse(typeof(df_zoop$time_zone)== "integer" | typeof(df_zoop$time_zone)  == "double", 
         yes = out[20] <- "okay",
         no = out[20] <- "check time_zone")
  
  return(out)
}

# zoop_length worksheet

check_zlen <- function(df_zlen) {
  out = numeric(13)
  
  ifelse(length(df_zlen) == 12, 
         yes = out[1] <- "okay",
         no = out[1] <- "check number of variables")
  ifelse(typeof(df_zlen$waterbody_name) == "character", 
         yes = out[2] <- "okay",
         no = out[2] <- "check waterbody_name")
  ifelse(typeof(df_zlen$stationid) == "character", 
         yes = out[3] <- "okay",
         no = out[3] <- "check stationid")
  ifelse(typeof(df_zlen$year_yyyy)== "integer" |typeof(df_zlen$year_yyyy)  == "double", 
         yes = out[4] <- "okay",
         no = out[4] <- "check year_yyyy")
  ifelse(typeof(df_zlen$month_mm)== "integer" |typeof(df_zlen$month_mm)  == "double", 
         yes = out[5] <- "okay",
         no = out[5] <- "check month_mm")
  ifelse(typeof(df_zlen$day_of_month_dd)== "integer" |typeof(df_zlen$day_of_month_dd)  == "double", 
         yes = out[6] <- "okay",
         no = out[6] <- "check day_of_month_dd")
  ifelse(typeof(df_zlen$time_hhmm) == "character", 
         yes = out[7] <- "okay",
         no = out[7] <- "check time_hhmm")
  ifelse(typeof(df_zlen$time_of_day) == "character", 
         yes = out[8] <- "okay",
         no = out[8] <- "check time_of_day")
  ifelse(typeof(df_zlen$taxa_name) == "character", 
         yes = out[9] <- "okay",
         no = out[9] <- "check taxa_name")
  ifelse(typeof(df_zlen$zoop_sampler_type) == "character", 
         yes = out[10] <- "okay",
         no = out[10] <- "check zoop_sampler_type")
  ifelse(typeof(df_zlen$`length_ type`) == "character", 
         yes = out[11] <- "okay",
         no = out[11] <- "check length_ type")
  ifelse(typeof(df_zlen$length_raw_ID)== "integer" |typeof(df_zlen$length_raw_ID)  == "double", 
         yes = out[12] <- "okay",
         no = out[12] <- "check length_raw_ID")
  ifelse(typeof(df_zlen$length_mm)== "integer" |typeof(df_zlen$length_mm)  == "double", 
         yes = out[13] <- "okay",
         no = out[13] <- "check length_mm")

  return(out)
}

# lake_timeline worksheet

check_time <- function(df_time) {
  out = numeric(4)
  ifelse(length(df_time) == 3, 
         yes = out[1] <- "okay",
         no = out[1] <- "check number of variables")
  ifelse(typeof(df_time$waterbody_name) == "character", 
         yes = out[2] <- "okay",
         no = out[2] <- "check waterbody_name")
  ifelse(typeof(df_time$timeline_year)== "integer" |typeof(df_time$timeline_year)  == "double", 
         yes = out[3] <- "okay",
         no = out[3] <- "check timeline_year")
  ifelse(typeof(df_time$events) == "character", 
         yes = out[4] <- "okay",
         no = out[4] <- "check events")

  return(out)
}


# equipment worksheet
check_equip <- function(df_equip) {
  out = numeric(18)
  
  ifelse(length(df_equip) == 17, 
         yes = out[1] <- "okay",
         no = out[1] <- "check number of variables")
  ifelse(typeof(df_equip$temp_sensor_model) == "character", 
         yes = out[2] <- "okay",
         no = out[2] <- "check temp_sensor_model")
  ifelse(typeof(df_equip$chla_method) == "character", 
         yes = out[3] <- "okay",
         no = out[3] <- "check chla_method")
  ifelse(typeof(df_equip$chla_sensor_model) == "character", 
         yes = out[4] <- "okay",
         no = out[4] <- "check chla_sensor_model")
  ifelse(typeof(df_equip$ph_sensor_model) == "character", 
         yes = out[5] <- "okay",
         no = out[5] <- "check ph_sensor_model")
  ifelse(typeof(df_equip$cond_sensor_model) == "character", 
         yes = out[6] <- "okay",
         no = out[6] <- "check cond_sensor_model")
  ifelse(typeof(df_equip$TP_method) == "character", 
         yes = out[7] <- "okay",
         no = out[7] <- "check TP_method")
  ifelse(typeof(df_equip$dissolved_P_method) == "character", 
         yes = out[8] <- "okay",
         no = out[8] <- "check dissolved_P_method")
  ifelse(typeof(df_equip$NO2NO3_method) == "character", 
         yes = out[9] <- "okay",
         no = out[9] <- "check NO2NO3_method")
  ifelse(typeof(df_equip$TKN_method) == "character", 
         yes = out[10] <- "okay",
         no = out[10] <- "check TKN_method")
  ifelse(typeof(df_equip$DOC_method) == "character", 
         yes = out[11] <- "okay",
         no = out[11] <- "check DOC_method")
  ifelse(typeof(df_equip$DIC_method) == "character", 
         yes = out[12] <- "okay",
         no = out[12] <- "check DIC_method")
  ifelse(typeof(df_equip$silica_method) == "character", 
         yes = out[13] <- "okay",
         no = out[13] <- "check silica_method")
  ifelse(typeof(df_equip$chloride_method) == "character", 
         yes = out[14] <- "okay",
         no = out[14] <- "check chloride_method")
  ifelse(typeof(df_equip$alkalinity_method) == "character", 
         yes = out[15] <- "okay",
         no = out[15] <- "check alkalinity_method")
  ifelse(typeof(df_equip$hardness_method) == "character", 
         yes = out[16] <- "okay",
         no = out[16] <- "check hardness_method")
  ifelse(typeof(df_equip$turbidity_sensor) == "character", 
         yes = out[17] <- "okay",
         no = out[17] <- "check turbidity_sensor")
  ifelse(typeof(df_equip$TN_method) == "character", 
         yes = out[18] <- "okay",
         no = out[18] <- "check TN_method")

  return(out)
}

# additional_data worksheet
check_add <- function(df_add) {
  out = numeric(10)
  
  ifelse(length(df_add) == 9, 
         yes = out[1] <- "okay",
         no = out[1] <- "check number of variables")
  ifelse(typeof(df_add$fish_density_biomass) == "character", 
         yes = out[2] <- "okay",
         no = out[2] <- "check fish_density_biomass")
  ifelse(typeof(df_add$veligers) == "character", 
         yes = out[3] <- "okay",
         no = out[3] <- "check veligers")
  ifelse(typeof(df_add$mussel_counts_biomass) == "character", 
         yes = out[4] <- "okay",
         no = out[4] <- "check mussel_counts_biomass")
  ifelse(typeof(df_add$ciliates) == "character", 
         yes = out[5] <- "okay",
         no = out[5] <- "check ciliates")
  ifelse(typeof(df_add$`phytoplankton_biomass `) == "character", 
         yes = out[6] <- "okay",
         no = out[6] <- "check phytoplankton_biomass")
  ifelse(typeof(df_add$bacteria_biomass) == "character", 
         yes = out[7] <- "okay",
         no = out[7] <- "check bacteria_biomass")
  ifelse(typeof(df_add$stratified_zoop) == "character", 
         yes = out[8] <- "okay",
         no = out[8] <- "check stratified_zoop")
  ifelse(typeof(df_add$detailed_zoop_length) == "character", 
         yes = out[9] <- "okay",
         no = out[9] <- "check detailed_zoop_length")
  ifelse(typeof(df_add$meteorological) == "character", 
         yes = out[10] <- "okay",
         no = out[10] <- "check meteorological")
  
  return(out)
}

