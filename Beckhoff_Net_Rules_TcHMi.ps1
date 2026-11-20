# Expose the TwinCAT HMI server (TF2000).
# The client connects over HTTP or HTTPS.
# Run as Administrator.
#
# Ports according to Beckhoff documentation (IPC security / TF2000):
#   HTTP  1010 (versions <= 1.12), 2010 (versions >= 1.14) — localhost only by default (127.0.0.1)
#   HTTPS 1020 (versions <= 1.12), 2020 (versions >= 1.14) — all interfaces by default
#   HTTP  80 — WebView
# Remote access should use HTTPS. HTTP ports are opened in case the endpoint is bound to 0.0.0.0.

$ruleName = 'TwinCAT_HMI'

$existing = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
if ($existing) {
    Remove-NetFirewallRule -DisplayName $ruleName
}

New-NetFirewallRule -DisplayName $ruleName `
    -Description 'Allows a client to connect to the TwinCAT HMI server (HTTP 80/1010/2010, HTTPS 1020/2020).' `
    -LocalPort 80, 1010, 1020, 2010, 2020 `
    -Action Allow `
    -Profile Any `
    -Protocol TCP `
    -Direction Inbound
