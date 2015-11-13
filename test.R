

library(R.utils)
library(raster)


# Load SRDB lon/lat values


# Load the soilgrid1km files one by one
SOILSDATA <- "~/Data/soilgrids1km/"
FILEPATTERN <- "_02_apr_2014.tif.gz"

files <- list.files(SOILSDATA, pattern = FILEPATTERN)

for(fn in files) {

  print(fn)
  
  # get variable name from filename
  varname <- gsub(FILEPATTERN, "", fn)
  
  #fn <- "BLD_sd1_M_02_apr_2014.tif.gz"
  fqfn <- file.path(SOILSDATA, fn)
  
  
  # gunzip the file to a temporary file
  tf <- gunzip(fqfn, remove = FALSE, temporary = TRUE, overwrite = TRUE)
  
  # load into raster
  d <- raster(tf)
  print(d)
  
  fqof <- paste0(file.path("output", varname), ".png")
  png(fqof, width = 640, height = 480)
  plot(d, main = varname)
  dev.off()
  
  # Use raster::extract(raster object, point list)
  
  file.remove(tf)
  
}


