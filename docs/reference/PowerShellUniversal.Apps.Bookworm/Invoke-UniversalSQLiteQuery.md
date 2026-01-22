---
document type: cmdlet
external help file: PowerShellUniversal.Apps.Bookworm-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PowerShellUniversal.Apps.Bookworm
ms.date: 01/13/2026
PlatyPS schema version: 2024-05-01
title: Invoke-UniversalSQLiteQuery
---

# Invoke-UniversalSQLiteQuery

## SYNOPSIS

Execute SQLite queries using the sqlite3 command-line tool

## SYNTAX

### __AllParameterSets

```
Invoke-UniversalSQLiteQuery [-Path] <string> [-Query] <string> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

A wrapper function that executes SQLite queries using the native sqlite3 CLI.
This provides cross-platform compatibility without requiring PowerShell modules.

## EXAMPLES

### EXAMPLE 1

Invoke-UniversalSQLiteQuery -Path "./data/HerdManager.db" -Query "SELECT * FROM Cattle"

## PARAMETERS

### -Path

Path to the SQLite database file

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

### -Query

SQL query to execute

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
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

Requires sqlite3 to be installed and available in PATH


## RELATED LINKS

{{ Fill in the related links here }}

