---
document type: cmdlet
external help file: PowerShellUniversal.Apps.Bookworm-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PowerShellUniversal.Apps.Bookworm
ms.date: 01/13/2026
PlatyPS schema version: 2024-05-01
title: Get-BookMetadata
---

# Get-BookMetadata

## SYNOPSIS

Retrieves book metadata from the Open Library API.

## SYNTAX

### __AllParameterSets

```
Get-BookMetadata [-ISBN] <string> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Fetches detailed book information from Open Library using an ISBN.
Returns book title, publisher, publication date, page count, cover URL, and first sentence.
If the book is not found, returns a placeholder object with the ISBN.

## EXAMPLES

### EXAMPLE 1

Get-BookMetadata -ISBN '9780134685991'
Retrieves metadata for Effective Java (3rd Edition).

### EXAMPLE 2

$metadata = Get-BookMetadata -ISBN '9780062316097'
Add-Book @metadata

Fetches book metadata and pipes it to Add-Book for storage.

### EXAMPLE 3

'9780134685991', '9780062316097' | ForEach-Object { Get-BookMetadata -ISBN $_ }

Retrieves metadata for multiple books.

## PARAMETERS

### -ISBN

The ISBN (International Standard Book Number) of the book to look up.
Can be ISBN-10 or ISBN-13 format.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
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

### PSCustomObject with properties:
- ISBN: The book's ISBN
- Title: Book title
- PublishDate: Publication date
- Publishers: Publisher name(s)
- NumberOfPages: Page count
- CoverUrl: URL to book cover image
- FirstSentence: Opening sentence of the book
- ScannedAt: Timestamp when metadata was retrieved

{{ Fill in the Description }}

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

