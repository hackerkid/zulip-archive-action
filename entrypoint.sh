#!/bin/bash
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python3 get-pip.py

pip install virtualenv
virtualenv -p python3 .
source bin/activate
pip3 install zulip

site_url=$1
api_key=$2
email=$3

mkdir -p archive
mkdir -p zulip_json

git clone https://github.com/hackerkid/zulip-archive
cd  zulip-archive
git checkout gh-action
cp default_settings.py settings.py

crudini --set zuliprc api site $site_url
crudini --set zuliprc api key $api_key
crudini --set zuliprc api email $email

export PROD_ARCHIVE=true
export SITE_URL=$site_url
export ARCHIVE_DIRECTORY="../archive"

python3 archive.py -t
python3 archive.py -b

cd ..

git config --global user.email "zulip-archive-bot@users.noreply.github.com"
git config --global user.name "Archive Bot"

git add archive
git add zulip_json
git commit -m "Update archive."
git push origin master --force
