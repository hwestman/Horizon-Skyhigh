#!/usr/bin/perl

use 5.10.0;
use Math::NumberCruncher;
use Math::Round;

sub latexOneFile {
 open(FD, "<$_[0]"); @input=<FD>; chomp @input;

 $megaByte=2**10; @relevantFields = ( 9, 10, 37, 11, 12, 38, 15, 16, 40, 17, 18, 41, 24, 18, 17 );
 @operasjon=( "Seq. write, block (KB/s)", "CPU load (\\%)", "Latency", "Seq. rewrite, block (KB/s)", "CPU load (\\%)", "Latency", "Seq. read, block (KB/s)", "CPU load (\\%)", "Latency", "Random seek (operations/s)", "CPU load (\\%)", "Latency", "Seq. create files (operations/s)", "CPU load (\\%)", "Latency" );

 open(texFile, "+>$_[0].tex"); chomp @input;

 for($i=0;$i<@input;$i++) {
  @oneTest=split(/,/, $input[$i]); for($j=0;$j<@relevantFields;$j++) { given ($j) {
  when (0)  { $testArray[$i][$j]   = $oneTest[$relevantFields[$j]]; } when (3)  { $testArray[$i][$j]    = $oneTest[$relevantFields[$j]]; } default   { $testArray[$i][$j] = $oneTest[$relevantFields[$j]]; } } } }

 open (tempFile, "+>$_[0].temporary"); $num=@input; chomp @testArray;

 for($i=0;$i<@relevantFields;$i++) { 
  for($j=0;$j<@input;$j++) { 
   if($testArray[$j][$i]) { 
   print tempFile "$testArray[$j][$i]";
   if($j < $num-1) { print tempFile " "; }
    }  }
  print tempFile "\n";
 } 
 close(tempFile); open (tempFile, "<$_[0].temporary"); @temp=<tempFile>;

 print texFile "\\documentclass[a4paper]{report}\n"; print texFile "\\begin{document}\n"; print texFile "\\begin{table}[ht]\n"; print texFile "$caption"; print texFile "\\centering\n";
 print texFile "\\begin{tabular}{c | c | c | c | c | c}\n"; print texFile "\\hline\n"; print texFile "Operasjon & Gjennomsnitt & Median & Min & Maks & Differanse (maks-min) \\\\ \\hline\n";

 for($i=0;$i<@temp;$i++) {
  @oneLine=split(/ /, $temp[$i]);
  ($high,$low)=Math::NumberCruncher::Range(\@oneLine);
  print texFile "$operasjon[$i] & ";
  print texFile Math::NumberCruncher::Mean(\@oneLine), " & ";
  print texFile Math::NumberCruncher::Median(\@oneLine), " &";
  print texFile " $low & $high & ", $high-$low, " \\\\";
  if (($i+1)%3 == 0) { print texFile " \\hline"; }
  print texFile "\n";
 }
 print texFile "\\end{tabular}\n"; print texFile "\\label{table:nonlin}\n"; print texFile "\\end{table}\n"; print texFile "\\end{document}";
}

if(@ARGV > 1) {
 open (comparisonTex, "+>comparisonTex.tex");
 print comparisonTex "\\documentclass[a4paper]{report}\n"; print comparisonTex"\\begin{document}\nBlablablabla\n";
 print comparisonTex "\\begin{figure}\n\\centering\n";
  print comparisonTex "\\begin{tabular}{c|c|c|c|c|c}\n"; print comparisonTex"\\hline\n";
print comparisonTex "\\multicolumn{2}{c|}{Beskrivelse} & ";
print comparisonTex "\\multicolumn{2}{c|}{Sek. skriving} & ";
print comparisonTex "\\multicolumn{1}{c|}{Sek. lesing} & ";
print comparisonTex "\\multicolumn{1}{c}{Random} \\\\ \\hline\n ";
print comparisonTex "Maskin & Target & Blokk (KB/s) & Gjenskriv (KB/s) & Blokk (KB/s) & Seeks/s \\\\ \\hline\n";

 for($x=0;$x<@ARGV;$x++) {
  &latexOneFile($ARGV[$x]);
  open(fil, "<$ARGV[$x].temporary");
  @hei=split(/-/, $ARGV[$x]);
  print @hei;
  @result=<fil>;
  print comparisonTex "$hei[0] & $hei[1]";
  for($i=0;$i<@result;$i++) {
   @oneRow=split(/ /, $result[$i]);
   if($i == 0) { print comparisonTex Math::NumberCruncher::Mean(\@oneRow); print comparisonTex " & "; }
   if($i == 3) { print comparisonTex Math::NumberCruncher::Mean(\@oneRow); print comparisonTex " & "; }
   if($i == 6) { print comparisonTex Math::NumberCruncher::Mean(\@oneRow); print comparisonTex " & "; }
   if($i == 9) { print comparisonTex Math::NumberCruncher::Mean(\@oneRow); print comparisonTex " \\\\ \\hline\n"; }
  }
  close(fil);
 }
 print comparisonTex "\\end{tabular}\n\\caption{Baseline-resultater fra bonnie++ for forskjellige maskiner sin lokale disk
}\n\\end{figure}\n"; print comparisonTex"\\end{document}";
}

else {
 &latexOneFile($ARGV[0]);
}
