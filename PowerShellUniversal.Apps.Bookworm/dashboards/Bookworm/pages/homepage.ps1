$homepage = New-UDPage -id 'homepage' -Name 'Home' -Url '/Home' -Content {
    
    # Load the bookworm logo as Base64
    $Module = Get-Module -Name 'PowerShellUniversal.Apps.Bookworm'
    $LogoPath = Join-Path $Module.ModuleBase 'assets' 'bookworm.png'
    $LogoBase64 = if (Test-Path $LogoPath) {
        $bytes = [System.IO.File]::ReadAllBytes($LogoPath)
        $base64 = [System.Convert]::ToBase64String($bytes)
        "data:image/png;base64,$base64"
    }
    else {
        $null
    }
    
    New-UDContainer -Content {
        
        # Hero Section with Logo
        New-UDElement -Tag 'div' -Attributes @{ 
            style = @{ 
                background   = 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)'
                padding      = '40px 20px'
                borderRadius = '12px'
                marginBottom = '24px'
                boxShadow    = '0 4px 12px rgba(0,0,0,0.1)'
            } 
        } -Content {
            New-UDStack -Direction 'column' -AlignItems 'center' -Spacing 2 -Content {
                if ($LogoBase64) {
                    New-UDElement -Tag 'div' -Attributes @{ 
                        style = @{ 
                            background   = 'white'
                            borderRadius = '50%'
                            padding      = '20px'
                            boxShadow    = '0 8px 16px rgba(0,0,0,0.2)'
                            marginBottom = '16px'
                        } 
                    } -Content {
                        New-UDImage -Url $LogoBase64 -Height 120 -Width 120 -Attributes @{
                            style = @{ display = 'block' }
                        }
                    }
                }
                
                New-UDTypography -Text '📚 Bookworm Library' -Variant h3 -Align center -Style @{
                    color      = 'white'
                    fontWeight = 'bold'
                    textShadow = '2px 2px 4px rgba(0,0,0,0.3)'
                }
                
                New-UDTypography -Text 'Scan, Organize, and Manage Your Personal Library' -Variant h6 -Align center -Style @{
                    color      = 'rgba(255,255,255,0.95)'
                    fontWeight = '300'
                    marginTop  = '8px'
                }
            }
        }
        
        New-UDElement -Tag 'div' -Attributes @{ style = @{ height = '24px' } }
        
        New-UDStack -Direction 'column' -Spacing 3 -Content {
            
            # Scanner Section
            New-UDElement -Tag 'div' -Attributes @{ 
                style = @{ 
                    padding      = '24px'
                    borderRadius = '12px'
                } 
            } -Content {
                New-UDStack -Direction 'row' -AlignItems 'center' -Spacing 2 -Content {
                    New-UDElement -Tag 'div' -Attributes @{ 
                        style = @{ fontSize = '36px'; marginRight = '8px' } 
                    } -Content {
                        New-UDHTML -Markup '📷'
                    }
                    New-UDStack -Direction 'column' -Content {
                        New-UDTypography -Text 'Scan Book' -Variant h5 -Style @{ fontWeight = 'bold' }
                        New-UDTypography -Text 'Point your camera at the ISBN barcode' -Variant body2
                    }
                }
                
                New-UDElement -Tag 'div' -Attributes @{ style = @{ height = '16px' } }
                
                New-UDElement -Tag 'div' -Attributes @{ 
                    style = @{ 
                        borderRadius = '8px'
                        overflow     = 'hidden'
                        border       = '3px solid #667eea'
                        boxShadow    = '0 4px 12px rgba(102, 126, 234, 0.2)'
                    } 
                } -Content {
                    New-UDBarcodeScanner -Width '100%' -Height 750 -FacingMode 'environment' -OnScan {
                        $ISBN = $EventData
                        Show-UDToast -Message "🔍 Scanning: $ISBN" -Duration 2000
                        
                        try {
                            $BookMetadata = Get-BookMetadata -ISBN $ISBN
                            $null = $BookMetadata | Add-Book
                            Show-UDToast -Message "✅ Added: $($BookMetadata.Title)" -Duration 3000 -MessageColor success
                            Sync-UDElement -Id 'recentBooks'
                            Sync-UDElement -Id 'bookGrid' -Broadcast
                        }
                        catch {
                            Show-UDToast -Message "❌ Error: $_" -Duration 4000 -MessageColor error
                        }
                    }
                }
            }
            
            # Recent Books Section
            New-UDElement -Tag 'div' -Attributes @{ 
                style = @{ 
                    padding      = '24px'
                    borderRadius = '12px'
                } 
            } -Content {
                New-UDStack -Direction 'row' -AlignItems 'center' -Spacing 2 -Content {
                    New-UDElement -Tag 'div' -Attributes @{ 
                        style = @{ fontSize = '36px'; marginRight = '8px' } 
                    } -Content {
                        New-UDHTML -Markup '📚'
                    }
                    New-UDStack -Direction 'column' -Content {
                        New-UDTypography -Text 'Recent Books' -Variant h5 -Style @{ fontWeight = 'bold' }
                        New-UDTypography -Text 'Your latest additions' -Variant body2
                    }
                }
                
                New-UDElement -Tag 'div' -Attributes @{ style = @{ height = '16px' } }
                
                New-UDDynamic -Id 'recentBooks' -Content {
                    try {
                        $RecentBooks = Get-Book -Limit 5
                        
                        if ($RecentBooks) {
                            New-UDStack -Direction 'column' -Spacing 2 -Content {
                                foreach ($book in $RecentBooks) {
                                    New-UDCard -Elevation 2 -Content {
                                        New-UDStack -Direction 'row' -Spacing 2 -Content {
                                            if ($book.CoverUrl) {
                                                New-UDElement -Tag 'div' -Attributes @{ 
                                                    style = @{ 
                                                        borderRadius = '4px'
                                                        overflow     = 'hidden'
                                                        boxShadow    = '0 2px 8px rgba(0,0,0,0.15)'
                                                    } 
                                                } -Content {
                                                    New-UDImage -Url $book.CoverUrl -Height 100 -Width 75
                                                }
                                            }
                                            
                                            New-UDStack -Direction 'column' -Justify 'center' -Content {
                                                New-UDTypography -Text $book.Title -Variant body1 -Style @{ fontWeight = 'bold' }
                                                New-UDTypography -Text "ISBN: $($book.ISBN)" -Variant caption -Style @{ fontFamily = 'monospace' }
                                                
                                                if ($book.Publishers -and $book.Publishers -ne 'N/A') {
                                                    New-UDStack -Direction 'row' -AlignItems 'center' -Spacing 1 -Content {
                                                        New-UDHTML -Markup '🏢'
                                                        New-UDTypography -Text $book.Publishers -Variant caption
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
                                            New-UDButton -Text "Close" -OnClick { Hide-UDModal } -Variant contained -Color primary
                                        } -FullWidth -MaxWidth 'sm'
                                    }
                                }
                            }
                        }
                        else {
                            New-UDElement -Tag 'div' -Attributes @{ style = @{ textAlign = 'center'; padding = '40px 20px' } } -Content {
                                New-UDElement -Tag 'div' -Attributes @{ style = @{ fontSize = '64px'; marginBottom = '16px' } } -Content {
                                    New-UDHTML -Markup '📚'
                                }
                                New-UDTypography -Text 'No books yet!' -Variant h6 -Style @{ fontWeight = 'bold' }
                                New-UDTypography -Text 'Start scanning to build your library' -Variant body2 -Style @{ marginTop = '8px' }
                            }
                        }
                    }
                    catch {
                        New-UDAlert -Severity warning -Text "Could not load books: $_"
                    }
                }
            }
        }
    }
}