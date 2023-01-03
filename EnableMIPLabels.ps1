#Use the Beta Microsoft Graph Powershell
Select-MgProfile -Name "beta"

Connect-MgGraph -Scopes "Directory.ReadWrite.All"

$settingName = 'Group.Unified'
$MIPLabels = "true"

$ErrorActionPreference = 'Stop'

#Check to see if there is a "Group.Unified" Directory Setting Already
$settingsObject = Get-MgDirectorySetting | Where-Object DisplayName -EQ $settingName
if(!$settingsObject)
{
	Write-Warning 'No existing Group.Unified directory settings found, creating new from template'
	$template = Get-MgDirectorySettingTemplate | Where-Object DisplayName -EQ $settingName
	$settingsObject = New-MgDirectorySetting -TemplateId $template.id
}

#Check the values from the template.
(Get-MgDirectorySetting | Where-Object DisplayName -EQ $settingName).Values
Write-Output "`n$line"

#Set up our changes.
$params = @{
	Values = @(
		@{
			Name = "EnableMIPLabels";
			Value = $MIPLabels;
		}
	)
}

#Apply the changes.
Update-MgDirectorySetting -DirectorySettingId $settingsObject.id -BodyParameter $params

#Check the values from the restriction.
(Get-MgDirectorySetting | Where-Object DisplayName -EQ $settingName).Values
Write-Output "`n$line"