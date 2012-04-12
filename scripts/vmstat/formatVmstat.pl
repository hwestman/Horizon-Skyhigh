#!/usr/bin/perl

use Math::NumberCruncher;
use Math::Round;

$argumentNum = 2;

sub usage { print "Usage of $0:\n$0 [ inputfile ] [ name of scenario ]\n\n"; exit 0; }

if ($#ARGV+1 != $argumentNum) { &usage; }
if (!-e $ARGV[0]) { print "Inputfile '$ARGV[0]' does not exist.\n\n"; &usage; }

system("egrep -v 'procs|swpd' $ARGV[0] > $ARGV[0].temp");

open(file, "<$ARGV[0].temp");
@results=<file>;

for($i=0;$i<@results;$i++) {
 @line=split(m/ +/, $results[$i]);
 $user[$i]    = $line[13];
 $system[$i]  = $line[14];
 $waiting[$i] = $line[16];
 $idle[$i]    = $line[15];
}

close(file);
open(file, "+>$ARGV[0].formatted");

$userMean    = sprintf("%.2f", Math::NumberCruncher::Mean(\@user));
$systemMean  = sprintf("%.2f", Math::NumberCruncher::Mean(\@system));
$waitingMean = sprintf("%.2f", Math::NumberCruncher::Mean(\@waiting));
$idleMean    = sprintf("%.2f", Math::NumberCruncher::Mean(\@idle));

$userStd     = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@user));
$systemStd   = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@system));
$waitingStd  = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@waiting));
$idleStd     = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@idle));

print "# Averages for this scenario - user system waiting idle\n$ARGV[1] ",
           $userMean, " ", $systemMean, " ", $waitingMean, " ", $idleMean,
           "\n\n # Standard deviation for this scenario: user system waiting idle\n$ARGV[1] ",
           $userStd, " ", $systemStd, " ", $waitingStd, " ", $idleStd, "\n";

print "Finished. Your output can be found in '$ARGV[0].formatted'\n";

close(file);

system("rm $ARGV[0].temp");
