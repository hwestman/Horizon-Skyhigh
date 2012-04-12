#!/usr/bin/perl

use Math::NumberCruncher;
use Math::Round;

$minArguments=2;

$iteratevmstat=0;
$iteratedd=0;
$newlines=0;

$type=$ARGV[1];
$outfile="$ARGV[0]";

sub usage() { print "Usage of $0:\n$0 <output file name> <single or multi output> <inputfiles>\n\n"; exit 0; }

open(resultfile, "+>$ARGV[0].results");
if(@ARGV >= 3) {
 for($i=2;$i<@ARGV;$i++) { 
  if(-e "$ARGV[$i]") { 
   open(infile, "<$ARGV[$i]");
   @results=<infile>;  
   if($results[0] =~ m/procs/) {
    system("egrep -v 'procs|swpd' $ARGV[$i] > $ARGV[$i].temp");
    open(tempfile, "<$ARGV[$i].temp");
    @vmstatresults=<tempfile>;
    if($type eq "multi") { $newlines=$iteratevmstat+1+$#vmstatresults; } else { $newlines=@vmstatresults; }
    while($iteratevmstat<$newlines) {
     @line=split(m/ +/, $vmstatresults[$iteratevmstat]);
     $user[$iteratevmstat]    = $line[13]; $system[$iteratevmstat]  = $line[14];
     $waiting[$iteratevmstat] = $line[16]; $idle[$iteratevmstat]    = $line[15];
     $iteratevmstat++;
    } 
 
    if($type eq "single" || ($type eq "multi" && $i == $#ARGV)) { 
     if($type eq "single") { $iteratevmstat = 0; }
     $userMean    = sprintf("%.2f", Math::NumberCruncher::Mean(\@user));
     $systemMean  = sprintf("%.2f", Math::NumberCruncher::Mean(\@system)); 
     $waitingMean = sprintf("%.2f", Math::NumberCruncher::Mean(\@waiting));
     $idleMean    = sprintf("%.2f", Math::NumberCruncher::Mean(\@idle));

     $userStd     = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@user)); 
     $systemStd   = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@system));
     $waitingStd  = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@waiting)); 
     $idleStd     = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@idle));
     if($type eq "single") { $filename = $ARGV[$i]; } else { $filename = $outfile; }

     print resultfile "\n'$filename' averages - user system waiting idle: ",
       $userMean, " ", $systemMean, " ", $waitingMean, " ", $idleMean,
       "\n'$filename' stddev - user system waiting idle: ",
       $userStd, " ", $systemStd, " ", $waitingStd, " ", $idleStd, "\n";
    }

    close(tempfile);
    system("rm $ARGV[$i].temp");
    }
    
   else {
    if($type eq "multi") { $newlines=$iteratedd; "newlines: $lines"; } else { $newlines=@results; }
     
     for($iteratedd=0;$iteratedd<@results;$iteratedd++,$newlines++) { $accumulate[$newlines] = $results[$iteratedd]; }

     if($type eq "single" || ($type eq "multi" && $i == $#ARGV)) {
      $averages = sprintf("%.2f", Math::NumberCruncher::Mean(\@accumulate));
      $std      = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@accumulate));

     if($type eq "single") { $filename = $ARGV[$i]; } else { $filename = $outfile; }
     print resultfile "'$filename' averages:\t$averages\n";
     print resultfile "'$filename' stdevs:\t$std\n"; 
     }
  }
   close(infile);
  } else { print "'$ARGV[$i]' does not exist.\n"; }
 }
} else { &usage; }

close(resultfile);
