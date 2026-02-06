function Initialize-BookwormDatabase {
    <#
    .SYNOPSIS
    
    Initializes the Bookworm library SQLite database with required schema.
    
    .DESCRIPTION
    
    Creates the SQLite database and applies the schema to create necessary tables.
    The schema includes the 'books' table with columns for ISBN, Title, PublishDate, Publishers, 
    NumberOfPages, CoverUrl, FirstSentence, and ScannedAt timestamp.
    
    Schema can be provided as a file path or raw SQL string.
    Uses "CREATE TABLE IF NOT EXISTS" to safely handle existing databases.
    
    .PARAMETER Schema
    
    Path to a SQL schema file (.sql) OR raw SQL string to execute.
    If a file path is provided, the file content is read and executed.
    If not specified, uses the default schema from data\Database-Schema.sql.
    
    .PARAMETER Database
   
    Path to the SQLite database file.
    If not specified, uses the module's configured database path from Get-DatabasePath.
    
    .EXAMPLE
    
    Initialize-BookwormDatabase
    
    Creates the database using default schema and path.
    
    .EXAMPLE

    Initialize-BookwormDatabase -Schema 'C:\custom\schema.sql' -Database 'C:\data\mybooks.db'

    Initializes a custom database with a custom schema file.
    
    .EXAMPLE

    $sql = "CREATE TABLE IF NOT EXISTS books (ISBN TEXT PRIMARY KEY, Title TEXT)"
    Initialize-BookwormDatabase -Schema $sql -Database 'C:\temp\test.db'
    
    Creates a database with inline SQL schema.
    
    .EXAMPLE
    
    Initialize-BookwormDatabase -Database 'C:\temp\newlibrary.db'
    
    Creates a new database at a specific path using the default schema.
    
    .NOTES
    
    Requires the Invoke-UniversalSQLiteQuery function for database operations.
    The function is idempotent - safe to run multiple times.
    Uses "CREATE TABLE IF NOT EXISTS" to prevent errors on existing tables.
    
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $Schema,

        [Parameter(Mandatory)]
        [string]
        $Database
    )

    # Ensure db file exists (your SQLite wrapper requires it)
    if (-not (Test-Path $Database)) {
        $dbFolder = Split-Path $Database -Parent
        if ($dbFolder -and -not (Test-Path $dbFolder)) {
            New-Item -Path $dbFolder -ItemType Directory -Force | Out-Null
        }
        New-Item -Path $Database -ItemType File -Force | Out-Null
    }

    # Schema can be either:
    # - A file path to Schema.sql
    # - The raw SQL contents of Schema.sql
    $schemaSql = $null

    if (Test-Path $Schema) {
        # It's a file path
        $schemaSql = Get-Content -Raw $Schema
    }
    else {
        # It's raw SQL
        $schemaSql = $Schema
    }

    if (-not $schemaSql -or $schemaSql.Trim().Length -eq 0) {
        throw "Initialize-BookwormDatabase: Schema SQL was empty."
    }

    # Apply schema (safe due to IF NOT EXISTS)
    $null = Invoke-UniversalSQLiteQuery -Path $Database -Query $schemaSql

    # MIGRATIONS: These queries will run on module upgrades to ensure the latest schema

    # Migration: Add Author column to Book table
    Write-Verbose -Message "PERFORMING MIGRATION: Add Author column to Book table"
    $invokeUniversalSQLiteQuerySplat = @{
        Path = (Get-DatabasePath)
        Query = "SELECT COUNT(*) as ColumnExists FROM pragma_table_info('Books') WHERE name = 'Author';"
    }

    $addColumn = Invoke-UniversalSQLiteQuery @invokeUniversalSQLiteQuerySplat

    if(-not $addColumn.ColumnExists -eq 1) {

        $invokeUniversalSQLiteQuerySplat = @{
            Path = $DatabasePath
            Query = "ALTER TABLE Books ADD COLUMN Author TEXT"
        }

        Invoke-UniversalSQLiteQuery @invokeUniversalSQLiteQuerySplat
    }
    else {
        Write-Verbose "Migration not needed, skipped"
    }
}