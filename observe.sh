#!/bin/sh

if [ "$#" -eq 0 ]; then
    echo "Usage: observe.sh <ip> [interval] [runtime]"
    exit 1
fi

ip="${1}" # ip of the tasmota device
url="http://${ip}/cm?cmnd=status%2010" # api url
interval="${2:-5}" # in seconds
runtime="${3:-30} second" # how long, in seconds
endtime=$(date -ud "$runtime" +%s)

header="Time,Power"
data=""

while [[ $(date -u +%s) -le $endtime ]]; do
    sleep $interval
    resp=$(curl -s ${url} | jq -r '.StatusSNS | [.Time, .ENERGY.Power] | @csv')
    data="${data}\n${resp}"
done <<< $data

echo -e "${header}${data}"
