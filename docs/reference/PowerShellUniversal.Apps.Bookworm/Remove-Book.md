---
document type: cmdlet
external help file: PowerShellUniversal.Apps.Bookworm-Help.xml
HelpUri: ''
Locale: en-US
Module Name: PowerShellUniversal.Apps.Bookworm
ms.date: 01/13/2026
PlatyPS schema version: 2024-05-01
title: Remove-Book
---

# Remove-Book

## SYNOPSIS

Removes books from the Bookworm database.

## SYNTAX

### ISBN (Default)

```
Remove-Book [-ISBN <string>] [-DatabasePath <string>] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Title

```
Remove-Book [-Title <string>] [-DatabasePath <string>] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Id

```
Remove-Book [-Id <int>] [-DatabasePath <string>] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases,
  {{Insert list of aliases}}

## DESCRIPTION

Deletes books from the Books table based on ISBN, Title pattern, or ID.
Supports pipeline input and confirmation prompts.

## EXAMPLES

### EXAMPLE 1

Remove-Book -ISBN '9780134685991'

Removes the book with the specified ISBN.

### EXAMPLE 2

Remove-Book -Id 5 -Force

Removes the book with ID 5 without confirmation.

### EXAMPLE 3

Get-Book -Title 'Old Book' | Remove-Book

Gets books matching 'Old Book' and removes them (with confirmation).

### EXAMPLE 4

Remove-Book -Title 'Test' -Force

Removes all books with 'Test' in the title without confirmation.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
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

### -Force

Skip confirmation prompts.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -Id

Remove book by database ID (exact match).

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ISBN

Remove book by ISBN (exact match).

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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Title

Remove books with titles matching this pattern (partial match, case-insensitive).
Use with caution as it can match multiple books.

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

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

{{ Fill in the Description }}

### System.Int32

{{ Fill in the Description }}

## OUTPUTS

## NOTES

## RELATED LINKS

{{ Fill in the related links here }}

