#=============================================================#
#NAME:exerciceAUDIT3dns.ps1                                   #
#AUTHOR:Hocquiné William,BTS SIO                              #
#DATE:11/04/2023                                              #
#                                                             #
#VERSION 1.0                                                  #
#COMMENTS: créer un script qui donne un fichier au format     #
#  texte avec les plages DHCP existante                       #
#                                                             #
#=============================================================#





$dnsZone = "local.californie.cub.sioplc.fr"
$outputFile = "C:\git_cub\contextecubsituation11\auditDNS.txt"

# Récupération des enregistrements de type A pour la zone DNS spécifiée
$dnsRecords = Get-DnsServerResourceRecord -ZoneName $dnsZone -RRType A 

# Stockage des enregistrements dans un fichier texte avec la date et l'heure actuelles
foreach ($record in $dnsRecords) {
    $record | Out-File -FilePath $outputFile -Append 
    
}
(Get-Item $outputFile).CreationTime.ToString("dd/MM/yyyy HH:mm:ss") + "`n" + (Get-Content $outputFile) | Set-Content $outputFile

Write-Host "Les enregistrements de type A pour la zone DNS '$dnsZone' ont été enregistrés dans le fichier '$outputFile'."


