
////////////////////////////////////////////////////////////////////////
// ОРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	МенеджерВременныхТаблиц = Найти(ВРег(Параметры.ТекстЗапроса), "ПОМЕСТИТЬ") ИЛИ Найти(ВРег(Параметры.ТекстЗапроса), "INTO");
	ПеременнаяЗапроса = "лЗапрос";
	ПроверитьРезультатЗапроса = Ложь;
	
	пХранилище = ПолучитьИзВременногоХранилища(Параметры.ПутьКХранилищу);
	пТаблицаПакетов = пХранилище.ТаблицаПакетов;
	
	Отбор = Новый Структура("ЭтоВТ,ИД", Ложь, Параметры.ИД);
	пТаблицаПакетов = пТаблицаПакетов.НайтиСтроки(Отбор);
	
	Для каждого Эл Из пТаблицаПакетов Цикл
		Если Лев(ВРег(Эл.ТекстПакета), 10) = "УНИЧТОЖИТЬ" ИЛИ Лев(ВРег(Эл.ТекстПакета), 4) = "DROP" Тогда
			пТаблицаПакетов.Удалить(пТаблицаПакетов.Найти(Эл));
		КонецЕсли;
	КонецЦикла; 
	
	ЭтаФорма.КоличествоРезультатовЗапроса = пТаблицаПакетов.Количество();
	
	Если ЭтаФорма.КоличествоРезультатовЗапроса = 0 Тогда
		Отказ = Истина;
	КонецЕсли;
	
	пРезультатыЗапроса = ДанныеФормыВЗначение(ВыводРезультатаЗапроса, Тип("ТаблицаЗначений"));
	
	КолРез = ЭтаФорма.КоличествоРезультатовЗапроса;
	СтруктураИменПолей = Новый Структура;
	Разделители = " /*-+=-\""''.,;*-+=(){}% "+Символы.Таб+Символы.ПС+Символы.НПП+Символы.ВТаб+Символы.ВК+Символы.ПФ;
	
	Для Сч = 1 По ЭтаФорма.КоличествоРезультатовЗапроса Цикл
		НоваяСтрока = пРезультатыЗапроса.Добавить();
		НоваяСтрока.Переменная = "лВыборка" + ?(КолРез > 1, формат(Сч, "ЧГ=0"), "");
		НоваяСтрока.СпособВывода = "Выбрать";
	    НоваяСтрока.ТаблицаПриемника = "лТаблицаЗначений" + ?(КолРез > 1, формат(Сч, "ЧГ=0"), "");
		НоваяСтрока.Итератор = "лСтрока";
		
		СтрокаПакета = пТаблицаПакетов[Сч-1];
		ТекстПакета = СтрокаПакета.ТекстПакета;
		СтрокаПолей = "";

		НайтиВхождение = НайтиВхождения(ТекстПакета, "ВЫБРАТЬ,SELECT");
		ПозицияСледующегоСлова = НайтиВхождение.Вхождение + НайтиВхождение.Длина + 1;
		НайтиИЗ = НайтиОкончаниеСпискаПолейПакета(ТекстПакета);
		ТекстПолей = СокрЛП(Сред(ТекстПакета, ПозицияСледующегоСлова, НайтиИЗ - ПозицияСледующегоСлова));
		ПоляРезультатаЗапроса = "";
		
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент2 = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.УстановитьТекст(ТекстПолей);
		КоличествоСтрок = ТекстовыйДокумент.КоличествоСтрок();
		
		СоответствиеОткрывашек = Новый Соответствие;

		Для i = 1 По КоличествоСтрок Цикл
			ТекущаяСтрока = ТекстовыйДокумент.ПолучитьСтроку(i);
			НоваяСтрокаРазбора = "";
			ЭтоТекст = Ложь;
			СимволовВСтроке = СтрДлина(ТекущаяСтрока);
			Для r = 1 По СимволовВСтроке Цикл
				ТекСимвол = Сред(ТекущаяСтрока, r, 1);
				Если ТекСимвол = """" Тогда
					ЭтоТекст = НЕ ЭтоТекст;
				КонецЕсли;
				Если НЕ ЭтоТекст И ТекСимвол = "/" И ?(r < СимволовВСтроке, Истина, Ложь) И Сред(ТекущаяСтрока, r + 1, 1) = "/" Тогда
					Прервать;
				КонецЕсли;
				Если ТекСимвол = "(" ИЛИ ТекСимвол = "{" Тогда
					СоответствиеОткрывашек.Вставить(ТекСимвол);
				КонецЕсли;
				Если СоответствиеОткрывашек.Количество() = 0 Тогда
					НоваяСтрокаРазбора = НоваяСтрокаРазбора + ТекСимвол;
				КонецЕсли; 
				Если ТекСимвол = ")" ИЛИ ТекСимвол = "}" Тогда
					СоответствиеОткрывашек.Удалить(ТекСимвол);
				КонецЕсли;
			КонецЦикла;
			ТекстовыйДокумент2.ДобавитьСтроку(НоваяСтрокаРазбора);
		КонецЦикла;
		
		ТекстПолей = ТекстовыйДокумент2.ПолучитьТекст();

		ТекстПолей = СтрЗаменить(ТекстПолей, "	", " ");
		ТекстПолей = СтрЗаменить(ТекстПолей, " ,", ",");
		ТекстПолей = СтрЗаменить(ТекстПолей, Символы.ПС, " ");
		ТекстПолей = СтрЗаменить(ТекстПолей, "  ", " ");
		ТекстПолей = СтрЗаменить(ТекстПолей, ",", Символы.ПС);
		ТекстДок = Новый ТекстовыйДокумент;
		ТекстДок.УстановитьТекст(ТекстПолей);
		КоличествоСтрок = ТекстДок.КоличествоСтрок();
		СтруктураИменПолей.Очистить();;

		Для пСч = 1 По КоличествоСтрок Цикл
			СтрокаПолей = ТекстДок.ПолучитьСтроку(пСч);
			НайтиВхождение = НайтиВхождения(СтрокаПолей, "КАК,AS");
			ПозицияСледующегоСлова = НайтиВхождение.Вхождение + НайтиВхождение.Длина + 1;
			Если НайтиВхождение.Вхождение > 0 Тогда
                СтруктураИменПолей.Вставить(СокрЛП(Сред(СтрокаПолей, ПозицияСледующегоСлова)));
			Иначе
				Пока Найти(СтрокаПолей, ".") Цикл
					СтрокаПолей = Сред(СтрокаПолей, Найти(СтрокаПолей, ".") + 1);
				КонецЦикла;
				Для ппСч=1 По СтрДлина(СтрокаПолей) Цикл
					Буква = Сред(СтрокаПолей, ппСч, 1);
					Если Найти(Разделители, Буква)>0 Тогда
						СтрокаПолей = Лев(СтрокаПолей, ппСч-1);
					КонецЕсли;
				КонецЦикла;
				Если СтрокаПолей = "" Тогда
				    Сч = Сч + 1;
					СтрокаПолей = "Поле" + Формат(Сч, "ЧГ=0");
				КонецЕсли;
				Попытка
					СтруктураИменПолей.Вставить(СтрокаПолей);
				Исключение
				КонецПопытки;
			КонецЕсли; 
		КонецЦикла;
		
		Для каждого ЭлСтруктуры Из СтруктураИменПолей Цикл
			 ПоляРезультатаЗапроса = ПоляРезультатаЗапроса + ?(ПоляРезультатаЗапроса = "", "", ",") + ЭлСтруктуры.Ключ;
		КонецЦикла; 

		НоваяСтрока.Поля = ПоляРезультатаЗапроса;
	КонецЦикла; 
	
	ЗначениеВДанныеФормы(пРезультатыЗапроса, ВыводРезультатаЗапроса);
	
	#Если Клиент Тогда
	Элементы.Копировать.Видимость = Истина;
	#Иначе
	Элементы.Копировать.Видимость = Ложь;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекст();
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////
// ОРАБОТЧИКИ КОМАНД

&НаКлиенте
Процедура СоздатьТекст(Команда)
	
	ОбновитьТекст();
	
КонецПроцедуры

&НаКлиенте
Процедура Копировать(Команда)
	
	УстановитьТекстВБуферОбмена(Текст.ПолучитьТекст());
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////
// ДОПОЛНИТЕЛЬНЫЕ ФУНКЦИИ И ПРОЦЕДУРЫ

&НаКлиенте
Процедура ОбновитьТекст()
	
	пТекст = Параметры.ТекстЗапроса;
	пТекстЗапроса = СформироватьТекстЗапросаДляКонфигуратора(пТекст);
	пТекстПараметров = СоздатьКодЗаполненияПараметров(пТекст);
	пТекстЗначенийПеременныхПараметров = ПолучитьТекстПрисвоенияЗначенийПеременнымПараметров();
	пМенеджерВременныхТаблиц = "" + ПеременнаяЗапроса + ".МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;" + Символы.ПС;
	
	лТекстРезультатаЗапроса = "";
	НесколькоПакетов = ЭтаФорма.КоличествоРезультатовЗапроса > 1;
	Если НесколькоПакетов Тогда

		ПредставлениеРезультатаЗапроса = "лМассивРезультатовЗапроса";
	Иначе

		ПредставлениеРезультатаЗапроса = ?(ПроверитьРезультатЗапроса, "лРезультатЗапроса", ПеременнаяЗапроса + "." + "Выполнить()");
	КонецЕсли; 
	
	пТекстЗапроса = Сред(пТекстЗапроса, 2);
	пТекстЗапроса = Сред(пТекстЗапроса, 1, СтрДлина(пТекстЗапроса) - 1);
	лТекстЗапроса = Символы.Таб + "лТекст = """ + Символы.ПС + Символы.Таб + Символы.Таб + "|" + пТекстЗапроса;
	
	лТекстКонструктора = 
	"	" + ПеременнаяЗапроса + " = Новый Запрос(лТекст);
	|" + ?(МенеджерВременныхТаблиц, Символы.Таб + пМенеджерВременныхТаблиц, "");
	
		
	Если ПроверитьРезультатЗапроса Тогда
		
		лТекстРезультатаЗапроса = "	" + ПредставлениеРезультатаЗапроса + " = " + ПеременнаяЗапроса + "." + ?(НесколькоПакетов, "ВыполнитьПакет()", "Выполнить()") + ";" +Символы.ПС;
		Для лИндекс = 0 По ЭтаФорма.КоличествоРезультатовЗапроса - 1 Цикл
			
			лТекстРезультатаЗапроса = лТекстРезультатаЗапроса +				
				"	Если " +ПредставлениеРезультатаЗапроса + ?(НесколькоПакетов, "[" +лИндекс+"].Пустой()", ".Пустой()") + " Тогда
				|		Возврат;	
				|	КонецЕсли;
				|"+Символы.ПС;
		КонецЦикла;
	Иначе
		
		лТекстРезультатаЗапроса = ?(НесколькоПакетов, "	" + ПредставлениеРезультатаЗапроса + " = " + ПеременнаяЗапроса + ".ВыполнитьПакет();" +Символы.ПС , "");
	КонецЕсли;

	ТекстВыборкиВыгрузки = "";
	Для каждого ОписаниеВывода Из ВыводРезультатаЗапроса Цикл
		
		ТекстЗаполненияПолей = "";
		МаксСтрДлина = 0;
		МассивСтрок = Новый Массив;
		Для каждого ПолеПакета Из Новый Структура(ОписаниеВывода.Поля) Цикл
			НоваяСтрока = "		лНоваяСтрока." + ПолеПакета.Ключ + "#= " + ОписаниеВывода.Переменная + "." + ПолеПакета.Ключ + ";";
			МассивСтрок.Добавить(НоваяСтрока);
		    МаксСтрДлина = Макс(МаксСтрДлина, Найти(НоваяСтрока, "#"));
		КонецЦикла;
		
		Для каждого элМассива Из МассивСтрок Цикл
			НехваткаСимволов = МаксСтрДлина - Найти(элМассива, "#");
			Пробелы = "";
			
			Пока НехваткаСимволов > 0 Цикл
				Пробелы = Пробелы + " ";
				НехваткаСимволов = НехваткаСимволов - 1;
			КонецЦикла;
			
			ТекстСтроки = СтрЗаменить(элМассива, "#", Пробелы + " ");
			ТекстЗаполненияПолей = ТекстЗаполненияПолей + Символы.ПС + ТекстСтроки;
		КонецЦикла; 
		
	Если ОписаниеВывода.СпособВывода = "Выбрать" Тогда
			ТекстВыборкиВыгрузки = ТекстВыборкиВыгрузки + Символы.ПС + "	" + ОписаниеВывода.Переменная + " = " + ПредставлениеРезультатаЗапроса + ?(НесколькоПакетов, "[" + ВыводРезультатаЗапроса.Индекс(ОписаниеВывода) + "]", "") + ".Выбрать();" + Символы.ПС;
			ТекстВыборкиВыгрузки = ТекстВыборкиВыгрузки + Символы.ПС + "	Пока " + ОписаниеВывода.Переменная + ".Следующий() Цикл"+Символы.ПС;
			ТекстВыборкиВыгрузки = ТекстВыборкиВыгрузки + Символы.ПС + "		лНоваяСтрока = " + ОписаниеВывода.ТаблицаПриемника + ".Добавить();";
			ТекстВыборкиВыгрузки = ТекстВыборкиВыгрузки + ТекстЗаполненияПолей;
			ТекстВыборкиВыгрузки = ТекстВыборкиВыгрузки + Символы.ПС + "	КонецЦикла;";
		ИначеЕсли ОписаниеВывода.СпособВывода = "Выгрузить" Тогда
			ТекстВыборкиВыгрузки = ТекстВыборкиВыгрузки + Символы.ПС + "	" + ОписаниеВывода.Переменная + " = " + ПредставлениеРезультатаЗапроса + ?(НесколькоПакетов, "[" + ВыводРезультатаЗапроса.Индекс(ОписаниеВывода) + "]", "") + ".Выгрузить();" + Символы.ПС;
			ТекстВыборкиВыгрузки = ТекстВыборкиВыгрузки + Символы.ПС + "	Для каждого " +ОписаниеВывода.Итератор+ " из " + ОписаниеВывода.Переменная + " Цикл" + Символы.ПС;
			ТекстВыборкиВыгрузки = ТекстВыборкиВыгрузки + Символы.ПС + "		лНоваяСтрока = " + ОписаниеВывода.ТаблицаПриемника + ".Добавить();";
			ТекстВыборкиВыгрузки = ТекстВыборкиВыгрузки + СтрЗаменить(ТекстЗаполненияПолей, ОписаниеВывода.Переменная, ОписаниеВывода.Итератор);
			ТекстВыборкиВыгрузки = ТекстВыборкиВыгрузки + Символы.ПС + "	КонецЦикла;";
		КонецЕсли;
		
		ТекстВыборкиВыгрузки = ТекстВыборкиВыгрузки + Символы.ПС;
	
	КонецЦикла; 	

	Текст.УстановитьТекст(лТекстЗапроса + Символы.ПС + Символы.Таб + Символы.Таб + "|"";" 
		+ Символы.ПС + Символы.ПС + лТекстКонструктора 
		+ Символы.ПС + "	// Присвоение значений переменным параметров." + Символы.ПС + СокрП(пТекстЗначенийПеременныхПараметров) 
		+ Символы.ПС + Символы.ПС + "	// Установка параметров." + Символы.ПС + пТекстПараметров
		+ Символы.ПС + лТекстРезультатаЗапроса + ТекстВыборкиВыгрузки);
	
