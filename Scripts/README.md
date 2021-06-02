# Scripts

This folder contains all of the scripts that will be used to convert the individual submitted data to one dataset that is ready for analysis.

<br>

## Naming conventions
Data cleaning scripts should be named using the following convention:  `00_lastname_data_cleaning.R` where '00' indicates that the script is for the data cleaning process.

*discussion points*
*one file/person or one/lake?*
*include high level qc in the data cleaning scripts?*

<br>


## Suggestions for data cleaning

Open the dataset in excel:
* Search for anything that could cause import issues
* Use readxl to import the data

<br>


**Worksheet: lake**
* Use the [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables are in the expected units. Check every mismatch and correct where needed. 
* Lake location:
  + Convert the latitude and longitude to decimal degrees, if needed
  + Confirm the corrdinates match to a water body using statlite imagry
  + Confirm R understands the corredinates using the "maps" package *include or no?*
* Look at data provider notes

<br>


**Worksheet: stationid**
* Use the [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables are in the expected units. Check every mismatch and correct where needed. 
* check that the waterbody_name matches the waterbody_name in the `lake` worksheet
* Site locations:
  + Convert the latitude and longitude to decimal degrees, if needed
  + Confirm the corrdinates match to a water body using statlite imagry
  + Confirm R understands the corredinates using the "maps" package *include or no?*
* read the `sid_comments`

<br>


**Worksheet: water_parameters**
* Use the [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables are in the expected units. Check every mismatch and correct where needed. 
* check that the waterbody_name matches the waterbody_name in the `lake` worksheet
* check that the stationids match the stationids in the `stationid` worksheet
* surf_or_int

**Worksheet: taxa_list**

<br>


**Worksheet: zooplankton**
* Use the [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables are in the expected units. Check every mismatch and correct where needed. 
* check that the waterbody_name matches the waterbody_name in the `lake` worksheet
* check that the stationids match the stationids in the `stationid` worksheet
* check that the taxa_name matches the taxa_name in the `taxa_list` worksheet
* all data needs to be converted to uniform units
  + Density **FILL IN**
  + Biomass **FILL IN**

<br>


**Worksheet: zoop_length**
* Use the [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables are in the expected units. Check every mismatch and correct where needed. 
* check that the waterbody_name matches the waterbody_name in the `lake` worksheet
* check that the stationids match the stationids in the `stationid` worksheet

<br>


**Worksheet: lake_timeline**
* check that the waterbody_name matches the waterbody_name in the `lake` worksheet

<br>

**Worksheet: equiptment**

<br>

**Worksheet: additional data**

<br>

## Suggestions for qc checks

Checking distributions of values; 1:1 plots for interannual variation
Checking for completeness (e.g. sites listed in `water_parameters` are also in `stationid`)

<br>

## Suggestions for creating metadata
Noting if the dataset also works for ZooST or ZooSize

<br>

## Example script
See `00_example_data_cleaning.R` for an example of data cleaning and high level QC checks.