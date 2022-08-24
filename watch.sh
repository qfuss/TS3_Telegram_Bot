#!/bin/sh
dir1=/var/log/teamspeak/
while inotifywait -qqre modify "$dir1"; do
    bash /usr/share/logparse/parse.sh
done
