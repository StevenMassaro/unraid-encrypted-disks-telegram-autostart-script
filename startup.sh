echo Getting IP address and info.
ip_info=$(curl ipinfo.io --silent)
ip=$(echo "$ip_info" | jq .ip -r)
city=$(echo "$ip_info" | jq .city -r)
region=$(echo "$ip_info" | jq .region -r)
country=$(echo "$ip_info" | jq .country -r)
loc=$(echo "$ip_info" | jq .loc -r)

chat_id=$(< /boot/config/plugins/dynamix/telegram/chatid);
bot_token=$(< /boot/config/plugins/dynamix/telegram/token) || "";

echo Sending message requesting key.
curl https://api.telegram.org/bot"$bot_token"/sendMessage -d chat_id="$chat_id" -d text="Starting unRAID server ($ip, $city, $region, $country, $loc). Reply with disk encryption key to decrypt disks and start server." --silent --output /dev/null

echo Waiting for response.
result=$(curl https://api.telegram.org/bot"$bot_token"/getUpdates -d timeout=60 --silent | jq .result)
while [ "$result" = "[]" ]
do
   sleep 5s
   echo Waiting for response.
   result=$(curl https://api.telegram.org/bot"$bot_token"/getUpdates -d timeout=60 --silent | jq .result)
done

key=$(echo "$result" | jq '.[].message.text' -r)
update_id=$(echo "$result" | jq '.[].update_id' -r)

echo Received key.
echo -n "$key" > /root/keyfile
curl https://api.telegram.org/bot"$bot_token"/sendMessage -d chat_id="$chat_id" -d text="Key received. Starting server." --silent --output /dev/null

echo Marking received message as confirmed.
curl https://api.telegram.org/bot"$bot_token"/getUpdates -d offset=$((update_id+1)) --silent --output /dev/null
echo Continuing with system startup.
csrf=$(grep -oP 'csrf_token="\K[^"]+' /var/local/emhttp/var.ini)
curl -k --data "startState=STOPPED&file=&csrf_token=$csrf&cmdStart=Start" http://localhost/update.htm
