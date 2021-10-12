#Creates the data tables to use in the MVM

library(dplyr)

#Load in data
neural_variability <- read.delim(dir("nhlp_data/projects/neural_variability/",
                                            full.names=T, pattern="^neural_variability_20"),header=TRUE, sep="\t")

#MAKE MVM DATA TABLES
#Dual language project
DataTable <- neural_variability %>% 
  select(mrrc_id,record_id,age_mri,childsex.factor,lang_cat,average_motion_per_TR,medicaid)  

#Modify to MVM format and write out data table  
names(DataTable)[1] <- "Subj"
DataTable$`InputFile\ \\` <- paste("$STORAGE/nhlp/projects/variability/ResVar_Maps/AudUnrelCR/AudUnrelCR_DiffVarMasked_",DataTable$Subj,"_SPMG2+tlrc\ \\",sep="")
write.table(DataTable,"nhlp_data/projects/neural_variability/MVM/AudUnrelCR_Variability_MVM_DataTable_20190816.txt",row.names = FALSE,col.names = TRUE,quote=FALSE)

DataTable$`InputFile\ \\` <- paste("$STORAGE/nhlp/processed/",DataTable$Subj,"/",DataTable$Subj,".altGLM/cbucket.",DataTable$Subj,"_SPMG2_meanSDT+tlrc[AudUnrel_CR#0]\ \\",sep="")
write.table(DataTable,"nhlp_data/projects/neural_variability/MVM/AudUnrelCR_Mean_MVM_DataTable_20190816.txt",row.names = FALSE,col.names = TRUE,quote=FALSE)

DataTable$`InputFile\ \\` <- paste("$STORAGE/nhlp/projects/variability/ResVar_Maps/VisUnrelCR/VisUnrelCR_DiffVarMasked_",DataTable$Subj,"_SPMG2+tlrc\ \\",sep="")
write.table(DataTable,"nhlp_data/projects/neural_variability/MVM/VisUnrelCR_Variability_MVM_DataTable_20190816.txt",row.names = FALSE,col.names = TRUE,quote=FALSE)

DataTable$`InputFile\ \\` <- paste("$STORAGE/nhlp/processed/",DataTable$Subj,"/",DataTable$Subj,".altGLM/cbucket.",DataTable$Subj,"_SPMG2_meanSDT+tlrc[VisUnrel_CR#0]\ \\",sep="")
write.table(DataTable,"nhlp_data/projects/neural_variability/MVM/VisUnrelCR_Mean_MVM_DataTable_20190816.txt",row.names = FALSE,col.names = TRUE,quote=FALSE)
#Remember in TextWrangler to remove slash at end of last line

#READ1 project
DataTable <- neural_variability %>% 
  left_join(READ1, by = c("Subj"="subject")) %>% 
  select(mrrc_id,age_mri,childsex.factor,wjiiilwrs,ppvtrs,wasimrrs,fastloc_read_gap,fastloc_cognitives_gap,fastloc_ppvt_gap,average.motion..per.TR.,gov_assist,highestedmother,race,RU2.short_OR)

#FastLoc overlap project
DataTable <- neural_variability %>% 
  select(mrrc_id,age_mri,childsex.factor,wjiiilwrs,wasimrrs,fastloc_cognitives_gap) %>% 
  filter(!is.na(wasimrrs)) %>% 
  filter(!mrrc_id %in% c("pb3669","pb7102","pb7214","pb7308","pb7461","pb7462","pb7867","pb8052","pb8230","pb 8269","pb8395","pb8397","pb8398","pb8411","pb8412")) %>% #mising timing files for correct trials for these participants on 04-26-2019
  filter(!mrrc_id %in% c("pb3571","pb3728","pb3825","pb7121")) #for some reason these maps are missing as well (will need to look into this)


# names(DataTable)[1] <- "Subj"
# DataTable_wConds <- DataTable[rep(seq_len(nrow(DataTable)), 4), ]
# DataTable_wConds$StimType <- gl(2,nrow(DataTable)*2,nrow(DataTable)*4,labels = c("VisUnrel","FalseFont"))
# DataTable_wConds$TrialType <- gl(2,nrow(DataTable),nrow(DataTable)*4,labels = c("Standard","Oddball"))
# DataTable_wConds$StimLabel <- gl(4,nrow(DataTable),nrow(DataTable)*4,labels = c("VisUnrel_CR","FalseFont_CR","VisUnrel_Hit","FalseFont_Hit"))
# 
# #DataTable_wConds$`InputFile\ \\` <- paste("/SAY/standard/Neonatology-726014-MYSM/nhlp/processed/",DataTable_wConds$Subj,"/",DataTable_wConds$Subj,".altGLM/cbucket.",DataTable_wConds$Subj,"_GAM_meanSDT+tlrc[",DataTable_wConds$StimLabel,"#0]\" \\",sep="")
# 
# write.table(DataTable_wConds,"MVM_DataTable_FastLocOverlap_20190501.txt",row.names = FALSE,col.names = TRUE,quote=FALSE)
# #Remember in TextWrangler to remove slash at end of last line