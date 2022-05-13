param(
    [parameter()]
    [String]$AppId,
    [parameter()]
    [String]$TenantId,
    [parameter()]
    [String]$ClientSecret
)

$Body = @{
Grant_Type    = "client_credentials"
Scope         = "https://graph.microsoft.com/.default"
client_Id     = $AppId
Client_Secret = $ClientSecret
}

$ConnectGraph = Invoke-RestMethod -Uri https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token -Method POST -Body $Body
$token = $ConnectGraph.access_token
Write-Output "The token $token has been processed."

$BackupJsons = Get-ChildItem $BackupPath -Recurse -Include *.json
foreach ($Json in $BackupJsons) {
    
    $json = Get-Content $Json.FullName | Out-String | ConvertFrom-Json
    $json.PSObject.Properties.Remove('createdDateTime')
    $json.PSObject.Properties.Remove('modifiedDateTime')
    Write-Output "The json is $($json|ConvertTo-Json) ."
    Invoke-WebRequest -Verbose -UseBasicParsing https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies/$($json.id) -Headers @{Authorization = "Bearer $($token)"} -ContentType "application/json" -Method PATCH -Body $($json | ConvertTo-Json -Depth 10)
}

Write-Output "Adding new policies from the /new_jsons/ folder"
$new_jsons = Get-ChildItem "new_jsons/" -Recurse -Include *.json
foreach ($new_json in $new_jsons) {
    
    $json = Get-Content $new_json.FullName | Out-String | ConvertFrom-Json
    $json.PSObject.Properties.Remove('createdDateTime')
    $json.PSObject.Properties.Remove('modifiedDateTime')
    Write-Output "The json is $($json|ConvertTo-Json) ."
    Invoke-WebRequest -Verbose -UseBasicParsing https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies -Headers @{Authorization = "Bearer $($token)"} -ContentType "application/json" -Method POST -Body $($json | ConvertTo-Json -Depth 10)
}

