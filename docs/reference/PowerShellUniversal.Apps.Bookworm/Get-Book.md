---
document type: cmdlet
external help file: PowerShellUniversal.Apps.Bookworm-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PowerShellUniversal.Apps.Bookworm
ms.date: 01/13/2026
PlatyPS schema version: 2024-05-01
title: Get-Book
---

# Get-Book

## SYNOPSIS

Retrieves books from the Bookworm database.

## SYNTAX

### All (Default)

```
Get-Book [-DatabasePath <string>] [-Limit <int>] [<CommonParameters>]
```

### ISBN

```
Get-Book [-ISBN <string>] [-DatabasePath <string>] [-Limit <int>] [<CommonParameters>]
```

### Title

```
Get-Book [-Title <string>] [-DatabasePath <string>] [-Limit <int>] [<CommonParameters>]
```

### Author

```
Get-Book [-Author <string>] [-DatabasePath <string>] [-Limit <int>] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Queries the Books table based on ISBN, Title, or Author parameters.
If no parameters are provided, returns all books.

## EXAMPLES

### EXAMPLE 1

Get-Book

Returns all books in the Bookworm.

### EXAMPLE 2

Get-Book -ISBN '9780134685991'

Returns the book with the specified ISBN.

### EXAMPLE 3

Get-Book -Title 'Clean Code'

Returns all books with titles containing 'Clean Code'.

### EXAMPLE 4

Get-Book -Limit 10

Returns the 10 most recently scanned books.

## PARAMETERS

### -Author

Filter by Author (partial match, case-insensitive).
Note: Currently not implemented in schema, reserved for future use.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Author
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -DatabasePath

Path to the SQLite database file.
Defaults to module data directory.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ISBN

Filter by ISBN (exact match).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ISBN
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Limit

Maximum number of results to return.
Defaults to 100.

```yaml
Type: System.Int32
DefaultValue: 100
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Title

Filter by Title (partial match, case-insensitive).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Title
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

