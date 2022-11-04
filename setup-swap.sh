#/usr/bin/env bash

SWAP_FILE="swapfile.img"
FSTAB_STR="/$SWAP_FILE       none    swap    sw      0       0"

if [ "$(id -u)" -ne 0 ]
then
    echo "ERROR: Gimme root. (╯‵□′)╯︵┻━┻"
    exit 1
fi

while [ 1 -eq 1 ] 
do
	echo "How large should the swapfile be in GiB?"
	read input
	input=$(echo $input | tr -d '\"' | grep "[0-9]*")
	if [ -z "$input" ]
	then
		echo "ERROR: This isn't a number!"
	elif [ $input -ge 12 ]
	then
		echo "ERROR: Size is too big! Modify script if you need a bigger size."
		exit 1
	elif [ $input -le 4 ]
	then
		echo "ERROR: Void swapfile size or smaller than 4GiB."
	else
		break
	fi
done

while [ 1 -eq 1 ]
do
	echo "Creating swapfile at /$SWAP_FILE with a size of "$input"Gib, accept changes? [y/N]"
	read delete_question
	delete_question=$(echo $delete_question | grep "^[yYnN]$")
	if [ ! -z "$delete_question" ]
	then
		response=$(echo "$delete_question" | grep -c "^[yY]$")
		if [ $response -eq 0 ]
		then
			echo "Abort."
			exit 1
		fi
		break
	fi

	echo "Invalid input"
done

if [ -f "/$SWAP_FILE" ]
then
	swapoff /$SWAP_FILE
	rm /$SWAP_FILE	
fi
fallocate -l "$input"GiB /$SWAP_FILE
chmod 0600 /$SWAP_FILE
mkswap /$SWAP_FILE
swapon /$SWAP_FILE

cat /etc/fstab | sed -z "s|/$SWAP_FILE||g" | tee /etc/fstab > /dev/null
echo $FSTAB_STR | tee -a /etc/fstab > /dev/null
