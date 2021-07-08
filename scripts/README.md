Date Created: 2021 June 21 <br>
Date Updated: 2021 July 07

# To the Reader:

This documents is meant to serve as a generalized checklist for evaluating a submitted dataset as part of the "ZIG Data Harmonization Team". Please note that is only to serve as a template, and that you may need to expand beyond this template in the event the data value checking and cleaning steps are more intensive or demanding.

For each dataset we are looking for: 

1. Script for cleaning the dataset
	+ saved in scripts folder
	+ script naming convention: `00aa_<DataProviderLastName>_<LakeName>_<DataCleanerLastName>.R` More details on this below.

2. cleaned csv's
 	+ one .csv for each worksheet (nine total) 
 	+ .csv naming convention: `<LakeName>_<WorksheetName>.csv`
	+ write to data/derived_products/dataset folder
	+ dataset folder naming convention: `data/derived_products/<LakeName>_<DataTeamLastName>_disaggregated`

3. QC figures
	+ write to figures/dataset folder
	+ dataset folder naming convention: `figures/<LakeName>_<DataTeamLastName>_qc`
	
4. A well-documented `README` describing the data-cleaning process 
	+ saved in data/derived_products folder

This document provides more information on each of these requirements. 

As always, please feel free to reach out to Michael or Steph with any questions via email or Github Issues.

