# Set the vCenter server details
$server = "https://vcenter-server.example.com"
$username = "your-username"
$password = "your-password"

# Authenticate and get the session token
$authUrl = "$server/rest/com/vmware/cis/session"
$authBody = @{
    username = $username
    password = $password
}
$authHeaders = @{
    "Content-Type" = "application/json"
}
$authResponse = Invoke-RestMethod -Uri $authUrl -Method Post -Headers $authHeaders -Body ($authBody | ConvertTo-Json)
$sessionToken = $authResponse.value

# Set the certificate and chain file paths
$certificateFilePath = "path/to/certificate.crt"
$chainFilePath = "path/to/certificate-chain.crt"

# Upload the certificate
$certificateUrl = "$server/rest/vcenter/certificate-management/vcenter-certificate"
$certificateHeaders = @{
    "Content-Type" = "application/x-pem-file"
    "vmware-api-session-id" = $sessionToken
}
$certificateBody = Get-Content -Path $certificateFilePath -Raw
Invoke-RestMethod -Uri $certificateUrl -Method Post -Headers $certificateHeaders -Body $certificateBody

# Upload the certificate chain
$chainUrl = "$server/rest/vcenter/certificate-management/vcenter-certificate/chain"
$chainHeaders = @{
    "Content-Type" = "application/x-pem-file"
    "vmware-api-session-id" = $sessionToken
}
$chainBody = Get-Content -Path $chainFilePath -Raw
Invoke-RestMethod -Uri $chainUrl -Method Post -Headers $chainHeaders -Body $chainBody

# Print success message
Write-Host "Certificate and certificate chain uploaded successfully."