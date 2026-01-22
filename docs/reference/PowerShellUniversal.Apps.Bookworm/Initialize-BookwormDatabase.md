---
document type: cmdlet
external help file: PowerShellUniversal.Apps.Bookworm-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PowerShellUniversal.Apps.Bookworm
ms.date: 01/13/2026
PlatyPS schema version: 2024-05-01
title: Initialize-BookwormDatabase
---

# Initialize-BookwormDatabase

## SYNOPSIS

Initializes the Bookworm library SQLite database with required schema.

## SYNTAX

### __AllParameterSets

```
Initialize-BookwormDatabase [-Schema] <string> [-Database] <string> [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Creates the SQLite database and applies the schema to create necessary tables.
The schema includes the 'books' table with columns for ISBN, Title, PublishDate, Publishers, 
NumberOfPages, CoverUrl, FirstSentence, and ScannedAt timestamp.

Schema can be provided as a file path or raw SQL string.
Uses "CREATE TABLE IF NOT EXISTS" to safely handle existing databases.

## EXAMPLES

### EXAMPLE 1

Initialize-BookwormDatabase

Creates the database using default schema and path.

### EXAMPLE 2

Initialize-BookwormDatabase -Schema 'C:\custom\schema.sql' -Database 'C:\data\mybooks.db'

Initializes a custom database with a custom schema file.

### EXAMPLE 3

$sql = "CREATE TABLE IF NOT EXISTS books (ISBN TEXT PRIMARY KEY, Title TEXT)"
Initialize-BookwormDatabase -Schema $sql -Database 'C:\temp\test.db'

Creates a database with inline SQL schema.

### EXAMPLE 4

Initialize-BookwormDatabase -Database 'C:\temp\newlibrary.db'

Creates a new database at a specific path using the default schema.

## PARAMETERS

### -Database

Path to the SQLite database file.
If not specified, uses the module's configured database path from Get-DatabasePath.

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

### -Schema

Path to a SQL schema file (.sql) OR raw SQL string to execute.
If a file path is provided, the file content is read and executed.
If not specified, uses the default schema from data\Database-Schema.sql.

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

Requires the Invoke-UniversalSQLiteQuery function for database operations.
The function is idempotent - safe to run multiple times.
Uses "CREATE TABLE IF NOT EXISTS" to prevent errors on existing tables.


## RELATED LINKS

{{ Fill in the related links here }}

