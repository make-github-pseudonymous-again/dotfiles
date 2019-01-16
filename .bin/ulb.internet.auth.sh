#!/usr/bin/env sh

username=
password=

function grabusername {

  echo 'Looking for username'

  username="$(pass 'ULB/ethernet/user')"

  if [ "$username" = '' ] ; then
    echo 'Could not find username'
    exit 2
  fi

}

function grabpassword {

  echo 'Looking for password'

  password="$(pass 'ULB/ethernet/login')"

  if [ "$password" = '' ] ; then
    echo 'Could not find password'
    exit 3
  fi

}

grabusername
grabpassword

echo 'Fetching...'
# username and password should not contain new lines \n\r
if printf "$username\n$password\n" | ulb.internet.auth.helper.js; then
  echo ':)'
  exit 0
else
  echo ':('
  exit 1
fi
