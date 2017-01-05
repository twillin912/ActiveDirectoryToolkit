---
external help file: ActiveDirectoryToolkit-help.xml
online version: http://activedirectorytoolkit.readthedocs.io/en/latest/en-US/Get-ADUserLastLogon/
schema: 2.0.0
---

# Get-ADUserLastLogon

## SYNOPSIS
Gets last logon date for one or more Active Directory users.

## SYNTAX

```
Get-ADUserLastLogon [-UserName] <String>
```

## DESCRIPTION
The Get-ADUserLastLogon cmdlet gets the last logon date for Active Directory user(s) querying all active domain controllers in the current domain.

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Get-ADUserLastLogin -UserName MyUser
```

## PARAMETERS

### -UserName
Specifies an Active Directory user object by providing the user logon name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### A user object is recieved by the UserName parameter.

## OUTPUTS

### Returns one or more custom objects.

## NOTES
Author: Trent Willingham
Check out my other scripts and projects @ https://github.com/twillin912

## RELATED LINKS

[https://poshzabbixtools.readthedocs.io/en/latest/Commands/Get-ZabbixHost](https://poshzabbixtools.readthedocs.io/en/latest/Commands/Get-ZabbixHost)

