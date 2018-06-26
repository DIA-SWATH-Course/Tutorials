# Change directory to the Tutorial1 folder for library generation
cd /c/DIA_Course/Tutorial1_Library/

# Sequence database search with comet
# runtime ~16 min
comet -P/c/DIA_Course/Tutorial1_Library/parameter_files/comet.params.high-high_QE \
-Ncollinsb_X1803_177 \
/c/DIA_Course/Data/DDA_data/QE/collinsb_X1803_177.mzXML \
&>> Tutorial1_log.txt

comet -P/c/DIA_Course/Tutorial1_Library/parameter_files/comet.params.high-high_QE \
-Ncollinsb_X1803_178 \
/c/DIA_Course/Data/DDA_data/QE/collinsb_X1803_178.mzXML \
&>> Tutorial1_log.txt

# PeptideProphet
# runtime ~13 min
xinteract -dreverse_ \
-OARPd \
-Ninteract.comet.pep.xml \
collinsb_*.pep.xml \
&>> Tutorial1_log.txt

# iProphet
# runtime ~ few min
InterProphetParser DECOY=reverse_ \
interact.comet.pep.xml \
iProphet.pep.xml \
&>> Tutorial1_log.txt

# Mayu
# runtime ~1 min
perl /c/TPP/bin/Mayu.pl \
-A iProphet.pep.xml \
-C /c/DIA_Course/Data/napedro_3mixed_human_yeast_ecoli_20140403_iRT_reverse.fasta \
-E reverse_ \
-G 0.01 \
-H 101 \
-I 0 \
&>> Tutorial1_log.txt

# perform manual inspection of Mayu output file to select an iprophet probability cutoff for the next step

# spectrast library creation and iRT normalization
# runtime ~7 min 
spectrast -cNSpecLib \
-cIHCD \
-cf "Protein! ~ reverse_" \
-cP0.928079 \
-c_IRT../Data/irtkit.txt \
-c_IRR iProphet.pep.xml \
&>> Tutorial1_log.txt

# spectrast consensus spectrum generation
# runtime ~8 min
spectrast -cNSpecLib_cons \
-cIHCD \
-cAC SpecLib.splib \
&>> Tutorial1_log.txt

# spectrast MRM transition list generation
# runtime ~2 min
spectrast -cNSpecLib_pqp \
-cIHCD \
-cM \
SpecLib_cons.splib \
&>> Tutorial1_log.txt

# Import from SpectraST MRM and convert to TraML
# runtime ~2 min
TargetedFileConverter \
-in SpecLib_pqp.mrm \
-out transitionlist.TraML \
&>> Tutorial1_log.txt

# Target assay generation
# runtime ~1 min
OpenSwathAssayGenerator \
-in transitionlist.TraML \
-out transitionlist_optimized.TraML \
-swath_windows_file /c/DIA_Course/Data/dia_QE19_w_header.txt \
&>> Tutorial1_log.txt

# Decoy generation
# runtime ~1 min
OpenSwathDecoyGenerator \
-in transitionlist_optimized.TraML \
-out transitionlist_optimized_decoys.TraML \
-method shuffle \
&>> Tutorial1_log.txt

# convert to pqp format for OpenSWATH
# runtime ~1 min
TargetedFileConverter \
-in transitionlist_optimized_decoys.TraML \
-out transitionlist_optimized_decoys.pqp \
&>> Tutorial1_log.txt

# convert target library to tsv for manual inspection and Skyline usage
# runtime ~1 min
TargetedFileConverter \
-in transitionlist_optimized.TraML \
-out transitionlist_optimized.tsv \
&>> Tutorial1_log.txt


