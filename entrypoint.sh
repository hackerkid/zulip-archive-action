#!/bin/bash
pip install virtualenv
virtualenv -p python3 .
source bin/activate
pip3 install zulip

crudini --set zuliprc api site $1
crudini --set zuliprc api key $2

more zuliprc
