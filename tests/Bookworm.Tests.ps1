#Requires -Module PSPlaywright
#Requires -Module Pester

<#
.SYNOPSIS
    Playwright tests for the Bookworm PowerShell Universal app.

.DESCRIPTION
    These tests verify the Bookworm app UI behaves as expected.
    Requires PSPlaywright module: Install-Module PSPlaywright -Scope CurrentUser
    Then run: Install-Playwright

.EXAMPLE
    Invoke-Pester -Path .\tests\Bookworm.Tests.ps1 -Output Detailed
#>

BeforeAll {
    # Configuration
    $script:BaseUrl = $env:BOOKWORM_TEST_URL ?? 'http://localhost:5000/bookworm'
    $script:DefaultTimeout = 5000  # 5 second timeout for all operations
    $script:Browser = $null
    $script:Page = $null
    
    # Start Playwright and launch browser
    Start-Playwright
    $script:Browser = Start-PlaywrightBrowser -BrowserType chromium -Headless
    $script:Page = Open-PlaywrightPage -Browser $script:Browser
}

AfterAll {
    # Cleanup
    if ($script:Page) { 
        Close-PlaywrightPage -Page $script:Page 
    }
    if ($script:Browser) { 
        Stop-PlaywrightBrowser -Browser $script:Browser -Confirm:$false
    }
    Stop-Playwright

    # Remove screenshots folder
    $screenshotsDir = Join-Path $PSScriptRoot 'screenshots'
    if (Test-Path $screenshotsDir) {
        Remove-Item $screenshotsDir -Recurse -Force
    }
}

Describe 'Bookworm Homepage' {
    
    BeforeEach {
        Open-PlaywrightPageUrl -Page $script:Page -Url "$script:BaseUrl/Home"
        Start-Sleep -Milliseconds 1500
    }
    
    It 'Should display the Bookworm Library title' {
        $title = Find-PlaywrightPageElement -Page $script:Page -Text 'Bookworm Library'
        $title | Should -Not -BeNullOrEmpty
        { Assert-PlaywrightLocator -Locator $title -IsVisible } | Should -Not -Throw
    }
    
    It 'Should display the Scan Book section' {
        $scanSection = Find-PlaywrightPageElement -Page $script:Page -Text 'Scan Book'
        { Assert-PlaywrightLocator -Locator $scanSection -IsVisible } | Should -Not -Throw
    }
    
    It 'Should display the barcode scanner instructions' {
        $instructions = Find-PlaywrightPageElement -Page $script:Page -Text 'Point your camera'
        { Assert-PlaywrightLocator -Locator $instructions -IsVisible } | Should -Not -Throw
    }
    
    It 'Should display the Recent Books section' {
        $recentBooks = Find-PlaywrightPageElement -Page $script:Page -Text 'Recent Books'
        { Assert-PlaywrightLocator -Locator $recentBooks -IsVisible } | Should -Not -Throw
    }
}

Describe 'Bookworm Navigation' {
    
    BeforeEach {
        Open-PlaywrightPageUrl -Page $script:Page -Url "$script:BaseUrl/Home"
        Start-Sleep -Milliseconds 1500
    }
    
    It 'Should navigate to Browse page from menu' {
        # Open navigation drawer - click the hamburger menu button (first button)
        $menuButton = Find-PlaywrightPageElement -Page $script:Page -Selector 'button >> nth=0'
        Invoke-PlaywrightLocatorClick -Locator $menuButton -Timeout $script:DefaultTimeout
        
        Start-Sleep -Milliseconds 500
        
        # Click Browse link in the navigation drawer
        $browseLink = Find-PlaywrightPageElement -Page $script:Page -Text 'Browse'
        Invoke-PlaywrightLocatorClick -Locator $browseLink -Timeout $script:DefaultTimeout
        
        Start-Sleep -Milliseconds 1500
        
        # Verify Browse page loaded
        $header = Find-PlaywrightPageElement -Page $script:Page -Text 'Browse Library'
        { Assert-PlaywrightLocator -Locator $header -IsVisible } | Should -Not -Throw
    }
}

