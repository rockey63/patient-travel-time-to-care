library(ggmap)
register_google(key = Sys.getenv("GOOGLE_MAPS_API_KEY"))

#lib
library(readr)
library(dplyr)
library(osrm) # distance and duration

#df_npi
load("data/processed/3.0 df_npi.RData")

##df_sup
SUP <- read_csv("data/raw/2.1 NPI_family_18.csv") #row level data

#df_sup: claim ID level data: claim id is not unique: it can have more than one zip
df_sup <- SUP %>% rename(NPI = PERF_ID_PROVIDER_NPI, ZIP = ZIP_CODE) %>% select(-DTE_ADMISSION) %>% distinct_all()
df_sup$ZIP <- as.character(df_sup$ZIP) 
# df_sup$NPI %>% unique() %>% length()
# df_sup$CLAIM_GUID %>% unique() %>% length()

#df_zip: zip from df_sup: geo code for zip
df_zip <- df_sup %>% distinct(ZIP) %>% mutate(lon = NA, lat = NA)

for(i in 1:nrow(df_zip)){
  df_geo <- geocode(df_zip$ZIP[i])
  df_zip$lon[i] <- df_geo$lon
  df_zip$lat[i] <- df_geo$lat
}

#df_zip: geo_sup
df_zip$geo_sup <- vector("list", nrow(df_zip))
for(i in 1:nrow(df_zip)){
  df_zip$geo_sup[[i]] <- df_zip[c("lon","lat")][i,] %>% unlist() %>% as.numeric()
}

#df_sup_zip_npi: zip to geo
df_sup_zip_npi <- 
  df_sup %>% left_join(df_zip, by = "ZIP") %>% left_join(df_npi, by = "NPI") %>% 
  select(-lon.x,-lon.y,-lat.x,-lat.y,-CLASSIFICATION.x) %>% rename(CLASSIFICATION = CLASSIFICATION.y)

##df_geo
df_geo <- df_sup_zip_npi %>% distinct(geo_sup,geo_npi)
print(paste("There are", nrow(df_geo), "combinations of NPI address and Patient zip"))

#df_geo: route
df_geo$route <- vector("list", nrow(df_geo))

for(i in 1:nrow(df_geo)) {
  result <- try({
    df_geo$route[[i]] <- osrmRoute(src = df_geo$geo_sup[[i]], dst = df_geo$geo_npi[[i]], overview = "simplified")
  }, silent = TRUE)  # Suppress the error message
  
  if (inherits(result, "try-error")) {
    message(paste("There was an error at i =", i))  # Log the error with index
    next  
  }
}

#route: dur (min), dist (km)
df_geo$dur <- NA
df_geo$dis <- NA
df_geo <- df_geo %>% filter(!sapply(route, is.null))

for (i in 1:nrow(df_geo)){
  df_geo$dur[i] <- df_geo$route[[i]]$duration
  df_geo$dis[i] <- df_geo$route[[i]]$distance
}

summary(df_geo$dur)
summary(df_geo$dis)

##df_sup_zip_npi_geo: final data
df_sup_zip_npi_geo <- df_sup_zip_npi %>% left_join(df_geo)
summary(df_sup_zip_npi_geo$dur)
summary(df_sup_zip_npi_geo$dis)

save(df_sup_zip_npi_geo, file = "data/processed/3.1 df_geo_family_18.RData")
