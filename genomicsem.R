# Carla Smith 20/07/20
# project 3 munge summary data for QC

library(GenomicSEM)

#get sumstats into correct format
#munge(c("crp_prins_switched.vcf","ferritin_prins_switched.vcf","fibrinogen_prins_switched.vcf","il1beta_sun_switched.vcf","il6_sun_switched.vcf","mcp1_ahola_switched.vcf","procalcitonin_sun_switched.vcf","saa_sun_switched.vcf","trail_folkersen_switched.vcf","vitd_jiang_switched.vcf"),"w_hm3.snplist",trait.names=c("crp","ferritin","fibrinogen","il1beta","il6","mcp1","procalcitonin","saa","trail","vitd"),c(9541,9818,9762,3301,3301,8293,3301,3301,3394,79366), info.filter = 0.9, maf.filter = 0.01)

#perform ldsc
#traits <- c("monop.sumstats.gz", "insulin.sumstats.gz", "IL6.sumstats.gz","tg.sumstats.gz", "vitd.sumstats.gz")
#sample.prev <- c(NA,NA,NA,NA,NA)
#population.prev <- c(NA,NA,NA,NA,NA)
#ld <- "eur_w_ld_chr/"
#wld <- "eur_w_ld_chr/"
#trait.names<-c("monop","insulin","IL6","tg","vitd")
#LDSCoutput <- ldsc(traits=traits, sample.prev=sample.prev, population.prev=population.prev, ld=ld, wld=wld, trait.names=trait.names)
#saveRDS(LDSCoutput, file="/rds/general/user/cs3515/home/data/LDSCoutput.Rda")


#summary (no fibrinogen)
files=c("vitd_new3","crp_new3","fibrinogen_new3","ferritin_new3","il1beta_new4","il6_new4","mcp1_new3","procalcitonin_new4","saa_edit","trail_edit")
ref= "reference.1000G.maf.0.005.txt"
trait.names=c("vitd","crp","fibrinogen","ferritin","il1beta","il6","mcp1","procalcitonin","saa","trail")
se.logit=c(T,T,T,T,T,T,T,T,T,T)
info.filter=0.9
maf.filter=0.01
sumstats <-sumstats(files=files,ref=ref,trait.names=trait.names,se.logit=se.logit,OLS=trait.names,linprob=NULL,prop=NULL,N=NULL,info.filter=info.filter,maf.filter=maf.filter)
saveRDS(sumstats, file="/rds/general/user/cs3515/home/project3/outputs/core/sumstats.Rda")


#load in pre-calculated p_sumstats and LDSCoutput
#p_sumstats <- readRDS("p_sumstats2.Rda")
#LDSCoutput <- readRDS("LDSCoutput2.Rda")

#pfactor <- commonfactorGWAS(covstruc = LDSCoutput, SNPs = p_sumstats, estimation = "DWLS", cores = NULL, toler = 1e-100, SNPSE = 0.00005, parallel = FALSE, Output = NULL)

#write to outfile
#saveRDS(pfactor, file="/rds/general/user/cs3515/home/data/pfactor.Rda")

#comfactor <- commonfactor(LDSCoutput,estimation="DWLS")
#saveRDS(comfactor, file="/rds/general/user/cs3515/home/data/comfactor.Rda")
