#!/usr/bin/perl

use Math::NumberCruncher;
use Math::Round;

open(file, "<$ARGV[0]");
@fil=<file>;

print $ARGV[0],":";
for($i=0;$i<@fil;$i++) {
 $arr[$i] = $fil[$i];
}

$hei = sprintf("%.2f", round(Math::NumberCruncher::Mean(\@arr))/1024);
$std = sprintf("%.2f", round(Math::NumberCruncher::StandardDeviation(\@arr))/1024);

 print "\n\tSnitt: ", $hei,
       "\n\tStd: ", $std;
 print "\n";

close(file);
