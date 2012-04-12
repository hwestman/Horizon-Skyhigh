#!/usr/bin/perl
use 5.10.0;

# Makes gnuplot graphs with error-bars for the bonnie++ tests:

use Math::NumberCruncher;

# Check if an argument has been passed:
# Arguments with directory path, filename and output directory for graph required.
if (@ARGV != 3) {
 die "\nError: Arguments are (3): <Path to input data directory> <Common name for bonnie files (greped)>  <Path to output data directory>.\n\n";
}

#Check if output directory exists:
if (! -d $ARGV[2]) {
 die "\nError: Your second argument is not an existing directory.\n\n";
}


##################### Set variables ###########################

$inDir = $ARGV[0];         # Path to result files from bonnie++.
$useTheseFiles = $ARGV[1]; # Files from bonnie++ to use.
$outDir = $ARGV[2];        # Folder where graphs shall be output.
$mergedFileDir = "$inDir/errorgraphs"; # Path to file with mean, low and high from bonnie.
@folderFiles = `ls $inDir | grep $useTheseFiles`;
$yhigh = 0;
$xrange = 0;


################# Run-through of bonnie++ result files ##################

# Clear errorbar data file of old tests:
open(FD, "+>$mergedFileDir/mergedErrorbarFile.txt") or die("RUN FOREST, RUN! $!");
close(FD);


# For all bonnie++ result files, inserts high, low and mean of bonnie++ results into file mergedErrorbarFile for later use by gnuplot:
 $j = 0;
foreach $bonnieFile (@folderFiles) {
 $i = 0;
 $j++;
 chomp($bonnieFile);  # Remove newline in filename.
 #@fileNames[$i] = $bonnieiFile;  # Store test result filename for the xrange names.

 # Open each file:
 open (FD, "<$inDir/$bonnieFile") or die("NOOOOOOOOOOOOOoooooooooo! $!");
 @file = <FD>;
 $xrange++;               # counting to know what to set xrange to.
 #For each line in the file:
 foreach $line (@file) {
  @columns = split /\ /, $line;   # Split columns in file on spaces
  # Insert first column to freqArray (frequency of the results):
  @freqArray[$i++] = @columns[0]; 
 }
 close(FD);

 # Calculate high, low and mean values:
 $yhighOld = $yhigh;
 ($yhigh,$ylow)=Math::NumberCruncher::Range(\@freqArray);
 $mean=Math::NumberCruncher::Mean(\@freqArray);
 # Automatically find the highest yrange of all tests:
 $yrange = ($yhighOld > $yhigh ? $yhighOld : $yhigh)+10;

 # Write values to file:
 # Appends for each test with test number in the first column. 
 open (FD, "+>$mergedFileDir/mergedErrorbarFile$j.txt") or die("JESUS! NOOOOOO! $!");
 print FD "$bonnieFile $mean $ylow $yhigh\n";
 close(FD);
}


############### Prepare the GNUplotting ###########################
# Open file with high, low and mean values:
# Set paths.

@file = open (FD1, "<$mergedFileDir/mergedErrorbarFile1.txt") or die("AWW NAWWW! $!");
open (FD2, "<$mergedFileDir/mergedErrorbarFile2.txt") or die("AWW NAWWW! $!");
open (FD3, "<$mergedFileDir/mergedErrorbarFile3.txt") or die("AWW NAWWW! $!");
$outfile = "graph_errorbars.png";
$mergedBonniefile = "$mergedFileDir/mergedErrorbarFile.txt";

 
###################### GNUplotting ################################
# Makes one graph which contains the error-bars from ALL the tests:

print "\nPlotting error-bars with GNUPLOT...\nOutfile: ".$outDir."/".$outfile."\n";
given ($j) {
when (1) {
open (GNUPLOT, "|gnuplot");
print GNUPLOT <<EOPLOT;
unset key
set terminal png
set output "$outDir/$outfile"
set xrange [-1:$xrange]
set yrange [0:$yrange]
set xtics rotate by -90
plot "$mergedFileDir/mergedErrorbarFile1.txt" using 0:2:3:4:xticlabels(1) with errorbar lc rgb "#c50000"
EOPLOT
close(GNUPLOT);
close(FD1);
close(FD2);
close(FD3);
}
when (2) {
open (GNUPLOT, "|gnuplot");
print GNUPLOT <<EOPLOT;
unset key
set terminal png
set output "$outDir/$outfile"
set xrange [-1:$xrange]
set yrange [0:$yrange]
set xtics rotate by -90
plot "$mergedFileDir/mergedErrorbarFile1.txt" using 0:2:3:4:xticlabels(1) with errorbar lc rgb "#c50000, $mergedFileDir/mergedErrorbarFile2.txt"
EOPLOT
close(GNUPLOT);
close(FD1);
close(FD2);
close(FD3);
}
when (3) {
open (GNUPLOT, "|gnuplot");
print GNUPLOT <<EOPLOT;
unset key
set terminal png
set output "$outDir/$outfile"
set xrange [-1:$xrange]
set yrange [0:$yrange]
set xtics rotate by -90
plot "$mergedFileDir/mergedErrorbarFile1.txt" using 0:2:3:4:xticlabels(1) with errorbar lc rgb "#c50000", "$mergedFileDir/mergedErrorbarFile2.txt" using 0:2:3:4:xticlabels(1) with errorbar lc rgb "#c50000", "$mergedFileDir/mergedErrorbarFile3.txt" using 0:2:3:4:xticlabels(1) with errorbar lc rgb "#c50000"
EOPLOT
close(GNUPLOT);
close(FD1);
close(FD2);
close(FD3);
}
default { print "heiiheiii"; 
close(FD1);
close(FD2);
close(FD3);
}

}
print "Done!\n\n"
