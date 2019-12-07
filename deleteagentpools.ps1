$pat = "_token_"
$token = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$pat"))
$poolservers = Invoke-RestMethod -Uri "https://dev.azure.com/{organization}/_apis/distributedtask/pools/{poolID}/agents" -Method Get -Headers @{Authorization = "Basic $token"}
$poolservers.value | Where-Object { $_.status -eq 'offline' } |
ForEach-Object 
{
Invoke-RestMethod -uri "https://dev.azure.com/{organization}/_apis/distributedtask/pools/{poolID}/agents/$($_.id)?api-version=4.1" -Method Delete -Headers @{Authorization = "Basic $token"}
}