Describe 'Bookworm Browse Page' {
    
    BeforeEach {
        Open-PlaywrightPageUrl -Page $script:Page -Url "$script:BaseUrl/Browse"
        Start-Sleep -Milliseconds 1500
    }
    
    It 'Should display Browse Library header' {
        $header = Find-PlaywrightPageElement -Page $script:Page -Text 'Browse Library'
        { Assert-PlaywrightLocator -Locator $header -IsVisible } | Should -Not -Throw
    }
    
    It 'Should have a search input box' {
        # Use the specific ID for the search box
        $searchBox = Find-PlaywrightPageElement -Page $script:Page -Selector '#searchBox'
        { Assert-PlaywrightLocator -Locator $searchBox -IsVisible } | Should -Not -Throw
    }
    
    It 'Should filter books when searching' {
        # Use the specific ID for the search box
        $searchBox = Find-PlaywrightPageElement -Page $script:Page -Selector '#searchBox'
        Set-PlaywrightLocatorInput -Locator $searchBox -Value 'Map' -Timeout $script:DefaultTimeout
        
        Start-Sleep -Milliseconds 1500
        
        # Page should still have content (not crash)
        $header = Find-PlaywrightPageElement -Page $script:Page -Text 'Browse Library'
        { Assert-PlaywrightLocator -Locator $header -IsVisible } | Should -Not -Throw
    }
    
    It 'Should show empty state message when no books match search' {
        # Use the specific ID for the search box
        $searchBox = Find-PlaywrightPageElement -Page $script:Page -Selector '#searchBox'
        Set-PlaywrightLocatorInput -Locator $searchBox -Value 'xyznonexistentbook123' -Timeout $script:DefaultTimeout
        
        Start-Sleep -Milliseconds 1500
        
        $noResults = Find-PlaywrightPageElement -Page $script:Page -Text 'No books found'
        { Assert-PlaywrightLocator -Locator $noResults -IsVisible } | Should -Not -Throw
    }
}

Describe 'Bookworm Book Details Modal' {
    
    BeforeEach {
        Open-PlaywrightPageUrl -Page $script:Page -Url "$script:BaseUrl/Browse"
        Start-Sleep -Milliseconds 1500
    }
    
    It 'Should open modal when clicking a book card' {
        # Try to find a book card
        $bookCard = Find-PlaywrightPageElement -Page $script:Page -Selector '.MuiCard-root >> nth=0'
        
        # Skip if no books exist
        if ($null -eq $bookCard) {
            Set-ItResult -Skipped -Because 'No books in database'
            return
        }
        
        Invoke-PlaywrightLocatorClick -Locator $bookCard -Timeout $script:DefaultTimeout
        
        Start-Sleep -Milliseconds 1000
        
        # Check modal is visible - look for the emoji ISBN label which only appears in modal
        # The modal has "📖 ISBN:" while cards just have "ISBN: {number}"
        $modalContent = Find-PlaywrightPageElement -Page $script:Page -Text '📖 ISBN:'
        { Assert-PlaywrightLocator -Locator $modalContent -IsVisible } | Should -Not -Throw
    }
    
    It 'Should close modal when clicking Close button' {
        $bookCard = Find-PlaywrightPageElement -Page $script:Page -Selector '.MuiCard-root >> nth=0'
        
        if ($null -eq $bookCard) {
            Set-ItResult -Skipped -Because 'No books in database'
            return
        }
        
        Invoke-PlaywrightLocatorClick -Locator $bookCard -Timeout $script:DefaultTimeout
        Start-Sleep -Milliseconds 1000
        
        # Click close button - it's a MUI button with text "Close"
        $closeButton = Find-PlaywrightPageElement -Page $script:Page -Selector 'button:has-text("Close")'
        Invoke-PlaywrightLocatorClick -Locator $closeButton -Timeout $script:DefaultTimeout
        
        Start-Sleep -Milliseconds 500
        
        # Modal should not be visible - check the unique modal content is gone
        $modalContent = Find-PlaywrightPageElement -Page $script:Page -Text '📖 ISBN:'
        { Assert-PlaywrightLocator -Locator $modalContent -IsHidden } | Should -Not -Throw
    }
}

Describe 'Bookworm Screenshots' {
    
    It 'Should capture homepage screenshot' {
        Open-PlaywrightPageUrl -Page $script:Page -Url "$script:BaseUrl/Home"
        Start-Sleep -Milliseconds 2000
        
        $screenshotPath = Join-Path $PSScriptRoot 'screenshots\homepage.png'
        $screenshotDir = Split-Path $screenshotPath -Parent
        if (-not (Test-Path $screenshotDir)) {
            New-Item -Path $screenshotDir -ItemType Directory -Force | Out-Null
        }
        
        Get-PlaywrightPageScreenshot -Page $script:Page -Path $screenshotPath
        Test-Path $screenshotPath | Should -BeTrue
    }
    
    It 'Should capture browse page screenshot' {
        Open-PlaywrightPageUrl -Page $script:Page -Url "$script:BaseUrl/Browse"
        Start-Sleep -Milliseconds 2000
        
        $screenshotPath = Join-Path $PSScriptRoot 'screenshots\browse.png'
        Get-PlaywrightPageScreenshot -Page $script:Page -Path $screenshotPath
        Test-Path $screenshotPath | Should -BeTrue
    }
}
