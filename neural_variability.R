#Creates a dataframe for analyzing neural variability in the NHLP

library(dplyr);

#Load in data
#There must only be one file in the directory that corresponds to the "pattern" input
most_recent_fastloc <- read.delim(dir("nhlp_data/data_categories/mri_data/additional_mri_data/most_recent/",
                                   full.names=T, pattern="^most_recent_fastloc_20"),header=TRUE, sep="\t")
mri_data <- read.delim(dir("nhlp_data/data_categories/mri_data/",
                                    full.names=T, pattern="^mri_data_20"),header=TRUE, sep="\t")
fastloc_driver_summary <- read.delim(dir("nhlp_data/data_categories/mri_data/additional_mri_data/driver_summaries/",
                                         full.names=T, pattern="^Fastloc_Driver_Summary_20"),header=TRUE, sep="\t")
lookup_table <- read.delim(dir("nhlp_data/data_categories/lookup_table/",
                               full.names=T, pattern="^lookup_table_20"),header=TRUE, sep="\t")
questionnaire <- read.delim(dir("nhlp_data/data_categories/questionnaire/",
                                full.names=T, pattern="^questionnaire_20"),header=TRUE, sep="\t")
race <- read.delim(dir("nhlp_data/data_categories/questionnaire/additional_questionnaire/race",
                                full.names=T, pattern="^race_20"),header=TRUE, sep="\t")
lang_cat <- read.delim(dir("nhlp_data/data_categories/questionnaire/additional_questionnaire/language_categories",
                      full.names=T, pattern="^lang_cat_20"),header=TRUE, sep="\t")
DBRS_SWAN <- read.delim(dir("nhlp_data/data_categories/DBRS_SWAN",
                       full.names=T, pattern="^DBRS_SWAN_20"),header=TRUE, sep="\t")
READ1 <- read.delim(dir("nhlp_data/data_categories/READ1",
                       full.names=T, pattern="^READ1_genotype_categories_20"),header=TRUE, sep="\t")
readassess_CloseToFastloc <- read.delim(dir("nhlp_data/data_categories/reading_assessments/additional_readassess/",
                                         full.names=T, pattern="^readassess_CloseToFastloc_20"),header=TRUE, sep="\t")
ppvt_CloseToFastloc <- read.delim(dir("nhlp_data/data_categories/ppvt/additional_ppvt/",
                                   full.names=T, pattern="^ppvt_CloseToFastloc_20"),header=TRUE, sep="\t")
cognitives_CloseToFastloc <- read.delim(dir("nhlp_data/data_categories/cognitives/additional_cognitives/",
                                         full.names=T, pattern="^cognitives_CloseToFastloc_20"),header=TRUE, sep="\t")

#Create dataframe
neural_variability <- most_recent_fastloc %>% 
  left_join(mri_data, by = c("record_id", "mrrc_id")) %>% 
  left_join(fastloc_driver_summary, by = c("mrrc_id" = "subject.ID")) %>% 
  left_join(lookup_table, by = "record_id") %>%
  left_join(questionnaire, by = "record_id") %>%
  left_join(race, by = "record_id") %>%
  left_join(lang_cat, by = "record_id") %>%
  left_join(DBRS_SWAN, by = "record_id") %>%
  left_join(readassess_CloseToFastloc, by = "record_id") %>%
  left_join(ppvt_CloseToFastloc, by = "record_id") %>%
  left_join(cognitives_CloseToFastloc, by = "record_id") %>% 
  rename(maternal_ed=pq7a_1,
         medicaid=pq19e,
         average_motion_per_TR=average.motion..per.TR.)  %>% 
  distinct() %>% 
  filter(!is.na(average_motion_per_TR))  %>%
  filter(!is.na(age_mri)) %>% 
  filter(!is.na(medicaid))  %>%   
  filter(!is.na(lang_cat))

#Write out dataframe
write.table(neural_variability, file=paste("nhlp_data/projects/neural_variability/neural_variability_",Sys.Date(),".txt",sep=""), sep="\t", row.names = FALSE)

