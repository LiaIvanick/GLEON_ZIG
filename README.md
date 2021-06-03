# ZIG GLEON

Welcome to the ZIG GLEON Data Harmonization Team git repo! The goal of the data team is to: 

* Create a raw analysis-ready data product from submitted datasets
* Provide scripted workflows for each step of data cleaning
* Perform high level QC of submitted data

This README includes the data sharing policy, git repo structure, proposed workflow, suggested packages, and more. Please see the README in the Scripts folder more information on cleaning and performing QC check on an individual dataset and an example script.

Please use github issues or feel free to reach out to Michael Meyer (michael.f.meyer@wsu.edu), Steph Figary (sef92@cornell.edu) or Warren Currie (warren.currie@dfo-mpo.gc.ca) if you have any questions.  

<br>

## Table of contents
* [Data policy](#data-policy)
* [Repo structure](#repo-structure)
* [Proposed workflowp](#proposed-workflow)
* [Suggested packages and versions](#suggested-packages-and-versions)
* [Examples and additional information](#examples-and-additional-information)
* [Github resources](#github-resources)
* [Thank you!](#thank-you!)

## Data policy

ZIG's data sharing policy is that data will not be shared without permission from the data provider. Please do not share any data that you are given access to as a member of the Data Harmonization Team. Please see our [Authorship Guidelines and Data Policy](https://docs.google.com/document/d/1v-Wg50qSCBuFWXFg-B3PdfiEKz__8iJr3IeyCUpfKgU/edit?usp=sharing) for more details.

<br>

## Repo structure

This repo is organized with three main folders and several subfolder. Each main folder includes a README with more details on stucture of the subfolders and file naming conventions. 

Note: If you clone this repo to your computer you will have access to all of the files in the repo. Please **only** edit your own script and **do not** change the folder structure of this repo.

<br>

### Folder: Data

The data folder has several subfolders:

* Inputs: **Do not edit!** This folder includes the original data files from the data providers. Michael or Steph will assign datasets to each member of the Date Team that can be found in this folder.
  
* Derived: Each member of the team will have a subfolder in this folder that their R scripts should write cleaned .csv's to. Please see the README in this folder for file naming conventions suggestions.

<br>

### Folder: Scripts

This folder includes all of the scripts that are used to clean each dataset and create one final dataset for analysis (later step). The README in this folder describes the steps for data cleaning, qc checks, and file naming conventions. **Please only edit your own script in this folder to prevent merge conflicts.**

<br>

### Folder: Figures

This folder will include all of the figures used in the qc checks, including histograms, scatterplots, and others. Data cleaning scripts should write figures to this folder. See the README in this Scripts folder for suggested qa/qc methods and (also in the Figures README).

<br>

## Proposed workflow 

Michael and Steph will use Github issues to assign datasets to team members. The datasets will be located in the "Data/inputs" [folder](Data/inputs). To ensure each datset is looked over with a new pair of eyes, no one will work on their own dataset. Scripts for data cleaning and qc checks will be kept in the scripts folder and will write output to the "Data/derived" (.csv) and "Figures" (qc checks) folders. 

We will use Github Issues for project management, troubleshooting, team communications, and tracking progress. There are many benefits to using Issues, including maintaining a record of data cleaning decisions in a location that everyone in the Data Team can see and comment on. If you are interested in learning more about Github Issues, please see Chapter 10 in [GitHub for Project Management by Openscapes.](https://openscapes.github.io/series/github-issues.html)

<br>

## Example workflow

The Scripts [README](Scripts/README.md) in the "Scripts" folder includes a checklist of 

The README of the scripts folder is a good place to start as in provides more information on the work flow for each dataset. The script "TO FILL IN.R" provides an example workflow, with comments, for cleaning and quality checks for an example dataset. 

<br>

## Suggested packages and versions

`tidyverse` >= 1.3.0
`readxl` >= 1.3.0

<br>

## Github resources

We are using Github for this work because of its version control capabilities and the ability to communicate through issues. We know many members are new to Github and wanted to provide some resources for getting started. 

* [Git in R:](https://nt246.github.io/NTRES-6100-data-science/lesson2-rmarkdown-github.html) Lecture notes from Dr. Nina Overgaard Therkildsen's Collaborative and Reproducible Data Science in R course at Cornell University. Lessons 2-5 provide step-by-step instructions on how to get started using github with Rstudio. These links are shared with permission from Dr. Nina Overgaard Therkildsen.
* [GLEON GitHub workshop](https://www.youtube.com/watch?v=B-FHx4l1BNU)
* [Jenny Bryan’s Happy Git with R:](https://happygitwithr.com/big-picture.html) Chapter 1 is a great introduction to Git and the benefits of using it.
* [GitHub for Project Management by Openscapes:](https://openscapes.github.io/series/github-issues.html) Chapter 10 includes an overview of Git Issues.

*MM/SF discussion point: others to add?*

<br>

## Thank you!

Lastly, thank you all for all of your time and effort on ZIG! This team is such an important part of reaching the next step with ZIG.