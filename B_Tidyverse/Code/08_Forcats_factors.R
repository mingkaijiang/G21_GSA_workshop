# Factors - a brief introduction for use in plotting

# Load Libraries ----
# this is done each time you run a script
library(readxl) # read in excel files
library(tidyverse) # dplyr and piping and ggplot etc
library(lubridate) # dates and times
library(scales) # scales on ggplot ases
library(skimr) # quick summary stats
library(janitor) # clean up excel imports
library(patchwork) # multipanel graphs

# If you were typing in data this might be how it looks
# Read in wide dataframe ----
lakes.df <- read_csv("data/reduced_lake_long_genus_species.csv")

# Factors are used to help convert a continuous or categorical variable into 
# discrete categorical variables used in statistics 
# 
# You will still see the variable as you normall would
# Lakes - Willis, Grass, Indian, South
#
# What is really happening - they are alphabetized
# Indian, Grass, South Willis 
#
# and behind the scenes they are assigned a number 1 - n
# 1, 2, 3, 4

# Convert to factors -----
lakes.df <- lakes.df %>%
  mutate(lake_name = as.factor(lake_name))

# look at the levels
levels(lakes.df$lake_name)

# What if we wanted them reordered to some particular order
lakes.df <- lakes.df %>%
  mutate(
    lake_name = fct_relevel(lake_name, 
                       "Willis", "South", "Indian", "Grass"))

# here is an example of where you might want it...
# we can offset the points so they dont overlap
lakes.df  %>% ggplot(aes(year, color = lake_name)) + 
  stat_summary(aes(y = org_l),
               fun.y = mean, na.rm = TRUE,
               geom = "point",
               size = 3, 
               position = position_dodge(0.2)) +
  stat_summary(aes(y = org_l),
               fun.data = mean_se, na.rm = TRUE,
               geom = "errorbar",
               width = 0.2, 
               position = position_dodge(0.2)) +
  labs(x = "Date", y = "Animals (Number per Liter)") +
  scale_color_manual(name = "Group",
                     values = c("blue", "red", "black", "purple"),
                     labels = c("Willis", "South", "Indian", "Grass")) +
  facet_grid(group ~ lake_name)

# So what if you wanted to see Cladoceran on the bottom?
lakes.df <- lakes.df %>%
  mutate(
    group = fct_relevel(group, 
                            "Copepod", "Cladoceran"))

# here is an example of where you might want it...
# we can offset the points so they dont overlap
lakes.df  %>% ggplot(aes(year, color = lake_name)) + 
  stat_summary(aes(y = org_l),
               fun.y = mean, na.rm = TRUE,
               geom = "point",
               size = 3, 
               position = position_dodge(0.2)) +
  stat_summary(aes(y = org_l),
               fun.data = mean_se, na.rm = TRUE,
               geom = "errorbar",
               width = 0.2, 
               position = position_dodge(0.2)) +
  labs(x = "Date", y = "Animals (Number per Liter)") +
  scale_color_manual(name = "Group",
                     values = c("blue", "red", "black", "purple"),
                     labels = c("Willis", "South", "Indian", "Grass")) +
  facet_grid(group ~ lake_name)


# time for something new ----
# what if there were a lot of species 
# you wanted to only see the top 3
# lets read in a new file to add some complexity for fun
lakes.df <- read_csv("data/reduced_lake_long_genus_species.csv")

lakes.df <- lakes.df %>% 
  filter(org_l > 0) %>%
  mutate(genus_species = as.factor(genus_species)) %>%
  arrange(genus_species)

# lets look at a plot
lakes.df %>% 
  ggplot(aes(x=genus_species, y=org_l)) +
  geom_boxplot() +
  coord_flip()

# reorder it by number per liter look at a plot
lakes.df %>% 
  ggplot(aes(x=fct_reorder(genus_species, org_l), org_l)) +
  geom_boxplot() +
  coord_flip()


# Lets combine the rare species
lakes.df <- lakes.df %>%  
  mutate(lumped_sp = fct_lump(genus_species, n=2)) 
  mutate(lumped_sp = fct_lump(genus_species, n=3)) 

# reorder it by number per liter look at a plot
lakes.df %>% 
  ggplot(aes(lumped_sp, org_l)) +
  geom_boxplot() +
  coord_flip()

