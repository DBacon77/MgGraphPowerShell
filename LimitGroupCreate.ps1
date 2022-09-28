using namespace Microsoft.Graph.PowerShell.Models

#Use the Beta Microsoft Graph Powershell
Select-MgProfile -Name "beta"

$GroupName = "Group Creators"
$AllowGroupCreation = $false

$scopes = @(
    "TeamsApp.ReadWrite.All",
    "TeamsAppInstallation.ReadWriteForTeam",
    "TeamsAppInstallation.ReadWriteSelfForTeam",
    "TeamSettings.ReadWrite.All",
    "TeamsTab.ReadWrite.All",
    "TeamMember.ReadWrite.All",
    "Group.ReadWrite.All",
    "GroupMember.ReadWrite.All"
	"User.ReadWrite.All"
	"Directory.ReadWrite.All"
)

Connect-MgGraph -Scopes $scopes

$settingName = 'Group.Unified'

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

#Set up our restriction.
$params = @{
	Values = @(
		@{
			Name = "EnableGroupCreation";
			Value = $AllowGroupCreation;
		}
	)
}

#Apply the restriction
Update-MgDirectorySetting -DirectorySettingId $settingsObject.id -BodyParameter $params

#Check the values from the restriction.
(Get-MgDirectorySetting | Where-Object DisplayName -EQ $settingName).Values
Write-Output "`n$line"

#Give our group permission to create groups.
if($GroupName)
{
	$GroupID = (Get-MgGroup -Filter "DisplayName eq '$GroupName'").id

	#Set up the allowed group.
	$params2 = @{
		Values = @(
			@{
				Name = "GroupCreationAllowedGroupId";
				Value = $GroupID;
			}
		)
	}
	
	#Apply the update to the group
	Update-MgDirectorySetting -DirectorySettingId $settingsObject.id -BodyParameter $params2
}
	
#Check the values.
(Get-MgDirectorySetting | Where-Object DisplayName -EQ $settingName).Values