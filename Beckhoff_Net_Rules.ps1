# Firewall rules for IPC diagnostics, Remote Desktop, and TwinCAT ADS.
# Run as Administrator.
# An existing rule with the same name is removed before it is created again, so entries are not duplicated.

function Set-BeckhoffFirewallRule {
    param(
        [Parameter(Mandatory = $true)]
        [string] $DisplayName,

        [Parameter(Mandatory = $true)]
        [int[]] $LocalPort,

        [Parameter(Mandatory = $true)]
        [ValidateSet('TCP', 'UDP')]
        [string] $Protocol,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Inbound', 'Outbound')]
        [string] $Direction
    )

    $existing = Get-NetFirewallRule -DisplayName $DisplayName -ErrorAction SilentlyContinue
    if ($existing) {
        Remove-NetFirewallRule -DisplayName $DisplayName
    }

    New-NetFirewallRule -DisplayName $DisplayName `
        -LocalPort $LocalPort `
        -Action Allow `
        -Profile Any `
        -Protocol $Protocol `
        -Direction $Direction
}

Set-BeckhoffFirewallRule -DisplayName 'IPC_diagnostics' -LocalPort 443 -Protocol TCP -Direction Inbound
Set-BeckhoffFirewallRule -DisplayName 'RemoteDesktop' -LocalPort 3389 -Protocol TCP -Direction Inbound
Set-BeckhoffFirewallRule -DisplayName 'TwinCAT_ADS_UDP_In' -LocalPort 48899 -Protocol UDP -Direction Inbound
Set-BeckhoffFirewallRule -DisplayName 'TwinCAT_ADS_UDP_Out' -LocalPort 48899 -Protocol UDP -Direction Outbound
Set-BeckhoffFirewallRule -DisplayName 'TwinCAT_ADS_TCP_In' -LocalPort 8016, 48898 -Protocol TCP -Direction Inbound
Set-BeckhoffFirewallRule -DisplayName 'TwinCAT_ADS_TCP_Out' -LocalPort 8016, 48898 -Protocol TCP -Direction Outbound
Set-BeckhoffFirewallRule -DisplayName 'TwinCAT_Runtime_In' -LocalPort 851 -Protocol TCP -Direction Inbound
Set-BeckhoffFirewallRule -DisplayName 'TwinCAT_Runtime_Out' -LocalPort 851 -Protocol TCP -Direction Outbound

# Ping (ICMPv4 Echo Request, type 8). ICMP does not use a port.
foreach ($pingRule in @(
        @{ Name = 'IPC_ping_In'; Direction = 'Inbound' }
        @{ Name = 'IPC_ping_Out'; Direction = 'Outbound' }
    )) {
    $existing = Get-NetFirewallRule -DisplayName $pingRule.Name -ErrorAction SilentlyContinue
    if ($existing) {
        Remove-NetFirewallRule -DisplayName $pingRule.Name
    }

    New-NetFirewallRule -DisplayName $pingRule.Name `
        -Protocol ICMPv4 `
        -IcmpType 8 `
        -Action Allow `
        -Profile Any `
        -Direction $pingRule.Direction
}
