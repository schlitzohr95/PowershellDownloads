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

#CSV Header Row -     MovieActress     MovieTitle     MoviePublished     MoviePoster     PosterFilename     MovieZip     ZipFilename     ScreenZip     ScreenFilename
Import-Csv -Path "$CSVLocation" -Delimiter ',' | 
    % {
        $ModelInitial = ($_.MovieActress).SubString(0,1)
        $ModelInitialFolder = Join-Path $WebsiteFolder $ModelInitial
        $ModelFolderPath = Join-Path $ModelInitialFolder $_.MovieActress
        $MovieFolderPath = Join-Path $ModelFolderPath $_.MovieTitle
		$PosterFolderPath = Join-Path $MovieFolderPath $_.PosterFilename
		$ZipFolderPath = Join-Path $MovieFolderPath $_.ZipFilename
		$ScreenFolderPath = Join-Path $MovieFolderPath $_.ScreenFilename
        $MoviePrint = $_.MovieTitle
        $ActressPrint = $_.MovieActress
        $PosterPrint = $_.PosterFilename
		$ZipPrint = $_.ZipFilename
		$ScreenPrint = $_.ScreenFilename
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

#Creates a folder within the Actress' based on the Movie title.
        If([string]::IsNullOrWhiteSpace($_.MovieTitle))
		{
		}
		Else
		{		
			If(Test-Path -Path "$MovieFolderPath")
			{
			Write-Output "The folder $MoviePrint already exists in this location."
			} 
			Else 
			{
			$HideMovie = New-Item -Path $MovieFolderPath -ItemType Directory
				If([string]::IsNullOrWhiteSpace($_.MoviePublished))
				{
				$HideMovie.attributes = "Hidden"
				}
				Else
				{
				$HideMovie.CreationTime = ([DateTime]::ParseExact($_.MoviePublished, 'M\/d\/yyyy', [Globalization.CultureInfo]::InvariantCulture))
				$HideMovie.attributes = "Hidden"
				}
			}
		}

#Creates the "Actress Profile" folder within the Actress' folder.
			If(Test-Path -Path "$ModelFolderPath\$ActressPrint Profile" -PathType Container){
				Write-Output "The folder $ActressPrint Profile already exists in this location."

			} Else {
			$HideActressProfile = New-Item -Path "$ModelFolderPath\$ActressPrint Profile" -ItemType Directory
			$HideActressProfile.attributes = "Hidden"
			}


#Downloads the Poster into the Movie folder.
        If([string]::IsNullOrWhiteSpace($_.MoviePoster))
		{
		}
		Else
		{			
			If(Test-Path -Path "$PosterFolderPath")
			{
			Write-Output "The file $PosterPrint already exists in this location."
			}
			Else
			{
			(New-Object System.Net.WebClient).DownloadFileAsync($_.MoviePoster, $PosterFolderPath )   
			Write-Output "$PosterPrint saved to $MoviePrint folder in $((Get-Date).Subtract($start_time).Seconds) second(s)"
			}
		}
#Downloads the Zip file of the Movie Pictures.
        If([string]::IsNullOrWhiteSpace($_.MovieZip))
		{
		}
		Else
		{				
			If(Test-Path -Path "ZipFolderPath")
			{
			Write-Output "The file $ZipPrint already exists in this location."
			}
			Else
			{
			(New-Object System.Net.WebClient).DownloadFileAsync($_.MovieZip, $ZipFolderPath)     
			Write-Output "$ZipPrint saved to $MoviePrint folder in $((Get-Date).Subtract($start_time).Seconds) second(s)"
			}
		}	
	
#Downloads the Zip file of the Movie Screenshots.
        If([string]::IsNullOrWhiteSpace($_.ScreenZip))
		{
		}
		Else
		{	
			If(Test-Path -Path "ScreenFolderPath")
			{
			Write-Output "The file $ScreenPrint already exists in this location."
			}
			Else
			{
			(New-Object System.Net.WebClient).DownloadFileAsync($_.ScreenZip, $ScreenFolderPath)   
			Write-Output "$ScreenPrint saved to $MoviePrint folder in $((Get-Date).Subtract($start_time).Seconds) second(s)"
			}
		}
		
}     