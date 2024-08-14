# Global variables
$TmpPath = "~/AppData/Local/Temp"
$TmpPathFlareVM = "$TmpPath/flare-vm-main"
$TmpPathScript = "$TmpPathFlareVM/install.ps1"
$TmpPathZip = "$TmpPath/flarevm.zip"

# Start message
Write-Output "[*] Installing Mandiant FlareVM..."

# Administrator check
Write-Output "[*] Checking whether the current user has adminstrator rights..."
$l_current_user = [Security.Principal.WindowsIdentity]::GetCurrent()
$l_windows_principal = New-Object Security.Principal.WindowsPrincipal($l_current_user)

if ($l_windows_principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Output "[*] The current user has administrator rights..."
} else {
    Write-Output "[X] ERROR: The current user does not have Administrator rights. Returning..."
    return
}

# Downloading the latest FlareVM ZIP archive
Write-Output "[*] Downloading the latest FlareVM ZIP archive..."
Invoke-WebRequest -Uri "https://github.com/mandiant/flare-vm/archive/refs/heads/main.zip" -OutFile $TmpPathZip

# Verify the downloaded file
if (Test-Path $TmpPathZip -PathType Leaf) {
    Write-Output "[*] Successfully downloaded the latest FlareVM ZIP archive."
}
else {
    Write-Output "[X] ERROR: Failed to download the latest FlareVM ZIP archive. Exiting..."
    exit 1;
}

# Check, whether the ZIP archive was already extracted
if (Test-Path $TmpPathFlareVM -PathType Container) {
    Write-Output "[X] ERROR: Directory '$TmpPathFlareVM' already exists. Exiting..."
    exit 1;
}

# Extract the ZIP archive
Write-Output "[*] Extracting the ZIP archive..."
Expand-Archive -LiteralPath "$TmpPathZip" -DestinationPath "$TmpPath"

# Check, whether the installation script was extracted
if ((Test-Path $TmpPathScript -PathType Leaf) -eq $False) {
    Write-Output "[X] ERROR: Installation script '$TmpPathScript' does not exist. Exiting..."
    exit 1;
}

# Finally, execute the installation script
echo "[*] Executing the installation script..."
& $TmpPathScript
