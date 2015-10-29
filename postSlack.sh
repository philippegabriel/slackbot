#!/bin/bash
#Post a msg to a slack channel, using Slack Incoming WebHooks
#https://citrix.slack.com/services/new/incoming-webhook
#
#read endpoint from config file
. .config.sh
Usage() {
echo "Missing argument(s)
Usage:
$0 channel <channel> botname <name> msg <msg to post> [emoji <emoji name>]
channel, botname as registered with slack incoming webhook
See: #https://citrix.slack.com/services/new/incoming-webhook"
exit 1
}
[ $# -ne 0 ] || Usage
while [ $# -ge 2 ]
do
case "$1" in
	channel)
		channel=$2;;
	botname)
		botname=$2;;
	msg)
		msg=$2;;
	emoji)
		emoji=$2;;
	*)
		Usage;exit 1;;
esac
shift;shift
done
read -r -d '' payload << EOF
"channel": "$channel",
"username": "$botname",
"text": "$msg",
"icon_emoji": "$emoji"
EOF
echo $payload
echo $SlackEndpoint
curl -X POST --data-urlencode "payload={$payload}" $SlackEndpoint
exit 0
