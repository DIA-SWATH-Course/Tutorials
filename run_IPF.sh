# Change directory to the Tutorial6 folder for the IPF workflow
cd /c/DIA_Course/Tutorial6_IPF/

# Library generation

# Decoy generation

# File conversion to pqp format

# OpenSWATH

# PyProphet nerging of seperate OpenSWATH output files
# Nore: the * again denotes a wildcard meaning that
# all files ending on .osw are used

# Score features on MS1 level

# Score features on MS2 level

# Score features on transition level

# Export a pdf with all the separate subscore distributions

# Run the IPF specific score integration

# Export the final quantification matrix
# Note: In the standard OpenSWATH tutorial we have exported the
# a tsv file. Here we now use the option to directly export a
# quantification matrix. If you want to see the difference you
# open both files in excel to compare the different formats.

# Run mapDIA on data to identify most perturbed proteins
# First some data curation to only extract information that mapDIA requires
cat merged.tsv | awk -F'\t' '{OFS="\t"; print $4, $1, $5, $7, $9, $6, $8, $10}' > mapDIA_input.tsv
# Actually run mapDIA
./mapDIA_win64.exe mapDIA.params
