<#
Script used to quickly ascertain IP's connected to a network over time using ARP. Because some networks have devices
that are intermittently connected it is recommend to run this script at consistent intervals (every 30 minutes or so)
To run:
manually run arp -a, note the NIC network address you wish to monitor (Ex 10.1.10.104)
Edit the 1st line of this script's -N flag with this address
Create a txt file called internal_ips.txt, inside the file place the same IP address
Execute this Powershell script manually the 1st time:
	Powershell -ExecutionPolicy Bypass
	At powershell prompt run script:  .\Arp_Get.ps1
	Verify that script generated entries in the internal_ips.txt file (should match your original arp -a output)
Set up task scheduler to run this script as often as you feel necessary
#>

$arpText = & arp -a -N 192.168.1.124
$currentIps = $arpText[3..$($arpText.Count-1)] | & { process { $ip = $(-split $_)[0]; $ip} }
$previousIps = Get-Content $ENV:UserProfile\internal_ips.txt
$newIps = $currentIps | ForEach-Object {if ($previousIps -notcontains $_) { $_} }
$newIps | & { process { "$_`n" | Out-File -Append -Encoding ASCII $ENV:UserProfile\internal_ips.txt } }
