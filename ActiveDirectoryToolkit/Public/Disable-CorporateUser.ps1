#Requires -Version 3.0 -Module 'ActiveDirectory'
function Disable-CorporateUser {
    <#
    .SYNOPSIS
        Disable one or more AD user accounts with cleanup steps.
    .DESCRIPTION
        The Disable-CorporateUser cmdlet disables an Active Directory user account and performs additional cleanup steps including removing from Active Directory group, move the object to the DisabledUsers OU and hiding the mailbox from the address book.
    .EXAMPLE
        PS C:\> Disable-CorporateUser -Identity 'MyUserName'
        Disables the account with SamAccountName: MyUserName.
    .EXAMPLE
        PS C:\> Disable-CorporateUser -Identity 'CN=John Smith,OU=UserAccounts,DC=MYDOMAIN,DC=COM'
        Disables the account with DistinguishedName: "CN=John Smith,OU=UserAccounts,DC=MYDOMAIN,DC=COM".
    .EXAMPLE
        PS C:\> Disable-CorporateUser -Filter {Name -like '* Smith'}
        Disables all users with the last name 'Smith'.
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        None
    .NOTES
        Author: Trent Willingham
        Check out my other scripts and projects @ https://github.com/twillin912
    .LINK
        http://activedirectorytoolkit.readthedocs.io/en/latest/en-US/Disable-CorporateUser
    #>
    [CmdletBinding(
        ConfirmImpact = 'High',
        DefaultParameterSetName = 'Identity',
        SupportsShouldProcess
    )]
    param (
        # Specifies an Active Directory user account object by providing either SAM Account Name or Distinguished Name.
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Identity',
            Position = 1,
            ValueFromPipeline = $true
        )]
        [string[]] $Identity,

        # Specifies a query string that retrieves Active Directory objects.
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Filter'
        )]
        [string] $Filter,

        # Specified the name of the OU to move the disabled users to.
        [Parameter(
            Mandatory = $false,
            Position = 2
        )]
        [string] $OUName = 'Disabled Users'
    )

    begin {
        $null = Get-Command -Name Get-ADOrganizationalUnit -ErrorAction Stop
        $null = Get-Command -Name Get-ADUser -ErrorAction Stop
        $null = Get-Command -Name Get-Mailbox -ErrorAction Stop
        $DisabledUsersOU = Get-ADOrganizationalUnit -Filter {Name -eq $OUName}
        if (!($DisabledUsersOu)) {
            throw "Could not find OU '$OUName', because it does not exist."
        }
    } #begin

    process {
        Write-Progress -Id 1 -Activity 'Disable User Account' -Status 'Query AD for User Accounts' -PercentComplete 0
        $UsersToDisable = @()
        if ($PSCmdlet.ParameterSetName -eq 'Identity') {
            foreach ($IdentString in $Identity) {
                Write-Verbose -Message "Retreiving AD users that match identity '$IdentString'"
                $UsersToDisable += Get-ADUser -Identity $IdentString
            }
        }
        else {
            Write-Verbose -Message "Retreiving AD users that match filter '$Filter'"
            $UsersToDisable += Get-ADUser -Filter $Filter
        } #if paramset

        if (!($UsersToDisable)) {
            Write-Warning -Message 'No users found that match the search criteria.'
            return
        } #if userstodisable

        $UserProgress = 0
        $UserCount = ($UsersToDisable | Measure-Object).Count
        foreach ($User in $UsersToDisable) {
            Write-Progress -Id 1 -Activity 'Disable User Account' -Status "Processing User: $($User.Name)" -PercentComplete (($UserProgress / $UserCount) * 95 + 5)
            if ($PSCmdlet.ShouldProcess($User)) {
                Write-Verbose -Message "Disabling user '$($User.Name
                )'..."
                if ($User.Enabled) {
                    Write-Verbose -Message "  Disable AD user account"
                    $null = Disable-ADAccount -Identity $User
                    Set-ADUser -Identity $User -Description "Account Disabled on $((Get-Date).ToString("MM/dd/yyyy"))"
                }
                else {
                    Write-Verbose -Message "  Account already disabled"
                } #if user.enabled

                $UserGroups = Get-ADPrincipalGroupMembership -Identity $User | Where-Object { $_.SamAccountName -ne "Domain Users"}
                if ($UserGroups) {
                    foreach ($Group in $UserGroups) {
                        Write-Verbose -Message "  Removing from group '$($Group.Name)'"
                        Remove-ADGroupMember -Identity $Group -Members $User
                    }
                }
                else {
                    Write-Verbose -Message "  No groups to remove"
                } #if usergropus

                $Mailbox = Get-Mailbox -Identity $($User.UserPrincipalName) -ErrorAction SilentlyContinue
                if ($Mailbox) {
                    if ($Mailbox.HiddenFromAddressListsEnabled -eq $false) {
                        Write-Verbose -Message "  Hide Account from Address List"
                        Set-Mailbox -Identity $($User.UserPrincipalName) -HiddenFromAddressListsEnabled:$true
                    }
                    else {
                        Write-Verbose -Message "  Mailbox already hidden"
                    } #if mailbox.hidden
                }
                else {
                    Write-Verbose -Message "  No related mailbox found"
                } #if mailbox

                if ($User.DistinguishedName -notlike "*$DisabledUsersOU") {
                    Write-Verbose -Message "  Move AD object to DisabledUsers OU"
                    $null = Move-ADObject -Identity $User -TargetPath $DisabledUsersOU.DistinguishedName -PassThru
                }
                else {
                    Write-Verbose -Message "  Account already in DisabledUsers OU"
                } #if OU=Disabled

            } #shouldprocess
            $UserProgress++
        } #foreach user

    } #process

    end {

    } #end

}
