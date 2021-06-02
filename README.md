# ZIG GLEON

Welcome to the ZIG GLEON Data Harmonization Team git repo! The goal of the data team is to: 

* Create a raw analysis-ready data product from submitted datasets
* Provide scripted workflows for each step of data cleaning
* Perform high level QC of submitted data

This readme will walk through the data sharing policy, structure of this git repo, proposed workflow and structure of the repo, suggested packages, and more. Please see the `readme` in the Scripts folder for tips on cleaning a dataset, performing QC, and example script.

Please use github issues or feel free to reach out to Michael Meyer (michael.f.meyer@wsu.edu), Steph Figary (sef92@cornell.edu) or Warren Currie (warren.currie@dfo-mpo.gc.ca) if you have any questions on this work.  

*MM/SF discussion point- slack channel or stick to github issues?*

<br>

## Data policy

ZIG's data sharing policy is that data will be shared without permission from the data provider. Please do not share any data that you are given access to as a member of the Data Harmonization Team. Please see our [Authorship Guidelines and Data Policy](https://docs.google.com/document/d/1v-Wg50qSCBuFWXFg-B3PdfiEKz__8iJr3IeyCUpfKgU/edit?usp=sharing) for more details.

<br>

## Repo structure

Currently, this repo is organized with three main folders and several subfolders.

<br>

### Folder: Data

The data folder has several subfolders:

* Inputs: **Do not edit!** This folder includes the original data files from the data providers. Michael or Steph will assign datasets to each member of the Date Team that can be found in this folder.
  
* Derived: Each member of the team will have a subfolder in this folder. Please see the `readme` in this folder for file naming conventions and organization suggestions.

*MM/SF discussion point: The repo is private. Does it seem reasonable to house the data here? We will also have copies in the Google Drive. Alternatively- we could just send everyone each file when we assign it avoid having the raw data on git at all*

<br>

### Folder: Scripts

This folder includes all of the scripts that will be used to clean data individual provider datasets and create one 'final' dataset for data analysis. The `readme` in this folder provides tips for data cleaning and file naming conventions. **Please only edit your own script in this folder to prevent merge conflicts.**

*MM/SF discussion points: Should everyone have a separate folder here as well? Also, one script/dataset, or one script/person with all datasets included?*

<br>

### Folder: Figures

This folder will include all of the qa/qc figures, including histograms, scatterplots, and others. See the `readme` in this Scripts folder for suggested qa/qc methods and naming conventions (also in the Figures `readme`).

*MM/SF discussion point: Should everyone have a separate folder here as well?*

<br>


## Proposed workflow 

Michael and Steph will you Github issues to assign datasets to team members. The datasets will be located in the Data/inputs folder. To ensure a fresh set of eyes looks at each datasets, no one will work on their own dataset. Data scripts for data cleanings and qc checks will be kept in the scripts folder and output will be kept in the Data/derived (.csv) and Figures (qc checks) folders. 

We propose using the Github Issues tab for project management, troubleshooting and team communications. Using Issues will also keep a record of how we decided to clean the data in a place that everyone can see and comment on. This will also be helpful in the future if(/when) we need to make changes.

<br>

## Suggested packages and versions
tidyverse $\geq$ 1.3.0

readxl $\geq$ 1.3.0

*MM/SF discussion point: Others? Could list all components of the tidyverse, but this seemed cleaner to me*

<br>

## Examples and additional information

Additional information can be found in the `readme` of each of the folders. Specifically, the `readme` of the scripts folder is a good place to start as in provides more information on the work flow for each dataset. The script `.R` provides an example workflow, with comments, for cleaning and quality checks for an example dataset. 
<br>


## Github resources

We are using Github for this work because of its version control capabilities and the ability to communicate through issues. We know many members are new to Github and wanted to provide some resources for getting started. 

* [Git in R](https://nt246.github.io/NTRES-6100-data-science/lesson2-rmarkdown-github.html): Lecture notes from Dr. Nina Overgaard Therkildsen's Collaborative and Reproducible Data Science in R course at Cornell University. Lessons 2-5 provide step-by-step instructions on how to get started using github with Rstudio. These links were shared with permission from Dr. Nina Overgaard Therkildsen.
* [GLEON Github workshop](https://www.youtube.com/watch?v=B-FHx4l1BNU)
* [Jenny Bryan’s Happy Git with R:](https://happygitwithr.com/big-picture.html) Chapter 1 is a great introduction to Git and the benefits of using it.
* [GitHub for Project Management by Openscapes:](https://openscapes.github.io/series/github-issues.html) Chapter 10 includes an overview of Git Issues.

*MM/SF discussion point: others to add?*

<br>

## Thank you!

Lastly, thank you all for all of your time and effort on ZIG! This team is such an important part of reaching the next step with ZIG.