КонецПроцедуры

&НаСервере
Функция НайтиОкончаниеСпискаПолейПакета(Знач СтрокаПакета)

	КП = 0;
	Разделители = " /*-+=-\""''.,;*-+=(){}% "+Символы.Таб+Символы.ПС+Символы.НПП+Символы.ВТаб+Символы.ВК+Символы.ПФ;

	Для сч=1 По 5 Цикл
		Искомое = (?(сч=1, "ПОМЕСТИТЬ,INTO", ?(сч=2, "ИЗ,FROM", ?(сч=3, "ГДЕ,WHERE", ?(сч=4, "УПОРЯДОЧИТЬ,ORDER", "ИТОГИ,TOTALS")))));
		ВхождениеИскомого = НайтиВхождения(СтрокаПакета, Искомое);
		Слово = ВхождениеИскомого.Вхождение;
		
		СтрокаПакетаКастро = СтрокаПакета;
		пОк = Ложь;
		Циклов = 0;
		Пока Слово > 0 И НЕ пОк Цикл
			Циклов = Циклов + 1;
			Если Слово > 1 Тогда
				ПредСимвол = Сред(СтрокаПакетаКастро, Слово-1, 1);
				пОк = Найти(Разделители, ПредСимвол) > 0;
			ИначеЕсли Слово = 0 Тогда
				пОк = Истина;
			Иначе
				пОк = Ложь;
			КонецЕсли;
			
			Если Слово+СтрДлина(ВхождениеИскомого.Слово)+1 > СтрДлина(СтрокаПакетаКастро) Тогда
				пОк = Истина;
			Иначе
				СледСимвол = Сред(СтрокаПакетаКастро, Слово+СтрДлина(ВхождениеИскомого.Слово)+1, 1);
				пОк = Найти(Разделители, СледСимвол) > 0;
			КонецЕсли;
			
			СтрокаПакетаКастро = Сред(ВРег(СтрокаПакетаКастро), 2);
			Слово = Найти(ВРег(СтрокаПакетаКастро), ВхождениеИскомого.Слово);

		КонецЦикла;
		
		
		Если Слово > 0 Тогда
			Слово = Слово + Циклов;
			КП = Мин(?(КП = 0, Слово, КП), Слово);
		КонецЕсли;
	КонецЦикла;
	
	Возврат КП;

