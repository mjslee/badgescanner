# badgescanner
Conference badge scanner (with timestamp) for use with reacTIVision.

Tested using Processing 2.2.1 (processing.org) and reacTIVision 1.5 (http://reactivision.sourceforge.net)

Before running the software:
1. Setup people.csv with the names and ID numbers of those you want to coorespond to the reacTIVision fiducial makers. Columns are as follows: fiducial_id, full_name, internal_id, group. (internal_id can be whatever you want; group can be whatever you want too, typically we use UG for undegrads, G for graduates, and YP for young professionnals)
2. Setup the /photos/ directory to correspond with the IDs (or names) from the CSV file. These can be JPG or PNG, but in one format for all photos. Person with fiducial ID #1 should be 1.jpg

To run the software:
1. Execute reacTIVision. This will turn on the webcam. Choose your preferred camera if you have multiple connected.
2. Execute either the processing PDE script, or a pre-compiled version of the executable.

While executing:
1. The script/executable will write and append to a CSV log file in /logs/. For each time you execute the script, a new CSV will be made with the following filename: DD-HH-SS.CSV, where DD corresponds to the day, HH to the current hour, and SS to the current seconds at execution.
