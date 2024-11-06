#Loading libraries
library(tidyverse)
library(palmerpenguins)
library(janitor)
library(here)
#Setting our working directory
here()

#Exploring data
head(penguins_raw)
#Show column names
colnames(penguins_raw)
# problems with these column names: white spaces, brackets, random capitalization (harder to remember)
# Comments and Delta are also pribably just comments people made when they were working in Excel which we definitely don't need for data analysis

#Write raw data to a csv file before cleaning- for safe keeping fo the raw data
#Writing it to this working directory using here, saving it to a subfolder called PenguinData
write.csv(penguins_raw, here("PenguinData","penguins_raw.csv"))

# removing some of the columns from our data frame (data cleaning)
# using hyphen to delete the column with the specified name
# this function is from tidyverse
penguins_raw <- select(penguins_raw, -Comments)
#can also delete multiple columns at a time using starts_with
#need to reload raw data to overwrite the original "Comments" command
penguins_raw <- read.csv(here("PenguinData", "penguins_raw.csv"))

#example of BAD CODE:
penguins_clean <- select(penguins_raw, -Comments)
penguins_clean <- select(penguins_clean, -starts_with("Delta"))
#this won't work because we are basically saying penguins_clean = penguins_clean in the second line
# so to fix this data cleaning step we will use piping from the tidyverse universe

# piping: we can use %>% as an "and then" function
penguins_clean <- penguins_raw %>%
  select(-Comments)%>%
  select(-starts_with("Delta"))%>%
# also use this janitor function (see differences in colnames after)
  clean_names()

colnames(penguins_clean)

# making our own functions to make it easier to share our data pipeline

# making a function which cleans penguin data columns
# the input for this function will be called raw_data

cleaning_penguin_columns <- function(raw_data){
  print("Removed comments, removed empty columns and rows, removed delta.")
  raw_data %>%
    clean_names() %>%
    remove_empty(c("rows", "cols"))%>%
    select(-starts_with("delta"))%>%
    select(-comments)
}

# load raw data again
penguins_raw <- read.csv(here("PenguinData", "penguins_raw.csv"))
# check column names
colnames(penguins_raw)
# run the function
penguins_clean <- cleaning_penguin_columns(penguins_raw)
# check the output
colnames(penguins_clean)

#________________________________________________________________________________________________________________

#write the clean data to a csv file
# this prevents problems from the code which arise due to overwriting the code multiple times
write.csv(penguins_clean, here("PenguinData", "penguins_clean.csv"))


# loading in functions from our files that we have created
source(here("Week1PenguinProject", "Functions", "cleaning.R"))
# using the functions we designed to clean names, remove empty rows and cols, and to remove NA

# using the cleaning.R file for shorthand to select columns_names and shorten species names

cleaning_penguins_columns <- function(raw_data, columns_names){
  print("cleaned names, removed comments, removed empty rows and cols, shortening species names, removed delta.")
  raw_data %>%
    clean_names()%>%
    shorten_species()%>%
    remove_empty(c("rows", "cols"))%>%
    select(-columns_names)
}

# then calling and using this function
# redoing pipeline by loading raw data, running the function, and checking the output again
penguins_raw <- read.csv(here("PenguinData", "penguins_raw.csv"))
penguins_clean <- cleaning_penguin_columns(penguins_raw)

# so we loaded some convenient functions into our folders
# and then used these to clean the data in one mass function
colnames(penguins_clean)

#________________________________________________________________________________________________________________

# installing libraries the reproducible way using renv
# installed renv package
renv::init()
1
#can now see renv in my working directory
# use snapshot function to save the state of the project
# and uses renv.lock to see all the libraries currently loaded into renv folder
renv::snapshot()

# install a new one
install.packages("table1")
renv::snapshot()
#using the renv folder to install all the right packages
renv::restore()
# this function makes it so that others can load all the libraries they need to work on this code automatically
# it is a part of best practices i.e., sharing code
