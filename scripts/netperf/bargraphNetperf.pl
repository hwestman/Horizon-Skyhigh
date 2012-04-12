#!/usr/bin/perl

# This script takes one or more input files (netperf tab-separated output) 
# and formats it for later use with Derek Bruening's bar graph perl script.

use Math::NumberCruncher;
use Math::Round;

sub usage { print "Usage of $0:\n$0 [scenario number] [inputfiles]\n"; }

if($#ARGV+1 < 2) { &usage; exit 0; }

$iteration = 0;

for($x=1;$x<@ARGV;$x++) {
 open(inputfile, "<$ARGV[$x]");
 @results=<inputfile>; 
 for($i=0;$i<@results;$i++,$iteration++) {
  @line=split(m/\D+/, $results[$i]);
  $bandWidth[$iteration] = $line[6];
  $cpuLocal[$iteration]  = $line[8];
  $cpuRemote[$iteration] = $line[10];
 }
 close(inputfile);
}

open(outputfile,"+>$ARGV[0].formatted");

$bandWidthMean = Math::NumberCruncher::Mean(\@bandWidth);
$cpuLocalMean  = Math::NumberCruncher::Mean(\@cpuLocal );
$cpuRemoteMean = Math::NumberCruncher::Mean(\@cpuRemote);

$bandWidthStd  = Math::NumberCruncher::StandardDeviation(\@bandWidth, 2);
$cpuLocalStd   = Math::NumberCruncher::StandardDeviation(\@cpuLocal,  2);
$cpuRemoteStd  = Math::NumberCruncher::StandardDeviation(\@cpuRemote, 2);

print outputfile   "# Averages for this scenario - bandwidth cpulocal cpuremote\n$ARGV[0] ",
             $bandWidthMean, " ", $cpuLocalMean, " ", $cpuRemoteMean,
             "\n\n# Standard deviation for this scenario: bandwidth cpulocal cpuremote\n$ARGV[0] ",
             $bandWidthStd, " ", $cpuLocalStd, " ", $cpuRemoteStd, "\n";

print "Finished. Your output can be found in '$ARGV[0].formatted'\n";

close(outputfile);
