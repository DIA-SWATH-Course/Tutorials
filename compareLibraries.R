
library(data.table)

setwd("C:/DIA_Course/Tutorial3_DIAUmpire/TTOF/")
lib_DIA <- fread("transitionlist_optimized_decoys.tsv")

targets_DIA <- subset(lib_DIA, Decoy==0)
decoys_DIA <- subset(lib_DIA, Decoy==1)

peptides_DIA = unique(targets_DIA$PeptideSequence)
proteins_DIA = unique(targets_DIA$ProteinId)

n_peptides_DIA = length(peptides_DIA)
n_proteins_DIA = length(proteins_DIA)

setwd("C:/DIA_Course/Tutorial1_Library/TTOF/")
lib_DDA <- fread("transitionlist_optimized_decoys.tsv")

targets_DDA <- subset(lib_DDA, Decoy==0)
decoys_DDA <- subset(lib_DDA, Decoy==1)

peptides_DDA = unique(targets_DDA$PeptideSequence)
proteins_DDA = unique(targets_DDA$ProteinId)

n_peptides_DDA = length(peptides_DDA)
n_proteins_DDA = length(proteins_DDA)

setwd("C:/DIA_Course/Tutorial3_DIAUmpire/")
lib_DIA_QE <- fread("transitionlist_optimized_decoys.tsv")

targets_DIA_QE <- subset(lib_DIA_QE, Decoy==0)
decoys_DIA_QE <- subset(lib_DIA_QE, Decoy==1)

peptides_DIA_QE = unique(targets_DIA_QE$PeptideSequence)
proteins_DIA_QE = unique(targets_DIA_QE$ProteinId)

n_peptides_DIA_QE = length(peptides_DIA_QE)
n_proteins_DIA_QE = length(proteins_DIA_QE)

setwd("C:/DIA_Course/Tutorial1_Library/")
lib_DDA_QE <- fread("transitionlist_optimized_decoys.tsv")

targets_DDA_QE <- subset(lib_DDA_QE, Decoy==0)
decoys_DDA_QE <- subset(lib_DDA_QE, Decoy==1)

peptides_DDA_QE = unique(targets_DDA_QE$PeptideSequence)
proteins_DDA_QE = unique(targets_DDA_QE$ProteinId)

n_peptides_DDA_QE = length(peptides_DDA_QE)
n_proteins_DDA_QE = length(proteins_DDA_QE)

