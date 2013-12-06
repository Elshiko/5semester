import json

tst = ""
with open("tests",'r') as f:
	tst = f.read()
tst = json.loads(tst)
with open("csv",'w') as f:
	f.write("Входные параметры,,,,,,Ожидаемые выходные данные,,,\n")
	f.write("Номер теста,Подготовка среды,Проверка среды,Объекты ФС,строка вызова,Требование,Сообщение,Код возврата,Объекты ФС\n");
	for a in tst:
		_in = a["Входные параметры"]
		_out = a["Ожидаемые выходные данные"]
		f.write('"' + _in["Номер теста"] + '"' + ',')
		f.write('"' + _in["Подготовка среды"] + '"' + ',')
		f.write('"' + _in["Проверка среды"] + '"' + ',')
		f.write('"' + _in["Объекты ФС"] + '"' + ',')
		f.write('"' + _in["Строка вызова"] + '"' + ',')
		f.write('"' + _in["Требование"] + '"' + ',')
		f.write('"' + _out["Сообщение"] + '"' + ',')
		f.write('"' + _out["Код возврата"] + '"' + ',')
		f.write('"' + _out["Объекты ФС"] + '"' + ',\n')
		with open("test" + _in["Номер теста"], 'w') as testfile:
			testfile.write(_in["Номер теста"] + '\n')
			testfile.write(_in["Подготовка среды"] + '\n')
			testfile.write(_in["Проверка среды"] + '\n')
			testfile.write(_in["Объекты ФС"] + '\n')
			testfile.write(_in["Строка вызова"] + '\n')
			testfile.write(_in["Требование"] + '\n')
			testfile.write(_out["Код возврата"] + '\n')
			testfile.write(_out["Объекты ФС"] + '\n')
			testfile.write(_out["Сообщение"] + '\n')
