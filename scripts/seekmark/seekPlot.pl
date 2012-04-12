#!/usr/bin/perl

@tests = @ARGV;
$i = 0;
foreach $test (@tests) {
 # Finding the name of the test for later use with Bargraph:
 $test =~ m/.*\.(.*)\.dat/;
 $testName[$i] = $1;

 open(seekTestFD, "<$test") or die($!);
 for $line (<seekTestFD>) {
  @columns = split /\ /, $line; # Split the seek and access times.
 }
 $seekTableRows[$i] = $columns[0];
 $seekYerrorRows[$i] = $columns[1];
 $accessTimeTableRows[$i] = $columns[2];
 $accessTimeYerrorRows[$i++] = $columns[3]
}

open (FD, "+>seekSecPlotterFile.dat") or die($!);
print FD "=cluster SeeksPerSec\n";
print FD "title=Heiiijjjduuu\n";
print FD "ylabel=ylabel goes here\n";
print FD "=noupperright\n";
print FD "fontsz=8\n";
print FD "legendx=right\n";
print FD "=norotate\n";
print FD "legendy=center\n";
print FD "xlabel=xlabel goes here\n";
print FD "yformat=%g\n";
print FD "=table\n";
for ($j = 0; $j < $#ARGV+1; $j++) {
 print FD "$testName[$j] $seekTableRows[$j]\n";
}
print FD "\n=yerrorbars\n";
for ($j = 0; $j < $#ARGV+1; $j++) {
 print FD "$testName[$j] $seekYerrorRows[$j]\n";
}
close(FD);

open (FD, "+>accessTimePlotterFile.dat") or die($!);
print FD "=cluster AccessTime\n";
print FD "title=Heiiijjjduuu\n";
print FD "ylabel=ylabel goes here\n";
print FD "=noupperright\n";
print FD "fontsz=8\n";
print FD "legendx=right\n";
print FD "=norotate\n";
print FD "legendy=center\n";
print FD "xlabel=xlabel goes here\n";
print FD "yformat=%g\n";
print FD "=table\n";
for ($j = 0; $j < $#ARGV+1; $j++) {
 print FD "$testName[$j] $accessTimeTableRows[$j]\n";
}
print FD "\n=yerrorbars\n";
for ($j = 0; $j < $#ARGV+1; $j++) {
 print FD "$testName[$j] $accessTimeYerrorRows[$j]\n";
}
close(FD);

print "\nPlotting with Bargraph...\n";
`./bargraph.pl -pdf seekSecPlotterFile.dat > graf.seekSec.pdf`;
`./bargraph.pl -pdf accessTimePlotterFile.dat > graf.accessTime.pdf`;

print "Removing unnecessary files...\n";
system("rm", "bufferFile.dat", "seekSecPlotterFile.dat", "accessTimePlotterFile.dat");
print "Remaining files should probably be backed up somewhere.\n";

print "Done!\n\n";
