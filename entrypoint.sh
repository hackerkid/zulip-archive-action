#!/bin/sh -l

echo "Hello $1"
echo "$(ls)"
echo "Hello again"
time=$(date)
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python3 get-pip.py --user
pip3 install virtualenv
virtualenv -p python3.6 .
source bin/activate
pip3 install zulip
echo ::set-output name=time::$time
