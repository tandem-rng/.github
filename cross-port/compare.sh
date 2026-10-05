#!/usr/bin/env bash
# Compares a port's streams with tandem-c's and prints one Markdown table row per stream.
#   compare.sh REFERENCE.sha256 OUT "KINDS"
# KINDS names the streams the port must write, such as "uniform bounded normal exponential".
# Exits 1 if a stream is missing or its SHA-256 differs from tandem-c's.
set -uo pipefail

ref=$1
out=$2
status=0
for kind in $3; do
    want=$(awk -v f="$kind.bin" '$2 == f { print $1 }' "$ref")
    if [ -z "$want" ]; then
        echo "| $kind | no reference | |"
        status=1
    elif [ ! -f "$out/$kind.bin" ]; then
        echo "| $kind | missing | |"
        status=1
    else
        got=$(sha256sum "$out/$kind.bin" | cut -d' ' -f1)
        if [ "$got" = "$want" ]; then
            echo "| $kind | equal | \`${got:0:16}\` |"
        else
            echo "| $kind | **differs** | \`${got:0:16}\`, tandem-c \`${want:0:16}\` |"
            status=1
        fi
    fi
done
exit $status
