#!/bin/bash
#Post a msg to a slack channel, using Slack Incoming WebHooks
#https://citrix.slack.com/services/new/incoming-webhook
#
#read endpoint from config file
. .config.sh
Usage() {
echo "Missing argument(s)
Usage:
$0 channel <channel> botname <name> endpoint <slack webhook url> [emoji <emoji name>] < \"text to post\"
input on stdin
parameters can also be specified as environment vars with the same name 
channel, botname as registered with slack incoming webhook
See: #https://citrix.slack.com/services/new/incoming-webhook"
exit 1
}
while [ $# -ge 2 ]
do
case "$1" in
	channel)
		channel=$2;;
	botname)
		botname=$2;;
	endpoint)
		endpoint=$2;;
	emoji)
		emoji=$2;;
	*)
		Usage;exit 1;;
esac
shift;shift
done
while read line
do
	read -r -d '' payload << EOF
	"channel": "$channel",
	"username": "$botname",
	"text": "$line",
	"icon_emoji": "$emoji"
EOF
#echo $payload
#echo $endpoint
	curl -X POST --data-urlencode "payload={$payload}" $endpoint
done
exit 0
