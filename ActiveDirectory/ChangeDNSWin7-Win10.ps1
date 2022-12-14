#Declaring Variables

$OSVersion = (get-itemproperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
$var1 = "192.168.10.201"
$var2 = "8.8.8.8"

If($OSVersion -eq "Windows Server 2008 R2 Standard")
{
    Write-Host "This is a server!"
}
ElseIf($OSVersion -eq "Windows 10 Pro" -or $OSVersion -eq "Windows 11 Pro")
{

    Write-Host "Windows 10 or 11"

    $Adapter1 = Get-NetAdapter -Physical | select -expand name 

    $Adapter1 | ForEach-Object{
        $myAdapter = $_
        "Adapter: $myAdapter" 
        netsh interface ipv4 set dnsservers name=$myAdapter static $var1 primary
        netsh interface ipv4 add dnsservers name=$myAdapter $var2 index=2
    }
    Write-Host "The Primary DNS is:" $var1
    Write-Host "The Secondary DNS is:" $var2

}
ElseIf($OSVersion -eq "Windows 7 Professional")
{
    Write-Host "Okay, Windows 7 is cool, too!"
    Write-Host "Set DNS with netsh"

    $ipinfo = netsh interface ipv4 show interface
    $Names = 
    foreach($element in $ipinfo){
        $matches = $null
        if($element -match '.*ethernet.*|.*Local Area Connection.*'){
            (($matches.values) -split "\s\s")[-1] -replace "^\s"
        }
    }
    $names

    netsh interface ipv4 set dnsservers $names static $var1 primary
    netsh interface ipv4 add dnsservers $names $var2 index=2
    
    Write-Host "The Primary DNS is:" $var1
    Write-Host "The Secondary DNS is:" $var2

}