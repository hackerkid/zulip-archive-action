#!/bin/bash

echo "Hello $1"
echo "$(ls)"

pip install virtualenv
virtualenv -p python3 .
source bin/activate
pip3 install zulip

#echo ::set-output name=time::$time
