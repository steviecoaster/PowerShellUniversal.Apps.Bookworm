function Get-Book {
    <#
    .SYNOPSIS

    Retrieves books from the Bookworm database.
    
    .DESCRIPTION

    Queries the Books table based on ISBN, Title, or Author parameters.
    If no parameters are provided, returns all books.
    
    .PARAMETER ISBN

    Filter by ISBN (exact match).
    
    .PARAMETER Title

    Filter by Title (partial match, case-insensitive).
    
    .PARAMETER Author

    Filter by Author (partial match, case-insensitive).
    Note: Currently not implemented in schema, reserved for future use.
    
    .PARAMETER DatabasePath

    Path to the SQLite database file. Defaults to module data directory.
    
    .PARAMETER Limit

    Maximum number of results to return. Defaults to 100.
    
    .EXAMPLE

    Get-Book

    Returns all books in the Bookworm.
    
    .EXAMPLE

    Get-Book -ISBN '9780134685991'

    Returns the book with the specified ISBN.
    
    .EXAMPLE

    Get-Book -Title 'Clean Code'

    Returns all books with titles containing 'Clean Code'.
    
    .EXAMPLE

    Get-Book -Limit 10

    Returns the 10 most recently scanned books.
    
    #>
    [CmdletBinding(DefaultParameterSetName='All')]
    Param(
        [Parameter(ParameterSetName='ISBN')]
        [String]
        $ISBN,

        [Parameter(ParameterSetName='Title')]
        [String]
        $Title,

        [Parameter(ParameterSetName='Author')]
        [String]
        $Author,
        
        [Parameter()]
        [String]
        $DatabasePath,
        
        [Parameter()]
        [int]
        $Limit = 100
    )

    process {
        # Use module-level database path if not provided
        if (-not $DatabasePath) {
            $DatabasePath = $script:DatabasePath
        }
        
        try {
            # Build WHERE clause based on parameters
            $WhereConditions = @()
            
            if ($ISBN) {
                $EscapedISBN = $ISBN -replace "'", "''"
                $WhereConditions += "ISBN = '$EscapedISBN'"
            }
            
            if ($Title) {
                $EscapedTitle = $Title -replace "'", "''"
                $WhereConditions += "Title LIKE '%$EscapedTitle%'"
            }
            
            if ($Author) {
                # Note: Author field not yet in schema, but keeping for future use
                $EscapedAuthor = $Author -replace "'", "''"
                $WhereConditions += "Author LIKE '%$EscapedAuthor%'"
            }
            
            # Build the query
            $Query = "SELECT * FROM Books"
            
            if ($WhereConditions.Count -gt 0) {
                $Query += " WHERE " + ($WhereConditions -join " AND ")
            }
            
            # Order by most recently scanned
            $Query += " ORDER BY ScannedAt DESC"
            
            # Add limit
            $Query += " LIMIT $Limit"
            
            Write-Verbose "Executing query: $Query"
            
            # Execute query
            $Results = Invoke-UniversalSQLiteQuery -Path $DatabasePath -Query $Query
            
            if ($Results) {
                return $Results
            }
            else {
                Write-Verbose "No books found matching the criteria."
                return $null
            }
        }
        catch {
            Write-Error "Failed to retrieve books: $_"
            throw
        }
    }
}