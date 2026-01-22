function Add-Book {
    <#
    .SYNOPSIS

    Adds a book to the Bookworm database.
    
    .DESCRIPTION

    Inserts book metadata into the Books table. Uses INSERT OR REPLACE to handle duplicates.
    
    .PARAMETER ISBN

    The ISBN of the book (unique identifier).
    
    .PARAMETER Title

    The title of the book.
    
    .PARAMETER PublishDate

    The publication date.
    
    .PARAMETER Publishers

    The publisher(s) of the book.
    
    .PARAMETER NumberOfPages

    The number of pages in the book.
    
    .PARAMETER CoverUrl

    URL to the book's cover image.
    
    .PARAMETER ScannedAt

    The timestamp when the book was scanned.
    
    .PARAMETER DatabasePath

    Path to the SQLite database file. Defaults to module data directory.
    
    .EXAMPLE

    $metadata = Get-BookMetadata -ISBN '9780134685991'
    Add-Book @metadata
    
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $ISBN,
        
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $Title,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $PublishDate,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $Publishers,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [int]
        $NumberOfPages,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $CoverUrl,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $FirstSentence,
        
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ScannedAt,
        
        [Parameter()]
        [string]
        $DatabasePath
    )

    process {
        # Use module-level database path if not provided
        if (-not $DatabasePath) {
            $DatabasePath = $script:DatabasePath
        }
        
        try {
            # Escape single quotes in strings for SQLite
            $EscapedTitle = $Title -replace "'", "''"
            $EscapedPublishers = $Publishers -replace "'", "''"
            $EscapedCoverUrl = if ($CoverUrl) { $CoverUrl -replace "'", "''" } else { '' }
            $EscapedFirstSentence = if ($FirstSentence) { $FirstSentence -replace "'", "''" } else { '' }
            $EscapedScannedAt = $ScannedAt -replace "'", "''"
            $EscapedISBN = $ISBN -replace "'", "''"
            $EscapedPublishDate = $PublishDate -replace "'", "''"
            
            # Use INSERT OR REPLACE to handle duplicates (updates if ISBN exists)
            $Query = @"
INSERT OR REPLACE INTO Books (ISBN, Title, PublishDate, Publishers, NumberOfPages, CoverUrl, FirstSentence, ScannedAt)
VALUES ('$EscapedISBN', '$EscapedTitle', '$EscapedPublishDate', '$EscapedPublishers', $NumberOfPages, '$EscapedCoverUrl', '$EscapedFirstSentence', '$EscapedScannedAt')
"@
            
            Invoke-UniversalSQLiteQuery -Path $DatabasePath -Query $Query
            
            Write-Verbose "Added book to database: $Title (ISBN: $ISBN)"
            
            # Return the added book info
            [PSCustomObject]@{
                ISBN          = $ISBN
                Title         = $Title
                PublishDate   = $PublishDate
                Publishers    = $Publishers
                NumberOfPages = $NumberOfPages
                CoverUrl      = $CoverUrl
                FirstSentence = $FirstSentence
                ScannedAt     = $ScannedAt
                Status        = 'Added'
            }
        }
        catch {
            Write-Error "Failed to add book to database: $_"
            throw
        }
    }
}