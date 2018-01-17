#Requires -Version 3.0 -Module ActiveDirectory
function Get-ADUserLastLogon {
    <#
    .SYNOPSIS
        Gets last logon date for one or more Active Directory users.
    .DESCRIPTION
        The Get-ADUserLastLogon cmdlet gets the last logon date for Active Directory user(s) querying all active domain controllers in the current domain.
    .EXAMPLE
        Get-ADUserLastLogin -Identity 'MyUserName'
    .INPUTS
        None
    .OUTPUTS
        Returns one or more custom objects.
    .NOTES
        Author: Trent Willingham
        Check out my other scripts and projects @ https://github.com/twillin912
    .LINK
        http://activedirectorytoolkit.readthedocs.io/en/latest/en-US/Get-ADUserLastLogon
    #>
    [CmdletBinding()]
    [OutputType([PSObject])]
    param (
        # Specifies an Active Directory user object by providing the user logon name.
        [Parameter(Mandatory = $true, Position = 0)]
        [Alias('UserName')]
        [string[]] $Identity
    )

    begin {
        $ADServers = Get-ADDomainController -Filter '*' | Sort-Object -Property Name
    } #section begin

    process {
        foreach ($Username in $Identity) {
            foreach ($ADServer in $ADServers) {
                try {
                    $User = Get-ADUser -Identity $Username -Server $ADServer.Name -Properties LastLogon
                    $LastLogonDate = [DateTime]::FromFileTime($User.LastLogon)
                    $UserOutput = New-Object -TypeName PSObject
                    $UserOutput | Add-Member -MemberType NoteProperty -Name 'SamAccountName' -Value $User.SamAccountName
                    $UserOutput | Add-Member -MemberType NoteProperty -Name 'DomainController' -Value $ADServer.Name
                    $UserOutput | Add-Member -MemberType NoteProperty -Name 'LastLogonDate' -Value $LastLogonDate
                    $UserOutput.PSObject.TypeNames.Insert(0, 'ActiveDirectoryToolkit.LastLogon')
                    Write-Output -InputObject $UserOutput
                }
                catch {
                    Write-Error -Message "Failed to retieve user '$UserName' from '$($ADServer.Name)'"
                    continue
                }
            } #foreaach ADServer
        } #foreach User
    } #section process

    end {
    } #section end

} #function Get-ADUserLastLogon
