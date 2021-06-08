# To do:

* Determining naming conventions for:

  + script names
  + QC figures
  + cleaned data (.csv)
  + notes
  
* Determine if new columns should be added. Ideas:

  + top_tow_m (zooplankton worksheet)
  + bottom_tow_m (zooplankton worksheet)
  + column indicating if data could be useful for ZooST (additional_data). ZooSize has a column in additional data already
  + add a column in either (or both?) zooplankton or water_parameters indicating if the sampling event has both zooplankton and water quality data
  
* Not the case in the current dataset, but I think surf_or_int column could be problematic/contain a lot of information in other datasets. May be this should be treated like the stationid and lake notes.

* Need guidence on how to create notes for each dataset. I've never done this in R

* Need to pick zooplankton units:
  + Density **FILL IN** SF suggestion: “ind_L” Should we provide script for converting?
  + Biomass **FILL IN** SF suggestion: “µg_L” Again- provide script?

* question I *should* know the answer to: Is there any reason to correct the varaible types in sheets that are all NAs. Will it impact `read_csv()` later?



  
  


-------
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

Notes:

* ADD

<br>

## Data cleaning

The scripts that are written for data cleaning should include all of the information that's needed to take the submitted dataset and turn it into a dataset that is consistent with the rest of the datasets following the data submission guidelines. To ensure this, we ask that all changes to the dataset are accounted for in the R script and that **no changes are made by manually editing the dataset in Excel.**

### Import data
* Use readxl to read the data in from the [inputs folder](https://github.com/sfigary/GLEON_ZIG/tree/main/data/inputs)
<br> 

Read data provider notes in the lake and stationid worksheets (and surf_or_int in water_parameters). Do something with them? Include them in the output notes?

<br>

### Check variable types
* Use the [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables are in the expected units and that all read in. *Use `source(ZIG_data_team_functions.R)` to use the `check_*` functions for each worksheet. These functions check the number of variables and variable type for each worksheet in the excel file.
* Check for additional variables that were not included in the data submission template.
* Check any variable unit mismatch and correct where needed. Look at the raw data before correcting the mismatches! The mismatches may be from unit changes or other information that is needed. For instance, in the water_parameters worksheet a data provider may have used "< 1" to indicate a sampling event that was below the detection limit of 1. In this case, "< 1" should be replaced with half of the detection limit ("0.5").
* Column time_hhmm in **water_parameters** and **zooplankton** worksheets will read in as characters. These need to be converted to HH:MM. `parse_time(format(time_hhmm, "%H:%M"))` works well for this.

<br>

### Coordinate checks
* Lake worksheet: 
  + Convert the latitude and longitude to decimal degrees, if needed
  + Confirm the coordinates match to a water body using satellite imagery
* Stationid worksheet:
  + Convert the latitude and longitude to decimal degrees, if needed
  + Confirm the coordinates match to a water body using satellite imagery
* Note any errors that need to be followed up on

<br>

### Check for completeness
* waterbody_name is defined in the lake worksheet and is also found in stationid, water_parameters, zooplankton, zoop_length, and lake_timeline
* stationid is defined in the stationid worksheet and is also found in water_paramters, zooplankton, and zoop_length
* sampling event information (c("stationid", "year_yyyy", "month_mm", day_of_month_dd", "time_hhmm", "time_of_day")) is found in the water_parameter, zooplankton, and zoop_length worksheets
* taxa_name is defined in the taxa_list worksheet and is also found in zooplankton and zoop_length
* zoop_sampler_type is defined in the zooplankton worksheet  and is also found in zoop_length.
* Note any errors that need to be followed up on


<br> 

### Check units
* The zooplankton worksheet allowed different units for density and biomass that need to be converted to:
  + Density **FILL IN** SF suggestion: “ind_L” Should we provide script for converting?
  + Biomass **FILL IN** SF suggestion: “µg_L” Again- provide script?

<br>

### Methods check

Confirm that all of the parameters in water_parameters also include method data in the equiptment worksheet.

<br>

### Add columns
* In the zooplankton worksheet use sample_depth_m to create two new columns "top_tow_m" and "bottom_tow_m". Assume top of tow is 0 unless stated otherwise. Remove the sample_depth_m column.
* *surf_or_int- need to do something with this*
* add column that notes if the data could be useful for ZooSize or ZooST?*
* Add a column to zoop or water parameters to say if the sampling event has data from both? nessesary or not?
* add column for full citations?

<br>

### Other things to watch for
* water_parameters: Anything noted with "<" is assumed to be below detection and should be changed to half of the value. As in, if <1 is listed for a value, this should be changed to 0.5 instead.
* if a sheet is all NAs...
*

<br>

### Contacting data providers
Cleaning many, if not all, datasets will lead to questions for the data providers. If you contact a data provider (email's are in the lake worksheet), please cc the ZIG co-leads on the email. Additionally, please note in your script when changes are made at the direction of the data provider.

## QC checks

* Checking distributions of values using histograms 
* 1:1 plots for interannual variation
* Checking for zero values in water_parameters. Most water quality parameters should not allow zero values and instead should read as half of the detection limit. 

<br>

## Creating notes

ADD

<br>

## Example script and functions

See TO_FILL_IN.R  for an example script of data cleaning and QC checks. This is an example of the approaches we used to clean one dataset, but certainly does not represent the only way of approaching this work. There may be many things in this script that will not work on a different dataset, particularly if the dataset deviated from the data submission instructions. 
