# Change directory to the Tutorial1 folder for library generation
cd /c/DIA_Course/Tutorial1_Library/

# Sequence database search with comet
# runtime ~16 min
comet -P/c/DIA_Course/Tutorial1_Library/parameter_files/comet.params.high-high_TTOF \
-Ncollinsb_I180316_007-A \
/c/DIA_Course/Data/DDA_data/TTOF/collinsb_I180316_007-A.mzXML \
&>> Tutorial1_log.txt

# paste the command for the second comet search here!

# PeptideProphet
# runtime ~13 min

# iProphet
# runtime ~ few min

# Mayu
# runtime ~1 min

# perform manual inspection of Mayu output file to select an iprophet probability cutoff for the next step

# spectrast library creation and iRT normalization
# runtime ~7 min

# spectrast consensus spectrum generation
# runtime ~8 min

# spectrast MRM transition list generation
# runtime ~2 min

# Import from SpectraST MRM and convert to TraML
# runtime ~2 min

# Target assay generation
# runtime ~1 min

# Decoy generation
# runtime ~1 min

# convert to pqp format for OpenSWATH
# runtime ~1 min

# convert target library to tsv for manual inspection and Skyline usage
# runtime ~1 min
