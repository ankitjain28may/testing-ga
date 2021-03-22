#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
# http://redsymbol.net/articles/unofficial-bash-strict-mode/

APP_NAME="concierge"

kubectl diff -f /tmp/$APP_NAME.yaml > /dev/null | cat -
echo $?
# echo $ERR
sjkregfn