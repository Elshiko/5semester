#!/bin/bash
python3.3 parser.py

fname="res"

rm -f "$fname"

outfile="../../$fname"
output="../$fname"
testdir=$(exec date +%s)
while [ -e ${testdir} ]
do
	testdir=$(exec date +%s)
done

mkdir "${testdir}"
cd "${testdir}"

tst=1
passed=0

while [ $tst -le ${1} ]
do
	mkdir $tst
	cd $tst
	
	file="../../test"$tst
	declare params
	
	i=0
	while read line
	do
		params[${i}]=$line
		let i++
	done < $file
	
	num="${params[0]}"
	prep="${params[1]}"
	checkcall="${params[2]}"
	descrFS="${params[3]}"
	call="${params[4]}"
	req="${params[5]}"
	code="${params[6]}"
	objFS="${params[7]}"
	message="${params[8]}"
	
	dif=$(eval $prep)
	before=$(ls)
	
	msg=$(exec ../../$call)
	res=$?
	
	dif=(eval $checkcall)
	rdif=$?
	
	echo "Входные параметры" >> $outfile
	echo ",Номер теста,$num" >> $outfile
	echo ",Подготовка среды,$prep" >> $outfile
	echo ",Проверка среды,$checkcall" >> $outfile
	echo ",Объекты ФС,\"$descrFS\"" >> $outfile
	echo ",Строка вызова,\"$call\"" >> $outfile
	echo ",Требование,\"$req\"" >> $outfile
	
	echo "Ожидаемые выходные данные" >> $outfile
	echo ",Код возврата,\"$code\"" >> $outfile
	echo ",Объекты ФС,\"$objFS\"" >> $outfile
	echo ",Сообщение,\"$message\"" >> $outfile
	
	echo "Выходные данные" >> $outfile
	echo ",Код возврата,${res}" >> $outfile
	echo ",Сообщение,\"${msg}\"" >> $outfile
	
	after=$(ls)
	
	if [ $rdif -eq '0' ] && [ $res -eq $code ] && [ "$msg" = "$message" ] && [ "$before" = "$after" ]
	then
		echo ",Вердикт,PASSED" >> $outfile
		let passed++
		echo "$tst PASSED"
	else
		echo ",Вердикт,FAILED" >> $outfile
		echo "$tst FAILED"
	fi
	
	cd "../"
	
	rm -rf "./*"
	
	cd "../"
	
	rm "./test${tst}"
	cd "${testdir}"
	
	let tst++
done

echo "Пройдено,${passed}" >> $output
echo "Всего,${1}" >> $output

cd "../"
sudo rm -rf "${testdir}"

libreoffice --calc "$fname"
