#!/bin/sh -l

echo "Hello $1"
echo "$(ls)"
echo "Hello again"
time=$(date)
virtualenv -p python3 .
source bin/activate
pip3 install zulip
echo ::set-output name=time::$time
