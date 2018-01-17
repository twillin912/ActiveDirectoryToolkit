---
external help file: ActiveDirectoryToolkit-help.xml
Module Name: ActiveDirectoryToolkit
online version: http://activedirectorytoolkit.readthedocs.io/en/latest/en-US/Disable-CorporateUser
schema: 2.0.0
---

# Disable-CorporateUser

## SYNOPSIS
Disable one or more AD user accounts with cleanup steps.

## SYNTAX

### Identity (Default)
```
Disable-CorporateUser [-Identity] <String[]> [[-OUName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Filter
```
Disable-CorporateUser -Filter <String> [[-OUName] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Disable-CorporateUser cmdlet disables an Active Directory user account and performs additional cleanup steps including removing from Active Directory group, move the object to the DisabledUsers OU and hiding the mailbox from the address book.

## EXAMPLES

### EXAMPLE 1
```
Disable-CorporateUser -Identity 'MyUserName'
```

Disables the account with SamAccountName: MyUserName.

### EXAMPLE 2
```
Disable-CorporateUser -Identity 'CN=John Smith,OU=UserAccounts,DC=MYDOMAIN,DC=COM'
```

Disables the account with DistinguishedName: "CN=John Smith,OU=UserAccounts,DC=MYDOMAIN,DC=COM".

### EXAMPLE 3
```
Disable-CorporateUser -Filter {Name -like '* Smith'}
```

Disables all users with the last name 'Smith'.

## PARAMETERS

### -Identity
Specifies an Active Directory user account object by providing either SAM Account Name or Distinguished Name.

```yaml
Type: String[]
Parameter Sets: Identity
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Filter
Specifies a query string that retrieves Active Directory objects.

```yaml
Type: String
Parameter Sets: Filter
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OUName
Specified the name of the OU to move the disabled users to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Disabled Users
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Inputs (if any)

## OUTPUTS

### None

## NOTES
Author: Trent Willingham
Check out my other scripts and projects @ https://github.com/twillin912

## RELATED LINKS

[http://activedirectorytoolkit.readthedocs.io/en/latest/en-US/Disable-CorporateUser](http://activedirectorytoolkit.readthedocs.io/en/latest/en-US/Disable-CorporateUser)

