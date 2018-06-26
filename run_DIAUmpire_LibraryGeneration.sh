# Change directory to the Tutorial3 folder for DIA-Umpire based library generation
cd /c/DIA_Course/Tutorial3_DIAUmpire/

# copy two DIA files to the DIA-Umpire tutorial folder
cp /c/DIA_Course/Data/DIA_data/TTOF/collinsb_I180316_001_SW-A.mzXML \
/c/DIA_Course/Tutorial3_DIAUmpire/

# paste command to copy the second DIA file here

# run DIA-Umpire
# runtime ~20 min

# convert .mgf files to .mzXML files for database search
# remember: the '*' means that the conversion is performed for all files ending with '.mgf'

# Sequence database search with comet
# remember: the '*' means that we perform the comet search for all files starting with 'collinsb' and ending on '.mzXML'
# the 'Q' in the middle is included to only use the Q1-Q3 output files from DIA-Umpire and not the raw DIA files

# PeptideProphet for each quality tier

# iProphet
# ~6min

# Mayu

# perform manual inspection of Mayu output file to select an i-prophet probability cutoff for the next step

# spectrast iRT normalization

# spectrast consensus spectrum generation
# runtime ~8 min

# spectrast MRM transition list generation
# runtime ~2 min

# Import from SpectraST MRM and convert to TraML
# runtime ~2 min

# Target assay generation
# runtime ~1 min
# seems like this file needs header - changed to swath64_w_header.txt

# Decoy generation
# runtime ~1 min

# convert to pqp format for OpenSWATH
# runtime ~1 min

# convert target library to tsv for manual inspection and Skyline usage
# runtime ~1 min
