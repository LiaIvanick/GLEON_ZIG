# ZIG GLEON

Welcome to the ZIG GLEON Data Harmonization Team git repo! The goals of the data team are to:

* Create a raw analysis-ready data product from submitted datasets
* Provide scripted workflows for each step of data cleaning
* Perform high level QC of submitted data

This README includes the data sharing policy, git repo structure, proposed workflow, suggested packages, and more. Please see the scripts folder [README](scripts/README.md) for more information on cleaning and performing QC check on an individual dataset and an example script.

Please use Github [Issues](https://github.com/sfigary/GLEON_ZIG/issues) or feel free to reach out to Michael Meyer (michael.f.meyer@wsu.edu), Steph Figary (sef92@cornell.edu) or Warren Currie (warren.currie@dfo-mpo.gc.ca) if you have any questions.  

<br>

## Table of contents
* [Data policy](#data-policy)
* [Repo structure](#repo-structure)
* [Proposed workflow](#proposed-workflow)
* [Suggested packages, versions, and R practices](#suggested-packages-versions-and-R-practices)
* [Example workflow](#example-workflow)
* [Github resources](#github-resources)
* [Thank you!](#thank-you)

<br>

## Data policy

ZIG's data sharing policy is that data will not be shared without permission from the data provider. Please do not share any data that you are given access to as a member of the Data Harmonization Team. Please see our [Authorship Guidelines and Data Policy](https://docs.google.com/document/d/1v-Wg50qSCBuFWXFg-B3PdfiEKz__8iJr3IeyCUpfKgU/edit?usp=sharing) for more details.

<br>

## Repo structure

This repo is organized with three main folders and several subfolder. Each main folder includes a README with more details on structure of the subfolders and file naming conventions. 

Note: If you clone this repo to your computer you will have access to all of the files in the repo. Please **only** edit your own script and **do not** change the folder structure of this repo.

<br>

### Folder: [Data](https://github.com/sfigary/GLEON_ZIG/tree/main/data)

The data folder has several subfolders:

* Inputs: **Do not edit!** This folder includes the original data files from the data providers. Michael or Steph will assign datasets to each member of the Date Team that can be found in this folder.
  
* Derived: Each member of the team will have a subfolder in this folder that their R scripts should write cleaned .csv's to. Please see the scripts folder's [README](scripts/README.md) for file naming conventions.

<br>

### Folder: [Scripts](https://github.com/sfigary/GLEON_ZIG/tree/main/scripts)

This folder includes all of the scripts that are used to clean each dataset and create one final dataset for analysis (later step). The [README](scripts/README.md) in this folder describes the steps for data cleaning, qc checks, and file naming conventions. **Please only edit your own script in this folder to prevent merge conflicts.**

<br>

### Folder: [Figures](https://github.com/sfigary/GLEON_ZIG/tree/main/figures)

This folder will include all of the figures used in the qc checks, including histograms, scatterplots, and others. Data cleaning scripts should write figures to this folder. See the [README](scripts/README.md) in this scripts folder for suggested qa/qc methods and in the [README](figures/README.md) in the figures folder.

<br>

## Proposed workflow 

Michael and Steph will use Github [Issues](https://github.com/sfigary/GLEON_ZIG/issues) to assign datasets to team members. The datasets will be located in the [data/inputs](https://github.com/sfigary/GLEON_ZIG/tree/main/data/inputs). To ensure each dataset is looked over with a new pair of eyes, no one will work on their own dataset. Scripts for data cleaning and qc checks will be kept in the scripts folder and will write output to the [data/derived](https://github.com/sfigary/GLEON_ZIG/tree/main/data/derived) (.csv) and [figures](https://github.com/sfigary/GLEON_ZIG/tree/main/figures) (qc checks) folders. 

We will use Github [Issues](https://github.com/sfigary/GLEON_ZIG/issues) for project management, troubleshooting, team communications, and tracking progress. There are many benefits to using Issues, including maintaining a record of data cleaning decisions in a location that everyone in the Data Team can see and comment on. If you are interested in learning more about Github [Issues](https://github.com/sfigary/GLEON_ZIG/issues), please see Chapter 10 in [GitHub for Project Management by Openscapes.](https://openscapes.github.io/series/github-issues.html)

<br>

## Example workflow

The [README](scripts/README.md) in the scripts folder includes a checklist for data cleaning and qc checks. Additionally, the scripts folder includes a well-commented example R script (TO FILL IN) for cleaning a dataset. 

<br>

## Suggested packages, versions, and R practices

* `tidyverse` >= 1.3.0
* `readxl` >= 1.3.0
* Please set your RStudio -> Preferences -> General to never restore or save the workspace (.RData)

![](RData.png){width = 25%}

<br>

## Github resources

We are using Github for version control and communication/troubleshooting through Issues. If you're new to Github, here are some resources to get you started:

* [Git in R:](https://nt246.github.io/NTRES-6100-data-science/lesson2-rmarkdown-github.html) Lecture notes from Dr. Nina Overgaard Therkildsen's Collaborative and Reproducible Data Science in R course at Cornell University. Lessons 2-5 provide step-by-step instructions for setting up and pairing Github with Rstudio. These links are shared with permission from Dr. Nina Overgaard Therkildsen.
* [GLEON GitHub workshop](https://www.youtube.com/watch?v=B-FHx4l1BNU)
* [Jenny Bryan’s Happy Git with R:](https://happygitwithr.com/big-picture.html) Chapter 1 is a great introduction to Git and its benefits.
* [GitHub for Project Management by Openscapes:](https://openscapes.github.io/series/github-issues.html) Chapter 10 includes an overview of Git Issues.

<br>

## Thank you!

Thank you all for volunteering your time and effort to moving ZIG forward by joining this team!