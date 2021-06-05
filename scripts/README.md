# Scripts

This folder contains all of the scripts that will be used to convert the individual submitted data to one dataset that is ready for analysis.

<br>

## Table of contents
* [Naming conventions](#naming-conventions)
* [Data cleaning](#data-cleaning)
* [QC checks](#qc-checks)
* [Creating notes](#creating-notes)
* [Example script](#example-script)


## Naming conventions

Script names:

* "00" indicates a script that is used for data cleaning and high level QC checks. Each dataset should have one script associated with it that is used for data cleaning. 
  + Naming convention: "00_datateamlastname_lakename_cleaning.R" all lowercase and the lake name should match the format of the lake name in the title of the original dataset name. 
  
* "01" indicates the script that brings all of the cleaned data together into one dataset

Cleaned data:

* Cleaned data should be written to the [derived folder](https://github.com/sfigary/GLEON_ZIG/tree/main/data/derived) as a .csv with one csv for each worksheet from each dataset. 
  + Naming convention: FILL IN

QC Figures:

* QC figures should be written the [figures folder](https://github.com/sfigary/GLEON_ZIG/tree/main/figures) ...
  + Naming convention: FILL IN

<br>

## Data cleaning

Import data and check variable units:
* Use readxl to read the data in from the [inputs folder](https://github.com/sfigary/GLEON_ZIG/tree/main/data/inputs)
* Use the [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables are in the expected units and that all read in.  Variable count/worksheet:
  + lake: 26
  + stationid: 11
  + water_parameters 29
  + taxa_list: 6 
  + zooplankton: 19
  + zoop_length: 12
  + lake_timeline: 3
  + equipment: 17
  + additional_data: 9
* Check for additional variables that were not included in the data submission template.
* Check any variable unit mismatches and correct where needed. Look at the raw data before correcting the mismatches! The mismatches may be from unit changes or other information that is needed.
* Column time_hhmm in water_parameters and zooplankton will read in as characters. This needs to be converted to HH:MM. `parse_time(format(time_hhmm, "%H:%M"))` works well for this.
 
<br>

Coordinate checks:
* Lake worksheet: 
  + Convert the latitude and longitude to decimal degrees, if needed
  + Confirm the coordinates match to a water body using satellite imagery
* Stationid worksheet:
  + Convert the latitude and longitude to decimal degrees, if needed
  + Confirm the coordinates match to a water body using satellite imagery
* Note any errors that need to be followed up on

<br>

Check for completeness:
* waterbody_name is defined in the lake worksheet and also in stationid, water_parameters, zooplankton, zoop_length, and lake_timeline
* stationid is defined in the stationid worksheet and is also used in water_paramters, zooplankton, and zoop_length
* sampling event information (c("stationid", "year_yyyy", "month_mm", day_of_month_dd", "time_hhmm", "time_of_day")) is found in the water_parameter, zooplankton, and zoop_length worksheets
* taxa_name is defined in the taxa_list worksheet and also used in zooplankton and zoop_length
* zoop_sampler_type is defined in the zooplankton worksheet and also used in zoop_length.


<br> 

Read data provider notes in the lake and stationid worksheets. Do something with them

<br> 

Check units
* The zooplankton worksheet allowed different units for density and biomass that need to be converted to:
  + Density **FILL IN**
  + Biomass **FILL IN**

<br>

Add columns:
* In the zooplankton worksheet use sample_depth_m to create two new columns "top_tow_m" and "bottom_tow_m". Assume top of tow is 0 unless stated otherwise. Remove the sample_depth_m column.
* *surf_or_int- need to do something with this*
* add column that notes if the data could be useful for ZooSize or ZooST?*
* Add a column to zoop or water parameters to say if the sampling event has data from both? nessesary or not?
* add column for full citations?

<br>

Other things to watch for:
* water_parameters: Anything noted with "<" is assumed to be below detection and should be changed to half of the value. As in, if <1 is listed for a value, this should be changed to 0.5 instead.
* if a sheet is all NAs...
*



<br>

## QC checks

* Checking distributions of values using histograms 
* 1:1 plots for interannual variation

ADD

<br>

## Creating notes

ADD

need to note if anyone reached out to data providers for more info and have everyon cc us if they do

<br>

## Example script

See 00_MeyerFigary_examplelake_cleaning.R for an example script of data cleaning and QC checks.
