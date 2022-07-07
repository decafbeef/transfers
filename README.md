# transfers

Spin up a quick webserver and host some files

```
files/      # contains all files that will be hosted
templates/  # contains templates for reverse shells, etc.
setup.sh    # initial setup script to populate files/ directory
go.sh       # script to start the webserver, generate templates, display files
```
## Filenames:

* `templates/*` - Template files that can contain things like {{rport}}, {{rhost}}, etc.
* `wsr.*` - windows shell reverse
* `lsr.*` - linux shell reverse
