# Project Skeleton

A basic repo template (directory structure) to be use as starting point for new projects.


  
# Structure
  
## 00-Information
  
Proposals, prompts, outlines, ... anything relevant to the conception of the project.
  
## 01-Data
  
Data in downloaded formats are "raw" (e.g., .xlsx, .dat, .csv, ...). We import and store data in R formats (e.g., .rds, .rdata) during "processing". Data cleaning and recoding finalize "analytic" datasets. *Note: generally, "00-" prefix means don't modify or rewrite the files within.*
  
* Sub-directories
  + 00-Raw-Data
  + 01-Processed-Data
  + 02-Analytic-Data

## 02-Scripts

Envisioned as a linear path from raw data management to final figure creation. Playground to catch everything incomplete; data wrangling to transition through data directories; helper functions to hold project specific functions or those oriented to external programs; visualization is obvious; analysis to fit models, calculate stats, general computation/programming. Each has its own typical set of script types.

* Sub-directories and typical scripts
  + 00-Playground
    - exploratory code dump, in-progress scripts, under construction, placeholder for other scripts
  + 01-Data-Wrangling
    - download_Data_\* : scripts to automate the data download from online
    - process_Data_\* : scripts to process raw data
    - prep_Files_\* : scripts to write files for external program use
    - process_Results_\* : scripts to process results from external program analyses
  + 02-Helper-Functions
    - repeated, modular, specific, useful code
    - run_Program_\* : scripts to automate external programs
  + 03-Visualization
    - plot_\* : pretty self-explanatory, fundamental units to generate_Figure scripts
    - generate_Figure_\* : scripts to create high-level figures, plots, images, interactive visualizations
    - generate_Table_\* : scripts to create tables
  + 04-Analysis
    - analyze_\* : scripts to run analyses within R

## 03-Output

Store the goodies to show everyone else. 

* Sub-directories
  + 01-Tables
  + 02-Figures
  + 03-Non-Static


## 04-Report

* Sub-directories
  + 01-Notebook (detailed reports, write-ups, long-winded, process-oriented)
    - reproducibility_notebook.RMD : quasi-stream-of-thought writing, deeply woven web of scripts and analytical directions
  + 02-Presentation (slide decks)
  + 03-Manuscript (polished for publication)

## 05-Miscellaneous

Whatever else may need to accompany repo.





# Useful Resources

[How to collaborate](https://www.sciencemag.org/careers/2012/07/how-collaborate)

[Ten simple rules for collaboratively writing a multi-authored paper](https://doi.org/10.1371/journal.pcbi.1006508)


[How to write a first-class paper](https://doi.org/10.1038/d41586-018-02404-4)

[Ten simple rules for structuring papers](https://doi.org/10.1371/journal.pcbi.1005619)

[Writing science](https://www.science.org/content/article/writing-science-storys-thing)


[Ten guidelines for effective data visualization in scientific publications](https://doi.org/10.1016/j.envsoft.2010.12.006)


[Three tips for giving a great research talk](https://www.science.org/content/article/three-tips-giving-great-research-talk)

[How to give a great scientific talk](https://doi.org/10.1038/d41586-018-07780-5)


[Science communication, public engagement, and outreach](https://www.informalscience.org/develop-projects/science-communication-public-engagement-and-outreach)

