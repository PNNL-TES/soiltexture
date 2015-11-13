

library(R.utils)
library(raster)


# Load SRDB lon/lat values


# Load the soilgrid1km files one by one
SOILSDATA <- "~/Data/soilgrids1km/"

files <- list.files(SOILSDATA, pattern = "*.tif.gz")

for(fn in files) {
  
  #fn <- "BLD_sd1_M_02_apr_2014.tif.gz"
  fqfn <- file.path(SOILSDATA, fn)
  
  # get variable name from filename
  varname <- paste(unlist(strsplit(fn, "_"))[1:3], collapse="_")
  
  
  # gunzip the file to a temporary file
  tf <- tempfile()
  gunzip(fqfn, destname = tf)
  
  # load into raster
  
  d <- raster(tf)
  print(d)
  plot(d)
  
  # Use raster::extract(raster object, point list)
  
  file.remove(tf)
  
}


