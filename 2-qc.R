# Match up SRDB data with climate and soils data
# BBL November 13, 2015

source("0-functions.R")

SCRIPTNAME  	<- "2-qc.R"

SRDB          <- "srdb.csv"

# ==============================================================================
# Main 

openlog(file.path(outputdir(), paste0(SCRIPTNAME, ".log")), sink = TRUE)

printlog("Welcome to", SCRIPTNAME)

srdb <- read_csv(SRDB, datadir = outputdir(scriptfolder = FALSE))

# -----------------------------------------------------------------------------
# Check climatology temperature and precip versus study-reported values
p <- ggplot(srdb, aes(MAT, tmean)) + geom_point()
p <- p + geom_abline()
p <- p + geom_smooth(method = 'lm', linetype = 2)
p <- p + xlab("MAT (°C, reported)") + ylab("MAT (°C, climatology)")
print(p)
save_plot("qc_tmean")
srdb %>%
  lm(tmean ~ MAT, data = .) %>%
  summary() %>%
  print()

p <- ggplot(srdb, aes(MAP, prec)) + geom_point()
p <- p + geom_abline()
p <- p + geom_smooth(method = 'lm', linetype = 2)
p <- p + xlab("MAP (mm/yr, reported)") + ylab("MAP (mm/yr, climatology)")
print(p)
save_plot("qc_prec")
srdb %>%
  lm(prec ~ MAP, data = .) %>%
  summary() %>%
  print()

# -----------------------------------------------------------------------------
# Soil properties - consistent with reported data and each other?
p <- ggplot(srdb, aes(Soil_BD, BLD_sd4_M / 1000)) + geom_point()
p <- p + geom_abline()
p <- p + geom_smooth(method = 'lm', linetype = 2)
p <- p + xlab("BD (g/cm3, reported)") + ylab("2 cm BD (g/cm3, soils database)")
print(p)
save_plot("qc_bd")

p <- ggplot(srdb, aes(WRB_class, BLD_sd1_M)) + geom_boxplot()
p <- p + theme(axis.text.x = element_text(angle = 90, hjust = 1))
p <- p + xlab("Inferred FAO WRB soil class") + ylab("Inferred 2 cm BD (g/cm3)")
print(p)
save_plot("qc_bd_class")

p <- ggplot(srdb, aes(WRB_class, CLYPPT_sd1_M)) + geom_boxplot()
p <- p + theme(axis.text.x = element_text(angle = 90, hjust = 1))
p <- p + xlab("Inferred FAO WRB soil class") + ylab("Inferred 2 cm clay (%)")
print(p)
save_plot("qc_clay_class")

p <- ggplot(srdb, aes(Longitude, Latitude, color = WRB_class))
p <- p + geom_point(aes(size = OCSTHA_M))
p <- p + coord_equal() + theme(legend.position = "bottom")
print(p)
save_plot("qc_class")


closelog()

