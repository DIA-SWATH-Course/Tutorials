# Change directory to the Tutorial6 folder for the IPF workflow
cd /c/DIA_Course/Tutorial6_IPF/

# Library generation
OpenSwathAssayGenerator \
-in pqp_p100.tsv \
-out pqp_p100_ipf.TraML \
-enable_ipf \
-unimod_file unimod.xml \
&>> Tutorial6_log.txt

# Decoy generation
OpenSwathDecoyGenerator \
-in pqp_p100_ipf.TraML \
-out pqp_p100_ipf_decoys.TraML \
&>> Tutorial6_log.txt

# File conversion to pqp format
TargetedFileConverter \
-in pqp_p100_ipf_decoys.TraML \
-out pqp_p100.pqp \
&>> Tutorial6_log.txt

# OpenSWATH
for run in *.mzML.gz
do
  OpenSwathWorkflow \
  -in $run \
  -tr pqp_p100.pqp \
  -tr_irt iRTkit.TraML \
  -batchSize 10 \
  -readOptions workingInMemory \
  -Scoring:stop_report_after_feature 5 \
  -min_upper_edge_dist 1 \
  -use_ms1_traces \
  -enable_uis_scoring \
  -Scoring:Scores:use_uis_scores \
  -Scoring:Scores:use_ms1_mi \
  -Scoring:Scores:use_mi_score \
  -Scoring:Scores:use_total_mi_score \
  -out_osw ${run%%.*}.osw \
  -threads 1 \
  &>> Tutorial6_log.txt
done

# PyProphet nerging of seperate OpenSWATH output files
# Nore: the * again denotes a wildcard meaning that 
# all files ending on .osw are used
pyprophet merge \
--out=merged.osw \
*.osw \
&>> Tutorial6_log.txt

# Score features on MS1 level
pyprophet score \
--in=merged.osw \
--level=ms1 \
--group_id=feature_id \
&>> Tutorial6_log.txt

# Score features on MS2 level
pyprophet score \
--in=merged.osw \
--level=ms2 \
--group_id=feature_id \
&>> Tutorial6_log.txt

# Score features on transition level
pyprophet score \
--in=merged.osw \
--level=transition \
&>> Tutorial6_log.txt

# Export a pdf with all the separate subscore distributions 
pyprophet export \
--format=score_plots \
--in=merged.osw \
&>> Tutorial6_log.txt

# Run the IPF specific score integration
pyprophet ipf \
--in=merged.osw \
&>> Tutorial6_log.txt

# Export the final quantification matrix
# Note: In the standard OpenSWATH tutorial we have exported the 
# a tsv file. Here we now use the option to directly export a 
# quantification matrix. If you want to see the difference you 
# open both files in excel to compare the different formats.
pyprophet export \
--format=matrix \
--in=merged.osw \
--max_rs_peakgroup_qvalue=0.05 \
&>> Tutorial6_log.txt

# Run mapDIA on data to identify most perturbed proteins
# First some data curation to only extract information that mapDIA requires
cat merged.tsv | awk -F'\t' '{OFS="\t"; print $4, $1, $5, $7, $9, $6, $8, $10}' > mapDIA_input.tsv
# Actually run mapDIA
./mapDIA_win64.exe mapDIA.params

