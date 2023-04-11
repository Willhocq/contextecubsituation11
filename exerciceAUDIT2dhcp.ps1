#=============================================================#
#NAME:exerciceAUDIT2dhcp.ps1                                  #
#AUTHOR:Hocquiné William,BTS SIO                              #
#DATE:11/04/2023                                              #
#                                                             #
#VERSION 1.0                                                  #
#COMMENTS: créer un script qui donne un fichier au format     #
#  texte avec les plages DHCP existante                       #
#                                                             #
#=============================================================#

$dhcpServer = "ServeurPrimaire6"
$filename = "C:\git_cub\contextecubsituation11\auditDHCP.txt"
$date = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"
# Récupération des informations sur le serveur DHCP
Get-DhcpServerInDC -ServerName $dhcpServer | Out-Null

# Récupération des plages DHCP
$dhcpScopes = Get-DhcpServerv4Scope -ComputerName $dhcpServer

# Enregistrement des plages DHCP dans le fichier texte
foreach ($scope in $dhcpScopes) {
     if ($scope.State -ne "Active") {
        Write-Host -ForegroundColor Red $scope.Name, $scope.StartRange, $scope.EndRange, $scope.SubnetMask, $scope.State
    }
    $output = "Plage DHCP : $($scope.Name)`r`n"
    $output += "Adresse de début : $($scope.StartRange)`r`n"
    $output += "Adresse de fin : $($scope.EndRange)`r`n"
    $output += "Masque de sous-réseau : $($scope.SubnetMask)`r`n"
    $output += "Durée de bail : $($scope.LeaseDuration.Days) jours`r`n`r`n"
    $output += "Status : $($scope.State)`r`n"
    $output += "DATE :" + $date + "`n"
    Add-Content -Path $filename -Value $output
}

Write-Host "Les plages DHCP ont été enregistrées dans le fichier $filename"

