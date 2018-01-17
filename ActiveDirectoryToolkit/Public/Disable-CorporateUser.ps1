function Disable-CorporateUser {
    #Requires -Version 3.0 -Module 'ActiveDirectory'
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .EXAMPLE
        PS C:\> <example usage>
        Explanation of what the example does
    .INPUTS
        Inputs (if any)
    .OUTPUTS
        Output (if any)
    .NOTES
        General notes
    #>
    [CmdletBinding(
        ConfirmImpact = 'High',
        DefaultParameterSetName = 'Identity',
        SupportsShouldProcess
    )]
    param (
        # Parameter help description
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Identity',
            Position = 1,
            ValueFromPipeline = $true
        )]
        [string[]] $Identity,

        # Parameter help description
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Filter'
        )]
        [scriptblock] $Filter,

        # Parameter help description
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
