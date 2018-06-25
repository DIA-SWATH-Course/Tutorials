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
for file in /c/DIA_Course/Data/DIA_data/TTOF/collinsb*.mzXML
do
  OpenSwathWorkflow \
  -in ${file} \
  -tr /c/DIA_Course/Tutorial1_Library/transitionlist_optimized_decoys.pqp \
  -tr_irt /c/DIA_Course/Data/hroest_DIA_iRT.TraML \
  -batchSize 1000 \
  -min_upper_edge_dist 1 \
  -Scoring:stop_report_after_feature 5 \
  -out_osw $(basename ${file%%.*}).osw \
  -threads 2 \
  &>> Tutorial4_log.txt
done

## pyprophet
# first merge and subsample the data for learning scores
# Note: The subsampling is done to speed-up the machine learning step (LDA)
# that is used to determine the score weights to derive combined discriminant scores.
# The learning on large datasets is computationally demanding and subsampling will
# increase the processing speed. Here we use a subsampling ratio of 0.33, meaning that 
# starting from 6 files we will learn the scores on ~2x the size of a single run file. 
pyprophet merge \
--out=training.osw \
--subsample_ratio=0.33 \
collinsb*.osw \
&>> Tutorial4_log.txt

# merge all files for scoring
# Note: this step simply merges all OpenSWATH results together into one merged.osw file.
pyprophet merge \
--out=merged.osw \
--subsample_ratio=1 \
collinsb*.osw \
&>> Tutorial4_log.txt

# learn score weights on training set
pyprophet score \
--in=training.osw \
--level=ms2 \
&>> Tutorial4_log.txt

# use the scoring function from the subsampled training set 
# to score the full merged data on peptide query level
pyprophet score \
--in=merged.osw \
--level=ms2 \
--apply_weights=training.osw \
&>> Tutorial4_log.txt

# score the full dataset on peptide level
# Note: here we run the "pyprophet peptide" module 3 times 
# to get statistics in run-specific, experiment-wide and global context 
pyprophet \
peptide --in=merged.osw --context=run-specific \
peptide --in=merged.osw --context=experiment-wide \
peptide --in=merged.osw --context=global \
&>> Tutorial4_log.txt

# score the full dataset on protein level
pyprophet \
protein --in=merged.osw --context=run-specific \
protein --in=merged.osw --context=experiment-wide \
protein --in=merged.osw --context=global \
&>> Tutorial4_log.txt

# export results to tsv format for subsequent feature alignment with TRIC
pyprophet export \
--in=merged.osw \
--out=merged_export.tsv \
--format=legacy_merged \
--no-ipf \
--max_rs_peakgroup_qvalue 0.1 \
--max_global_peptide_qvalue 0.05 \
--max_global_protein_qvalue 0.01 \
&>> Tutorial4_log.txt

# export scoring pdf
pyprophet export \
--in=merged.osw \
--format=score_plots \
&>> Tutorial4_log.txt

# TRIC alignment
feature_alignment.py \
--in merged_export.tsv \
--out aligned.tsv \
--method LocalMST \
--realign_method lowess \
--max_rt_diff 60 \
--mst:useRTCorrection True \
--mst:Stdev_multiplier 3.0 \
--target_fdr -1 \
--fdr_cutoff 0.05 \
--max_fdr_quality -1 \
--alignment_score 0.05  \
&>> Tutorial4_log.txt
