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

# Generate the certificate signing request (CSR)
$csrUrl = "$server/rest/vcenter/certificate-management/vcenter-certificate/intermediate-csr"
$csrHeaders = @{
    "Content-Type" = "application/json"
    "vmware-api-session-id" = $sessionToken
}
$csrResponse = Invoke-RestMethod -Uri $csrUrl -Method Post -Headers $csrHeaders

# Download the CSR file
$csrFileUrl = $csrResponse.value
$csrFileName = "vcenter.csr"
Invoke-WebRequest -Uri $csrFileUrl -Headers $csrHeaders -OutFile $csrFileName

# Print the location of the downloaded CSR file
Write-Host "CSR file successfully downloaded!"