#!/usr/bin/env sh

IP='172.19.78.1'
URL='https://'"$IP"'/web_auth/index.html'

read -p 'username: ' USERNAME
read -s -p 'password: ' PASSWORD
echo

function urlencode () {
	echo -n "$1" | perl -pe 's/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg'
}

_USERNAME="$(urlencode "$USERNAME")"
_PASSWORD="$(urlencode "$PASSWORD")"

RESULT="$(2>/dev/null curl --insecure --data "admin_id=$_USERNAME&admin_pw=$_PASSWORD" "$URL")"

if <<< "$RESULT" grep 'webauthsucc' 1>/dev/null 2>/dev/null ; then
	>&2 echo 'OK :)'
	exit 0
else
	>&2 echo "$RESULT"
	>&2 echo 'KO :('
	exit 1
fi
