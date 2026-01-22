---
document type: cmdlet
external help file: PowerShellUniversal.Apps.Bookworm-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PowerShellUniversal.Apps.Bookworm
ms.date: 01/13/2026
PlatyPS schema version: 2024-05-01
title: Initialize-BookwormDbFile
---

# Initialize-BookwormDbFile

## SYNOPSIS

Creates the SQLite database file if it doesn't exist.

## SYNTAX

### __AllParameterSets

```
Initialize-BookwormDbFile [-DatabaseFile] <string> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Checks if the specified SQLite database file exists and creates an empty file if missing.
This is a simple file creation utility that ensures the database file is present before 
applying schema or running queries.
The function is idempotent - it won't overwrite 
existing files.

## EXAMPLES

### EXAMPLE 1

Initialize-BookwormDbFile -DatabaseFile 'C:\data\library.db'

Creates an empty database file at the specified path if it doesn't exist.

### EXAMPLE 2

$dbPath = Get-DatabasePath
Initialize-BookwormDbFile -DatabaseFile $dbPath
Initialize-BookwormDatabase -Database $dbPath

Creates the database file, then applies the schema.

### EXAMPLE 3

if (-not (Test-Path $dbPath)) {
    Initialize-BookwormDbFile -DatabaseFile $dbPath
}

Manually checks before creating the file (though the function handles this internally).

## PARAMETERS

### -DatabaseFile

Path to the SQLite database file to create.
If the file already exists, no action is taken.
Parent directories must already exist.

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

## NOTES

This function only creates the file, it does not create the schema.
Use Initialize-BookwormDatabase to create the file AND apply the schema.
The function is idempotent - safe to run multiple times.


## RELATED LINKS

{{ Fill in the related links here }}

