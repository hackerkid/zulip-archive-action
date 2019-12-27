#!/bin/bash
zulip_realm_url=$1
zulip_bot_api_key=$2
zulip_bot_email=$3
github_token=$4

repo_path="$(pwd)"
archive_dir_path=$repo_path
json_dir_path="${repo_path}/zulip_json"
_layouts_path="${repo_path}/_layouts"
img_dir_path="${repo_path}/assets/img"

cd ..

curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python3 get-pip.py

pip install virtualenv
virtualenv -p python3 .
source bin/activate
pip3 install zulip

git clone https://github.com/hackerkid/zulip-archive
cd  zulip-archive
git checkout gh-action
cp default_settings.py settings.py

crudini --set zuliprc api site $zulip_realm_url
crudini --set zuliprc api key $zulip_bot_api_key
crudini --set zuliprc api email $zulip_bot_email

export PROD_ARCHIVE=true
export SITE_URL="/"
export ARCHIVE_DIRECTORY=$archive_dir_path
export JSON_DIRECTORY=$json_dir_path
export HTML_ROOT=""
export ZULIP_ICON_URL="/assets/img/zulip2.png"

if [ ! -d $json_dir_path ]; then
    mkdir -p $json_dir_path

    mkdir -p $_layouts_path
    cp -rf layouts/* $_layouts_path

    mkdir -p $img_dir_path
    cp assets/img/* $img_dir_path

    python3 archive.py -t
else
    python3 archive.py -i
fi

python3 archive.py -b

cd ..

cd ${repo_path}
git checkout master

git config --global user.email "zulip-archive-bot@users.noreply.github.com"
git config --global user.name "Archive Bot"

git add -A
git commit -m "Update archive."

git remote set-url --push origin https://${GITHUB_ACTOR}:${github_token}@github.com/${GITHUB_REPOSITORY}

git push origin master --force
