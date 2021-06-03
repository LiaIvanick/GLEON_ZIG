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
  
* "01" indicates the script that is used to bring all of the cleaned data together into one dataset

Cleaned data:

* Cleaned data should be written the [derived folder](https://github.com/sfigary/GLEON_ZIG/tree/main/data/derived) as a .csv with one csv for each worksheet from each dataset. 
  + Naming convention: FILL IN

QC Figures:

* QC figures should be written the [figures folder](https://github.com/sfigary/GLEON_ZIG/tree/main/figures) ...
  + Naming convention: FILL IN


<br>


## Data cleaning

Open the dataset in excel:
* Search for anything that could cause import issues
* Use readxl to read the data in from the  [inputs folder](https://github.com/sfigary/GLEON_ZIG/tree/main/data/inputs)

<br>

**Worksheet: lake**
* Use the [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables (26) are in the expected units and that all read in. Check every mismatch and correct where needed. 
* Lake location:
  + Convert the latitude and longitude to decimal degrees, if needed
  + Confirm the coordinates match to a water body using satellite imagery
  + *Maybe? Confirm R understands the coordinates using the "maps" package*
* Look at data provider notes and...

<br>


**Worksheet: stationid**
* Use the [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables (11) are in the expected units and that all read in. Check every mismatch and correct where needed. 
* Check that the waterbody_name matches the waterbody_name in the lake worksheet
* Site locations:
  + Convert the latitude and longitude to decimal degrees, if needed
  + Confirm the coordinates match to a water body using satellite imagery
  + Confirm R understands the coordinates using the "maps" package *include or no?*
* Read the sid_comments and...

<br>


**Worksheet: water_parameters**
* Use the [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables (29) are in the expected units and that all read in. Check every mismatch and correct where needed. 
* Check that the waterbody_name matches the waterbody_name in the lake worksheet
* Check that the stationids match the stationids in the stationid worksheet
* *surf_or_int- need to do something with this*

<br>

**Worksheet: taxa_list**
* Use the [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables (6) are in the expected units and that all read in. Check every mismatch and correct where needed.

<br>


**Worksheet: zooplankton**
* Use the [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables (19) are in the expected units and that all read in. Check every mismatch and correct where needed. 
* Check that the waterbody_name matches the waterbody_name in the lake worksheet
* Check that the stationids match the stationids in the stationid worksheet
* Check that the taxa_name matches the taxa_name in the taxa_list worksheet
* All data needs to be converted to uniform units
  + Density **FILL IN**
  + Biomass **FILL IN**

<br>


**Worksheet: zoop_length**
* Use the [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables (12) are in the expected units and that all read in. Check every mismatch and correct where needed. 
* Check that the waterbody_name matches the waterbody_name in the lake worksheet
* Check that the stationids match the stationids in the stationid worksheet

<br>


**Worksheet: lake_timeline**
* Use the [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables (3) are in the expected units and that all read in. Check every mismatch and correct where needed.
* Check that the waterbody_name matches the waterbody_name in the lake worksheet

<br>

**Worksheet: equipment**

* Use the [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables (17) are in the expected units and that all read in. Check every mismatch and correct where needed.

<br>

**Worksheet: additional data**

* Use the [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables (8) are in the expected units and that all read in. Check every mismatch and correct where needed.

*add column that notes if the data could be useful for ZooSize or ZooST?*

<br>

## QC checks

* Checking distributions of values using histograms 
* 1:1 plots for interannual variation

ADD

<br>

## Creating notes

ADD

<br>

## Example script
See 00_MeyerFigary_examplelake_cleaning.R for an example script of data cleaning and QC checks.
