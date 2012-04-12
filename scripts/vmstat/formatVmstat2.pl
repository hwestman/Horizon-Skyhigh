#!/usr/bin/perl

use Math::NumberCruncher;
use Math::Round;

$argumentNum = 1;

sub usage { print "Usage of $0:\n$0 [ inputfile ] [ name of scenario ]\n\n"; exit 0; }

if ($#ARGV+1 != $argumentNum) { &usage; }
if (!-e $ARGV[0]) { print "Inputfile '$ARGV[0]' does not exist.\n\n"; &usage; }

system("egrep -v 'procs|swpd' $ARGV[0] > $ARGV[0].temp");

open(file, "<$ARGV[0].temp");
@results=<file>;

for($i=0;$i<@results;$i++) {
 @line=split(m/ +/, $results[$i]);
 $system[$i]  = $line[14];
 $waiting[$i] = $line[16];
}

close(file);
open(file, "+>$ARGV[0].formatted");

$systemMean  = sprintf("%.2f", Math::NumberCruncher::Mean(\@system));
$waitingMean = sprintf("%.2f", Math::NumberCruncher::Mean(\@waiting));

$systemStd   = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@system));
$waitingStd  = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@waiting));

print "# Averages for this scenario - system waiting\n$ARGV[0]\n",
           $systemMean, " ", $waitingMean,
           "\n\n # Standard deviation for this scenario: system waiting\n$ARGV[0]\n",
           $systemStd, " ", $waitingStd, "\n";

print "Finished. Your output can be found in '$ARGV[0].formatted'\n";

close(file);

system("rm $ARGV[0].temp");
