#!/bin/sh -e
USAGE="Usage: $0 <username> <SSH key> <sudo | normal> [<uid> <gid>]"
if [ "$#" -ne 3 ] && [ "$#" -ne 5 ]; then
	echo "$USAGE"
	exit 1
fi
if [ "$#" -eq 5 ]; then
	set_ids=true
	uid="$4"
	gid="$5"
fi
user="$1"
key="$2"
case "$3" in
	"sudo") super=true;;
	"normal") super=false;;
	*)
		echo "$USAGE"
		exit 1
		;;
esac

if [ "$set_ids" = true ]; then
	sudo useradd -ms /bin/bash "$user" -u "$uid"
	sudo groupmod -g "$gid" "$user"
else
	sudo useradd -ms /bin/bash "$user"
fi
sudo passwd -de "$user"
if [ "$super" = true ]; then
	sudo usermod -aG ssh-users,sudo "$user"
else
	sudo usermod -aG ssh-users "$user"
fi
sudo mkdir -p /home/"$user"/.ssh
echo "$key" | sudo tee /home/"$user"/.ssh/authorized_keys > /dev/null
sudo chmod 600 /home/"$user"/.ssh/authorized_keys
sudo chmod 700 /home/"$user"/.ssh
sudo chown -R "$user:$user" /home/"$user"/.ssh
