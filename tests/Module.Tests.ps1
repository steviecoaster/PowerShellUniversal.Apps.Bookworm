# Helper function to create a fake book with custom properties


BeforeAll {
    # Import the module
    $ModulePath = Join-Path $PSScriptRoot '..\PowerShellUniversal.Apps.Bookworm\PowerShellUniversal.Apps.Bookworm.psd1'
    Import-Module $ModulePath -Force
    
    # Create a temporary database for testing
    $script:TestDbPath = Join-Path $env:TEMP "Bookworm-Test-$([guid]::NewGuid().ToString('N')).db"
    
    # Initialize the test database
    $schema = Join-Path $PSScriptRoot '..\PowerShellUniversal.Apps.Bookworm\data\Database-Schema.sql'
    Initialize-BookwormDatabase -Database $script:TestDbPath -Schema $schema

    $script:FakeBooks = @{
    
        # A complete book with all fields populated
        CompleteBook     = @{
            ISBN          = '9780134685991'
            Title         = 'Effective Java'
            PublishDate   = '2018-01-06'
            Publishers    = 'Addison-Wesley Professional'
            NumberOfPages = 416
            CoverUrl      = 'https://covers.openlibrary.org/b/isbn/9780134685991-M.jpg'
            FirstSentence = 'This book is designed to help you make effective use of the Java programming language.'
            ScannedAt     = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
        }
    
        # A minimal book with only required fields
        MinimalBook      = @{
            ISBN          = '9781234567890'
            Title         = 'Minimal Test Book'
            PublishDate   = 'N/A'
            Publishers    = 'N/A'
            NumberOfPages = 0
            CoverUrl      = ''
            FirstSentence = ''
            ScannedAt     = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
        }
    
        # A book with special characters in title/publisher
        SpecialCharsBook = @{
            ISBN          = '9789876543210'
            Title         = "O'Reilly's Guide to SQL & Databases: A Complete Reference"
            PublishDate   = '2023-06-15'
            Publishers    = "O'Reilly Media, Inc."
            NumberOfPages = 512
            CoverUrl      = ''
            FirstSentence = "It's important to understand that SQL isn't just a language—it's a way of thinking."
            ScannedAt     = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
        }
    
        # A fiction book
        FictionBook      = @{
            ISBN          = '9780062316097'
            Title         = 'The Martian'
            PublishDate   = '2014-02-11'
            Publishers    = 'Crown Publishing Group'
            NumberOfPages = 369
            CoverUrl      = 'https://covers.openlibrary.org/b/isbn/9780062316097-M.jpg'
            FirstSentence = 'I am pretty much fucked.'
            ScannedAt     = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
        }
    
        # A book for search testing
        SearchableBook   = @{
            ISBN          = '9780596517748'
            Title         = 'JavaScript: The Good Parts'
            PublishDate   = '2008-05-01'
            Publishers    = "O'Reilly Media"
            NumberOfPages = 176
            CoverUrl      = ''
            FirstSentence = 'Most programming languages contain good parts and bad parts.'
            ScannedAt     = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
        }
    }

    function New-FakeBook {
    [CmdletBinding()]
    param(
        [string]$ISBN = "978$((Get-Random -Minimum 1000000000 -Maximum 9999999999))",
        [string]$Title = "Test Book $(Get-Random)",
        [string]$PublishDate = (Get-Date).ToString('yyyy-MM-dd'),
        [string]$Publishers = 'Test Publisher',
        [int]$NumberOfPages = (Get-Random -Minimum 100 -Maximum 1000),
        [string]$CoverUrl = '',
        [string]$FirstSentence = 'This is the first sentence of the test book.',
        [string]$ScannedAt = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
    )
    
    @{
        ISBN          = $ISBN
        Title         = $Title
        PublishDate   = $PublishDate
        Publishers    = $Publishers
        NumberOfPages = $NumberOfPages
        CoverUrl      = $CoverUrl
        FirstSentence = $FirstSentence
        ScannedAt     = $ScannedAt
    }
}
}

AfterAll {
    # Clean up test database
    if (Test-Path $script:TestDbPath) {
        Remove-Item $script:TestDbPath -Force -ErrorAction SilentlyContinue
    }
}

#region Add-Book Tests

