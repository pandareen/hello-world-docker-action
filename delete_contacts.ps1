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


#Invoke-WebRequest -Verbose -UseBasicParsing https://graph.microsoft.com/v1.0/me -Headers @{Authorization = "Bearer $($token)"} -ContentType "application/json" -Method PATCH -Body $($json | ConvertTo-Json -Depth 10)

Invoke-WebRequest -Verbose -UseBasicParsing https://graph.microsoft.com/v1.0/me -Headers @{Authorization = "Bearer $($token)"} -Method GET

