# gbif.R
# Query species current data from GBIF
# Clean up the data
# Save it to a csv file
# Create a map to display species occurence points

# List of packages
packages<-c("tidyverse","rgbif","usethis", "CoordinateCleaner", "leaflet", "mapview")

#instal packages not yet installed
installed_packages<-packages %in% rownames(installed.packages())
if(any(installed_packages==FALSE)){
  install.packages(packages[!installed_packages])
}

# Packages loading, with libray function 
invisible(lapply(packages, library, character.only=TRUE))

usethis::edit_r_environ()

spiderBackbone<-name_backbone(name="Habronattus americanus")
speciesKey<-spiderBackbone$usageKey

# Getting data from GBIF

occ_download(pred("taxonKey", speciesKey),format="SIMPLE_CSV")

d<- occ_download_get( 'number from' ), path="data/"%>%
write_csv(d, "data/rawData.csv")
