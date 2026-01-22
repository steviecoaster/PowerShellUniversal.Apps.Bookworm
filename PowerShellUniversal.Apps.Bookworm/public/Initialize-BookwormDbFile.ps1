function Initialize-BookwormDbFile {
    <#
    .SYNOPSIS
    
    Creates the SQLite database file if it doesn't exist.
    
    .DESCRIPTION
    
    Checks if the specified SQLite database file exists and creates an empty file if missing.
    This is a simple file creation utility that ensures the database file is present before 
    applying schema or running queries. The function is idempotent - it won't overwrite 
    existing files.
    
    .PARAMETER DatabaseFile
    
    Path to the SQLite database file to create.
    If the file already exists, no action is taken.
    Parent directories must already exist.
    
    .EXAMPLE
    
    Initialize-BookwormDbFile -DatabaseFile 'C:\data\library.db'
    
    Creates an empty database file at the specified path if it doesn't exist.
    
    .EXAMPLE
    
    $dbPath = Get-DatabasePath
    Initialize-BookwormDbFile -DatabaseFile $dbPath
    Initialize-BookwormDatabase -Database $dbPath
    
    Creates the database file, then applies the schema.
    
    .EXAMPLE
    
    if (-not (Test-Path $dbPath)) {
        Initialize-BookwormDbFile -DatabaseFile $dbPath
    }
    
    Manually checks before creating the file (though the function handles this internally).
    
    .NOTES
    
    This function only creates the file, it does not create the schema.
    Use Initialize-BookwormDatabase to create the file AND apply the schema.
    The function is idempotent - safe to run multiple times.
    
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]
        $DatabaseFile
    )
    
    if(-not (Test-Path $DatabaseFile)) {
        $null = New-Item $DatabaseFile -ItemType File -Force
    }
}