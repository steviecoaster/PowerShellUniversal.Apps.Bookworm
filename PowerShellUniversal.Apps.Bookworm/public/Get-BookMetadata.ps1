function Get-BookMetadata {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $ISBN
    )

    end {
        
        try {
            $BookInfo = Invoke-RestMethod -Uri "https://openlibrary.org/isbn/$ISBN.json" -ErrorAction Stop

            $CoverUrl = if ($BookInfo.covers -and $BookInfo.covers.Count -gt 0) {
                "https://covers.openlibrary.org/b/id/$($BookInfo.covers[0])-M.jpg"
            }
            else {
                $null
            }
                            
            # Create book object
            $Book = [pscustomobject]@{
                ISBN          = if ($BookInfo.isbn_13) { $BookInfo.isbn_13[0] } else { $ISBN }
                Title         = $BookInfo.title
                PublishDate   = $BookInfo.publish_date
                Publishers    = $BookInfo.publishers -join ', '
                NumberOfPages = $BookInfo.number_of_pages
                CoverUrl      = $CoverUrl
                FirstSentence = $BookInfo.first_sentence.value
                ScannedAt     = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            }

            $Book
        }
        catch {
            Write-Error -Message 'Book not found, writing generic record'
            $Book = [PSCustomObject]@{
                ISBN          = $ISBN
                Title         = "Unknown (ISBN: $ISBN)"
                PublishDate   = 'N/A'
                Publishers    = 'N/A'
                NumberOfPages = $null
                CoverUrl      = $null
                FirstSentence = 'N/A'
                ScannedAt     = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            }

            $Book
        }
    }
}