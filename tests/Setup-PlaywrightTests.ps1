#Requires -Module PSPlaywright

<#
.SYNOPSIS
    Sets up PSPlaywright for testing the Bookworm app.

.DESCRIPTION
    Installs PSPlaywright module and required browsers for Playwright testing.

.EXAMPLE
    .\tests\Setup-PlaywrightTests.ps1
#>

[CmdletBinding()]
param()

# Check if PSPlaywright is installed
if (-not (Get-Module -ListAvailable -Name PSPlaywright)) {
    Write-Host "Installing PSPlaywright module..." -ForegroundColor Yellow
    Install-Module -Name PSPlaywright -Scope CurrentUser -Force
}

# Import the module
Import-Module PSPlaywright -Force

# Install Playwright browsers
Write-Host "Installing Playwright browsers..." -ForegroundColor Yellow
Install-Playwright

Write-Host "`nPlaywright setup complete!" -ForegroundColor Green
Write-Host "Run tests with: Invoke-Pester -Path .\tests\Bookworm.Tests.ps1 -Output Detailed" -ForegroundColor Cyan
