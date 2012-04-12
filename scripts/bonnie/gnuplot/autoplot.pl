#!/usr/bin/perl

$i=0;
foreach $file (`ls testdata | grep bonnie`) {
 $i++;
 chomp($file);
 print "Plotting number ".$i.", ".$file."...\n";
 $outfile = $file;
 $outfile =~ s/\.dat$/\.png/;
 print "Converting to .png, outfile: graph_".$outfile."...\n";
 open (GNUPLOT, "|gnuplot");
 print GNUPLOT <<EOPLOT;
unset key
set boxwidth 0.5
set yrange [0:]
set style fill solid 0.1
set terminal png
set output "testdata/normalgraphs/graph_$outfile"
set title "$outfile"
set ylabel "kek"
set xlabel "keeeek"
plot "testdata/$file" using 1:2 with boxes title "heii duuuu"
EOPLOT
close(GNUPLOT);
}
