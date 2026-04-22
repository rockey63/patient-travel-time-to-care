library(readr)
library(dplyr)
library(ggmap)

register_google(key = Sys.getenv("GOOGLE_MAPS_API_KEY"))

#df_npi: npi from SUP data joined wih IPOP npi full info data
NPI_Primary_Dental <- read_csv("data/raw/NPI_Primary_Dental.csv")

df_npi <- NPI_Primary_Dental %>% filter(ADDRESS_TYPE == "PRACTICE")
df_npi$NPI %>% unique() %>% length()

#df_npi: address to geo
df_npi <- df_npi %>% mutate(address = paste(ADDR_LINE1, ", ", ADDR_CITY, ", ", ADDR_STATE))
df_npi$lon <- NA
df_npi$lat <- NA

for(i in 1:nrow(df_npi)){
  
  df_geo <- geocode(df_npi$address[i], output = "latlona")
  
  df_npi$lon[i] <- df_geo$lon
  df_npi$lat[i] <- df_geo$lat
}

#df_npi: geo_npi
df_npi$geo_npi <- vector("list", nrow(df_npi))
for(i in 1:nrow(df_npi)){
  df_npi$geo_npi[[i]] <- df_npi[c("lon","lat")][i,] %>% unlist() %>% as.numeric()
}

#save
save(df_npi, file = "data/processed/3.0 df_npi.RData")