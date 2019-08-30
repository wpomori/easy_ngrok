#!/bin/bash

##[ Simple app for ngrok ]----------------------------#
path_to_ngrok="/usr/bin/ngrok"
port_used_by_ngrok=22

##[ Setting others variables ]------------------------#
RAW=null
API=null
FST=null
LNK_HTTP=.
LNK_HTTPS=.
sq='"'
lnpref=public_url
prefix="${lnpref}:"
tnl="localhost:4040/api/tunnels"

##[ Setting colors this script ]----------------------#
C_RED=$(tput setaf 1)
C_GRN=$(tput setaf 2)
C_YLW=$(tput setaf 3)
C_BLE=$(tput setaf 4)
C_RST=$(tput sgr0)

function cls {
	printf "\033c"
	printf "\e[5t"
}

function logo {
	printf "\n\n\n"
	printf "    ${C_YLW}╔╗╔╔═╗╦═╗╔═╗╦╔═  ${C_BLE}┌─┐┌┬┐┌─┐┬─┐┌┬┐┌─┐┬─┐${C_RST}\n"
	printf "    ${C_YLW}║║║║ ╦╠╦╝║ ║╠╩╗  ${C_BLE}└─┐ │ ├─┤├┬┘ │ ├┤ ├┬┘${C_RST}\n"
	printf "    ${C_YLW}╝╚╝╚═╝╩╚═╚═╝╩ ╩  ${C_BLE}└─┘ ┴ ┴ ┴┴└─ ┴ └─┘┴└─${C_RST}\n"
	printf "    By ${C_RED}NullDev${C_RST}"
	printf "\n\n\n"
	printf " Loading...\n\n\n"
}

cls
logo
pkill -x ngrok
EXEC=$(`${path_to_ngrok} tcp ${port_used_by_ngrok} >> /dev/null &`)
sleep 5s
if ! [ -x "$(command -v curl)" ]; then
	unset API
	API=$(wget -q0 - $tnl | awk -F"," -v k=$lnpref '{
		gsub(/{|}/,"")
		for(i=1;i<=NF;i++){
			if ( $i ~ k){ printf "${i}" }
		}
	}')
else
	unset API
	API=$(curl -s $tnl | awk -F"," -v k=$lnpref '{
		gsub(/{|}/,"")
		for(i=1;i<=NF;i++){
			if ( $i ~ k ){ printf $i }
		}
	}')
fi

echo "${API}"
mail -s "Teste acesso negrok: ${API}" wellington.omori@neoprospecta.com


API=${API//$sq}
API=${API//$prefix}
IFS=$'\n' read -rd '' -a FST <<<"$API"
FST=${FST//http\:\/\/}
sleep 1s
LNK_HTTP="http://${FST}"
LNK_HTTPS="https://${FST}"
printf " ${C_BLE}Status: ${C_GRN}ONLINE${C_RST}\n\n"
printf " ${C_BLE}Link (HTTP):   ${C_YLW}${LNK_HTTP}${C_RST}\n"
printf "\n ${C_GRN}Anote o endereço de ssh!!!${C_RST}"
printf "\n\n\n"
exit 0
