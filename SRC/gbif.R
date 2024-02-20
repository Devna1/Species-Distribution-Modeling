# gbif.R
# Query species current data from GBIF
# Clean up the data
# Save it to a csv file
# Create a map to display species occurrence points

# List of packages
packages<-c("tidyverse","rgbif","usethis", "CoordinateCleaner", "leaflet", "mapview")

#install packages not yet installed
installed_packages<-packages %in% rownames(installed.packages())
if(any(installed_packages==FALSE)){
  install.packages(packages[!installed_packages])
}

# Packages loading, with libray function 
invisible(lapply(packages, library, character.only=TRUE))

usethis::edit_r_environ()

spiderBackbone<-name_backbone(name="Habronattus americanus")
speciesKey<-spiderBackbone$usageKey

# Getting raw data from GBIF

occ_download(pred("taxonKey", speciesKey),format="SIMPLE_CSV")


d <- occ_download_get('0012257-240202131308920') %>%
  occ_download_import()

View(d)

write_csv(d, "data/rawData.csv")

# Cleaning and Filtering Out Data

fData<-d %>%
  filter(!is.na(decimalLatitude), !is.na(decimalLongitude))

fData <-fData %>%
  filter(countryCode %in% c("US", "CA", "MX"))

fData <- fData %>%
  filter(!basisOfRecord %in% c("FOSSIL_SPECIMAN", "LIVING_SPECIMEN"))

fData <-fData %>%
  cc_sea(lon="decimalLongitude", lat="decimalLatitude")

fData<-fData %>%
  distinct(decimalLongitude, decimalLatitude, speciesKey, datasetKey, .keep_all=TRUE)

# Can clean in one fell swoop
# cleanData<-d %>%
#   filter(!is.na(decimalLatitude), !is.na(decimalLongitude)) %>%
#   filter(!basisOfRecord %in% c("FOSSIL_SPECIMAN", "LIVING_SPECIMEN")) %>%
#   filter(countryCode %in% c("US", "CA", "MX")) %>%
#   cc_sea(lon="decimalLongitude", lat="decimalLatitude") %>%
#   distinct(decimalLongitude, decimalLatitude, speciesKey, datasetKey, .keep_all=TRUE)
  
  
  
 


