<#
.SYNOPSIS
    Runs the Bookworm Playwright tests.

.DESCRIPTION
    Convenience script to run Playwright tests with proper configuration.

.PARAMETER BaseUrl
    The base URL of the Bookworm app. Defaults to http://localhost:5000/bookworm

.PARAMETER Headless
    Run tests in headless mode (no visible browser). Default is true.

.PARAMETER Output
    Pester output verbosity. Default is 'Detailed'.

.EXAMPLE
    .\tests\Invoke-BookwormTests.ps1
    
.EXAMPLE
    .\tests\Invoke-BookwormTests.ps1 -BaseUrl 'http://myserver:5000/bookworm' -Headless $false
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]
    $BaseUrl = 'http://localhost:5000/bookworm',

    [Parameter()]
    [string]
    $TestPath = (Join-Path $PSScriptRoot 'Bookworm.Tests.ps1'),
    
    [Parameter()]
    [bool]
    $Headless = $true,
    
    [Parameter()]
    [ValidateSet('None', 'Normal', 'Detailed', 'Diagnostic')]
    [string]
    $Output = 'Detailed'
)

# Set environment variable for test configuration
$env:BOOKWORM_TEST_URL = $BaseUrl

Write-Host "Running Bookworm Playwright Tests" -ForegroundColor Cyan
Write-Host "Base URL: $BaseUrl" -ForegroundColor Gray
Write-Host "Headless: $Headless" -ForegroundColor Gray
Write-Host ""



$pesterConfig = New-PesterConfiguration
$pesterConfig.Run.Path = $testPath
$pesterConfig.Output.Verbosity = $Output
$pesterConfig.TestResult.Enabled = $true
$pesterConfig.TestResult.OutputPath = Join-Path $PSScriptRoot 'TestResults.xml'

Invoke-Pester -Configuration $pesterConfig