# Carla Smith 24/07/20
# Script to make input file for Metasoft, using sumstats combined file (output from GenomicSEM)

# read in combined summary statistic file
sumstats <- readRDS("sumstats.Rda")

# get order of input traits, will need these when you get metasoft output (no headers)
header <- colnames(sumstats)

# remove all columns that are not rsid, beta or se
sumstats_edited <- sumstats[,-c(2:6)]

# metasoft does not allow for standard error equal to (or below) 0, so remove these
sumstats_edited <- sumstats_edited[!(sumstats_edited$se.vitd==0 | sumstats_edited$se.crp==0 | sumstats_edited$se.fibrinogen==0 | sumstats_edited$se.ferritin==0 | sumstats_edited$se.il1beta==0 | sumstats_edited$se.il6==0 | sumstats_edited$se.mcp1==0 | sumstats_edited$se.procalcitonin==0 | sumstats_edited$se.saa==0 | sumstats_edited$se.trail==0),]
# this took the number of SNPs from 20910 to 9473

# write without column names (header)
write.table(sumstats_edited, file="metasoft_input", row.names=FALSE, col.names=FALSE, quote=FALSE)

