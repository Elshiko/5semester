#!/bin/csh
python3.3 parser.py

set fname="res"

rm -f "$fname"

set outfile="../../$fname"

set output="../$fname"

set testdir=`eval "date +%s"`

while ( -e ${testdir} )
	set testdir=`eval "date +%s"`
end

mkdir "${testdir}"
cd "${testdir}"

set tst=1
set passed=0

while ( $tst <= $argv[1] )
	mkdir $tst
	cd $tst
	
	set file="../../test"$tst
	
	set info=`eval "cat -E < '$file'"`
	set params=("" "" "" "" "" "" "" "" "")
	set pos=1
	while ( $pos <= 9 )
		set params[$pos]=`eval "python3.3 ../../makearray.py '$info' $pos"`
		@ pos ++
	end
	
	set num="${params[1]}"
	set prep="${params[2]}"
	set checkcall="${params[3]}"
	set descrFS="${params[4]}"
	set call="${params[5]}"
	set req="${params[6]}"
	set code="${params[7]}"
	set objFS="${params[8]}"
	set message="${params[9]}"
	
	set dif=`eval "$prep"`
	set before=`eval "ls"`
	
	set msg=`eval "../../$call"`
	set res=$status
	
	set dif=`eval "$checkcall"`
	set rdif=$status
	
	echo "Входные параметры" >> $outfile
	echo ",Номер теста,$num" >> $outfile
	echo ",Подготовка среды,$prep" >> $outfile
	echo ",Проверка среды,$checkcall" >> $outfile
	echo ",Объекты ФС,$descrFS" >> $outfile
	echo ",Строка вызова,$call" >> $outfile
	echo ",Требование,$req" >> $outfile
	
	echo "Ожидаемые выходные данные" >> $outfile
	echo ",Код возврата,$code" >> $outfile
	echo ",Объекты ФС,$objFS" >> $outfile
	echo ",Сообщение,$message" >> $outfile
	
	echo "Выходные данные" >> $outfile
	echo ",Код возврата,${res}" >> $outfile
	echo ",Сообщение,${msg}" >> $outfile
	
	set after=`eval "ls"`
	if ( ( $rdif == '0' ) && ( $res == $code ) && ( "$msg" == "$message" ) && ( "$before" == "$after" ) ) then
		echo ",Вердикт,PASSED" >> $outfile
		@ passed ++
		echo "$tst PASSED"
	else
		echo ",Вердикт,FAILED" >> $outfile
		echo "$tst FAILED"
	endif
	
	cd "../"
	
	rm -rf "./*"
	
	cd "../"
	
	rm "./test${tst}"
	cd "${testdir}"
	
	@ tst ++
end

echo "Пройдено,${passed}" >> $output
echo "Всего,${1}" >> $output

cd "../"
sudo rm -rf "${testdir}"

libreoffice --calc "$fname"

#	set params=("" "" "" "" "" "" "" "" "")
#	set some=`eval "cat -E < $file"`
#	set i = 1
#	set pos = 1
#	while ( $i <= $#some )
#		set params[$pos]="${params[$pos]}"" ""${some[${i}]}"
#		if ( `expr "$params[$pos]" : '.*\$'` != 0 ) then
#			
#			@ pos ++
#			echo $params[$pos]
#			exit 0
#		endif
#		@ i ++
#	end
