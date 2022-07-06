#!/bin/bash

# fail script, if any command fails
set -e

# get single binaries
this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" &> /dev/null && pwd  )"
cd ${this_dir}/files

wget https://github.com/DominicBreuker/pspy/releases/latest/download/pspy32 -O pspy32
wget https://github.com/DominicBreuker/pspy/releases/latest/download/pspy64 -O pspy64
wget https://live.sysinternals.com/accesschk.exe -O accesschk.exe
wget https://live.sysinternals.com/psexec.exe -O psexec.exe
wget https://github.com/ivanitlearning/Juicy-Potato-x86/releases/download/1.2/Juicy.Potato.x86.exe -O juicypotato.exe
wget https://github.com/ohpe/juicy-potato/releases/download/v0.1/JuicyPotato.exe -O juicypotato64.exe
curl -L https://the.earth.li/~sgtatham/putty/latest/w32/plink.exe --output plink.exe
curl -L https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe --output plink64.exe
wget https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/master/SharpUp.exe -O sharpup.exe
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASany.exe -O winpeas.exe
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASx64.exe -O winpeasx64.exe
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASx86.exe -O winpeasx86.exe
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEAS.bat -O winpeas.bat
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -O linpeas.sh
wget https://raw.githubusercontent.com/ohpe/juicy-potato/master/CLSID/GetCLSID.ps1 -O getclsid.ps1
wget https://raw.githubusercontent.com/yangbaopeng/ashx_webshell/master/shell.ashx -O webshell.ashx # used in butch PG
wget https://github.com/CsEnox/just-some-stuff/raw/main/GMSAPasswordReader.exe -O gmsapasswordreader.exe
wget https://github.com/jpillora/chisel/releases/download/v1.7.7/chisel_1.7.7_windows_amd64.gz && gunzip chisel_1.7.7_windows_amd64.gz && mv chisel_1.7.7_windows_amd64 chisel64.exe
wget https://github.com/jpillora/chisel/releases/download/v1.7.7/chisel_1.7.7_linux_amd64.gz && gunzip chisel_1.7.7_linux_amd64.gz && mv chisel_1.7.7_linux_amd64 chisel64
wget https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/socat -O socat64
wget https://github.com/andrew-d/static-binaries/raw/master/binaries/linux/x86_64/ncat -O ncat64
wget https://github.com/r3motecontrol/Ghostpack-CompiledBinaries/raw/master/Seatbelt.exe -O seatbelt.exe

# windows-binaries in /usr/share
cd ${this_dir}/files

ln -s /usr/share/windows-binaries/nc.exe
ln -s /usr/share/windows-resources/binaries/whoami.exe
ln -s /usr/share/windows-resources/mimikatz/x64/mimikatz.exe mimikatzx64.exe
ln -s /usr/share/windows-resources/mimikatz/Win32/mimikatz.exe mimikatzx86.exe
ln -s /opt/PowerUpSQL/PowerUpSQL.ps2 powerupsql.ps1
# todo: sharphound
