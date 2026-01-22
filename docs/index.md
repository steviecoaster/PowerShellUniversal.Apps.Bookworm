# PowerShellUniversal.Apps.Bookworm

The PowerShellUniversal.Apps.Bookworm module provides a SQLite3 database for storing book metadata, a PowerShell module CLI interface for managing your book library, as well as a web-based management platform hosted in PowerShell Universal providing a user-friendly interface to manage your library including a mobile-friendly ISBN scanner for quick book additions, and a Browse section to quickly find items from your library.

## Available Module Commands

- Initialize-BookwormDatabase
- Initialize-BookwormDbFile
- Get-DatabasePath
- Invoke-UniversalSQLiteQuery
- New-UDBookwormApp
- Add-Book
- Get-Book
- Get-BookMetadata
- Remove-Book

## Installation

### Manual installation

1. Clone this repository
2. Copy the `PowerShellUniversal.Apps.Bookworm` folder to `C:\ProgramData\UniversalAutomation\Repository\Modules` (or wherever your Universal Repository directory resides).
3. Restart your PowerShell Universal instance.
4. Access Bookworm at `https://yourpsuinstance/bookworm`

### From PowerShell Universal

1. Login to your PSU admin portal
2. Navigate to Platform -> Gallery
3. Search for `PowerShellUniversal.Apps.Bookworm
4. Click 'Install'
5. Access Bookworm at `https://yourpsuinstance/bookworm`