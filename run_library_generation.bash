# Start docker session for TPP database search generation (biocontainers/tpp:latest):
# This starts a docker session named "tpp_tutorial" and stores data
# from the "DIA_Course" directory in a local "data" directory
docker run --name tpp_tutorial --rm -v /c/DIA_Course/:/data -i -t biocontainers/tpp:latest

cd /data/Tutorial1_Library/

# Sequence database search with comet
comet -Pcomet.params.high-high_TTOF -Ncollinsb_I180316_007-B /data/Data/DDA_data/TTOF/collinsb_I180316_007-B.mzXML
comet -Pcomet.params.high-high_TTOF -Ncollinsb_I180316_008-A /data/Data/DDA_data/TTOF/collinsb_I180316_008-A.mzXML

# PeptideProphet
xinteract -dreverse_ -OARPd -Ninteract.comet.pep.xml collinsb_*.pep.xml

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

# exit TPP docker image 
exit 

# Start docker session for OpenSWATH library generation (openswath/openswath:0.1.0):
# This starts a docker session named "osw_tutorial" and stores data
# from the "DIA_Course" directory in a local "data" directory
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

# exit openswath docker image
exit 