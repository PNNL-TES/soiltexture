# Match up SRDB data with climate and soils data
# BBL November 13, 2015

source("0-functions.R")

SCRIPTNAME  	<- "1-data.R"

library(R.utils)
library(raster)
library(magrittr)


# -----------------------------------------------------------------------------
# Extract raster data and match with arbitrary lon/lat pairs
extract_rasterdata <- function(datadir, filepattern, lonlat) {
  printlog(SEPARATOR)
  printlog("Looking for files in", datadir)
  files <- list.files(datadir, pattern = filepattern)
  outdata <- matrix(NA_real_, nrow = nrow(lonlat), ncol = length(files)) %>%
    as.data.frame()
  print_dims(outdata)
  
  for(i in seq_along(files)) {
    
    fn <- files[i]
    printlog(fn)
    
    # get variable name from filename
    varname <- gsub(filepattern, "", fn)
    names(outdata)[i] <- varname
    
    # gunzip (from R.utils) the file to a temporary file
    printlog("Decompressing...")
    fqfn <- file.path(datadir, fn)
    tf <- gunzip(fqfn, remove = FALSE, overwrite = TRUE)
    
    # Load into raster structure
    d <- raster(tf)
    print(d)
    
    # Plot data
    printlog("Plotting...")
    fqof <- paste0(file.path(outputdir(), varname), ".png")
    png(fqof, width = 1000, height = 500)
    plot(d, main = varname)
    rug(lonlat[,1])
    rug(lonlat[,2], side = 2)
    points(lonlat[,1], lonlat[,2], pch = ".")
    dev.off()
    
    # Use raster::extract(raster object, point list)
    printlog("Extracting...")
    rd <- raster::extract(d, lonlat)
    printlog("Extracted", length(rd), "raster data")
    outdata[,i] <- rd
    file.remove(tf)
  }
  outdata
}

# ==============================================================================
# Main 

openlog(file.path(outputdir(), paste0(SCRIPTNAME, ".log.txt")), sink = TRUE)

printlog("Welcome to", SCRIPTNAME)

# Load SRDB lon/lat values
printlog("Loading SRDB data...")
srdb <- gzfile("data/srdb-20150826a/srdb-data.csv.gz") %>%
  read.csv() %>%
  subset(select = c(Record_number, Longitude, Latitude))
lonlat <- srdb %>%
  subset(select = c(Longitude, Latitude))

# Load the soilgrid1km files one by one
soildata <- extract_rasterdata(datadir = "~/Data/soilgrids1km/",
                               filepattern = "_02_apr_2014.tif.gz", 
                               lonlat = lonlat)
save_data(soildata)

# Precipitation climatology from WorldClim
precipdata <- extract_rasterdata(datadir = "~/Data/WorldClim/prec_30s_bil/",
                                 filepattern = ".bil.gz", 
                                 lonlat = lonlat)
save_data(precipdata)

# Temperature climatology from WorldClim
tempdata <- extract_rasterdata(datadir = "~/Data/WorldClim/tmean_30s_bil/",
                               filepattern = ".bil.gz", 
                               lonlat = lonlat)
save_data(tempdata)

closelog()
