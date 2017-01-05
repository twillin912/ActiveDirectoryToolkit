function Get-ADUserLastLogon {
    <#
    .SYNOPSIS
        Gets last logon date for one or more Active Directory users.
    .DESCRIPTION
        The Get-ADUserLastLogon cmdlet gets the last logon date for Active Directory user(s) querying all active domain controllers in the current domain.
    .PARAMETER UserName
        Specifies an Active Directory user object by providing the user logon name.
    .EXAMPLE
        Get-ADUserLastLogin -UserName MyUser
    .INPUTS
        A user object is recieved by the UserName parameter.
    .OUTPUTS
        Returns one or more custom objects.
    .NOTES
        Author: Trent Willingham
        Check out my other scripts and projects @ https://github.com/twillin912
    .LINK
        https://poshzabbixtools.readthedocs.io/en/latest/Commands/Get-ZabbixHost
    #>
    [CmdletBinding()]
    [OutputType([PSObject])]

    Param (
        [Parameter(Mandatory=$true,Position=0)]
        [string] $UserName
    )

    Begin {
        $OutputObject = @()
        $DomainControllers = Get-ADDomainController -Filter { Name -like "*" }
    }

    Process {
        foreach ( $DomainController in $DomainControllers ) {
            $DCHostname = $DomainController.HostName
            $User = Get-ADUser $UserName -Server $DCHostname | Get-ADObject -Properties lastLogon
            $DisplayTime = [DateTime]::FromFileTime($User.LastLogon)
            $UserOutput = New-Object -TypeName PSObject
            $UserOutput | Add-Member -MemberType NoteProperty -Name samAccountName -Value $UserName
            $UserOutput | Add-Member -MemberType NoteProperty -Name DomainController -Value $DCHostname
            $UserOutput | Add-Member -MemberType NoteProperty -Name LastLogon -Value $DisplayTime
            $OutputObject += $UserOutput
        } # foreaach
    }

    End {
        Write-Output -InputObject $OutputObject
    }

} #function Get-ADUserLastLogon
