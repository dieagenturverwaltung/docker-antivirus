#!/bin/bash
files=$(shopt -s nullglob dotglob; echo /data/av/queue/*)
if (( ${#files} ))
then
    printf "Found files to process\n"
    for file in "/data/av/queue"/* ; do
        filename=`basename "$file"`
        mv -f "$file" "/data/av/scan/${filename}"
        printf "Processing /data/av/scan/${filename}\n"
        /usr/local/bin/scanfile.sh > "/data/av/scan/${filename}-info" 2>&1
        if [ -e "/data/av/scan/${filename}" ]
        then
            printf "  --> File ok\n"
            mv -f "/data/av/scan/${filename}" "/data/av/ok/${filename}"
            printf "  --> File moved to /data/av/ok/${filename}\n"
            rm -f "/data/av/scan/${filename}-info" || true
        elif [ -e "/data/av/quarantine/${filename}" ]
        then
            printf "  --> File quarantined / nok\n"
            mv -f "/data/av/scan/${filename}-info" "/data/av/nok/${filename}"
            printf "  --> Scan report moved to /data/av/nok/${filename}\n"
        fi
    done
    rm -rf "/data/av/quarantine/*"
    printf "Done with processing\n"
fi
