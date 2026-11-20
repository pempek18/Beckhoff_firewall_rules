# Beckhoff firewall rules

PowerShell scripts that create Windows Firewall allow rules for Beckhoff TwinCAT IPC communication.

Each script removes an existing rule with the same display name before creating it, so it can be run again without duplicate entries.

## Requirements

- Windows with the NetSecurity PowerShell module
- PowerShell started as Administrator

## Usage

```powershell
powershell -ExecutionPolicy Bypass -File .\Beckhoff_Net_Rules.ps1
powershell -ExecutionPolicy Bypass -File .\Beckhoff_Net_Rules_OPC_UA.ps1
powershell -ExecutionPolicy Bypass -File .\Beckhoff_Net_Rules_TcHMi.ps1
```

Run only the scripts you need. Re-running a script replaces rules that share its display names.

## Beckhoff_Net_Rules.ps1

IPC diagnostics, Remote Desktop, TwinCAT ADS, the first PLC runtime, and ping.

| Display name | Protocol | Port | Direction |
| --- | --- | --- | --- |
| `IPC_diagnostics` | TCP | 443 | Inbound |
| `RemoteDesktop` | TCP | 3389 | Inbound |
| `TwinCAT_ADS_UDP_In` | UDP | 48899 | Inbound |
| `TwinCAT_ADS_UDP_Out` | UDP | 48899 | Outbound |
| `TwinCAT_ADS_TCP_In` | TCP | 8016, 48898 | Inbound |
| `TwinCAT_ADS_TCP_Out` | TCP | 8016, 48898 | Outbound |
| `TwinCAT_Runtime_In` | TCP | 851 | Inbound |
| `TwinCAT_Runtime_Out` | TCP | 851 | Outbound |
| `IPC_ping_In` | ICMPv4 Echo Request (type 8) | — | Inbound |
| `IPC_ping_Out` | ICMPv4 Echo Request (type 8) | — | Outbound |

## Beckhoff_Net_Rules_OPC_UA.ps1

Inbound TCP **4840** for the TwinCAT OPC UA server. UA Expert on the host connects to `opc.tcp://<VM-IP-address>:4840`.

| Display name | Protocol | Port | Direction |
| --- | --- | --- | --- |
| `OPC_UA_Server` | TCP | 4840 | Inbound |

## Beckhoff_Net_Rules_TcHMi.ps1

Inbound TCP ports for the TwinCAT HMI server (TF2000) and WebView. Remote access should use HTTPS. HTTP ports are included for WebView and for endpoints bound to `0.0.0.0`.

| Port | Protocol | Use |
| --- | --- | --- |
| 80 | HTTP | WebView |
| 1010 | HTTP | TF2000 versions 1.12 and earlier (localhost by default) |
| 1020 | HTTPS | TF2000 versions 1.12 and earlier (all interfaces by default) |
| 2010 | HTTP | TF2000 versions 1.14 and later |
| 2020 | HTTPS | TF2000 versions 1.14 and later |

| Display name | Protocol | Ports | Direction |
| --- | --- | --- | --- |
| `TwinCAT_HMI` | TCP | 80, 1010, 1020, 2010, 2020 | Inbound |