## Table of contents
* [Example scripts](#example-scripts)
* [Directory structures for scripts](#directory-structures-for-scripts)
* [General notes on scripts and assessing quality control](#general-notes-on-scripts-and-assessing-quality-control)
* [Data cleaning suggestions](#data-cleaning-suggestions)
* [Contacting data providers](#contacting-data-providers)
* [Creating READMEs](#creating-readmes)

## Example scripts

Both Michael and Steph wrote example scripts that you can use to get started. Michael's script provides great examples of creating qc figures, cleaning the data, and a README (`00a_oberteggger_data_meyermichael.R`). Steph's script is focused on cleaning the data (`00a_obertegger_data_figary.R`) and provides functions for checking the number of variables for each worksheet and if the read-in variables match the expected variable type (`functions_ZIG_data_team.R`). 

NOTE: These scripts are certainly incomplete and may deviate from what we have listed as suggestions, requirements, or naming conventions in this document. Please follow the guidelines in this document, not the scripts!

## Directory structures for scripts
- Be sure that you have modified the derived products output directory as well as the QC figures directory. This should be in the first section of the script.
  - The **data/derived_products** directory should be named `*_disaggregated`, meaning that the data are kept at the original spatial and temporal resolutions, but they have been checking for correct values. These are the data that will be used for the data product as well as the analytical datasets for successive projects. We would like one folder/dataset and all output should be written as .csv. 
  - The **figures/XXXX_qc** directory should be located within the figures directory and contain all figures produced from the associated harmonization script. 
- Be sure to build all scripts using a relative file path, where the "home" directory is the **scripts** folder. All data are read from the **data/inputs** directory and written to the **data/derived_products** directory. If you are new(er) to relative file paths, it means that there should never be a hardcoded directory within your script (this helps promote future reproducibility without need for machine/user specific file nomenclature). To check if your directories are set up correctly, you should use `getwd()` within your R console. If it is *NOT* set to ~/ZIG/scripts, then you can use the RStudio GUI by clicking `Set Working Directory > Source to File Location` and your directory *should* be properly set.



## General notes on scripts and assessing quality control
- **Very Important:** Please remember that we are operating under the "stay in your lane doctrine". This means that each member of the team will have their own piece that they are working on, and no one else should touch someone else's script. This will help prevent merge conflicts in the long run. To do this efficiently, everyone will need to make their own R script (1 R script per dataset). It should follow the nomenclature: `00aa_<DataProviderLastName>_<LakeName>_<DataCleanerLastName>.R` -- example `00a_currie_ontario_meyer.R`. The `00` refers to this script as being labeled a "cleaning script". The letters following `00` refer to the unique identifier this script has. These identifiers will be very important when we submit the full workflow, and they help our data harmonization routine retain a consistent structure.
- The companion R script (which you will adapt/create based on MFM and SEF's example scripts) is meant to largely capture high-level issues and signal where low-level issues may occur. A high level issue would be something like one year/month of data having abnormally high values (potentially indicative of lessened data quality). While there is nothing we can do about the data's quality assurance, this scripted routine assures that the original data integrity and quality are maintained throughout are aggregation procedure.
- In an ideal case, you would manually check plots and in the event of unexpected values pattern - you can manually investigate those data and document abnormalities. This process will also help expedite analysis down the road, as those performing the analysis may have questions about data integrity arise as they begin to work with the dataset.
- There may be instances where you are able to work more inefficiently by manually inspecting certain dates and timepoints within R. That is 100% okay, but that checking should be documented in your companion README document. MFM created a template for what this document could/should look like within the `derived_products/obertegger_disaggregated` directory. While you are welcome to change the format, each README document should contain the same information, at the very least.


## Data cleaning suggestions
* **Required- replace tow column:** In the zooplankton worksheet use `sample_depth_m` to create two new columns `top_tow_m` and `bottom_tow_m`. Assume top of tow is 0 unless stated otherwise. Remove the `sample_depth_m` column.


* **Check zooplankton units**: Different units were allowed in the `zooplankton` worksheet for abundance and biomass. Confirm or convert the units to:
  + Abundance: ind_L
  + Biomass: µg_m^3 or mg_m^3
  + Also, check that the biomass units and values are logical for wet or dry biomass (column: `biomass_dry_wet`)

* **Read the data provider notes** in `lake/lake_comments`, `stationid/sid_comments`, `water_parameters/surf_or_int`. These may include useful information for the data cleaning process. If you find comments in other areas of the data that need to be removed for variable consistency, please add (`paste()`) them to the lake/lake_comments.

* **Check variable types/number** for each worksheet using [ZIG data instructions](https://drive.google.com/file/d/1FhcNSKs0Xd4fJ2NH4V4TzQP1KB_zjhUV/view?usp=sharing) to see if all of the variables are in the expected units and that each worksheet includes the expected number of variables.

  + You can `source(scripts/ZIG_data_team_functions.R)` and the worksheet specific `check_*` functions to check the number of variables and variable type for each worksheet in the excel file. The functions output a vector that notes the variables that do not match the expected input type.

  + Check any variable unit mismatch and correct where needed. Look at the raw data before correcting the mismatches! The mismatches may be from unit changes or other information that is needed. For instance, in the water_parameters worksheet a data provider may have used "< 1" to indicate a sampling event that was below the detection limit of 1. In this case, "< 1" should be replaced with half of the detection limit (0.5).
  
  + Column `time_hhmm` in **water_parameters** and **zooplankton** worksheets will read in as characters. These need to be converted to HH:MM. `parse_time(format(time_hhmm, "%H:%M"))` works well for this.
  
  + All **"NA"** as character strings need to be converted to `NA` instead.
  
* **Check the coordinates** against satellite imagery, to confirm they are in a waterbody, and also confirm they are in decimal degrees. Coordinates are located on both the lake and stationid worksheets.

* **Check for completeness** using joins. This will confirm that entries are spelled the same on each sheet
  +  `waterbody_name` is defined in the `lake` worksheet and is also found in `stationid`, `water_parameters`, `zooplankton`, `zoop_length`, and `lake_timeline`
  + `stationid` is defined in the `stationid` worksheet and is also found in `water_paramters`, `zooplankton`, and `zoop_length`
  + sampling event information `(c("stationid", "year_yyyy", "month_mm", day_of_month_dd", "time_hhmm", "time_of_day"))` is found in the `water_parameter`, `zooplankton`, and `zoop_length` worksheets
  + `taxa_name` is defined in the `taxa_list` worksheet and is also found in `zooplankton` and `zoop_length`
  + `zoop_sampler_type` is defined in the `zooplankton` worksheet  and is also found in `zoop_length`.
  


* **Check for zeros** in the water parameters sheet. In most cases there should not be zero values, and instead half of the detection limit should be listed instead.

* **Methods**: Confirm that all of the parameters in `water_parameters` also include method data in the equipment worksheet. Note: DO methods were not collected.

* **zooplankton$min_counts** was confusing in the data instructions and has received the most questions. This should be the minimum number of zooplankton that needed to be counted in order to stop subsampling, if subsampling was used. Check this value to see if it makes sense. Most protocols use a `min_count` of 100, 150, 200, or 400.

* **read_excel()**: Because data were submitted as a .xlsx format, you will likely need to use the `read_excel()` function from the `readxl` package in R. All outputs should be in a CSV format though.


## Contacting data providers

Cleaning many, if not all, datasets will lead to questions for the data providers. If you contact a data provider (email's are in the lake worksheet), please cc the ZIG co-leads on the email and feel free to use this [template](https://docs.google.com/document/d/1BUZAzFWY_lv6jz-ZLHaANd9EcIX-Z4n25Q2K0vWmw9s/edit?usp=sharing). Additionally, please note in your script and `README` when changes are made at the direction of the data provider.


## Creating READMEs

Each cleaned dataset needs a `README` associated with it that explains the data cleaning process. An example of this can be found in `data/derived_products/obertegger_disaggregated`. At a minimum the `README` should include: 

* Your name and contact information
* List of input and outputs
* Directory tree
* Session info and R packages
* Notes from the data cleaning process





## 
