#!/bin/csh

if ( $#argv <= 2 ) then
	echo "2 or less params"
	exit 6
endif

set FROM="$argv[1]"
set TO="$argv[2]"

if ( `echo -n "$FROM" | wc -m` >= 256 ) then
	echo 'Catalog error FROM'
	exit 2
endif

if ( `echo -n "$TO" | wc -m` >= 256 ) then
	echo 'Catalog error TO'
	exit 4
endif

if ( ( ! -e "$FROM" ) || ( ! -d "$FROM" ) ) then
	echo 'Catalog error FROM'
	exit 3
endif

if ( ( ! -e "$TO" ) || ( ! -d "$TO" ) ) then
	echo 'Catalog error TO'
	exit 5
endif

if ( ! -r "$FROM" ) then
	echo 'Read error FROM'
	exit 6
endif

if ( ! -w "$TO" ) then
	echo 'Write error TO'
	exit 7
endif

set i=3
set FILE1="$argv[$i]"
@ i ++
set FILE2=""
if ( $i <= $#argv ) then
	set FILE2="$argv[$i]"
endif

set code=1

while ( ( `echo -n "$FILE1" | wc -m` >= 1 ) && ( `echo -n "$FILE2" | wc -m` >= 0 ) )
	if ( `echo -n "$FILE2" | wc -m` <= 0 ) then
		echo 'One param error'
		break
	endif
	if ( ( `expr "$FILE1" : '.*[\/].*'` != 0 ) || ( `echo -n "$FILE1" | wc -m` >= 256 ) || ( ! -e "${FROM}/${FILE1}" ) ) then
		echo 'FILE1 = '"$FILE1"' error'
	else 
		if ( ( `expr "$FILE2" : '.*[\/].*'` != 0 ) || ( `echo -n "$FILE2" | wc -m` >= 256 ) || ( ! -e "${FROM}/${FILE2}" ) ) then
			echo 'FILE2 = '"$FILE2"' error'
		else
			if ( ! -r "${FROM}/${FILE1}" ) then
				echo 'Read error FILE1 = '"$FILE1"
			else
				if ( ! -r "${FROM}/${FILE2}" ) then
					echo 'Read error FILE2 = '"$FILE2"
				else 
					if ( ( -e "${TO}/${FILE1}" ) && ( ! -w "${TO}/${FILE1}" ) ) then
						echo 'Write error'
					else
						if ( ( ! -e "${TO}/${FILE1}" ) && ( ! -x "$TO" ) ) then
							echo 'Execution error'
						else
							set code=0
							cat "${FROM}/${FILE1}" > "${TO}/${FILE1}"
							cat "${FROM}/${FILE2}" >> "${TO}/${FILE1}"
						endif
					endif
				endif
			endif
		endif
	endif
	
	@ i ++
	if ( $i <= $#argv ) then
		set FILE1="$argv[$i]"
	else
		set FILE1=""
	endif
	@ i ++
	if ( $i <= $#argv ) then
		set FILE2="$argv[$i]"
	else
		set FILE2=""
	endif
end

exit $code
