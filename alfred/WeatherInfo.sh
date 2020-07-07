query=$1

if [[ -z $query ]]
then
	curl wttr.in?format=%l:+%c+%t+%w
else
	curl wttr.in/${query}?format=%l:+%c+%t+%w
fi
