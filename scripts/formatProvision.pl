#!/usr/bin/perl

use Math::NumberCruncher;
use Math::Round;

open(infile, "<$ARGV[0]");

@fil=<infile>;
chomp @fil;

for($i=0;$i<@fil;$i++) {
 if($fil[$i] =~ m/(\d+);(\d+);(\d+)/) {
 $build[$1] += $2;
 $active[$1] += $3;
 }
}

for($k=0;$k<@build;$k++) {
 print "På tidspunkt $k er det i snitt ", ($build[$k]/$active[$#active]), " som bygger og ", ($active[$k]/5), " aktive\n";
}

print "\n\nMax: $#build\n";
