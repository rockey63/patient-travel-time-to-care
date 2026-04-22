library(dplyr)
library(tidyr)
library(stringr)

#load df_file
df_file <- 
  data.frame(file_name = list.files("data/processed", pattern = "^3\\.[0-9].*\\.RData$")) %>% 
  mutate(file_name = paste0("data/processed/", file_name)) %>% 
  mutate(core_name = gsub("^3\\.[0-9] df_geo_|\\.RData$", "", basename(file_name))) %>% 
  mutate(rdata_file_name = basename(file_name)) %>% 
  mutate(
    YEAR = paste0("20", substr(core_name, nchar(core_name) - 1, nchar(core_name))),
    CLASSIFICATION = case_when(
      str_detect(core_name, "clinic") ~ "Clinic/Center",
      str_detect(core_name, "dentist") ~ "Dentist",
      str_detect(core_name, "family") ~ "Family Medicine",
      str_detect(core_name, "internal") ~ "Internal Medicine",
      str_detect(core_name, "nurse") ~ "Nurse Practitioner",
      str_detect(core_name, "pediatrics") ~ "Pediatrics",
      str_detect(core_name, "preventive") ~ "Preventive Medicine",
      TRUE ~ NA_character_
    )
  )

#df_file_1: Count variables
ls_count <- list()

for(i in 1:nrow(df_file)){
  
  print(i)
  
  load(df_file$file_name[i])
  
  obj_name <- ls()[ls() != "df_file" & ls() != "ls_count"][length(ls()[ls() != "df_file" & ls() != "ls_count"])]
  df <- get(obj_name)
  
  df_1 <- data.frame(
    file_name = df_file$file_name[i],
    core_name = df_file$core_name[i],
    rdata_file_name = df_file$rdata_file_name[i],
    CLASSIFICATION = df_file$CLASSIFICATION[i],
    YEAR = df_file$YEAR[i],
    Key = c("row_n", "NPI_n", "CLAIM_GUID_n", "BEN_ID_n", "ZIP_n", "address_n", "zip_add_combination_n"),
    Type = "Count",
    Value = c(
      nrow(df),
      df$NPI %>% unique() %>% length(),
      df$CLAIM_GUID %>% unique() %>% length(),
      df$BEN_ID %>% unique() %>% length(),
      df$ZIP %>% unique() %>% length(),
      df$address %>% unique() %>% length(),
      df %>% distinct(geo_sup, geo_npi) %>% nrow()
    )
  )
  
  ls_count[[i]] <- df_1
  
  rm(df, df_1, obj_name)
}

df_file_1 <- bind_rows(ls_count)

#df_file_2: List variables
ls_list <- list()

for(i in 1:nrow(df_file)){
  
  print(i)
  
  load(df_file$file_name[i])
  
  obj_name <- ls()[ls() != "df_file" & ls() != "df_file_1" & ls() != "ls_count" & ls() != "ls_list"][length(ls()[ls() != "df_file" & ls() != "df_file_1" & ls() != "ls_count" & ls() != "ls_list"])]
  df <- get(obj_name)
  
  df_age <- df$AGE_RANGE_DFS %>% table() %>% data.frame() %>% rename(Type = ".", Value = Freq) %>% mutate(Key = "AGE_RANGE_DFS")
  df_race <- df$RACE %>% table() %>% data.frame() %>% rename(Type = ".", Value = Freq) %>% mutate(Key = "RACE")
  df_gender <- df$GENDER %>% table() %>% data.frame() %>% rename(Type = ".", Value = Freq) %>% mutate(Key = "GENDER")
  
  df_2 <- bind_rows(df_age, df_race, df_gender) %>% 
    mutate(
      file_name = df_file$file_name[i],
      core_name = df_file$core_name[i],
      rdata_file_name = df_file$rdata_file_name[i],
      CLASSIFICATION = df_file$CLASSIFICATION[i],
      YEAR = df_file$YEAR[i]
    ) %>% 
    select(file_name, core_name, rdata_file_name, CLASSIFICATION, YEAR, Key, Type, Value)
  
  ls_list[[i]] <- df_2
  
  rm(df, df_age, df_race, df_gender, df_2, obj_name)
}

df_file_2 <- bind_rows(ls_list)

#df_file_3: Summary
ls_summary <- list()

for(i in 1:nrow(df_file)){
  
  print(i)
  
  load(df_file$file_name[i])
  
  obj_name <- ls()[ls() != "df_file" & ls() != "df_file_1" & ls() != "df_file_2" & ls() != "ls_count" & ls() != "ls_list" & ls() != "ls_summary"][length(ls()[ls() != "df_file" & ls() != "df_file_1" & ls() != "df_file_2" & ls() != "ls_count" & ls() != "ls_list" & ls() != "ls_summary"])]
  df <- get(obj_name)
  
  dur <- summary(df$dur) %>% t() %>% data.frame() %>% select(Var2, Freq) %>% rename(Type = Var2, Value = Freq) %>% mutate(Key = "Duration")
  dis <- summary(df$dis) %>% t() %>% data.frame() %>% select(Var2, Freq) %>% rename(Type = Var2, Value = Freq) %>% mutate(Key = "Distance")
  
  df_3 <- bind_rows(dur, dis) %>% 
    mutate(
      file_name = df_file$file_name[i],
      core_name = df_file$core_name[i],
      rdata_file_name = df_file$rdata_file_name[i],
      CLASSIFICATION = df_file$CLASSIFICATION[i],
      YEAR = df_file$YEAR[i],
      Value = round(as.numeric(Value), 2)
    ) %>% 
    select(file_name, core_name, rdata_file_name, CLASSIFICATION, YEAR, Key, Type, Value)
  
  ls_summary[[i]] <- df_3
  
  rm(df, dur, dis, df_3, obj_name)
}

df_file_3 <- bind_rows(ls_summary)

#df_summary
df_summary <- bind_rows(df_file_1,df_file_2,df_file_3) %>% arrange(core_name,Key,Type)

write.csv(df_summary,"data/processed/4.1 df_summary.csv",row.names = F)
