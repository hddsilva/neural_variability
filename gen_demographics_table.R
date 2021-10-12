#Generates the information needed for the neural variability demographics table

library(dplyr)

#Load data
neural_variability <- read.delim(dir("nhlp_data/projects/neural_variability/",
                                      full.names=T, pattern="^neural_variability_20"),header=TRUE, sep="\t")


#Split into two dataframes
neural_variability_Bi_Span <- neural_variability %>% 
  filter(lang_cat=="Bi_Span") %>% 
  #mutate(
  summarise(
            numSubj = n(),
            minAge = min(age_mri/365, na.rm = TRUE),
            maxAge = max(age_mri/365, na.rm = TRUE),
            meanAge = mean(age_mri/365, na.rm = TRUE),
            sdAge = sd(age_mri/365, na.rm = TRUE),
            numGirls = sum(childsex.factor=="Female"),
            numBoys = sum(childsex.factor=="Male"),
            numUnreportedSex = numSubj - (numGirls+numBoys),
            numAfricanAmerican = sum(race == 1, na.rm = TRUE),
            numAmericanIndian = sum(race == 2, na.rm = TRUE),
            numAsian = sum(race == 3, na.rm = TRUE),
            numCaucasian = sum(race == 4, na.rm = TRUE),
            numPacificIslander = sum(race == 5, na.rm = TRUE),
            numHispanic = sum(race == 6, na.rm = TRUE),
            numMixedRace = sum(race == 7, na.rm = TRUE),
            numOtherRace = sum(race == 8, na.rm = TRUE),
            numUnreportedRace = (numSubj - (numAfricanAmerican+numAmericanIndian+numAsian+numCaucasian+numPacificIslander+numHispanic+numMixedRace+numOtherRace)),
            numMedicaid_yes = sum(medicaid == 1, na.rm = TRUE),
            numMedicaid_no = sum(medicaid == 0, na.rm = TRUE),
            numUnreportedMedicaid = numSubj - (numMedicaid_yes+numMedicaid_no),
            avg_maternal_ed = mean(maternal_ed, na.rm = TRUE),
            avg_motion = mean(average_motion_per_TR),
            sdMotion = sd(average_motion_per_TR),
            meanMatrixReasoning = mean(wasimrss, na.rm = TRUE),
            sdMatrixReasoning = sd(wasimrss, na.rm = TRUE),
            meanLetterWord = mean(wjiiilwss, na.rm = TRUE),
            sdLetterWord = sd(wjiiilwss, na.rm = TRUE),
            meanVocab = mean(ppvtss, na.rm = TRUE),
            sdVocab = sd(ppvtss, na.rm = TRUE))

neural_variability_Mono_Engl <- neural_variability %>% 
  filter(lang_cat=="Mono_Engl") %>%
  #mutate(
  summarise(
            numSubj = n(),
            minAge = min(age_mri/365, na.rm = TRUE),
            maxAge = max(age_mri/365, na.rm = TRUE),
            meanAge = mean(age_mri/365, na.rm = TRUE),
            sdAge = sd(age_mri/365, na.rm = TRUE),
            numGirls = sum(childsex.factor=="Female"),
            numBoys = sum(childsex.factor=="Male"),
            numUnreportedSex = numSubj - (numGirls+numBoys),
            numAfricanAmerican = sum(race == 1, na.rm = TRUE),
            numAmericanIndian = sum(race == 2, na.rm = TRUE),
            numAsian = sum(race == 3, na.rm = TRUE),
            numCaucasian = sum(race == 4, na.rm = TRUE),
            numPacificIslander = sum(race == 5, na.rm = TRUE),
            numHispanic = sum(race == 6, na.rm = TRUE),
            numMixedRace = sum(race == 7, na.rm = TRUE),
            numOtherRace = sum(race == 8, na.rm = TRUE),
            numUnreportedRace = (numSubj - (numAfricanAmerican+numAmericanIndian+numAsian+numCaucasian+numPacificIslander+numHispanic+numMixedRace+numOtherRace)),
            numMedicaid_yes = sum(medicaid == 1, na.rm = TRUE),
            numMedicaid_no = sum(medicaid == 0, na.rm = TRUE),
            numUnreportedMedicaid = numSubj - (numMedicaid_yes+numMedicaid_no),
            avg_maternal_ed = mean(maternal_ed, na.rm = TRUE),
            avg_motion = mean(average_motion_per_TR),
            sdMotion = sd(average_motion_per_TR),
            meanMatrixReasoning = mean(wasimrss, na.rm = TRUE),
            sdMatrixReasoning = sd(wasimrss, na.rm = TRUE),
            meanLetterWord = mean(wjiiilwss, na.rm = TRUE),
            sdLetterWord = sd(wjiiilwss, na.rm = TRUE),
            meanVocab = mean(ppvtss, na.rm = TRUE),
            sdVocab = sd(ppvtss, na.rm = TRUE))

#Output test of differences results into text file
#must use mutate option above instead of summarise
sink('nhlp_data/projects/neural_variability/Demographics_TestOfDifferences.txt')
print('Test of differences (t-test and chi square) results of variables of interest. Results that are statistically significant should be run as covariates in the MVM')
print('Age at MRI')
t.test(neural_variability_Mono_Engl$age_mri,neural_variability_Bi_Span$age_mri)
print('Sex')
tbl_sex<-table(neural_variability$lang_cat,as.factor(neural_variability$childsex.factor))
chisq.test(tbl_sex)
print('Race')
tbl_race<-table(neural_variability$lang_cat,as.factor(neural_variability$race))
chisq.test(tbl_race)
print('Medicaid participation')
tbl_medicaid<-table(neural_variability$lang_cat,as.factor(neural_variability$medicaid))
chisq.test(tbl_medicaid)
print('Maternal Education')
tbl_maternal_ed<-table(neural_variability$lang_cat,as.factor(neural_variability$maternal_ed))
chisq.test(tbl_maternal_ed)
print('MRI motion')
t.test(neural_variability_Mono_Engl$average_motion_per_TR,neural_variability_Bi_Span$average_motion_per_TR)
print('Matrix Reasoning scaled')
t.test(neural_variability_Mono_Engl$wasimrss,neural_variability_Bi_Span$wasimrss)
print('Letter Word standard')
t.test(neural_variability_Mono_Engl$wjiiilwss,neural_variability_Bi_Span$wjiiilwss)
print('PPVT standard')
t.test(neural_variability_Mono_Engl$ppvtss,neural_variability_Bi_Span$ppvtss)
sink()
