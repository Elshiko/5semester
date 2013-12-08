#!/bin/bash

if [ $# -le '2' ]
then
	echo "2 or less params"
	exit 6
fi

FROM="$1"
TO="$2"

if [ "${#FROM}" -ge '256' ] || [[ "$FROM" =~ '\0' ]]
then
	echo 'Catalog error FROM'
	exit 2
fi

if [ "${#TO}" -ge '256' ] || [[ "$TO" =~ '\0' ]]
then
	echo 'Catalog error TO'
	exit 4
fi 

if ! [ -e "$FROM" ] || ! [ -d "$FROM" ]
then
	echo 'Catalog error FROM'
	exit 3
fi

if ! [ -e "$TO" ] || ! [ -d "$TO" ]
then
	echo 'Catalog error TO'
	exit 5
fi

if ! [ -r "$FROM" ]
then
	echo 'Read error FROM'
	exit 6
fi

if ! [ -w "$TO" ]
then
	echo 'Write error TO'
	exit 7
fi

i=3
FILE1="${!i}"
let i++
FILE2="${!i}"
code=1

while [ "${#FILE1}" -ge '1' ] && [ "${#FILE2}" -ge '0' ]
do	
	if [ "${#FILE2}" -le '0' ]
	then
		echo 'One param error'
		break
	fi
	if [[ "$FILE1" =~ '[/\0]' ]] || [ "${#FILE1}" -ge '256' ] || ! [ -e "${FROM}/${FILE1}" ]
	then
		echo 'FILE1 = '"$FILE1"' error'
	elif [[ "$FILE2" =~ '[/\0]' ]] || [ "${#FILE2}" -ge '256' ] || ! [ -e "${FROM}/${FILE2}" ]
	then
		echo 'FILE2 = '"$FILE2"' error'
	elif ! [ -r "${FROM}/${FILE1}" ]
	then
		echo 'Read error FILE1 = '"$FILE1"
	elif ! [ -r "${FROM}/${FILE2}" ]
	then
		echo 'Read error FILE2 = '"$FILE2"
	elif [ -e "${TO}/${FILE1}" ] && ! [ -w "${TO}/${FILE1}" ]
	then
		echo 'Write error'
	elif ! [ -e "${TO}/${FILE1}" ] && ! [ -x "$TO" ]
	then
		echo 'Execution error'
	else
		code=0
		cat "${FROM}/${FILE1}" > "${TO}/${FILE1}"
		cat "${FROM}/${FILE2}" >> "${TO}/${FILE1}"
	fi
	let i++
	FILE1="${!i}"
	let i++
	FILE2="${!i}"
done
exit $code
