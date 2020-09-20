#ModelFoldering.ps1
#Caleb Waddell

<##############################################
~~~~~~~~~~~~~~~Variable List~~~~~~~~~~~~~~~~~~~
$WebsiteFolder - path to website folder
$LetterPosition - keeps a running count of letter position in alphabet for printing
$LetterFolderPath - joins user input website folder path with the new folder name
Tests if directory exists for each letter of the alphabet,and if it does not, it
creates the new directories
#>#############################################


<#
New-Item -ItemType SymbolicLink -Path "K:\Users\cwadd\Prawn\Site\Shoplyfter\S\Sienna\Sheena Ryder" -Name "Case No. 9685254" -Value "K:\Users\cwadd\Prawn\Site\Shoplyfter\P\Peyton Robbie\Case No. 9685254"

Path that needs to link elsewhere:                                      "K:\Users\cwadd\Prawn\Site\Shoplyfter\S\Sienna\Sheena Ryder"
Name a directory folder to be made in Path that will link elsewhere:    "Case No. 9685254"
Where that symlink will open up:                                        "K:\Users\cwadd\Prawn\Site\Shoplyfter\P\Peyton Robbie\Case No. 9685254"
#>

Start-Transcript -OutputDirectory "$PSScriptRoot" -NoClobber
$CSVLocation = Read-Host -Prompt 'Please input the full path and filename for the CSV'
$WebsiteFolder = Split-Path -parent $CSVLocation

#CSV Header Row -     MovieActress	ActressPic	ActPicFilename

Import-Csv -Path "$CSVLocation" -Delimiter ',' |
% {
        $ModelInitial = ($_.MovieActress).SubString(0,1)
        $ModelInitialFolder = Join-Path $WebsiteFolder $ModelInitial
        $ModelFolderPath = Join-Path $ModelInitialFolder $_.MovieActress
	   $ActressPicFolderPath = Join-Path $ModelFolderPath $_.ActPicFilename
        $ActressPrint = $_.MovieActress
        $ActPicPrint = $_.ActPicFilename
		$start_time = Get-Date

#Creates both the Alphabet folder and then the Actress' folder.
        If(Test-Path -Path "$ModelFolderPath")
		{
          Write-Output "The folder $ActressPrint already exists in this location."
		}
		Else
		{
          $HideActress = New-Item -Path $ModelFolderPath -ItemType Directory
          $HideActress.attributes = "Hidden"
	}
	
#Downloads the Poster into the Movie folder.
		If ([string]::IsNullOrWhiteSpace($_.ActressPic))
		{
		}
		Else
		{
		If (Test-Path -Path "$ActressPicFolderPath")
		{
			Write-Output "The file $ActPicPrint already exists in this location."
		}
		Else
		{
			(New-Object System.Net.WebClient).DownloadFileAsync($_.ActressPic, $ActressPicFolderPath)
			Write-Output "$ActPicPrint saved to $ActressPrint folder in $((Get-Date).Subtract($start_time).Seconds) second(s)"
		}
	}
 }     