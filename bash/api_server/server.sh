#!/usr/bin/env bash

function response_rtn() {
    HTTP_200="HTTP/1.1 200 OK"
    HTTP_404="HTTP/1.1 404 Not Found"

    RSP_MSG=""
    RSP_CODE=""

    # Get endpoint
    EP=$(echo "${1}" | sed -n '/^GET /p' | awk '{print $2}' )

    if [ ! -z "${EP}" ]
    then
        case "$EP" in
            "/")
                RSP_MSG="Hello World"
                printf "%s\\\nlocation: %s\\\n\\\n%s\\\n" "$HTTP_200" "${EP}" "$RSP_MSG"
                ;;
            "/status")
                RSP_MSG="OK"
                printf "%s\\\nlocation: %s\\\n\\\n%s\\\n" "$HTTP_200" "${EP}" "$RSP_MSG"
                ;;
            "/info")
                RSP_MSG="{ \"desc\":\"REST API server in Bash\",  \"version\":\"0.0.1\" }"
                printf "%s\\\nlocation: %s\\\n\\\n%s\\\n" "$HTTP_200" "${EP}" "$RSP_MSG"
                ;;
            *)
                RSP_MSG="Unknown URL"
                printf "%s\\\nlocation: %s\\\n\\\n%s\\\n" "$HTTP_404" "${EP}" "${RSP_MSG} ${EP}"
                ;;
        esac
    fi
}

rm -f ffb
mkfifo ffb

while true
do
    nc -l 8888 \
       < <( cat ffb ) \
       > >(
        while read OUTPUTS
        do
            RSP_RET=$(response_rtn "$OUTPUTS")
            if [ ! -z "${RSP_RET}" ]
            then
                printf "$RSP_RET" > ffb
            fi
        done
    )
done
