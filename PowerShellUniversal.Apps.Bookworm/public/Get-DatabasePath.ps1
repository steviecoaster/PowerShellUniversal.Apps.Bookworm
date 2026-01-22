function Get-DatabasePath {
    <#
    .SYNOPSIS
    
    Returns the configured database path for the Bookworm library.
    
    .DESCRIPTION

    Retrieves the SQLite database path from the module-level $script:DatabasePath variable.
    If no custom path is configured, returns the default path in $env:ProgramData\Library\Library.db.
    This function ensures consistent database path access across all module functions.
    
    .EXAMPLE

    Get-DatabasePath

    Returns the current database path.
    
    .EXAMPLE

    $dbPath = Get-DatabasePath
    if (Test-Path $dbPath) {
        Write-Host "Database exists at $dbPath"
    }

    Checks if the database file exists at the configured path.
    
    .OUTPUTS

    System.String
    The full path to the SQLite database file.
    
    .NOTES

    The database path can be configured using $script:DatabasePath in the module.
    Default path is $env:ProgramData\Library\Library.db.
    This function is used internally by other module functions for consistency.
    
    #>
    [CmdletBinding()]
    Param()

    end {
        # Return the database path set by the module during initialization
        # This ensures consistency with where other functions are reading/writing
        if ($script:DatabasePath) {
            return $script:DatabasePath
        }
        
        # Fallback to default location if script variable not set
        # (shouldn't happen if module loaded properly)
        $defaultPath = Join-Path $((Get-Module PowerShellUniversal.Apps.Bookworm).ModuleBase) -ChildPath 'data\Bookworm.db'
        Write-Warning "Database path not initialized. Using default: $defaultPath"
        return $defaultPath
    }
}