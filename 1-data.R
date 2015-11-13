# Match up SRDB data with climate and soils data
# BBL November 13, 2015

source("0-functions.R")

SCRIPTNAME  	<- "1-data.R"

library(R.utils)  # 2.1.0
library(raster)   # 2.4-20

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

openlog(file.path(outputdir(), paste0(SCRIPTNAME, ".log")), sink = TRUE)

printlog("Welcome to", SCRIPTNAME)

# Load SRDB lon/lat values
printlog("Loading SRDB data...")
srdb <- gzfile("data/srdb-20150826a/srdb-data.csv.gz") %>%
  read.csv() %>%
  subset(select = c(Record_number, 
                    Longitude, Latitude, Elevation,
                    Manipulation,
                    Biome, Ecosystem_type, Ecosystem_state, Leaf_habit,
                    Soil_type, Soil_drainage, Soil_BD, Soil_CN, Soil_sandsiltclay,
                    MAT, MAP,
                    Meas_method,
                    Rs_annual, Rh_annual, Ra_annual,
                    R10, Q10_0_10, Q10_5_15, Q10_10_20))
lonlat <- srdb %>%
  subset(select = c(Longitude, Latitude))

# Load the soilgrid1km files one by one
soildata <- extract_rasterdata(datadir = "~/Data/soilgrids1km/",
                               filepattern = "_02_apr_2014.tif.gz", 
                               lonlat = lonlat)
save_data(soildata, scriptfolder = FALSE)

# Precipitation climatology from WorldClim
precipdata <- extract_rasterdata(datadir = "~/Data/WorldClim/prec_30s_bil/",
                                 filepattern = ".bil.gz", 
                                 lonlat = lonlat)
precipdata$prec <- rowSums(precipdata)
save_data(precipdata, scriptfolder = FALSE)

# Temperature climatology from WorldClim
tempdata <- extract_rasterdata(datadir = "~/Data/WorldClim/tmean_30s_bil/",
                               filepattern = ".bil.gz", 
                               lonlat = lonlat)
tempdata <- tempdata / 10.0   # WorldClim temperature is *10
tempdata$tmean <- rowMeans(tempdata)
save_data(tempdata, scriptfolder = FALSE)

# FAO WRB classes (from soilgrid1km README file)
faowrb <- read_csv("FAO_WRB.csv", datadir = INPUT_DIR)

printlog("Combining data...")
srdb <- cbind(srdb, soildata) %>% 
  cbind(precipdata) %>% 
  cbind(tempdata) %>%
  merge(faowrb, by = "TAXGWRB")
save_data(srdb, scriptfolder = FALSE)

closelog()