КонецФункции

&НаСервере
Функция СформироватьТекстЗапросаДляКонфигуратора(Текст)
	
	ВозврЗнач = """";
	ПереводСтроки = Символы.ВК+Символы.ПС;
	Для Счетчик = 1 По СтрЧислоСтрок(Текст) Цикл
		ТекСтрока = СтрПолучитьСтроку(Текст, Счетчик);
		Если Счетчик > 1 Тогда 
			ТекСтрока = СтрЗаменить(ТекСтрока,"""","""""");
			ВозврЗнач = ВозврЗнач + ПереводСтроки + "		|"+ ТекСтрока;
		Иначе	
			ТекСтрока = СтрЗаменить(ТекСтрока,"""","""""");
			ВозврЗнач = ВозврЗнач + ТекСтрока;
		КонецЕсли;	
	КонецЦикла;
	ВозврЗнач = ВозврЗнач + """";
	Возврат ВозврЗнач;
	
КонецФункции	

&НаСервере
Функция СоздатьКодЗаполненияПараметров(ТекстЗапроса)
	
	Если ПустаяСтрока(ТекстЗапроса) Тогда
		Возврат "";
	Иначе
		Запрос = Новый Запрос;
		Попытка
			Запрос.Текст = ТекстЗапроса;
			ОписаниеПараметров = Запрос.НайтиПараметры();
			КоличествоПараметров = ОписаниеПараметров.Количество();
		Исключение
			//Предупреждение(ОписаниеОшибки());
			Возврат "";
		КонецПопытки;
	КонецЕсли;
	
	Если КоличествоПараметров = 0 Тогда
		Возврат "";
	КонецЕсли;
	
	Текст = Новый ТекстовыйДокумент;
	
	Для Каждого ОписПар Из ОписаниеПараметров Цикл
		Текст.ДобавитьСтроку("	" + ПеременнаяЗапроса + ".УстановитьПараметр(""" + ОписПар.Имя + """, " + ОписПар.Имя + ");");
	КонецЦикла;
	
	Возврат Текст.ПолучитьТекст();
	
КонецФункции // СоздатьКодЗаполненияПараметров()

&НаКлиенте
Процедура ВыводРезультатаЗапросаСпособВыводаПриИзменении(Элемент)
	
	ТекСтрока = ВыводРезультатаЗапроса.НайтиПоИдентификатору(Элементы.ВыводРезультатаЗапроса.ТекущаяСтрока);
	пСпособВывода = ТекСтрока.СпособВывода;
	
	СлеваВЫБОРКА  = Лев(ВРег(ТекСтрока.Переменная), СтрДлина("лВЫБОРКА" )) = "ЛВЫБОРКА";
	СлеваВЫГРУЗКА = Лев(ВРег(ТекСтрока.Переменная), СтрДлина("лВЫГРУЗКА")) = "ЛВЫГРУЗКА";
	
	Если НЕ (СлеваВЫБОРКА ИЛИ СлеваВЫГРУЗКА) Тогда
		Возврат;
	КонецЕсли; 
	
	ВывестиВыборкой  = ВРег(пСпособВывода) = "ВЫБРАТЬ";
	ВывестиВыгрузкой = ВРег(пСпособВывода) = "ВЫГРУЗИТЬ";
	
	Если ВывестиВыборкой И СлеваВЫГРУЗКА Тогда
		НовоеНазвание = "лВыборка"  + Сред(ТекСтрока.Переменная, СтрДлина("лВЫГРУЗКА") + 1);
		ТекСтрока.Переменная = НовоеНазвание;
	ИначеЕсли ВывестиВыгрузкой И СлеваВЫБОРКА Тогда
		НовоеНазвание = "лВыгрузка" + Сред(ТекСтрока.Переменная, СтрДлина("лВЫБОРКА" ) + 1);
		ТекСтрока.Переменная = НовоеНазвание;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстВБуферОбмена(Текст)
	
	#Если Клиент Тогда
	ОбъектКопирования = Новый COMОбъект("htmlfile");
	ОбъектКопирования.ParentWindow.ClipboardData.Setdata("Text", Текст);
	#Иначе
	Сообщить("На сервере не работает.");
	#КонецЕсли

КонецПроцедуры 

&НаСервере
Функция НайтиВхождения(Знач Текст, ИскомыеСлова)
	
	СтруктураИскомыхСлов = Новый Структура(ИскомыеСлова);
	СтруктураРезультат = Новый Структура("Слово,Вхождение,Длина", "", 0, 0);
	ЗначениеНайдено = Ложь;
	НомерСтартовогоСимвола = 1;
	Для каждого Элемент Из СтруктураИскомыхСлов Цикл
		
		Пока НЕ ЗначениеНайдено Цикл

			ПроверкаСлеваПройдена = Ложь;
			ПроверкаСправаПройдена = Ложь;
			Вхождение = Найти(ВРег(Сред(Текст, НомерСтартовогоСимвола)), ВРег(Элемент.Ключ)) + НомерСтартовогоСимвола - 1;
			Если Вхождение = 0 Тогда
				Прервать;
			Иначе
				Если Вхождение = 1 Тогда
					ПроверкаСлеваПройдена = Истина;
				Иначе
					ПроверкаСлеваПройдена = ПустаяСтрока(Сред(Текст, Вхождение - 1, 1));
				КонецЕсли;
				
				ПозицияСледующегоСимвола = Вхождение + СтрДлина(Элемент.Ключ);
				
				Если ПозицияСледующегоСимвола = СтрДлина(Текст) Тогда
					ПроверкаСправаПройдена = Истина;
				Иначе
					ПроверкаСправаПройдена = ПустаяСтрока(Сред(Текст, ПозицияСледующегоСимвола, 1));
				КонецЕсли;
				
				Если ПроверкаСлеваПройдена И ПроверкаСправаПройдена Тогда
					СтруктураРезультат.Слово = Элемент.Ключ;
					СтруктураРезультат.Вхождение = Вхождение;
					СтруктураРезультат.Длина = СтрДлина(Элемент.Ключ);
					ЗначениеНайдено = Истина;
					Прервать;
				Иначе
					НомерСтартовогоСимвола = ПозицияСледующегоСимвола;
				КонецЕсли; 
			КонецЕсли; 
			
		КонецЦикла;
		
		Если ЗначениеНайдено Тогда
		
			Прервать;
		
		КонецЕсли; 
		
	КонецЦикла;
	
	Возврат СтруктураРезультат;
	
КонецФункции // НайтиВхождения()

&НаСервере
Функция ПолучитьТекстПрисвоенияЗначенийПеременнымПараметров()

	Об = РеквизитФормыВЗначение("Объект");
	Возврат Об.СоздатьТекстПрисвоенияЗначенийПеременнымПараметров(Параметры.ПутьКХранилищу, Параметры.ИД, Параметры.РежимСовместимости);

КонецФункции
 

