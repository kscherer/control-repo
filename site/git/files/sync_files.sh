#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

download_if_newer()
{
    local REMOTE_ADDRESS=$1
    local FILE=$2

    #--time-cond will output error if file not present
    local HTTP_CODE=
    HTTP_CODE=$(curl "$REMOTE_ADDRESS" --time-cond "$FILE" --output "$FILE.new" \
                     --silent --write-out '%{http_code}' 2> /dev/null)
    if [[ "$HTTP_CODE" == "200" ]]; then
        # 200 means native sstate has been updated
        mv -f "${FILE}.new" "$FILE"
    fi
    rm -f "${FILE}.new"
}

download_if_newer "http://ala-git.wrs.com/release/WRL9/wrlinux-9.json" "/git/release/WRL9/wrlinux-9.json"
download_if_newer "http://ala-git.wrs.com/release/WRL10_17/wrlinux-lts.17.json" "/git/release/WRL10_17/wrlinux-lts.17.json"
