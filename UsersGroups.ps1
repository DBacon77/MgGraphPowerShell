$scopes = @(
	"TeamMember.ReadWrite.All",
    "Group.ReadWrite.All",
    "GroupMember.ReadWrite.All"
	"User.ReadWrite.All"
)

Connect-MgGraph -Scopes $scopes

$users = Get-MgUser -Property "displayName,id" -All
foreach ($user in $users) {
	Write-Output $user.displayName
	$groups = Get-MgUserMemberOf -UserId $user.id
	foreach($group in $groups) {
		$gname = Get-MgGroup -GroupId $group.id -Property "DisplayName,Id"
		Write-Output $gname.DisplayName 
	}
	Write-Output "`n$line"
}
