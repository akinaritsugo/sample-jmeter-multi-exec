# -------------------------------------
# Java install
# -------------------------------------
cd $env:tmp
wget https://download.oracle.com/java/19/latest/jdk-19_windows-x64_bin.msi -OutFile jdk-19_windows-x64_bin.msi
msiexec /i "jdk-19_windows-x64_bin.msi" /quiet

# Set environment variable
$java_home = $env:ProgramFiles + "\Java\jdk-19"
[System.Environment]::SetEnvironmentVariable("JAVA_HOME", $java_home, "Machine")

# -------------------------------------
# JMeter setup
# -------------------------------------
cd $env:tmp
wget https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.5.zip -OutFile apache-jmeter-5.5.zip
Expand-Archive -Path apache-jmeter-5.5.zip -DestinationPath .\
New-Item $env:USERPROFILE\bin\jmeter -Type Directory -Force
Move-Item .\apache-jmeter-5.5\* $env:USERPROFILE\bin\jmeter -Force
Remove-Item .\apache-jmeter-5.5

# Create shortcut to the Desktop
$WsShell = New-Object -ComObject WScript.Shell
$Shortcut = $WsShell.CreateShortcut($env:USERPROFILE + "\Desktop\JMeter.lnk")
$Shortcut.TargetPath = $env:USERPROFILE + "\bin\jmeter\bin\jmeter.bat"
$Shortcut.Save()

# Set JMeter configuration
cd $env:USERPROFILE\bin\jmeter\bin
$target="jmeter.properties"
$encoding="UTF8"
(Get-Content $target -Encoding $encoding) | % {
  $_ -replace "#server.rmi.ssl.disable", "server.rmi.ssl.disable" `
  -replace "server.rmi.ssl.disable=false", "server.rmi.ssl.disable=true"
} | Set-Content $target

# DO NOT FORGET
# You need to add remote host address into the "remote_hosts" parameter.
# ex) remote_hosts=172.16.1.4,172.16.1.5,172.16.1.6

# Disable firewall
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# -------------------------------------
# Teraterm
# -------------------------------------
cd $env:tmp
wget https://ftp.halifax.rwth-aachen.de/osdn/ttssh2/74780/teraterm-4.106.exe -OutFile teraterm-4.106.exe
./teraterm-4.106.exe /install /silent /norestart

# -------------------------------------
# WinSCP
# -------------------------------------
cd $env:tmp
wget https://jaist.dl.sourceforge.net/project/winscp/WinSCP/5.21.6/WinSCP-5.21.6-Setup.exe -OutFile WinSCP-5.21.6-Setup.exe
.\WinSCP-5.21.6-Setup.exe /install /silent /allusers /norestart

# -------------------------------------
# Sakura Editor
# -------------------------------------
cd $env:TMP
wget https://github.com/sakura-editor/sakura/releases/download/v2.4.2/sakura-tag-v2.4.2-build4203-a3e63915b-Win32-Release-Installer.zip -OutFile sakura-v2.4.2-installer.zip
Expand-Archive -Path sakura-v2.4.2-installer.zip -DestinationPath .\
.\sakura_install2-4-2-6048-x86.exe /install /silent /norestart
