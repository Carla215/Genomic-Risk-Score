# Carla Smith 22/07/20
# script to make fam file the same size as sample file, while retaining sex and phenotype (batch) information

# current fam file
fam <- read.table("fam_file.fam")

# fam file made from sample file
fam_blank <- read.table("fam_blank.fam")

# new fam file
keep <- which(rownames(fam) %in% rownames(fam_blank))    
fam_updated <- fam[keep,]

# save it
write.table(fam_updated, file="fam_updated.fam", row.names=FALSE, col.names=FALSE, quote=FALSE)
