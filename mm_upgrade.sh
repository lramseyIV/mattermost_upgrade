#! /bin/bash
# WARNING this script should not be ran unless a snapshot is taken of the server and database is backed up
# this script is used to upgrade mattermost to the version specified in the arg passed into the script
# usage sudo ./upgrade_mattermost x.x.x
# x.x.x indicating the version number
set -e
set -x

cd /tmp
#check to ensure user entered version argument
if [ "$#" == "0" ]
then
    echo "Missing version number"
    exit 1
fi
upgrade_url="https://releases.mattermost.com/$1/mattermost-$1-linux-amd64.tar.gz"
response=$(wget -q "$upgrade_url")
if [ $? -ne 0 ]; then
    echo "failure to download upgrade files, check version number and format is [x.x.x]"
    exit 1
fi
wget $upgrade_url

#unzip and rename files so names do not conflict with current installation files
tar -xf mattermost*.gz --transform='s,^[^/]\+,\0-upgrade,'
echo STOPPING MATTERMOST SERVICE
systemctl stop mattermost

#first moves into mattermost installation dir then removes all files
cd /opt
find mattermost/ mattermost/client/ -mindepth 1 -maxdepth 1 \! \( -type d \( -path mattermost/client -o -path mattermost/client/plugins -o -path mattermost/config -o -path mattermost/logs -o -path mattermost/plugins -o -path mattermost/data \) -prune \) | sort | xargs rm -r

# COPYING UPGRADE FILES AND CONFIGURING GROUP OWNERSHIP
cp -an /tmp/mattermost-upgrade/. mattermost/
chown -R mattermost:mattermost mattermost
setcap cap_net_bind_service=+ep ./mattermost/bin/mattermost

echo STARTING MATTERMOST SERVICE - this may take a while
sleep 2 # for some reason the service will not start without a delay
systemctl start mattermost

# removes old files from the upgrade download
rm -rf /tmp/mattermost-upgrade/
rm -if /tmp/mattermost*.gz
echo SUCCESS ---- UPGRADE COMPLETE
