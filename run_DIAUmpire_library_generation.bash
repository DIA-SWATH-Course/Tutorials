docker run --name DIAUmpire_tutorial --rm -v /c/DIA_Course/:/data -i -t biocontainers/dia-umpire:latest

cd /data/Tutorial3_DIAUmpire/

# copy two DIA files to the DIA-Umpire tutorial folder
cp /data/Data/DIA_data/TTOF/collinsb_I180316_001_SW-A.mzXML /data/Tutorial3_DIAUmpire/
cp /data/Data/DIA_data/TTOF/collinsb_I180316_002_SW-B.mzXML /data/Tutorial3_DIAUmpire/

# run DIA-Umpire
java -jar -Xmx8G /home/biodocker/bin/DIA-Umpire/v2.1.2/DIA_Umpire_SE.jar collinsb_I180316_001_SW-A.mzXML diaumpire_se_ABSciex_params.txt
java -jar -Xmx8G /home/biodocker/bin/DIA-Umpire/v2.1.2/DIA_Umpire_SE.jar collinsb_I180316_002_SW-B.mzXML diaumpire_se_ABSciex_params.txt

# convert .mgf files to .mzXML files for database search 
# remember: the '*' means that the conversion is performed for all files ending with '.mgf' 
msconvert --mzXML *.mgf

# Sequence database search with comet
# remember: the '*' means that we perform the comet search for all files starting with 'collinsb' and ending on '.mzXML'
# the 'Q' in the middle is included to only use the Q1-Q3 output files from DIA-Umpire and not the raw DIA files
comet -P/data/Tutorial1_Library/comet.params.high-high_TTOF collinsb_*Q*.mzXML

# PeptideProphet
xinteract -dreverse_ -OARPd -Ninteract.comet.pep.xml collinsb_.pep.xml

# iProphet
InterProphetParser DECOY=reverse_ interact.comet.pep.xml iProphet.pep.xml

# Mayu
Mayu.pl -A iProphet.pep.xml -C /data/Data/napedro_3mixed_human_yeast_ecoli_20140403_iRT_reverse.fasta -E reverse_ -G 0.01 -H 101 -I 0

# perform manual inspection of Mayu output file to select an i-prophet probability cutoff for the next step

# spectrast iRT normalization
spectrast -cNSpecLib -cICID-QTOF -cf "Protein! ~ reverse_" -cP0.975302 -c_IRT/data/Data/irtkit.txt -c_IRR iProphet.pep.xml

# spectrast consensus spectrum generation for each peptide sequence
spectrast -cNSpecLib_cons -cICID-QTOF -cAC SpecLib.splib

# spectrast MRM transition list generation
spectrast -cNSpecLib_pqp -cICID-QTOF -cM SpecLib_cons.splib

# Start docker session for OpenSWATH library generation (grosenberger/openswath:latest):
# This starts a docker session named "osw_tutorial" and stores data
# from the "DIACourse" directory in a local "data" directory
docker run --name osw_tutorial --rm -v /c/DIA_Course/:/data -i -t openswath/openswath:0.1.0

cd /data/Tutorial1_Library/

# Import from SpectraST MRM and convert to TraML
TargetedFileConverter -in SpecLib_pqp.mrm -out transitionlist.TraML

# Target assay generation
OpenSwathAssayGenerator -in transitionlist.TraML -out transitionlist_optimized.TraML -swath_windows_file /data/Data/swath64_noheader.txt

# Decoy generation
OpenSwathDecoyGenerator -in transitionlist_optimized.TraML -out transitionlist_optimized_decoys.TraML -method shuffle

# convert to pqp format for OpenSWATH 
TargetedFileConverter -in transitionlist_optimized_decoys.TraML -out transitionlist_optimized_decoys.pqp

# convert to csv for manual inspection
TargetedFileConverter -in transitionlist_optimized_decoys.TraML -out transitionlist_optimized_decoys.tsv
