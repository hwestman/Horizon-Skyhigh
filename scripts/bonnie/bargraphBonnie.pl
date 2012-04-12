#!/usr/bin/perl

# This script takes one or more input files (bonnie++ CSV output) 
# and formats it for later use with Derek Bruening's bar graph perl script.

use Math::NumberCruncher;
use Math::Round;

sub usage { print "Usage of $0:\n$0 [xtic description] [one or more inputfiles]\n"; }

$conversion = 2**10;
$iteration  = 0;

if($#ARGV+1 < 2) { &usage; exit 0; }

for($x=0;$x<=$#ARGV+1;$x++) {
 open(file, "<$ARGV[$x]");
 @results=<file>; 
 for($i=0;$i<@results;$i++,$iteration++) {
  @line=split(m/,/, $results[$i]);
   $seqWrite[$iteration]    = $line[9]/$conversion;
   $seqWriteCPU[$iteration] = $line[10];
   $rewrite[$iteration]     = $line[11]/$conversion;
   $rewriteCPU[$iteration]  = $line[12];
   $seqRead[$iteration]     = $line[15]/$conversion;
   $seqReadCPU[$iteration]  = $line[16];
   $randomSeek[$iteration]  = $line[17];
 close(file);
 }
}

open(file,       "+>$ARGV[0].speeds");
open(randomfile, "+>$ARGV[0].random");
open(cpufile,    "+>$ARGV[0].cpu"   );

$seqReadMean     = round(Math::NumberCruncher::Mean(\@seqRead ));
$seqReadCPUMean  = Math::NumberCruncher::Mean(\@seqReadCPU     );
$seqWriteMean    = round(Math::NumberCruncher::Mean(\@seqWrite));
$seqWriteCPUMean = Math::NumberCruncher::Mean(\@seqWriteCPU    );
$rewriteMean     = round(Math::NumberCruncher::Mean(\@rewrite ));
$rewriteCPUMean  = Math::NumberCruncher::Mean(\@rewriteCPU     );
$randomSeekMean  = Math::NumberCruncher::Mean(\@randomSeek     );

$seqReadStd     = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@seqRead     ));
$seqReadCPUStd  = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@seqReadCPU  ));
$seqWriteStd    = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@seqWrite    ));
$seqWriteCPUStd = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@seqWriteCPU ));
$rewriteStd     = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@rewrite     ));
$rewriteCPUStd  = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@rewriteCPU  ));
$randomSeekStd  = sprintf("%.2f", Math::NumberCruncher::StandardDeviation(\@randomSeek  ));

print file   "# Averages for this scenario - seqread seqwrite rewrite\n$ARGV[0] ",
             $seqReadMean, " ", $seqWriteMean, " ", $rewriteMean,
             "\n\n# Standard deviation for this scenario: seqread seqwrite rewrite\n$ARGV[0] ",
             $seqReadStd, " ", $seqWriteStd, " ", $rewriteStd, "\n";

print randomfile "# Averages for this scenario - randomseek\n$ARGV[0] ",
             $randomSeekMean,
             "\n\n # Standard deviation for this scenario: randomseek\n$ARGV[0] ",
             $randomSeekStd, "\n";

print cpufile "# Averages for this scenario - seqreadcpu seqwritecpu rewritecpu\n$ARGV[0] ",
             $seqReadCPUMean, " ", $seqWriteCPUMean, " ", $rewriteCPUMean,
             "\n\n # Standard deviation for this scenario: seqwrite\n$ARGV[0] ",
             $seqReadCPUStd, " ", $seqWriteCPUStd, " ", $rewriteCPUStd;

print "Finished. Your output can be found in '$ARGV[0].speeds'\n";

close(file);
close(random);
close(cpufile);
