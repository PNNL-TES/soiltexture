# Analyze effect of soil properties on Rs
# BBL November 13, 2015

source("0-functions.R")

SCRIPTNAME  	<- "3-analyze.R"
SRDB          <- "srdb.csv"

library(party)

# ==============================================================================
# Main 

openlog(file.path(outputdir(), paste0(SCRIPTNAME, ".log")), sink = TRUE)

printlog("Welcome to", SCRIPTNAME)

srdb <- read_csv(SRDB, datadir = outputdir(scriptfolder = FALSE))

indepvars <- grepl("tmean|prec|OCSTHA|PHIHOX|CLYPPT|BLD", names(srdb))
depvar <- "Rs_annual"
vars <- grepl(depvar, names(srdb)) | indepvars
s1 <- srdb[vars]

s2 <- s1[complete.cases(s1),]


# "If the predictor variables are correlated, use cforest (party)with the
# default option controls = cforest_unbiased and the conditional permutation 
# importance varimp(obj, conditional = TRUE)."
# From https://epub.ub.uni-muenchen.de/9387/1/techreport.pdf

s2.cf <- cforest(Rs_annual ~ ., data = s2, control = cforest_unbiased())
vi <- varimp(s2.cf) %>% sort()
vi2 <- data.frame(var = factor(names(vi), levels = names(vi)), 
                  value = as.numeric(vi))
p <- ggplot(vi2, aes(var, value)) + geom_bar(stat = 'identity')
p <- p + theme(axis.text.x = element_text(angle = 90, hjust = 1))




closelog()

