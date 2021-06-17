# Scripts: DRAFT

This folder contains all of the scripts that will be used to convert the individual submitted data to one dataset that is ready for analysis.

<br>

## Table of contents
* [Naming conventions](#naming-conventions)
* [Data cleaning](#data-cleaning)
* [Contacting data providers](#contacting-data-providers)
* [QC checks](#qc-checks)
* [Creating notes](#creating-notes)
* [Example script](#example-script)

<br> 

## Naming conventions

<br> 

**Scripts:**

* "00" indicates a script that is used for data cleaning and high level QC checks. Each dataset should have one script associated with it. 
  + Naming convention: "00_dataproviderlastname_data_datateamlastnamefirstname.R" all lowercase. 
  
* Future: "01" indicates the script that brings all of the cleaned data together into one dataset.


**Cleaned data:**

* Cleaned data should be written to the [derived folder](https://github.com/sfigary/GLEON_ZIG/tree/main/data/derived_products) as a .csv with one csv for each worksheet from each dataset. 
  + Subfolder naming convention: dataproviderlastname_disaggregated
  + CSV naming convention: *_dataproviderlastname.csv


**QC Figures:**

* QC figures should be written the [figures folder](https://github.com/sfigary/GLEON_ZIG/tree/main/figures)
  + Subfolder naming convention: dataproviderlastname_qc
  + Figures naming convention: revisit


**Notes/readmes:**

* revisit

<br>

## Data cleaning

<br>

The data cleaning script should include all of steps that are needed to transform the submitted dataset into a format that can be aggrigated with other cleaned datasets. Please **do not** manually edit datasets in Excel! 

Here's an list of things to check/watch for while cleaning the data. This list is certainly incomplete at this stage.

<br>

* **Read the data provider notes** in lake/lake_comments, stationid/sid_comments, water_parameters/surf_or_int. These may include useful information for the data cleaning process. If you find comments in other areas of the data that need to be removed for varible consistency, please add (`paste()`) them to the lake/lake_comments with a note.

* **Check variable types/number** for each worksheet using [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables are in the expected units and that each worksheet includes the expected number of variables.

  + You can `source(scripts/ZIG_data_team_functions.R)` and the worksheet specific `check_*` functions to check the number of variables and variable type for each worksheet in the excel file. The functions output a vector that notes the variables that do not match the expected input type.

  + Check any variable unit mismatch and correct where needed. Look at the raw data before correcting the mismatches! The mismatches may be from unit changes or other information that is needed. For instance, in the water_parameters worksheet a data provider may have used "< 1" to indicate a sampling event that was below the detection limit of 1. In this case, "< 1" should be replaced with half of the detection limit (0.5).
  
  + Column time_hhmm in **water_parameters** and **zooplankton** worksheets will read in as characters. These need to be converted to HH:MM. `parse_time(format(time_hhmm, "%H:%M"))` works well for this.
  
  + All **"NA"** as character strings need to be converted to `NA` instead.
  
* **Check the coordinates** against satellite imagery, to confirm they are in a waterbody, and also confirm they are in decimal degrees. Coordinates are located on both the lake and stationid worksheets.

* **Check for completeness** using joins. This will confirm that entries are spelled the same on each sheet
  +  waterbody_name is defined in the lake worksheet and is also found in stationid, water_parameters, zooplankton, zoop_length, and lake_timeline
  + stationid is defined in the stationid worksheet and is also found in water_paramters, zooplankton, and zoop_length
  + sampling event information (c("stationid", "year_yyyy", "month_mm", day_of_month_dd", "time_hhmm", "time_of_day")) is found in the water_parameter, zooplankton, and zoop_length worksheets
  + taxa_name is defined in the taxa_list worksheet and is also found in zooplankton and zoop_length
  + zoop_sampler_type is defined in the zooplankton worksheet  and is also found in zoop_length.
  
  

* **Check zooplankton units**: Different units were allowed in the zooplankton worksheet for density and biomass. Confirm/convert the units to:
  + Density: ind_L
  + Biomass: µg_m^3 or mg_m^3
  + Also, check that the biomass units and values are logical for wet/dry biomass (column: biomass_dry_wet)

* **Check for zeros** in the water parameters sheet. In most cases there should not be zero values, and instead half of the detection limit should be listed instead.

* **Methods**: Confirm that all of the parameters in water_parameters also include method data in the equipment worksheet. Note: DO methods were not collected.

* **zooplankton$min_counts** was confusing in the data instructions and has received the most questions. This should be the minimum number of zooplankton that needed to be counted in order to stop subsampling, if subsampling was used. Check this value to see if it makes sense. Most protocals use a min_count of 100, 150, 200, or 400.

<br>

## Zooplankton: Replace tow column (yes?)

* In the zooplankton worksheet use sample_depth_m to create two new columns "top_tow_m" and "bottom_tow_m". Assume top of tow is 0 unless stated otherwise. Remove the sample_depth_m column.


<br>

## Contacting data providers

Cleaning many, if not all, datasets will lead to questions for the data providers. If you contact a data provider (email's are in the lake worksheet), please cc the ZIG co-leads on the email. Additionally, please note in your script when changes are made at the direction of the data provider.

<br>

## QC checks

* Checking distributions of values using histograms 
* 1:1 plots for interannual variation
* Checking for zero values in water_parameters. Most water quality parameters should not allow zero values and instead should read as half of the detection limit. 

<br>

## Creating notes

ADD

<br>

## Example script and functions

See 00a_obertegger_data_meyermichael.R for an example script of data cleaning and QC checks. This is an example of the approaches Michael used to clean one dataset, but certainly does not represent the only way of approaching this work. There may be many things in this script that will not work on a different dataset, particularly if the dataset deviated from the data submission instructions. 
