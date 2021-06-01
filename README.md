# ZIG GLEON

Welcome to the ZIG GLEON Data Harmonization Team git repo. The goal of the data team is to: 

* Create a raw analysis-ready data product from submitted datasets
* Provide scripted workflows for each step of data cleaning
* Perform high level QC of submitted data

This read me will walk through the structure of this git repo, the proposed structure of subfolders, details to consider when working up a dataset, and provide an example of working up a dataset.

Please feel free to reach out to [Michael Meyer](michael.f.meyer@wsu.edu) or [Steph Figary](sef92@cornell.edu) if you have any questions on this work or use Github issues.  

MM/SF discussion point- slack channel?

## Section One: Data policy

It is ZIG's policy to not share any data without permission from the data providers. Please do not share any data that you are given access to as a member of the Data Harmonization Team. Please see out [Authorship Guidelines and Data Policy](https://docs.google.com/document/d/1v-Wg50qSCBuFWXFg-B3PdfiEKz__8iJr3IeyCUpfKgU/edit?usp=sharing) for more details.

<br>

## Section Two: Repo structure

Currently, this repo is organized with three main folders and several subfolders

<br>

#### Data folder

The data folder has several subfolders:

* Inputs: **Do not edit!** This folder includes the original data files from the data providers. Michael or Steph will assign datasets to you that can be found in this folder
  + MM/SF discussion point: The repo is private. Does it seem reasonable to house the data here? We will also have copies in the Google Drive. Alternatively- we could just send everyone each file when we assign it avoid having the raw data on git at all.
  
* Derived: Each member of the team will have a subfolder in this folder. Please see the `readme` in this folder for file naming conventions and organization suggestions.

<br>

#### Scripts folder

This folder includes all of the scripts that will be used to convert the data from the data provider files into one dataset that includes all of the data. All data cleaning scripts will be housed here and everyone is expected to only edit their own scripts. More information can be found in the `readme` in the scripts folder.
  + MM/SF discussion point: Should everyone have a separate folder here as well? One script/dataset, or one script/person with all datasets included?

<br>

#### Figures folder

This folder will include all of the figures that are used for qa/qc methods. This will include historgrams, scatterplots, and others. See the readme in this folder for suggested qa/qc methods for cleaning and checking each dataset.
  + MM/SF discussion point: Should everyone have a separate folder here as well?

<br>

## Section Three: Suggested packages and versions
tidyverse $\geq$ 1.3.0
readxl $\geq$ 1.3.0

  + MM/SF discussion point: Others? Could list all components of the tidyverse, but this seemed cleaner to me

<br>

## Section Four: Examples and additional information

Additional information can be found in the `readme` of each of the folders. Specifically, the `readme` of the scripts folder is a good place to start as in provides more information on the work flow for each dataset. The script `.R` provides an example workflow, with comments, for cleaning and quality checks for an example dataset. 

<br>

## Section Five: Using Github Issues

Github issues are a very useful tool for project management and team communication. Michael and Steph will use it to assign datasets to team members and then team members can use the function to ask/answer eachothers questions. This will keep a record of how we decided to clean the data in a place that everyone can see, and will serve as a record in the future in case (/when) we need to change things.


<br>

## Section Six: Github resources

We are using Github for version control in this work, along with the ability to communicate through issues. Here are a few resources to get you started if you are new to github:

* POPULATE
*
*

<br>
