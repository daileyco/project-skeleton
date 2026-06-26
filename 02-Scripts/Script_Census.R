# Script for Housekeeping, census of all scripts in repo, their dependencies and outputs

## Load Data

## Packages
library(dplyr)
library(tidyr)
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
  `[`(., !grepl("Script_Census|template|Playground", .)) %>% 
  `[`(., order(file.info(.)$ctime))


### set up df
#### use order of scripts sourced in reproducibility notebook for census scripts
repronb <- data.frame(report = readLines("./04-Report/01-Notebook/reproducibility_notebook.rmd")) %>% 
  mutate(source = grepl("^source\\(", report)) %>%
  filter(source) %>%
  mutate(name = gsub('source\\(.*\\".+[/]{1}(.+[.]R)\\".+$', "\\1", gsub("[.](r)", ".R", report)))


# sapply(repronb$name, (\(x){sum(grepl(x, scripts.all))==1})) %>% sum(.)==nrow(repronb)



#### clean up filenames and isolate script subdirectory
census <- data.frame(path = scripts.all) %>%
  mutate(name = sub(".+[/]{1}(.+[.]R)$", "\\1", path), 
         subdirectory = sub(".+02[-]Scripts[/]{1}(.+)[/]{1}.+[.]R$", "\\1", path)) %>% 
  filter(name%in%repronb$name)





#### reorder
census <- census[match(repronb$name, census$name),]



## Read scripts & parse info

scripts.contents <- lapply(1:nrow(census), 
                           \(x){
                             script <- readLines(census$path[x])
                             
                             
                             contents <- data.frame(sections = script[which(grepl("^##[^#]", script))]) %>% 
                               mutate(sections.cleaned = gsub("##[ ]*", "", sections), 
                                      category = case_when(grepl(gsub("##[ ]", 
                                                                      "", 
                                                                      paste0(main.sections, 
                                                                             collapse = "|")), 
                                                                 sections.cleaned, 
                                                                 ignore.case = TRUE) ~ gsub("##[ ]", 
                                                                                            "", 
                                                                                            main.sections)[match(toupper(sections.cleaned), 
                                                                                                                 toupper(gsub("##[ ]", 
                                                                                                                              "", 
                                                                                                                              main.sections)))], 
                                                           TRUE ~ "other")) %>% 
                               mutate(index = which(script%in%sections)) %>% 
                               add_row(category="Purpose", 
                                       index = 0, 
                                       .before = 1) %>% 
                               arrange(index) %>% 
                               mutate(start = index + 1, 
                                      stop = ifelse(index==max(index), 
                                                    length(script), 
                                                    lead(index,1)-1)) %>%
                               group_by(category) %>% 
                               summarise(start = min(start), 
                                         stop = max(stop)) %>%
                               ungroup() %>%
                               rowwise() %>% 
                               mutate(content = script[start:stop] %>% 
                                        `[`(.,which(.!="")) %>% 
                                        paste(., collapse="\n")) %>% 
                               ungroup() %>% 
                               arrange(start) %>%
                               filter(grepl(gsub("##[ ]", 
                                                 "", 
                                                 paste0(c("Purpose", main.sections[c(1:4)]), 
                                                        collapse = "|")), 
                                            category, 
                                            ignore.case = TRUE)) %>% 
                               select(-start, -stop) %>%
                               rowwise() %>% 
                               mutate(content.code = content, 
                                      content = case_when(category == "Purpose" ~ gsub("#[ ]*", "", content), 
                                                          category %in% c("Load Data", "Helper Functions") ~ strsplit(content, 
                                                                                                                              split = "\n") %>%
                                                            unlist() %>%
                                                            gsub('^.+\\"(.+)\\".*\\)$', "\\1", .) %>% 
                                                            paste0(., collapse = ', '), 
                                                          category %in% c("Save") ~ strsplit(content, 
                                                                                                                              split = "\n") %>%
                                                            unlist() %>% 
                                                            `[`(., which(grepl('\\"', .) & grepl('Output|Data', .))) %>%
                                                            gsub('^.+\\"(.+)\\".*\\)$', "\\1", .) %>% 
                                                            paste0(., collapse = ', '), 
                                                          category == "Packages" ~ strsplit(content, 
                                                                                            split = "\n") %>% 
                                                            unlist() %>% 
                                                            gsub("library\\((.+)\\)", 
                                                                 "\\1", 
                                                                 .) %>% 
                                                            paste0(., collapse = ', '))) %>% 
                               ungroup() %>% 
                               pivot_wider(names_from = category, 
                                           values_from = c(content.code, content))
                             
                             return(contents)
                             
                             
                           }) %>%
  bind_rows()


names(scripts.contents) <- gsub("content[_]", "", names(scripts.contents))


census <- bind_cols(census, 
                    scripts.contents) %>% 
  select(`Script Name`=name, 
         `Script Location`=subdirectory, 
         Purpose, 
         `Data Input`=`Load Data`, 
         Packages, 
         `Helper Functions`,
         `Files Written`=Save)



## for readme
# knitr::kable(census[,c(2,1,3)])




## Write to excel

path_excel <- paste0("./00-Information/script_census-", Sys.Date(), ".xlsx")

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










# scripts.contents <- lapply(1:nrow(census), 
#                            \(x){
#                              script <- readLines(census$path[x])
#                              
#                              
#                              if(census$subdirectory[x]=="02-Helper-Functions"){
#                                
#                                meat <- which(grepl("^## Function", script))
#                                
#                                starts <- c(0,1,meat)+1
#                                stops <- c(2,meat,length(script))-1
#                                
#                                sections <- c("purpose", "description", "meat")
#                                
#                              }else{
#                                main.sections.index <- match(toupper(main.sections), toupper(script))
#                                main.sections.index <- main.sections.index
#                                
#                                meat <- min(which(grepl("^##", script))[-which(which(grepl("^##", script))%in%c(main.sections.index))])
#                                
#                                
#                                starts <- c(0,1,main.sections.index[1:3],(meat-1),main.sections.index[4])+1
#                                stops <- c(2,main.sections.index[1:3],meat,main.sections.index[4:5])-1
#                                
#                                sections <- c("purpose", "description", "input", "packages", "helper_functions", "meat", "saved_output")[which(!is.na(main.sections.index))]
#                                
#                                
#                              }
#                              
#                              contents <- sapply(1:length(starts), 
#                                                 \(y){
#                                                   script[starts[y]:stops[y]] %>% 
#                                                     `[`(.,which(.!="")) %>% 
#                                                     paste(., collapse="\n")
#                                                 })
#                              
#                              contents.df <- data.frame(Contents=contents) %>% 
#                                t() %>% 
#                                as.data.frame() %>% 
#                                setNames(., nm = sections)
#                              
#                              
#                            }) %>%
#   bind_rows()
# 
# rownames(scripts.contents) <- NULL
# 
# 
# census <- bind_cols(census, 
#                     scripts.contents) %>%
#   select(name, subdirectory, purpose, input, packages, helper_functions, saved_output)
