#!/bin/bash
join=" connected"
leave=" disconnected"
logfile=$(ls -t /var/log/teamspeak/ts3*1.log | head -1)
latest=$(tail -1 $logfile)
pat=' ' read -r -a array <<< "$latest"
user=$(echo ${array[5]} | sed -e "s/^[^']*'\([^']*\)'.*/\1/")
path=/usr/share/logparse/online
tmp=/usr/share/logparse/tmp
chatid=-xxxxxxxxx
botid=botxxxxxxxxx:xxxxxxxxx

if [[ $latest == *$leave* ]]; then
        grep -v $user $path > $tmp && mv $tmp $path
        players=$(cat /usr/share/logparse/online | xargs -n1 | sort -u | xargs | sed 's/ /, /g')

        if [ -z "$players" ]; then
                curl -X POST "https://api.telegram.org/$botid/sendMessage?chat_id=$chatid&text=$user%20hat$leave.%0AKeiner%20ist%20mehr%20Online."
                echo ---------------------------->>$logfile
                else
                curl -X POST "https://api.telegram.org/$botid/sendMessage?chat_id=$chatid&text=$user%20hat$leave.%0AOnline%20ist:%0A$players"
        fi
fi

if [[ $latest == *$join* ]]; then
        echo $user>>/usr/share/logparse/online
        players=$(cat /usr/share/logparse/online | xargs -n1 | sort -u | xargs | sed 's/ /, /g')
        curl -X POST "https://api.telegram.org/$botid/sendMessage?chat_id=$chatid&text=$user%20hat$join.%0AOnline%20ist:%0A$players"
fi