Describe 'Add-Book' {
    
    BeforeEach {
        # Clear all books before each test
        $allBooks = Get-Book -DatabasePath $script:TestDbPath -Limit 1000
        foreach ($book in $allBooks) {
            Remove-Book -ISBN $book.ISBN -DatabasePath $script:TestDbPath -Force
        }
    }
    
    It 'Should add a complete book to the database' {
        $book = $script:FakeBooks.CompleteBook
        $result = Add-Book @book -DatabasePath $script:TestDbPath
        
        $result | Should -Not -BeNullOrEmpty
        $result.Status | Should -Be 'Added'
        $result.ISBN | Should -Be $book.ISBN
        $result.Title | Should -Be $book.Title
    }
    
    It 'Should add a minimal book with only required fields' {
        $book = $script:FakeBooks.MinimalBook
        $result = Add-Book -ISBN $book.ISBN -Title $book.Title -DatabasePath $script:TestDbPath
        
        $result | Should -Not -BeNullOrEmpty
        $result.ISBN | Should -Be $book.ISBN
    }
    
    It 'Should handle special characters in title and publisher' {
        $book = $script:FakeBooks.SpecialCharsBook
        $result = Add-Book @book -DatabasePath $script:TestDbPath
        
        $result | Should -Not -BeNullOrEmpty
        $result.Title | Should -Be $book.Title
        $result.Publishers | Should -Be $book.Publishers
        
        # Verify it can be retrieved
        $retrieved = Get-Book -ISBN $book.ISBN -DatabasePath $script:TestDbPath
        $retrieved.Title | Should -Be $book.Title
    }
    
    It 'Should update existing book when ISBN already exists' {
        $book = New-FakeBook -ISBN '9999999999999' -Title 'Original Title'
        Add-Book @book -DatabasePath $script:TestDbPath
        
        # Add again with different title
        $updatedBook = New-FakeBook -ISBN '9999999999999' -Title 'Updated Title'
        Add-Book @updatedBook -DatabasePath $script:TestDbPath
        
        # Should only have one book with updated title
        $result = Get-Book -ISBN '9999999999999' -DatabasePath $script:TestDbPath
        $result.Title | Should -Be 'Updated Title'
    }
    
    It 'Should accept pipeline input' {
        # Pipeline requires PSCustomObject, not hashtable
        $book = [PSCustomObject]$script:FakeBooks.FictionBook
        $result = $book | Add-Book -DatabasePath $script:TestDbPath
        
        $result | Should -Not -BeNullOrEmpty
        $result.ISBN | Should -Be $book.ISBN
    }
}

#endregion

#region Get-Book Tests

Describe 'Get-Book' {
    
    BeforeAll {
        # Add test books for Get-Book tests - splat the hashtables
        $complete = $script:FakeBooks.CompleteBook
        $fiction = $script:FakeBooks.FictionBook
        $searchable = $script:FakeBooks.SearchableBook
        
        Add-Book @complete -DatabasePath $script:TestDbPath
        Add-Book @fiction -DatabasePath $script:TestDbPath
        Add-Book @searchable -DatabasePath $script:TestDbPath
    }
    
    It 'Should return all books when no parameters specified' {
        $result = Get-Book -DatabasePath $script:TestDbPath
        
        $result | Should -Not -BeNullOrEmpty
        $result.Count | Should -BeGreaterOrEqual 3
    }
    
    It 'Should return specific book by ISBN' {
        $result = Get-Book -ISBN $script:FakeBooks.CompleteBook.ISBN -DatabasePath $script:TestDbPath
        
        $result | Should -Not -BeNullOrEmpty
        $result.ISBN | Should -Be $script:FakeBooks.CompleteBook.ISBN
        $result.Title | Should -Be $script:FakeBooks.CompleteBook.Title
    }
    
    It 'Should return books matching title pattern' {
        $result = Get-Book -Title 'Martian' -DatabasePath $script:TestDbPath
        
        $result | Should -Not -BeNullOrEmpty
        $result.Title | Should -BeLike '*Martian*'
    }
    
    It 'Should return empty result for non-existent ISBN' {
        $result = Get-Book -ISBN '0000000000000' -DatabasePath $script:TestDbPath
        
        $result | Should -BeNullOrEmpty
    }
    
    It 'Should respect Limit parameter' {
        $result = Get-Book -Limit 2 -DatabasePath $script:TestDbPath
        
        $result.Count | Should -BeLessOrEqual 2
    }
    
    It 'Should return book with all properties populated' {
        $result = Get-Book -ISBN $script:FakeBooks.CompleteBook.ISBN -DatabasePath $script:TestDbPath
        
        $result.ISBN | Should -Not -BeNullOrEmpty
        $result.Title | Should -Not -BeNullOrEmpty
        $result.PublishDate | Should -Not -BeNullOrEmpty
        $result.Publishers | Should -Not -BeNullOrEmpty
        $result.NumberOfPages | Should -BeGreaterThan 0
    }
}

#endregion

#region Remove-Book Tests

