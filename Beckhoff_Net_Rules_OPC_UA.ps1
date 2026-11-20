# Expose the TwinCAT OPC UA server on a virtual machine.
# UA Expert on the host connects to opc.tcp://<VM-IP-address>:4840
# Run on the VM as Administrator.

$ruleName = 'OPC_UA_Server'

$existing = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
if ($existing) {
    Remove-NetFirewallRule -DisplayName $ruleName
}

New-NetFirewallRule -DisplayName $ruleName `
    -Description 'Allows UA Expert on the host to connect to the OPC UA server on the VM (port 4840/TCP).' `
    -LocalPort 4840 `
    -Action Allow `
    -Profile Any `
    -Protocol TCP `
    -Direction Inbound
