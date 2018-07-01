## Bash basics for Linux

# See in which directory you currently are: "Print Working Directory":
pwd

# Change directory to the "DIA_course" folder on the Cdrive:
cd /c/DIA_course

# List the content of your current directory:
ls
# For better readability and more information use option -l:
ls -l

# Move around a bit to explore the data available in the course folder:
cd Data
ls -l
cd DIA_data
ls -l
cd TTOF
ls -l

# List only content with a specifc pattern (using '*' as wildcard):
# ... all files that start with "collinsb" and end on "A.mzXML"
ls -l collinsb*A.mzXML
# ... all files that start with "collinsb" and end on "B.mzXML"
ls -l collinsb*B.mzXML

# Move one directory up:
cd ..
# Check which directory you are in now:
pwd

# Change to the scripts folder on the Cdrive in the DIA_course directory:
cd /c/DIA_course/scripts

# Print text to the standard out:
echo 'DIA is awesome'

# Redirect the output to a file "testFile.txt"
echo 'DIA is awesome' &>> testFile.txt
# Check that new file was created:
ls -l
# Read file:
cat awesome.txt

# Write something into a variable:
x='Hello'
# Printing the variable with"$":
echo $x
# The variable is not interpreted Without the "$":
echo x

# Long commands may need line breaks for good readability of the code.
# The "\" at the end of a line means that the command continues in the next line.
echo \
$x
