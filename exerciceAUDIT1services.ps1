#=============================================================#
#NAME:exerciceAUDIT1service.ps1                               #
#AUTHOR:Hocquiné William,BTS SIO                              #
#DATE:11/04/2023                                              #
#                                                             #
#VERSION 1.0                                                  #
#COMMENTS: créer un script qui donne un fichier au format     #
#  texte avec la date du script                               #
#                                                             #
#=============================================================#

$date = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"
$filename = "C:\git_cub\contextecubsituation11\auditServices.txt"
$output = "DATE :" + $date + "`n"
$output += "DHCP : " + (Get-Service dhcpserver).Status + "`n"
$output += "DNS : " + (Get-Service dnscache).Status + "`n"
$output += "AD : " + (Get-Service adws).Status + "`n"

Set-Content -Path $filename -Value $output
