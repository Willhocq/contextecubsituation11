#=============================================================#
#NAME:exerciceAUDIT4ad.ps1                                    #
#AUTHOR:Hocquiné William,BTS SIO                              #
#DATE:11/04/2023                                              #
#                                                             #
#VERSION 1.0                                                  #
#COMMENTS: créer un script qui donne un fichier au format     #
#  texte avec les info utilisateurs                           #
#                                                             #
#=============================================================#

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
