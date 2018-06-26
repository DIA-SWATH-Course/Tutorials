# Change directory to the Tutorial4 folder for the OpenSWATH workflow
cd /c/DIA_Course/Tutorial4_OpenSWATH/

# run OpenSWATH for each DIA file
# Remember: The * is a wildcard.
# Note: The for-loop is a structure regularly used in programming to iterate over
# multiple files. Here, each DIA file is processed with the OpenSwathWorkflow.
# The basic format of a for-loop across multiple files is:
# for file in files
# do function(${file}) done
# Note: ${file} means that the content of the variable "file" is interpreted
# Note: ${file%%.*} removes the file extention (anything beyond the ".", in our case .mzXML)
# Note: "$(basename ...)" removes the full file path (here: "/c/DIA_Course/Data/DIA_data/TTOF/")
# runtime ~21min

## pyprophet
# first merge and subsample the data for learning scores
# Note: The subsampling is done to speed-up the machine learning step (LDA)
# that is used to determine the score weights to derive combined discriminant scores.
# The learning on large datasets is computationally demanding and subsampling will
# increase the processing speed. Here we use a subsampling ratio of 0.33, meaning that
# starting from 6 files we will learn the scores on ~2x the size of a single run file.

# merge all files for scoring
# Note: this step simply merges all OpenSWATH results together into one merged.osw file.

# learn score weights on training set

# use the scoring function from the subsampled training set
# to score the full merged data on peptide query level

# score the full dataset on peptide level
# Note: here we run the "pyprophet peptide" module 3 times
# to get statistics in run-specific, experiment-wide and global context

# score the full dataset on protein level

# export results to tsv format for subsequent feature alignment with TRIC

# export scoring pdf

# TRIC alignment
