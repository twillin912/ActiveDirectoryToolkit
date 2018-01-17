---
external help file: ActiveDirectoryToolkit-help.xml
Module Name: ActiveDirectoryToolkit
online version: http://activedirectorytoolkit.readthedocs.io/en/latest/en-US/Get-ADUserLastLogon/
schema: 2.0.0
---

# Get-ADUserLastLogon

## SYNOPSIS
Gets last logon date for one or more Active Directory users.

## SYNTAX

```
Get-ADUserLastLogon [-Identity] <String[]> [<CommonParameters>]
```

## DESCRIPTION
The Get-ADUserLastLogon cmdlet gets the last logon date for Active Directory user(s) querying all active domain controllers in the current domain.

## EXAMPLES

### EXAMPLE 1
```
Get-ADUserLastLogin -UserName MyUser
```

## PARAMETERS

### -Identity
{{Fill Identity Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: UserName

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### A user object is recieved by the UserName parameter.

## OUTPUTS

### Returns one or more custom objects.

## NOTES
Author: Trent Willingham
Check out my other scripts and projects @ https://github.com/twillin912

## RELATED LINKS

[https://poshzabbixtools.readthedocs.io/en/latest/Commands/Get-ZabbixHost](https://poshzabbixtools.readthedocs.io/en/latest/Commands/Get-ZabbixHost)

