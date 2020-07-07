if [[ -s /Users/kevinzhuang/.blocked_status ]]
then
	echo  Website blocking started
else
	current_time=$(date | sed 's/:/ /' | awk '{ print $4 }')
	if [[ "$current_time" < "18" ]] && [[ "$current_time" > "08" ]]
	then
		echo  Taking a break..
	else
		echo  Website bloacking stopped
	fi
fi
