#!/bin/bash

set -e

function _get_veth_from_dmesg {
  dmesg | grep -F "$1" | awk 'match($0,"PHYSIN=([^ ]+)"){print substr(substr($0, RSTART, RLENGTH), 8);exit}'
}

function veth {
  IPADDR=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' $1)
  VETH=$(_get_veth_from_dmesg $IPADDR)
  if test -z "$VETH"; then
    iptables -I INPUT -i docker0 -p icmp -j LOG
    ping -c 1 $IPADDR >/dev/null
    iptables -D INPUT -i docker0 -p icmp -j LOG
    VETH=$(_get_veth_from_dmesg $IPADDR)
  fi
  echo $VETH
}

IFACES=(
  $(veth shadowsocks_bf_1)
  $(veth shadowsocks_aes_1)
)

echo "0 9 * * * bash -c 'for IF in ${IFACES[@]}; do (date; /sbin/tc qdisc del dev \$IF root; /sbin/tc qdisc add dev \$IF root tbf rate 512kbit burst 10kb latency 70ms) >> /tmp/tc.log 2>&1; done'"
echo "0 18 * * * bash -c 'for IF in ${IFACES[@]}; do (date; /sbin/tc qdisc del dev \$IF root; /sbin/tc qdisc add dev \$IF root tbf rate 900kbit burst 10kb latency 70ms) >> /tmp/tc.log 2>&1; done'"
