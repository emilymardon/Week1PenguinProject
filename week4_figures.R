# Loading libraries
library(tidyverse)
library(palmerpenguins)
library(janitor)
library(here)

# Setting wd
here()

source(here("functions", "cleaning.R"))

# cleaning and naming databases again (did in week 1)
write.csv(penguins_raw, here("PenguinData","penguins_raw.csv"))

penguins_clean <- penguins_raw %>%
  select(-Comments) %>%
  select(-starts_with("Delta")) %>%
  clean_names()

head(penguins_raw)
head(penguins_clean)

# Boxplots, exploratory figures using ggplot2
# will use column names directly as labels

# flipper_boxplot <- ggplot(
#  data = penguins_clean, 
#  aes(x=species, y= flipper_length_mm))+
#  geom_boxplot()
# flipper_boxplot

# get a warning message if we run the above code
# warning message tells us it has removed NAs
# should remove missing values only from the columns we are interested in
# data cleaning to remove NAs:

# now remove NAs and use piping to prevent overwriting
# check notes in notion for more about piping and not overwriting in code (week 4 notes)
penguins_flippers <- penguins_clean %>%
  select(species, flipper_length_mm) %>%
  drop_na()

colnames(penguins_flippers)

# flipper_boxplot <- ggplot(
#  data = penguins_flippers, 
#  aes(x=species, y= flipper_length_mm))+
#  geom_boxplot()
# flipper_boxplot

# flipper_boxplot

# good, this removes the error message as there are no NAs in the relevant columns
# but it looks ugly, lets improve aesthetics (within geom_boxplot):

# AESTHETICS STEPS:
# change colors by species
# remove automatic legend
# not hiding trends in data, to prevent to boxplot from being misleading
#   plotting raw data on top of boxplot!
# also controlling randomness of jitter function by using a random seed in our plot
# and making jitter more transparent
# and changing labels using labs
#   its ok to put special characters/spaces in labs() because they're in a string (string = human language)
# the default colours in R are not colour blind friendly! so need to change these too
#   attatching species to colours

# whew!! this is a lor of code...
# so let's simplify things by making it a function
# this function will be called plotting.R

species_colours <- c("Adelie Penguin (Pygoscelis adeliae)" = "darkorange",
                     "Chinstrap penguin (Pygoscelis antarctica)" = "purple",
                     "Gentoo penguin (Pygoscelis papua)" = "darkcyan")

flipper_boxplot <- ggplot(
data = penguins_flippers, 
aes(x = species, y = flipper_length_mm))+
geom_boxplot(
  aes(color = species), show.legend = FALSE
) +
  geom_jitter(aes(color = species),
              alpha = 0.3,
              show.legend = FALSE,
              position = position_jitter(
                width = 0.3,
                seed = 0
              )) +
  scale_color_manual(values = species_colours) +
  labs(x = "Penguin species",
       y = "Flipper length (mm)") +
  theme_bw()

flipper_boxplot

# now using the code from plotting.R:
# using a much cleaning code now to produce the graph
# this does not work !!!

plot_boxplot(penguins_clean, "species", "flipper_length_mm", "Penguin Species", "Flipper length (mm)")
