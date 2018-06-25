# Change directory to the Tutorial3 folder for DIA-Umpire based library generation
cd /c/DIA_Course/Tutorial3_DIAUmpire/

# copy two DIA files to the DIA-Umpire tutorial folder
cp /c/DIA_Course/Data/DIA_data/QE/collinsb_X1803_171.mzXML \
/c/DIA_Course/Tutorial3_DIAUmpire/

cp /c/DIA_Course/Data/DIA_data/QE/collinsb_X1803_172.mzXML \
/c/DIA_Course/Tutorial3_DIAUmpire/

# run DIA-Umpire
# runtime ~20 min
java -jar -Xmx8G DIA_Umpire_SE.jar \
collinsb_X1803_171.mzXML \
./parameter_files/diaumpire_se_Thermo_params_DIACourse.txt \
&>> Tutorial3_log.txt

java -jar -Xmx8G DIA_Umpire_SE.jar \
collinsb_X1803_172.mzXML \
./parameter_files/diaumpire_se_Thermo_params_DIACourse.txt \
&>> Tutorial3_log.txt

# convert .mgf files to .mzXML files for database search 
# remember: the '*' means that the conversion is performed for all files ending with '.mgf' 
msconvert --mzXML *.mgf \
&>> Tutorial3_log.txt

# Sequence database search with comet
# remember: the '*' means that we perform the comet search for all files starting with 'collinsb' and ending on '.mzXML'
# the 'Q' in the middle is included to only use the Q1-Q3 output files from DIA-Umpire and not the raw DIA files
comet -P/c/DIA_Course/Tutorial1_Library/parameter_files/comet.params.high-high_QE \
collinsb_*Q*.mzXML \
&>> Tutorial3_log.txt

# PeptideProphet for each quality tier
xinteract -dreverse_ \
-OARPd \
-Ninteract_Q1.comet.pep.xml \
collinsb_*Q1*.pep.xml \
&>> Tutorial3_log.txt

xinteract -dreverse_ \
-OARPd \
-Ninteract_Q2.comet.pep.xml \
collinsb_*Q2*.pep.xml \
&>> Tutorial3_log.txt

xinteract -dreverse_ \
-OARPd \
-Ninteract_Q3.comet.pep.xml \
collinsb_*Q3*.pep.xml \
&>> Tutorial3_log.txt

# iProphet
# ~6min
InterProphetParser DECOY=reverse_ \
interact*.pep.xml \
iProphet.pep.xml \
&>> Tutorial3_log.txt

# Mayu
perl /c/TPP/bin/Mayu.pl \
-A iProphet.pep.xml \
-C /c/DIA_Course/Data/napedro_3mixed_human_yeast_ecoli_20140403_iRT_reverse.fasta \
-E reverse_ \
-G 0.01 \
-H 101 \
-I 0 \
&>> Tutorial3_log.txt

# perform manual inspection of Mayu output file to select an i-prophet probability cutoff for the next step

# spectrast iRT normalization
spectrast -cNSpecLib \
-cIHCD \
-cf "Protein! ~ reverse_" \
-cP0.961339 \
-c_IRT/data/Data/irtkit.txt \
-c_IRR iProphet.pep.xml \
&>> Tutorial3_log.txt

# spectrast consensus spectrum generation
# runtime ~8 min
spectrast -cNSpecLib_cons \
-cIHCD \
-cAC SpecLib.splib \
&>> Tutorial3_log.txt

# spectrast MRM transition list generation
# runtime ~2 min
spectrast -cNSpecLib_pqp \
-cIHCD \
-cM \
SpecLib_cons.splib \
&>> Tutorial3_log.txt

# Import from SpectraST MRM and convert to TraML
# runtime ~2 min
TargetedFileConverter \
-in SpecLib_pqp.mrm \
-out transitionlist.TraML \
&>> Tutorial3_log.txt

# Target assay generation
# runtime ~1 min
# seems like this file needs header - changed to swath64_w_header.txt
OpenSwathAssayGenerator \
-in transitionlist.TraML \
-out transitionlist_optimized.TraML \
-swath_windows_file /c/DIA_Course/Data/dia_QE19_w_header.txt \
&>> Tutorial3_log.txt

# Decoy generation
# runtime ~1 min
OpenSwathDecoyGenerator \
-in transitionlist_optimized.TraML \
-out transitionlist_optimized_decoys.TraML \
-method shuffle \
&>> Tutorial3_log.txt

# convert to pqp format for OpenSWATH
# runtime ~1 min
TargetedFileConverter \
-in transitionlist_optimized_decoys.TraML \
-out transitionlist_optimized_decoys.pqp \
&>> Tutorial3_log.txt

# convert target library to tsv for manual inspection and Skyline usage
# runtime ~1 min
TargetedFileConverter \
-in transitionlist_optimized.TraML \
-out transitionlist_optimized.tsv \
&>> Tutorial3_log.txt

