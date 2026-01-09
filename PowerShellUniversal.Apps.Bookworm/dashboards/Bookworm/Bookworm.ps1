[CmdletBinding()]
Param()

end {
    $Navigation = New-UDList -Content {
        New-UDListItem -Label "Home" -Icon (New-UDIcon -Icon Home) -OnClick { Invoke-UDRedirect -Url '/Home' }
        New-UDListItem -Label "Browse" -Icon (New-UDIcon -Icon Book) -OnClick { Invoke-UDRedirect -Url '/Browse' }
    }

    $app = @{
        Title            = 'Bookworm: A personal library application'
        Pages            = @($homepage, $browse)
        Navigation       = $Navigation
        NavigationLayout = 'Temporary'
    }

    New-UDApp @app

}