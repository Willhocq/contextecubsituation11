#=============================================================#
#NAME:exerciceAUDIT                                           #
#ad.ps1                                                       #
#AUTHOR:Hocquiné William,BTS SIO                              #
#DATE:11/04/2023                                              #
#                                                             #
#VERSION 1.0                                                  #
#COMMENTS: créer un script qui donne un fichier au format     #
#  texte avec les info utilisateurs                           #
#                                                             #
#=============================================================#

Add-Type -AssemblyName System.Windows.Forms

# Créer une nouvelle fenêtre
$form = New-Object System.Windows.Forms.Form
$form.Text = "Mes Scripts PowerShell"
$form.Width = 300
$form.Height = 200
$form.StartPosition = "CenterScreen"

# Créer un bouton pour exécuter le premier script
$button1 = New-Object System.Windows.Forms.Button
$button1.Text = "Script 1"
$button1.Location = New-Object System.Drawing.Point(50, 20)
$button1.Width = 200
$button1.Height = 30
$button1.Add_Click({
    # Insérer le code pour exécuter le premier script ici
    $date = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"
$filename = "C:\git_cub\contextecubsituation11\auditServices.txt"
$output = "DATE :" + $date + "`n"
$output += "DHCP : " + (Get-Service dhcpserver).Status + "`n"
$output += "DNS : " + (Get-Service dnscache).Status + "`n"
$output += "AD : " + (Get-Service adws).Status + "`n"

Set-Content -Path $filename -Value $output

})
$form.Controls.Add($button1)

# Créer un bouton pour exécuter le deuxième script
$button2 = New-Object System.Windows.Forms.Button
$button2.Text = "Script 2"
$button2.Location = New-Object System.Drawing.Point(50, 60)
$button2.Width = 200
$button2.Height = 30
$button2.Add_Click({
    # Insérer le code pour exécuter le deuxième script ici
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
})
$form.Controls.Add($button2)

# Créer un bouton pour exécuter le troisième script
$button3 = New-Object System.Windows.Forms.Button
$button3.Text = "Script 3"
$button3.Location = New-Object System.Drawing.Point(50, 100)
$button3.Width = 200
$button3.Height = 30
$button3.Add_Click({
    # Insérer le code pour exécuter le troisième script ici
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
})
$form.Controls.Add($button3)

# Créer un bouton pour exécuter le quatrième script
$button4 = New-Object System.Windows.Forms.Button
$button4.Text = "Script 4"
$button4.Location = New-Object System.Drawing.Point(50, 140)
$button4.Width = 200
$button4.Height = 30
$button4.Add_Click({
    # Insérer le code pour exécuter le quatrième script ici
    # Chemin et nom de fichier de sortie
$outputDirectory = "C:\git_cub\contextecubsituation11"
$outputFilename = "auditAD.txt"
$outputFile = Join-Path $outputDirectory $outputFilename

# Récupération des informations sur tous les comptes utilisateurs dans le domaine
$users = Get-ADUser -Filter * -Properties *

# Stockage des informations des comptes utilisateurs dans un fichier texte avec la date et l'heure actuelles
foreach ($user in $users) {
    $line =  $user.SamAccountName, $user.DisplayName, $user.EmailAddress, $user.UserPrincipalName, $user.Enabled + "`n" 
    $line | Out-File -FilePath $outputFile -Append
}

# Ajout de la date et l'heure de création du fichier dans le fichier texte
(Get-Item $outputFile).CreationTime.ToString("dd/MM/yyyy HH:mm:ss") + "`n" + (Get-Content $outputFile) | Set-Content $outputFile

Write-Host "Les informations sur tous les comptes utilisateurs ont été enregistrées dans le fichier '$outputFile'."
})
$form.Controls.Add($button4)

# Afficher la fenêtre
$form.ShowDialog() | Out-Null
