oldFileName=$(echo -n $1 | awk -F ":" '{print $1}')
newFileName=$(echo -n $1 | awk -F ":" '{print $2}')
[[ -z $newFileName ]] && echo -n "Error" && exit 1
[[ -z $oldFileName ]] && echo -n "Error" && exit 1
extensionName=png
mv "$oldFileName" "/Users/kevinzhuang/Documents/TempScreenShot/$newFileName.$extensionName"
echo -n "$newFileName.$extensionName"

# second part
newFileName=$(echo -n "$1" | awk -F "+" '{print $2}')
oldFileName=$(echo -n "$1" | awk -F "+" '{print $1}')
mv "$oldFileName" "$newFileName"
