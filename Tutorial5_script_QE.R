# change to the working directory
setwd('C:/DIA_Course/Tutorial5_Statistics/')

# load R packages needed
library(SWATH2stats)
library(MSstats)

# read in the output of our OpenSWATH/pyprophet/TRIC workflow
data <- 
read.delim2(
  file = 'C:/DIA_Course/Tutorial4_OpenSWATH/aligned.tsv',
  dec = '.',
  sep = '\t',
  header = TRUE, 
  stringsAsFactors = FALSE)

dim(data)

# change some column names in order to fit the format for SWATH2stats
names(data)[names(data) == "FullUniModPeptideName"] <- 
  "FullPeptideName"
names(data)[names(data) == "aggr_fragment_annotation"] <- 
  "aggr_Fragment_Annotation"
names(data)[names(data) == "aggr_peak_area"] <- 
  "aggr_Peak_Area"

# reduce the number of columns to what is actually needed in further steps
data.reduced <- reduce_OpenSWATH_output(data)

# remove iRT peptides and non-proteotypic peptides from our data
data.reduced <- 
  data.reduced[grep(
    "iRT", data.reduced$ProteinName, 
    invert = TRUE),]
data.reduced <- 
  data.reduced[grep(
    ";", data.reduced$ProteinName,
    invert = TRUE),]

# read in th annotation file
annotation.file <- 
  read.delim2(
    file = 'DIA_Course_annotation_QE.txt',
    sep = '\t',
    header = TRUE)

# annotate the data
data.annotated <- sample_annotation(data.reduced, annotation.file)

# check the number of analytes in your data
count_analytes(data.annotated)

# we would like to use only data with complete measurements in a condition
data.filtered <- 
  filter_mscore_condition(
    data.annotated, 
    mscore=0.1, 
    n.replica = 3)

# now we can check the number of analytes again
count_analytes(data.filtered)

# split transitions
data.transition <- disaggregate(data.filtered)

# convert the data into the format of MSstats
MSstats.input <- convert4MSstats(data.transition)

# save the workflow and the final output
save(data.annotated, data.filtered, data.reduced, data.transition,
     file = 'SWATH2stats_workflow_TTOF.Rdata')
save(MSstats.input, file = 'MSstats_input_TTOF.Rdata')


## MSstats

# first the data will be processed by MSstats
data.processed <- dataProcess(MSstats.input, 
                              normalization = FALSE, 
                              summaryMethod = "TMP", censoredInt = "NA",
                              cutoffCensored = "minFeature", MBimpute = FALSE)

# we plot several different plot to review the quality
dataProcessPlots(
  data.processed, 
  type = "QCPlot", 
  legend.size = 4,
  which.Protein = "sp|P06733|ENOA_HUMAN",
  address = FALSE)

dataProcessPlots(
  data.processed, 
  type = "ProfilePlot",
  featureName = "Peptide", 
  legend.size = 4,
  originalPlot= TRUE,
  summaryPlot = TRUE, 
  which.Protein = "sp|P06733|ENOA_HUMAN",
  address = FALSE)

dataProcessPlots(
  data.processed, 
  type = "Conditionplot",
  which.Protein = "sp|P06733|ENOA_HUMAN",
  address = FALSE)

dataProcessPlots(
  data.processed,
  type = "Conditionplot",
  which.Protein = "tr|C8ZBP1|C8ZBP1_YEAS8",
  address = FALSE)

dataProcessPlots(
  data.processed, 
  type = "Conditionplot",
  which.Protein = "sp|P29745|PEPT_ECOLI",
  address = FALSE)

save(data.processed, file = 'MSstats_processed_TTOF.Rdata')

# Group comparison
# first check which groups we have defined
levels(data.processed$ProcessedData$GROUP_ORIGINAL)

#define a comparison matrix
comparison <- matrix(c(-1, 1), nrow=1)
rownames(comparison) <- "B vs. A"

# run the group comparison
result.GroupComparison <-
  groupComparison(
    contrast.matrix = comparison, 
    data = data.processed)

# make a Volcano plot
groupComparisonPlots(result.GroupComparison$ComparisonResult,
                     type = "VolcanoPlot", 
                     sig = 0.05, 
                     FCcutoff = 2, 
                     ProteinName = FALSE, 
                     address = FALSE)

# make a user-defined Volano plot
with(	result.GroupComparison$ComparisonResult, 
      plot(	log2FC, 
            -log10(adj.pvalue), 
            pch=20, 
            main="Mix B vs. Mix A", 
            xlim=c(-3, 3), 
            ylim = c(0, 3)))
with(	subset(result.GroupComparison$ComparisonResult,
      grepl("HUMAN", Protein)), 
      points(log2FC, 
             -log10(adj.pvalue), 
             pch=20, 
             col="aquamarine4")) 
with(	subset(result.GroupComparison$ComparisonResult,
      grepl("YEAS8", Protein)), 
      points(log2FC, 
             -log10(adj.pvalue), 
             pch=20, 
             col="chocolate3"))
with(	subset(result.GroupComparison$ComparisonResult,
      grepl("ECOLI", Protein)), 
      points(log2FC, 
             -log10(adj.pvalue), 
             pch=20, 
             col="slateblue2"))
legend("topright",
       legend = c("HUMAN - 1:1", "Yeast - 2:1","E.coli - 1:4"), 
       fill = c("aquamarine4", "chocolate3", "slateblue2"),
       col = NULL)

#write group comparison result in table
write.table(result.GroupComparison$ComparisonResult,
            file = "groupComparison_result_TTOF.tsv",
            quote = FALSE,
            row.names = FALSE,
            sep = "\t")

# Quantification 
quantification.result <- 
  quantification(data.processed,
                 type = "Sample",
                 format = "matrix")

# write output in a file
write.table(quantification.result, 
            file = "quantification_result_TTOF.tsv",
            quote = FALSE,
            row.names = FALSE,
            sep = "\t")

# Design Sample size for future experiments
result.sample <- designSampleSize(result.GroupComparison$fittedmodel, 
                                  numSample=TRUE, 
                                  desiredFC=c(1.25, 3), 
                                  FDR=0.05, 
                                  power=0.8)

#plot result
designSampleSizePlots(result.sample)

#calculate power for a given sample size
result.power <- designSampleSize(result.GroupComparison$fittedmodel, 
                                 numSample=3,
                                 desiredFC=c(1.25, 3), 
                                 FDR=0.05, 
                                 power=TRUE)
# plot result
designSampleSizePlots(result.power)

