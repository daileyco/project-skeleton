# Script for Housekeeping, census of all scripts in repo, their dependencies and outputs

## Load Data

## Packages
library(dplyr)
library(openxlsx)

## Helper Functions


## Script structure

main.sections <- c("## Load Data", 
                   "## Packages", 
                   "## Helper Functions", 
                   "## Save", 
                   "## Session Info", 
                   "## Clean Environment")

## Scripts in repo

scripts.all <- list.files("./02-Scripts", pattern = "[.]R$", full.names = TRUE, recursive = TRUE) %>%
  `[`(., !grepl("Script_Census|template", .))

### set up df

census <- data.frame(path = scripts.all) %>%
  mutate(name = sub(".+[/]{1}(.+[.]R)$", "\\1", path), 
         subdirectory = sub(".+[/]{1}(.+)[/]{1}.+[.]R$", "\\1", path))


## Read scripts & partition info

scripts.contents <- lapply(1:nrow(census), 
                           \(x){
                             script <- readLines(census$path[x])
                             
                             
                             if(census$subdirectory[x]=="02-Helper-Functions"){
                               
                               meat <- which(grepl("^## Function", script))
                               
                               starts <- c(0,1,meat)+1
                               stops <- c(2,meat,length(script))-1
                               
                               sections <- c("purpose", "description", "meat")
                               
                             }else{
                               main.sections.index <- match(main.sections, script)
                               
                               meat <- min(which(grepl("^##", script))[-which(which(grepl("^##", script))%in%c(main.sections.index))])
                               
                               
                               starts <- c(0,1,main.sections.index[1:3],(meat-1),main.sections.index[4])+1
                               stops <- c(2,main.sections.index[1:3],meat,main.sections.index[4:5])-1
                               
                               sections <- c("purpose", "description", "input", "packages", "helper_functions", "meat", "saved_output")
                               
                               
                             }
                             
                             contents <- sapply(1:length(starts), 
                                                \(y){
                                                  script[starts[y]:stops[y]] %>% 
                                                    `[`(.,which(.!="")) %>% 
                                                    paste(., collapse="\n")
                                                })
                             
                             contents.df <- data.frame(Contents=contents) %>% 
                               t() %>% 
                               as.data.frame() %>% 
                               setNames(., nm = sections)
                             
                             
                           }) %>%
  bind_rows()

rownames(scripts.contents) <- NULL


census <- bind_cols(census, 
                    scripts.contents) %>%
  select(name, subdirectory, purpose, input, packages, helper_functions, saved_output)





## Write to excel

path_excel <- "./00-Information/script_census.xlsx"

write.xlsx(census, path_excel)

# Load the workbook
wb <- loadWorkbook(path_excel)

# Get the header style
header_style <- createStyle(
  halign = "center",
  valign = "center",
  wrapText = TRUE,
  textDecoration = "bold",
  fgFill = "lightgrey"
)
wrap_style <- createStyle(wrapText = TRUE)


# Apply the style to the header
addStyle(wb, sheet = 1, style = header_style, rows = 1, cols = 1:ncol(census))
addStyle(wb, sheet = 1, style = wrap_style, rows=2:(nrow(census)+1), cols = 1:ncol(census), gridExpand = T)
# setColWidths(wb, sheet = 1, cols = 1:ncol(census), widths = "auto")
setColWidths(wb, sheet = 1, cols = 1:ncol(census), widths = c(39,19,35,64,17,73,67))
# Save the workbook
saveWorkbook(wb, path_excel, overwrite = TRUE)



## Save




## Session Info
sessionInfo()




## Clean Environment
rm(list=ls())
gc()
