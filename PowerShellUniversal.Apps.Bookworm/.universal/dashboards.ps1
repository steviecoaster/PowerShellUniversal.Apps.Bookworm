$app = @{
    Name        = "Bookworm"
    BaseUrl     = '/Bookworm'
    Module      = 'PowerShellUniversal.Apps.Bookworm'
    Command     = 'New-UDBookwormApp'
    AutoDeploy  = $true
    Description = "A library catalog app for PowerShell Universal"
    Environment = 'PowerShell 7'
    Authenticated = $false
}

New-PSUApp @app