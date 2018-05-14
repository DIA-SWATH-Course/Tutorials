# start docker for the OpenSWATH, PyProphet and TRIC workflow
docker run --name osw_tutorial --rm -v /c/DIA_Course/:/data -i -t openswath/openswath:0.1.0

cd /data/Tutorial4_OpenSWATH/

# save all DIA files in a variable
DIA_filenames=`ls /data/Data/DIA_data/TTOF/collinsb*SW*.mzXML`

# run OpenSWATH for each DIA file
for file in ${DIA_filenames}
do
  name=`echo ${file} | xargs -n 1 basename`
  OpenSwathWorkflow \
  -min_upper_edge_dist 1 \
  -use_ms1_traces \
  -Scoring:stop_report_after_feature 5 \
  -tr_irt /data/Data/hroest_DIA_iRT.TraML \
  -tr /data/Tutorial1_Library/transitionlist_optimized_decoys.pqp \
  -in ${file} \
  -out_osw ${name%.*.*}.osw
done

## pyprophet
# merge results
pyprophet merge --out=merged.osw --subsample_ratio=1 collinsb*SW*.osw
# score on precursor level
pyprophet score --in=merged.osw --level=ms2
# score on peptide level
pyprophet peptide --in=merged.osw --context=run-specific \
peptide --in=merged.osw --context=experiment-wide \
peptide --in=merged.osw --context=global
# score on protein level
pyprophet protein --in=merged.osw --context=global # doesn't work!
# export results
pyprophet export --in=merged.osw --out=merged_protein_export.tsv \
--max_rs_peakgroup_qvalue 0.1 \
--no-ipf --max_global_peptide_qvalue 0.1 \
--max_global_protein_qvalue 0.05
# export scoring pdf
pyprophet export --in=merged.osw --format=score_plots

## TRIC
feature_alignment.py \
--in merged_protein_export.tsv \
--out aligned.csv \
--method LocalMST \
--realign_method lowess_cython \
--max_rt_diff 60 \
--mst:useRTCorrection True \
--mst:Stdev_multiplier 3.0 \
--target_fdr -1 \
--fdr_cutoff 0.05 \
--max_fdr_quality -1 \
--alignment_score 0.05
