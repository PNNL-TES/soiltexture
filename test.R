

# Load SRDB lon/lat values


# Load the soilgrid1km files one by one
SOILSDATA <- "~/Data/soilgrids1km/"

fn <- "OCSTHA_M_02_apr_2014.tif.gz"
fqfn <- file.path(SOILSDATA, fn)

# get variable name from filename

library(R.utils)
library(raster)

# gunzip the file to a temporary file
tf <- tempfile()
gunzip(fqfn, destname = tf)

# load into raster

d <- raster(tf)
plot(d)

# Use raster::extract(raster object, point list)

file.remove(tf)

