#!/bin/sh -e
if [ "$#" -ne 3 ]; then
	echo "Usage: $0 <username> <SSH key> <sudo | normal>"
	exit 1
fi
user="$1"
key="$2"
case "$3" in
	"sudo") super=true;;
	"normal") super=false;;
	*)
		echo "Usage: $0 <username> <SSH key> <sudo | normal>"
		exit 1
		;;
esac

sudo useradd -ms /bin/bash "$user"
sudo passwd -de "$user"
if [ "$super" = true ]; then
	sudo usermod -aG ssh-users,sudo "$user"
else
	sudo usermod -aG ssh-users "$user"
fi
sudo mkdir /home/"$user"/.ssh
echo "$key" | sudo tee /home/"$user"/.ssh/authorized_keys > /dev/null
sudo chmod 600 /home/"$user"/.ssh/authorized_keys
sudo chmod 700 /home/"$user"/.ssh
sudo chown -R "$user:$user" /home/"$user"/.ssh
