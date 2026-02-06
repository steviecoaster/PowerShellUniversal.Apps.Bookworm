$browse = New-UDPage -Id 'browse' -Name 'Browse' -Url '/Browse' -Content {
    
    New-UDContainer -Content {
        
        # Header
        New-UDElement -Tag 'div' -Attributes @{ 
            style = @{ 
                background   = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
                padding      = '30px 20px'
                borderRadius = '12px'
                marginBottom = '24px'
                boxShadow    = '0 4px 12px rgba(0,0,0,0.1)'
            } 
        } -Content {
            New-UDStack -Direction 'column' -AlignItems 'center' -Spacing 1 -Content {
                New-UDTypography -Text '📚 Browse Library' -Variant h4 -Align center -Style @{
                    color      = 'white'
                    fontWeight = 'bold'
                    textShadow = '2px 2px 4px rgba(0,0,0,0.3)'
                }
                New-UDTypography -Text 'Search and explore your book collection' -Variant body1 -Align center -Style @{
                    color     = 'rgba(255,255,255,0.9)'
                    marginTop = '8px'
                }
            }
        }
        
        # Search Box
        New-UDElement -Tag 'div' -Attributes @{ 
            style = @{ 
                marginBottom = '24px'
            } 
        } -Content {
            New-UDTextbox -Id 'searchBox' -Label 'Search books by title, ISBN, or publisher...' -FullWidth -Icon (New-UDIcon -Icon Search) -OnChange {
                Sync-UDElement -Id 'bookGrid'
            }
        }
        
        # Book Grid
        New-UDDynamic -Id 'bookGrid' -Content {
            try {
                $SearchTerm = (Get-UDElement -Id 'searchBox').Value
                $AllBooks = Get-Book
                
                if ($SearchTerm) {
                    $AllBooks = $AllBooks | Where-Object {
                        $_.Title -like "*$SearchTerm*" -or 
                        $_.ISBN -like "*$SearchTerm*" -or 
                        $_.Publishers -like "*$SearchTerm*" -or
                        $_.Author -like "*$SearchTerm*"
                    }
                }
                
                if ($AllBooks) {
                    # Stats bar
                    New-UDElement -Tag 'div' -Attributes @{ 
                        style = @{ 
                            marginBottom = '16px'
                            padding      = '12px 16px'
                            borderRadius = '8px'
                            background   = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
                        } 
                    } -Content {
                        New-UDTypography -Text "📖 $($AllBooks.Count) book$(if ($AllBooks.Count -ne 1) { 's' }) found" -Variant body1 -Style @{ 
                            color      = 'white'
                            fontWeight = 'bold'
                        }
                    }
                    
                    # Grid of book cards
                    New-UDElement -Tag 'div' -Attributes @{ 
                        style = @{ 
                            display             = 'grid'
                            gridTemplateColumns = 'repeat(auto-fill, minmax(280px, 1fr))'
                            gap                 = '16px'
                        } 
                    } -Content {
                        foreach ($book in $AllBooks) {
                            New-UDCard -Elevation 2 -Content {
                                New-UDStack -Direction 'row' -Spacing 2 -Content {
                                    if ($book.CoverUrl) {
                                        New-UDElement -Tag 'div' -Attributes @{ 
                                            style = @{ 
                                                borderRadius = '4px'
                                                overflow     = 'hidden'
                                                boxShadow    = '0 2px 8px rgba(0,0,0,0.15)'
                                                flexShrink   = '0'
                                            } 
                                        } -Content {
                                            New-UDImage -Url $book.CoverUrl -Height 120 -Width 80
                                        }
                                    }
                                    else {
                                        New-UDElement -Tag 'div' -Attributes @{ 
                                            style = @{ 
                                                width          = '80px'
                                                height         = '120px'
                                                borderRadius   = '4px'
                                                background     = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
                                                display        = 'flex'
                                                alignItems     = 'center'
                                                justifyContent = 'center'
                                                fontSize       = '32px'
                                                flexShrink     = '0'
                                            } 
                                        } -Content {
                                            New-UDHTML -Markup '📖'
                                        }
                                    }
                                    
                                    New-UDStack -Direction 'column' -Justify 'center' -Content {
                                        New-UDTypography -Text $book.Title -Variant body1 -Style @{ 
                                            fontWeight      = 'bold'
                                            overflow        = 'hidden'
                                            textOverflow    = 'ellipsis'
                                            display         = '-webkit-box'
                                            WebkitLineClamp = '2'
                                            WebkitBoxOrient = 'vertical'
                                        }
                                        New-UDTypography -Text "ISBN: $($book.ISBN)" -Variant caption -Style @{ fontFamily = 'monospace' }
                                        
                                        if ($book.Author -and $book.Author -ne 'N/A') {
                                            New-UDStack -Direction 'row' -AlignItems 'center' -Spacing 1 -Content {
                                                New-UDHTML -Markup '✒️'
                                                New-UDTypography -Text $book.Author -Variant caption
                                            }
                                        }
                                        
                                        if ($book.PublishDate -and $book.PublishDate -ne 'N/A') {
                                            New-UDStack -Direction 'row' -AlignItems 'center' -Spacing 1 -Content {
                                                New-UDHTML -Markup '📅'
                                                New-UDTypography -Text $book.PublishDate -Variant caption
                                            }
                                        }
                                    }
                                }
                            } -Style @{ cursor = 'pointer'; transition = 'transform 0.2s, box-shadow 0.2s' } -OnClick {
                                Show-UDModal -Content {
                                    New-UDStack -Direction 'column' -Spacing 3 -Content {
                                        New-UDElement -Tag 'div' -Attributes @{ 
                                            style = @{ 
                                                background   = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
                                                padding      = '20px'
                                                borderRadius = '8px'
                                                marginBottom = '16px'
                                            } 
                                        } -Content {
                                            New-UDTypography -Text $book.Title -Variant h5 -Style @{ color = 'white'; fontWeight = 'bold'; textAlign = 'center' }
                                        }
                                        
                                        if ($book.CoverUrl) {
                                            New-UDElement -Tag 'div' -Attributes @{ style = @{ textAlign = 'center'; margin = '16px 0' } } -Content {
                                                New-UDElement -Tag 'div' -Attributes @{ 
                                                    style = @{ display = 'inline-block'; borderRadius = '8px'; overflow = 'hidden'; boxShadow = '0 8px 24px rgba(0,0,0,0.2)' } 
                                                } -Content {
                                                    New-UDImage -Url $book.CoverUrl -Height 250
                                                }
                                            }
                                        }
                                        
                                        New-UDElement -Tag 'div' -Attributes @{ 
                                            style = @{ padding = '20px'; borderRadius = '8px' } 
                                        } -Content {
                                            New-UDStack -Direction 'column' -Spacing 2 -Content {
                                                New-UDElement -Tag 'div' -Attributes @{ 
                                                    style = @{ display = 'grid'; gridTemplateColumns = 'auto 1fr'; gap = '12px'; alignItems = 'start' } 
                                                } -Content {
                                                    New-UDTypography -Text "📖 ISBN:" -Variant subtitle2 -Style @{ fontWeight = 'bold'; color = '#667eea' }
                                                    New-UDTypography -Text $book.ISBN -Variant body2 -Style @{ fontFamily = 'monospace' }
                                                    
                                                    if ($book.Publishers -and $book.Publishers -ne 'N/A') {
                                                        New-UDTypography -Text "🏢 Publisher:" -Variant subtitle2 -Style @{ fontWeight = 'bold'; color = '#667eea' }
                                                        New-UDTypography -Text $book.Publishers -Variant body2
                                                    }
                                                    
                                                    if($Book.Author -and $book.Author -ne 'N/A') {
                                                        New-UDTypography -Text "✒️: Author" -Variant subtitle2 -Style @{ fontWeight = 'bold'; color = '#667eea' }
                                                        New-UDTypography -Text $book.Author -Variant body2 -Style @{ fontFamily = 'monospace'}
                                                    }
                                                    if ($book.PublishDate -and $book.PublishDate -ne 'N/A') {
                                                        New-UDTypography -Text "📅 Published:" -Variant subtitle2 -Style @{ fontWeight = 'bold'; color = '#667eea' }
                                                        New-UDTypography -Text $book.PublishDate -Variant body2
                                                    }
                                                    
                                                    if ($book.NumberOfPages) {
                                                        New-UDTypography -Text "📄 Pages:" -Variant subtitle2 -Style @{ fontWeight = 'bold'; color = '#667eea' }
                                                        New-UDTypography -Text $book.NumberOfPages -Variant body2
                                                    }
                                                    
                                                    New-UDTypography -Text "🕒 Scanned:" -Variant subtitle2 -Style @{ fontWeight = 'bold'; color = '#667eea' }
                                                    New-UDTypography -Text $book.ScannedAt -Variant body2
                                                }
                                                
                                                if ($book.FirstSentence -and $book.FirstSentence -ne 'N/A') {
                                                    New-UDElement -Tag 'div' -Attributes @{ style = @{ height = '8px' } }
                                                    New-UDElement -Tag 'div' -Attributes @{ 
                                                        style = @{ padding = '16px'; borderRadius = '8px'; borderLeft = '4px solid #667eea' } 
                                                    } -Content {
                                                        New-UDTypography -Text "📝 First Sentence" -Variant subtitle2 -Style @{ fontWeight = 'bold'; color = '#667eea'; marginBottom = '8px' }
                                                        New-UDTypography -Text $book.FirstSentence -Variant body2 -Style @{ fontStyle = 'italic' }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } -Header {
                                    New-UDStack -Direction 'row' -AlignItems 'center' -Spacing 1 -Content {
                                        New-UDHTML -Markup '📚'
                                        New-UDTypography -Text "Book Details" -Variant h6 -Style @{ fontWeight = 'bold' }
                                    }
                                } -Footer {
                                    New-UDStack -Spacing 2 -Direction row -Children {
                                        New-UDButton -Text 'Delete' -OnClick { 
                                            $isbnToDelete = $book.ISBN
                                            Hide-UDModal
    
                                            Show-UDModal -Content {
                                                New-UDTypography -Text "Are you sure you want to delete this book?" -Variant h6
                                                New-UDTypography -Text "ISBN: $isbnToDelete" -Variant body2 -Style @{marginTop = '8px' }
                                            } -Header {
                                                New-UDTypography -Text "⚠️ Confirm Deletion" -Variant h6
                                            } -Footer {
                                                New-UDStack -Direction row -Spacing 2 -Content {
                                                    New-UDButton -Text 'Yes, Delete' -Color error -OnClick { 
                                                        Remove-Book -ISBN $isbnToDelete -Force
                                                        Hide-UDModal
                                                        Sync-UDElement -Id 'bookGrid' -Broadcast
                                                    }
                                                    New-UDButton -Text 'Cancel' -OnClick { Hide-UDModal }
                                                }
                                            } -FullWidth -MaxWidth 'xs'
                                        }
                                        New-UDButton -Text "Close" -OnClick { Hide-UDModal } -Variant contained -Color primary
                                    }
                                } -FullWidth -MaxWidth 'sm'
                            }
                        }
                    }
                }
                else {
                    New-UDElement -Tag 'div' -Attributes @{ style = @{ textAlign = 'center'; padding = '60px 20px' } } -Content {
                        New-UDElement -Tag 'div' -Attributes @{ style = @{ fontSize = '64px'; marginBottom = '16px' } } -Content {
                            New-UDHTML -Markup '🔍'
                        }
                        if ($SearchTerm) {
                            New-UDTypography -Text "No books found for '$SearchTerm'" -Variant h6 -Style @{ fontWeight = 'bold' }
                            New-UDTypography -Text 'Try a different search term' -Variant body2 -Style @{ marginTop = '8px' }
                        }
                        else {
                            New-UDTypography -Text 'No books in your library yet!' -Variant h6 -Style @{ fontWeight = 'bold' }
                            New-UDTypography -Text 'Go to the Home page to scan some books' -Variant body2 -Style @{ marginTop = '8px' }
                        }
                    }
                }
            }
            catch {
                New-UDAlert -Severity warning -Text "Could not load books: $_"
            }
        }
    }
}
