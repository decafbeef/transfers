# transfers

Spin up a quick webserver and host some files

# Usage

```text
./go.sh [-p LPORT] [-i IFACE] [-H HTTP_PORT] [-m lsr64.elf,wsr.c,...]
  -p LPORT      specify local port for reverse shell
  -i IFACE      specify interface to determine IP address, e.g. tun0 or eth0
  -m SHELLTYPE  specify the kind of shell you want to generate, e.g.
                lsr64.elf - linux shell reverse 64bit in elf format
                wsr.c     - windows shell reverse 32bit in c format
``` 

Examples

```bash
# spin up webserver on port 80, generate payloads with defaults
$ ./go.sh 

# webserver on port 8080, payload LPORT=53 and IP of interface 'eth0'
$ ./go.sh -p 53 -i eth0 -H 8080

# generate msfvenom payload: Windows reverse shell 64bit in c format
$ ./go.sh -m wsr64.c
```

# Project Structure

```
files/      # contains all files that will be hosted
templates/  # contains templates for reverse shells, etc.
install     # initial setup script to populate files/ directory
go.sh       # script to start the webserver, generate templates, display files
```
## Filenames

* `templates/*` - Template files that can contain things like {{rport}}, {{rhost}}, etc.
* `wsr.*` - windows shell reverse
* `lsr.*` - linux shell reverse
