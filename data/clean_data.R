library(xlsx)
library(stringr)
library(reshape2)
setwd("~/Google Drive/R_studio/coursera_dev_data/murder_rate")

#initial read in of the data: US regions
crime <- as.data.frame(read.xlsx("data/US homicide statistics2008.xlsx", 
                  sheetName="CRIMES BY COUNTY", startRow=1, endRow=2329, 
                  colIndex=1:12, header=TRUE, stringsAsFactors=TRUE))
  dim(crime)
  head(crime)
  colnames(crime) <- c("region_old", "subregion", "violent","murder", "rape", "robbery", "assault", "property", "burglary", "larceny", "car", "arson")
##codebook: region_old = crimes.by.state.and.county..2008
##codebook: subregion = county, violent=violent.crime, 
##codebook: murder = murder.and.nonnegligent.manslaughter
##codebook: rape = forcible.rape, robbery = robbery
##codebook: assault = aggravated.assault, property = property.crime
##codebook: burglary = burglary, larceny = larceny.theft
##codebook: car = motor.vehicle.theft, arson = arson
  
  #split column 1
  str(crime)
  dim(crime)
  crime$region <- gsub("|-", "*", crime$region_old)
  crime$region <- gsub("Counties", " ", crime$region)
  crime$region <- as.character(crime$region)
  crime <- cbind(crime[,-1]) #drop old region
  dim(crime)
crime.new <- with(crime,{cbind(crime[,-12],colsplit(region,fixed("*"),names=c("region","region_type")))})
   
  ##create new dataframe with correct order
  crime.new <- crime.new[,c("region", "subregion", "region_type", "violent","murder", "rape", "robbery", "assault", "property", "burglary", "larceny", "car", "arson" )]
  crime.new$region <- tolower(crime.new$region)
  crime.new$subregion <- tolower(crime.new$subregion)
  crime.new$region_type <- tolower(crime.new$region_type)
  head(crime.new)
  dim(crime_new)

  write.csv(crime.new, "crime.csv")

