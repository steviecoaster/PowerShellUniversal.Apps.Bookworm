---
document type: cmdlet
external help file: PowerShellUniversal.Apps.Bookworm-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PowerShellUniversal.Apps.Bookworm
ms.date: 01/13/2026
PlatyPS schema version: 2024-05-01
title: Get-DatabasePath
---

# Get-DatabasePath

## SYNOPSIS

Returns the configured database path for the Bookworm library.

## SYNTAX

### __AllParameterSets

```
Get-DatabasePath [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Retrieves the SQLite database path from the module-level $script:DatabasePath variable.
If no custom path is configured, returns the default path in $env:ProgramData\Library\Library.db.
This function ensures consistent database path access across all module functions.

## EXAMPLES

### EXAMPLE 1

Get-DatabasePath

Returns the current database path.

### EXAMPLE 2

$dbPath = Get-DatabasePath
if (Test-Path $dbPath) {
    Write-Host "Database exists at $dbPath"
}

Checks if the database file exists at the configured path.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
The full path to the SQLite database file.

{{ Fill in the Description }}

## NOTES

The database path can be configured using $script:DatabasePath in the module.
Default path is $env:ProgramData\Library\Library.db.
This function is used internally by other module functions for consistency.


## RELATED LINKS

{{ Fill in the related links here }}

