function Get-BookMetadata {
    <#
    .SYNOPSIS
    
    Retrieves book metadata from the Open Library API.
    
    .DESCRIPTION

    Fetches detailed book information from Open Library using an ISBN.
    Returns book title, publisher, publication date, page count, cover URL, and first sentence.
    If the book is not found, returns a placeholder object with the ISBN.
    
    .PARAMETER ISBN

    The ISBN (International Standard Book Number) of the book to look up.
    Can be ISBN-10 or ISBN-13 format.
    
    .EXAMPLE

    Get-BookMetadata -ISBN '9780134685991'
    Retrieves metadata for Effective Java (3rd Edition).
    
    .EXAMPLE

    $metadata = Get-BookMetadata -ISBN '9780062316097'
    Add-Book @metadata

    Fetches book metadata and pipes it to Add-Book for storage.
    
    .EXAMPLE

    '9780134685991', '9780062316097' | ForEach-Object { Get-BookMetadata -ISBN $_ }

    Retrieves metadata for multiple books.
    
    .OUTPUTS

    PSCustomObject with properties:
    - ISBN: The book's ISBN
    - Title: Book title
    - PublishDate: Publication date
    - Publishers: Publisher name(s)
    - NumberOfPages: Page count
    - CoverUrl: URL to book cover image
    - FirstSentence: Opening sentence of the book
    - ScannedAt: Timestamp when metadata was retrieved
    
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [String]
        $ISBN
    )

    end {
        
        try {
            $BookInfo = Invoke-RestMethod -Uri "https://openlibrary.org/isbn/$ISBN.json" -ErrorAction Stop
            Write-Verbose "Found: $($BookInfo.title)"
            $CoverUrl = if ($BookInfo.covers -and $BookInfo.covers.Count -gt 0) {
                "https://covers.openlibrary.org/b/id/$($BookInfo.covers[0])-M.jpg"
            }
            else {
                $null
            }

            $workSlug = (Split-path -leaf $BookInfo.works.key).trim('{}')
            $works = Invoke-RestMethod "https://openlibrary.org/works/$workSlug.json"

            # Some books may have co-authors, so we need to handle that
            $authorCollection = [System.Collections.Generic.List[pscustomobject]]::new()

            if ($works.authors.Count -gt 1) {

                $works.authors.author | Foreach-Object {
                    $authorSlug = (Split-Path -Leaf $_).Trim('{}')
                    $author = Invoke-RestMethod "https://openlibrary.org/authors/$authorSlug.json"
                    $authorCollection.Add($author)
                }
            }
            else {
                $authorSlug = (Split-Path -Leaf $works.authors.author).Trim('{}')
                $author = Invoke-RestMethod "https://openlibrary.org/authors/$authorSlug.json"
                $authorCollection.Add($author)
            }

            $Book = [pscustomobject]@{
                ISBN          = if ($BookInfo.isbn_13) { $BookInfo.isbn_13[0] } else { $ISBN }
                Title         = $BookInfo.title
                Author        = $authorCollection.name
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
            Write-Warning -Message 'Book not found, writing generic record'
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