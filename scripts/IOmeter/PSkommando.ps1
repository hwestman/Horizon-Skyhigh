(get-content results.csv)[13..14] > resultcsv.txt; import-csv resultcsv.txt > result.txt; Get-Content .\result.txt | Select-String "Read MBps" | foreach { $_.ToString().split(":")[1] | foreach {$_.TrimStart()} }

Remove-Item resultcsv.txt

Write-Host "Trykk en tast for å avslutte ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")