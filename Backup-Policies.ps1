# This is to retrieve/backup all the Conditional Access Policies
Set-ExecutionPolicy RemoteSigned
Install-Module Microsoft.Graph.Identity.SignIns -Scope CurrentUser -Force
Import-Module Microsoft.Graph.Identity.SignIns -Force
Connect-MgGraph

$AllPolicies = Get-MgIdentityConditionalAccessPolicy

foreach ($Policy in $AllPolicies) {

    Write-Output "Backing up $($Policy.DisplayName)"

    $PolicyJSON = $Policy | ConvertTo-Json -Depth 6

    $PolicyJSON | Out-File ".\$($Policy.DisplayName).json"
}