Describe 'Remove-Book' {
    
    BeforeEach {
        # Add a fresh book to remove
        $script:TestRemoveBook = New-FakeBook -ISBN "DEL$(Get-Random)" -Title 'Book To Delete'
        Add-Book @script:TestRemoveBook -DatabasePath $script:TestDbPath
    }
    
    It 'Should remove book by ISBN' {
        Remove-Book -ISBN $script:TestRemoveBook.ISBN -DatabasePath $script:TestDbPath -Force
        
        $result = Get-Book -ISBN $script:TestRemoveBook.ISBN -DatabasePath $script:TestDbPath
        $result | Should -BeNullOrEmpty
    }
    
    It 'Should remove books matching title pattern' {
        # Add books with specific pattern
        $book1 = New-FakeBook -Title 'DeleteMe Book 1'
        $book2 = New-FakeBook -Title 'DeleteMe Book 2'
        Add-Book @book1 -DatabasePath $script:TestDbPath
        Add-Book @book2 -DatabasePath $script:TestDbPath
        
        Remove-Book -Title 'DeleteMe' -DatabasePath $script:TestDbPath -Force
        
        $result = Get-Book -Title 'DeleteMe' -DatabasePath $script:TestDbPath
        $result | Should -BeNullOrEmpty
    }
    
    It 'Should support pipeline input from Get-Book' {
        Get-Book -ISBN $script:TestRemoveBook.ISBN -DatabasePath $script:TestDbPath | 
        Remove-Book -DatabasePath $script:TestDbPath -Force
        
        $result = Get-Book -ISBN $script:TestRemoveBook.ISBN -DatabasePath $script:TestDbPath
        $result | Should -BeNullOrEmpty
    }
    
    It 'Should not remove anything for non-existent ISBN' {
        $countBefore = (Get-Book -DatabasePath $script:TestDbPath).Count
        
        Remove-Book -ISBN '0000000000000' -DatabasePath $script:TestDbPath -Force
        
        $countAfter = (Get-Book -DatabasePath $script:TestDbPath).Count
        $countAfter | Should -Be $countBefore
    }
}

#endregion

#region Get-BookMetadata Tests

Describe 'Get-BookMetadata' -Tag 'Integration' {
    
    It 'Should return metadata for valid ISBN' -Skip:$env:SKIP_INTEGRATION_TESTS {
        # Use a well-known book ISBN
        $result = Get-BookMetadata -ISBN '9780134685991'
        
        $result | Should -Not -BeNullOrEmpty
        $result.ISBN | Should -Be '9780134685991'
        $result.Title | Should -Not -BeNullOrEmpty
    }
    
    It 'Should return null/empty for invalid ISBN' -Skip:$env:SKIP_INTEGRATION_TESTS {
        $result = Get-BookMetadata -ISBN '0000000000000'
        
        # Depending on implementation, might return null or object with placeholder values
        if ($result) {
            # Accept "Unknown", "not found", "N/A", or empty
            $result.Title | Should -Match 'Unknown|not found|N/A|^$'
        }
    }
    
    It 'Should handle ISBN with dashes' -Skip:$env:SKIP_INTEGRATION_TESTS {
        $result = Get-BookMetadata -ISBN '978-0-13-468599-1'
        
        # Should normalize the ISBN
        $result | Should -Not -BeNullOrEmpty
    }
}

#endregion

#region Mock Examples

Describe 'Add-Book with Mocked Database' {
    
    BeforeAll {
        # Mock the database query function to avoid actual DB operations
        Mock Invoke-UniversalSQLiteQuery -ModuleName PowerShellUniversal.Apps.Bookworm {
            # Return success without actually hitting the database
            return $null
        }
    }
    
    It 'Should call database query when adding book' {
        $book = New-FakeBook
        
        # This won't actually hit the DB due to mock
        $result = Add-Book @book -DatabasePath 'C:\fake\path.db'
        
        # Verify the mock was called
        Should -Invoke Invoke-UniversalSQLiteQuery -ModuleName PowerShellUniversal.Apps.Bookworm -Times 1
    }
}

Describe 'Get-Book with Mocked Database' {
    
    BeforeAll {
        # Mock to return fake book data
        Mock Invoke-UniversalSQLiteQuery -ModuleName PowerShellUniversal.Apps.Bookworm {
            @(
                [PSCustomObject]@{
                    Id            = 1
                    ISBN          = '9780134685991'
                    Title         = 'Mocked Book Title'
                    PublishDate   = '2020-01-01'
                    Publishers    = 'Mock Publisher'
                    NumberOfPages = 100
                    CoverUrl      = ''
                    FirstSentence = 'This is mocked.'
                    ScannedAt     = '2024-01-01 12:00:00'
                }
            )
        }
    }
    
    It 'Should return mocked book data' {
        $result = Get-Book -ISBN '9780134685991' -DatabasePath 'C:\fake\path.db'
        
        $result | Should -Not -BeNullOrEmpty
        $result.Title | Should -Be 'Mocked Book Title'
    }
}

#endregion
