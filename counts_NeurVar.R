#Creates counts of pertinent items in the NHLP neural variability project
#Must first run neural_variability.R to get the DataTable dataframe

library(dplyr)

BL_NeurVar <- DataTable %>% 
  filter(lang_cat_2groups_Span=="BL") %>% 
  summarise(
    numSubj = n(),
    minAge = min(age_mri)/365,
    maxAge = max(age_mri)/365,
    meanAge = mean(age_mri)/365,
    sdAge = sd(age_mri)/365
  )

ML_NeurVar <- DataTable %>% 
  filter(lang_cat_2groups_Span=="ML") %>% 
  summarise(
    numSubj = n(),
    minAge = min(age_mri)/365,
    maxAge = max(age_mri)/365,
    meanAge = mean(age_mri)/365,
    sdAge = sd(age_mri)/365
  )
  