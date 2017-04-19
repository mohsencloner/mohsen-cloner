#!/bin/bash
COUNTER=1
while(true) do
./amir.sh
curl "https://api.telegram.org/bot[ToKeN]/sendmessage" -F "chat_id=340026281" -F "text=#NEWCRASH-Reloaded-${COUNTER}-times"
let COUNTER=COUNTER+1 
done
