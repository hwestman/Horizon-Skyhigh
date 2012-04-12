#!/usr/bin/perl

# This script formats Seekmark data and writes it to a file.
# Output data is Name of test, Number of threads, Seeks per thread,
# Total time, Total seeks per sec, and Access time.

# Arguments are <file with Seekmark data> and <Name of test>:
if (@ARGV != 5) {
 die("autoSeek.pl <antall tråder> <antall seeks pr tråd> <testområde>".
" <antall testjøringer> <testnavn>\n");
}

# Special characters are not allowed in the test name:
if (!($ARGV[4] =~ m/^[a-zA-Z0-9]*$/)) {
 die("Testnavnet kan ikke inneholde merkelige tegn ;)\n");
}

use Math::NumberCruncher;
use Math::Round;

$threads = $ARGV[0];
$seeks = $ARGV[1];
$testPath = $ARGV[2];
$runs = $ARGV[3];
$testName = $ARGV[4];
$bufferFile = "bufferFile.dat";

open (seekSecFD, "+>seekTest.$testName.dat") or die ("Kunne ikke åpne filen".$!);

for ($i = 0; $i < $runs; $i++) {
 print "\nTest ",$i+1," of $runs:";
 #Running Seekmark with the requested arguments:
 `sudo ./seekmark -t$threads -f$testPath -s$seeks > $bufferFile`;

 # Regexing the Seekmark file for the numbers we want:
 open (FD, "<$bufferFile") or die("Fant ikke filen eller noe sånt\n");
 foreach $line (<FD>) {
  if ($line =~ m/total time: (\d\.\d{2})/) {
   $totalTime = $1;
  }
  if ($line =~ m/^(\d*\.\d{2}) total seeks/) {
   $seekSec = $1;
  }
  if ($line =~ m/READ request\(ms\): (\d*\.\d{3})/) {
   $accessTime = $1;
  }
 }

 print "\n";
 print "Tråder: $threads.\n";
 print "Seeks pr tråd: $seeks.\n";
 print "Total tid: $totalTime sekunder.\n";
 print "$seekSec seeks per sekund.\n";
 print "Aksesstid: $accessTime"."ms.\n";
 print "\n";
 close(FD);
 $seekSecArray[$i] = round($seekSec);  # Rounding the number.
 $accessTimeArray[$i] = $accessTime;
  
 if ($i < $runs-1) {
  sleep(5);   # seekmark cool-off to fix weird results.
 }
}

$seekSecMean = sprintf("%.0f", Math::NumberCruncher::Mean(\@seekSecArray));
$seekSecStd = sprintf("%.0f", Math::NumberCruncher::StandardDeviation(\@seekSecArray));
$accessTimeMean = sprintf("%.3f", Math::NumberCruncher::Mean(\@accessTimeArray));
$accessTimeStd = sprintf("%.3f", Math::NumberCruncher::StandardDeviation(\@accessTimeArray));

print seekSecFD "$seekSecMean $seekSecStd $accessTimeMean $accessTimeStd";

print "Done!\n\n";
