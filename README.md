# Automatic Mattermost Server Upgrade

This script when ran will ask you to enter a version in format : x.x.x i.e 8.5.4 then it will automatically upgrade the mattermost instance on the server.

**1.  Clone the repo**
<code>
  git clone https://https://github.com/lramseyIV/mattermost_upgrade
 </code>

**2.  Allow Execute Permissions**
<code>
  sudo chmod +x mm_upgrade.sh
</code>

**3.  Run the Script**
<code>
  sudo ./upgrade_mattermost #.#.#
</code>

## Uses

This is for self-hosted Mattermost admins with server access

## Caution

This script does not perform a backup and should not be ran until you backup according to your business or personal standards.

Be sure to check mattermost documentation for stable version information before upgrading. Incremental upgrades are advised. 
