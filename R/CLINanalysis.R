#args <- commandArgs(trailingOnly = TRUE) 
#snp=as.numeric(args[1])

#rm(list=setdiff(ls(), c("snp")))

source("/work/projects/epipgx/users/LIV/Task1Surv/SIMfunctions.R")
setwd("/work/projects/epipgx/users/LIV/Task1Surv/twocomp/twocompwoIMM/")
LuMixFull(obs.time=47,delta=17,bz=c(24,4,5,6,8,9,10,11,12,13,14,15,7,18,19,28,25,48,49,50,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45),
                 bzd=c(0,0,0,0,0,1,1,2,2,2,2,2,0,3,3,3,0,4,4,4,5,5,5,5,5,0,0,0,0,0,6,6,6,6,6,6,6),
                 gz=c(24,4,5,6,8,9,10,11,12,13,14,15,7,18,19,28,25,48,49,50,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45),
                 gzd=c(0,0,0,0,0,1,1,2,2,2,2,2,0,3,3,3,0,4,4,4,5,5,5,5,5,0,0,0,0,0,6,6,6,6,6,6,6),
                 sample="/work/projects/epipgx/users/LIV/Genfiles/Task1.sample",out=1)


#LuMixFull(obs.time=47,delta=17,bz=c(8,11:15,18:19,28,25,35,39:45,snp),gz=c(6,8,18:19,28,24,29:33,39:45,snp),sample="/work/projects/epipgx/users/LIV/Task1Surv/twocomp/twocompwoIMM/twocompwoIMM2.sample",out=0,snp=snp)
