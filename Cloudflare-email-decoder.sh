#!/bin/bash

# 0x0d1n

which bc &> /dev/null || sudo apt-get install bc -y


if [ $# -lt 1 ]; then
	echo "Usage: $0 [email]..." >&2
	exit 2
fi

function hextodec {
	echo "obase=10; ibase=16; ${1^^}" | bc
}

function chr {
	[ "$1" -lt 256 ] || return 1
	printf "\\$(printf '%03o' "$1")"
}

function r {
	local email=$1
	local index=$2
	local m=${email:index:2}
	local z=$(hextodec $m)
	echo "$z"
}

function n {
	local n=$1	# email
	local c=$2	# index

	str=""
	a=$(r $n $c)

	for ((i=$((c+2));i<${#n};i+=2)); do
		temp=$(r $n $i)
		l=$((temp ^ a))
		str+="$(chr $l | tr -d '\r\0')"
	done
	echo $str
}

for email in $@; do
	hex=${email:0:2}
	dec=$(hextodec $hex)
	n $email 0
done

exit 0
