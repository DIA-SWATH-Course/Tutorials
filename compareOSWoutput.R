library(data.table)

setwd("C:/DIA_Course/Tutorial4_OpenSWATH/")

data_osw_ttof <- fread("aligned.tsv")

targets_osw_ttof <- subset(data_osw_ttof, decoy==0)
decoys_osw_ttof <- subset(data_osw_ttof, decoy==1)

peptides_osw_ttof = unique(targets_osw_ttof$Sequence)
proteins_osw_ttof = unique(targets_osw_ttof$ProteinName)

n_peptides_osw_ttof = length(peptides_osw_ttof)
n_proteins_osw_ttof = length(proteins_osw_ttof)

#

setwd("C:/DIA_Course/Tutorial4_OpenSWATH/QE/")

data_osw_qe <- fread("aligned.tsv")

targets_osw_qe <- subset(data_osw_qe, decoy==0)
decoys_osw_qe <- subset(data_osw_qe, decoy==1)

peptides_osw_qe = unique(targets_osw_qe$Sequence)
proteins_osw_qe = unique(targets_osw_qe$ProteinName)

n_peptides_osw_qe = length(peptides_osw_qe)
n_proteins_osw_qe = length(proteins_osw_qe)
