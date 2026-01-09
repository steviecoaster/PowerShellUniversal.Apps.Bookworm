function Remove-Book {
    <#
    .SYNOPSIS
    Removes books from the Bookworm database.
    
    .DESCRIPTION
    Deletes books from the Books table based on ISBN, Title pattern, or ID.
    Supports pipeline input and confirmation prompts.
    
    .PARAMETER ISBN
    Remove book by ISBN (exact match).
    
    .PARAMETER Title
    Remove books with titles matching this pattern (partial match, case-insensitive).
    Use with caution as it can match multiple books.
    
    .PARAMETER Id
    Remove book by database ID (exact match).
    
    .PARAMETER DatabasePath
    Path to the SQLite database file. Defaults to module data directory.
    
    .PARAMETER Force
    Skip confirmation prompts.
    
    .EXAMPLE
    Remove-Book -ISBN '9780134685991'
    Removes the book with the specified ISBN.
    
    .EXAMPLE
    Remove-Book -Id 5 -Force
    Removes the book with ID 5 without confirmation.
    
    .EXAMPLE
    Get-Book -Title 'Old Book' | Remove-Book
    Gets books matching 'Old Book' and removes them (with confirmation).
    
    .EXAMPLE
    Remove-Book -Title 'Test' -Force
    Removes all books with 'Test' in the title without confirmation.
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High', DefaultParameterSetName='ISBN')]
    Param(
        [Parameter(ParameterSetName='ISBN', ValueFromPipelineByPropertyName)]
        [String]
        $ISBN,

        [Parameter(ParameterSetName='Title')]
        [String]
        $Title,

        [Parameter(ParameterSetName='Id', ValueFromPipelineByPropertyName)]
        [int]
        $Id,
        
        [Parameter()]
        [String]
        $DatabasePath,
        
        [Parameter()]
        [switch]
        $Force
    )

    process {
        # Use module-level database path if not provided
        if (-not $DatabasePath) {
            $DatabasePath = $script:DatabasePath
        }
        
        try {
            # Build WHERE clause based on parameters
            $WhereClause = $null
            $Target = $null
            
            if ($ISBN) {
                $EscapedISBN = $ISBN -replace "'", "''"
                $WhereClause = "ISBN = '$EscapedISBN'"
                $Target = "book with ISBN '$ISBN'"
            }
            elseif ($Title) {
                $EscapedTitle = $Title -replace "'", "''"
                $WhereClause = "Title LIKE '%$EscapedTitle%'"
                $Target = "books matching title pattern '$Title'"
            }
            elseif ($Id) {
                $WhereClause = "Id = $Id"
                $Target = "book with ID $Id"
            }
            else {
                Write-Error "Must specify ISBN, Title, or Id parameter"
                return
            }
            
            # First, check if any books match
            $CheckQuery = "SELECT COUNT(*) as Count FROM Books WHERE $WhereClause"
            $CountResult = Invoke-UniversalSQLiteQuery -Path $DatabasePath -Query $CheckQuery
            $Count = if ($CountResult) { [int]$CountResult.Count } else { 0 }
            
            if ($Count -eq 0) {
                Write-Warning "No books found matching the criteria."
                return
            }
            
            # Confirm deletion
            if ($Force -or $PSCmdlet.ShouldProcess($Target, "Remove $Count book(s)")) {
                
                # Build and execute DELETE query
                $DeleteQuery = "DELETE FROM Books WHERE $WhereClause"
                
                Write-Verbose "Executing query: $DeleteQuery"
                Invoke-UniversalSQLiteQuery -Path $DatabasePath -Query $DeleteQuery
                
                Write-Verbose "Successfully removed $Count book(s) from database"
                
                # Return result
                [PSCustomObject]@{
                    Removed = $Count
                    Criteria = $Target
                    DatabasePath = $DatabasePath
                }
            }
            else {
                Write-Verbose "Book removal cancelled by user"
            }
        }
        catch {
            Write-Error "Failed to remove book(s): $_"
            throw
        }
    }
}
