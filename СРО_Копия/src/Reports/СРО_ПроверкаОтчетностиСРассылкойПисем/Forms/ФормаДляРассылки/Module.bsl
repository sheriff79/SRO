
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)  
	
	ВидПечатнойФормы = 0;
	
	ДеревоТаблицаОшибок = РеквизитФормыВЗначение("ТаблицаОшибок"); 	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВремТаблица.КПК КАК КПК,
	               |	ВремТаблица.НазваниеТаблицы КАК НазваниеТаблицы,
	               |	ВремТаблица.ОписаниеУсловия КАК ОписаниеУсловия,
	               |	ВремТаблица.КоличествоОшибок КАК КоличествоОшибок,
	               |	ВремТаблица.ПорядокСортировки КАК ПорядокСортировки,
	               |	ВремТаблица.НомерВРеестреСРО КАК НомерВРеестреСРО,
	               |	ВремТаблица.КодОшибки КАК КодОшибки,
	               |	ВремТаблица.КоличествоОшибок КАК ОшибокПоКПК
	               |ПОМЕСТИТЬ ВремТЗ
	               |ИЗ
	               |	&ВремТаблица КАК ВремТаблица
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВремТЗ.КПК КАК КПК,
	               |	ВремТЗ.НазваниеТаблицы КАК НазваниеТаблицы,
	               |	ВремТЗ.ОписаниеУсловия КАК ОписаниеУсловия,
	               |	ВремТЗ.КоличествоОшибок КАК КоличествоОшибок,
	               |	ВремТЗ.ПорядокСортировки КАК ПорядокСортировки,
	               |	ВремТЗ.НомерВРеестреСРО КАК НомерВРеестреСРО,
	               |	ВремТЗ.КодОшибки КАК КодОшибки,
	               |	ВремТЗ.ОшибокПоКПК КАК ОшибокПоКПК
	               |ИЗ
	               |	ВремТЗ КАК ВремТЗ
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерВРеестреСРО,
	               |	КодОшибки
	               |ИТОГИ
	               |	СУММА(ОшибокПоКПК)
	               |ПО
	               |	КПК";
				   
	ВремТЗ = Параметры.ТаблицаОшибок.Выгрузить();                                          				   
	
	ВремТЗ.Свернуть("КПК, НазваниеТаблицы, ОписаниеУсловия, НомерВРеестреСРО, КодОшибки", "КоличествоОшибок, ПорядокСортировки");
	
	ПорядокСортировки = 0;
	Для Каждого ТекСтрока ИЗ ВремТЗ Цикл
		
		ПорядокСортировки = ПорядокСортировки + 1;      		
		ТекСтрока.ПорядокСортировки = ПорядокСортировки;		
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ВремТаблица", ВремТЗ);
	
	ВыборкаПоКПК = запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаПоКПК.Следующий() Цикл
		НоваяСтрокаКПК = ДеревоТаблицаОшибок.Строки.Добавить();
		НоваяСтрокаКПК.КПК = ВыборкаПоКПК.КПК;
		НоваяСтрокаКПК.НомерВРеестреСРО = ВыборкаПоКПК.КПК.НомерВРеестреСРО;
		НоваяСтрокаКПК.КоличествоОшибок = ВыборкаПоКПК.ОшибокПоКПК;
		
		Выборка = ВыборкаПоКПК.Выбрать();		
		Пока Выборка.Следующий() Цикл          
			НоваяСтрока = НоваяСтрокаКПК.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка); 				
		КонецЦикла; 		
		
		НоваяСтрокаДляРассылки = ТаблицаДляРассылки.Добавить();
		НоваяСтрокаДляРассылки.КПК = ВыборкаПоКПК.КПК;
		НоваяСтрокаДляРассылки.НомерВРеестреСРО = ВыборкаПоКПК.КПК.НомерВРеестреСРО;				
			
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоТаблицаОшибок, "ТаблицаОшибок");
	
	СРО_КаталогДляСохраненияДокументовРассылки = Константы.СРО_КаталогДляСохраненияДокументовРассылки.Получить();	
	НачальныйИсходящийНомер = Константы.СРО_ПоследнийИсходящийНомерДокументаДляРассылки.Получить() + 1;
	
	НачалоПериодаОтчета = Параметры.НачалоПериодаОтчета;
	ОкончаниеПериодаОтчета = Параметры.ОкончаниеПериодаОтчета;
	
КонецПроцедуры


&НаКлиенте
Процедура УстановитьФлаг(Команда)
	УстановитьСнятьФлаги(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлаг(Команда)
	УстановитьСнятьФлаги(Ложь);
КонецПроцедуры

&НаСервере
Процедура УстановитьСнятьФлаги(Флаг) 	
	
	Для Каждого ТекСтрока Из ТаблицаДляРассылки Цикл
		ТекСтрока.Флаг = Флаг;			
	КонецЦикла;
	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИнформациюПОКПК(ВыбДата, КПК)
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	СРО_ОтветственныеЛицаКПКСрезПоследних.ФизЛицо КАК ФизЛицо,
	|	СРО_ОтветственныеЛицаКПКСрезПоследних.Должность КАК Должность,
	|	ЕСТЬNULL(СклоненияПредставленийОбъектов.ДательныйПадеж, """") КАК ДательныйПадеж,
	|	ЕСТЬNULL(СклоненияПредставленийОбъектов.РодительныйПадеж, """") КАК РодительныйПадеж,
	|	ЕСТЬNULL(СклоненияПредставленийОбъектов.ИменительныйПадеж, """") КАК ИменительныйПадеж
	|ИЗ
	|	РегистрСведений.СРО_ОтветственныеЛицаКПК.СрезПоследних(&ВыбДата, КПК = &КПК) КАК СРО_ОтветственныеЛицаКПКСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СклоненияПредставленийОбъектов КАК СклоненияПредставленийОбъектов
	|		ПО (СРО_ОтветственныеЛицаКПКСрезПоследних.ФизЛицо = СклоненияПредставленийОбъектов.Объект)";
	
	Запрос.УстановитьПараметр("ВыбДата", ВыбДата);
	Запрос.УстановитьПараметр("КПК", КПК);
	
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("ФизЛицо", "");
	СтруктураРезультат.Вставить("Должность", "");
	СтруктураРезультат.Вставить("ДательныйПадеж", "");
	СтруктураРезультат.Вставить("РодительныйПадеж", "");
	СтруктураРезультат.Вставить("ИменительныйПадеж", "");

	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат СтруктураРезультат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	СтруктураРезультат.ФизЛицо = Выборка.ФизЛицо;
	СтруктураРезультат.Должность = Выборка.Должность;
	СтруктураРезультат.ДательныйПадеж = Выборка.ДательныйПадеж;
	СтруктураРезультат.РодительныйПадеж = Выборка.РодительныйПадеж;
	СтруктураРезультат.ИменительныйПадеж = Выборка.ИменительныйПадеж;
	
	Возврат СтруктураРезультат;	
	
КонецФункции


Функция ПолучитьФИОРуководителяИнициалы(ФИОруководителя)
	
	МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ФИОруководителя, " ");
	
	Если МассивПодстрок.Количество() < 3 Тогда
		Возврат ФИОруководителя;
		
	Иначе
		Фамилия = МассивПодстрок[0];
		Имя = МассивПодстрок[1];
		Отчество = МассивПодстрок[2];   		
		
		Возврат ВРЕГ(Лев(Имя, 1))+"." + ВРЕГ(Лев(Отчество, 1))+". " + Фамилия;
	КонецЕсли; 	
	
КонецФункции


Функция ПолучитьИмяОтчествоРуководителя(ФИОруководителя)
	
	МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ФИОруководителя, " ");
	
	Если МассивПодстрок.Количество() < 3 Тогда
		Возврат ФИОруководителя;
		
	Иначе
		Имя = МассивПодстрок[1];
		Отчество = МассивПодстрок[2];
		
		Возврат Имя + " " + Отчество;
	КонецЕсли; 	
	
КонецФункции


Функция ПолучитьПредставлениеПериода() // ДатаПериода     	
	
	//ПредставлениеПериода = 	ПредставлениеПериода(НачалоКвартала(ДатаПериода), КонецКвартала(ДатаПериода));
	//ПредставлениеПериода = ПредставлениеПериода(НачалоПериодаОтчета, КонецКвартала(ОкончаниеПериодаОтчета));
	//ПредставлениеПериода	= СокрЛП(СтрЗаменить(ПредставлениеПериода, "4 квартал", ""));
	//ПредставлениеПериода	= СокрЛП(СтрЗаменить(ПредставлениеПериода, "квартал", "квартала"));  
	//
	
	МесяцПериода = Месяц(КонецКвартала(ОкончаниеПериодаОтчета));
	
	ПредставлениеПериода = "";
	
	Если МесяцПериода = 3 Тогда
		ПредставлениеПериода = "3 месяца ";
	ИначеЕсли МесяцПериода = 6 Тогда
		ПредставлениеПериода = "6 месяцев ";		
	ИначеЕсли МесяцПериода = 9 Тогда
		ПредставлениеПериода = "9 месяцев ";		
	КонецЕсли;
	
	
	ПредставлениеПериода = СокрЛП(ПредставлениеПериода)	+ " " + XMLСтрока(Год(ОкончаниеПериодаОтчета)) + " г.";
		
	
	
	Возврат ПредставлениеПериода;
	
КонецФункции

&НаСервере
Процедура СформироватьДокументыДляРассылкиНаСервере() 
	
	ДеревоТаблицаОшибок = РеквизитФормыВЗначение("ТаблицаОшибок");
	ТЗДляРассылки = РеквизитФормыВЗначение("ТаблицаДляРассылки");  
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");		
	
	Если БлокТриггеров = 1 Тогда    
		Макет = ОтчетОбъект.ПолучитьМакет("ПисьмоВКПКОбОшибках");	
	ИначеЕсли ВторичныйВидФормы = 3 Тогда   
		Макет = ОтчетОбъект.ПолучитьМакет("ПисьмоВКПКОбОшибках_ВторичныйКонтрольФорма3");
	Иначе	
		Макет = ОтчетОбъект.ПолучитьМакет("ПисьмоВКПКОбОшибках_ВторичныйКонтроль");		
	КонецЕсли;   
	
	НайденныеСтрокиОшибки = ТЗДляРассылки.НайтиСтроки(Новый Структура("Флаг", Истина));
	МассивКПК = НОвый Массив;
	
	
	
	Для каждого НайденнаяСтрокаОшибки ИЗ НайденныеСтрокиОшибки Цикл
		
		КПК = НайденнаяСтрокаОшибки.КПК;
		НомерВРеестреСРО = XMLСтрока(НайденнаяСтрокаОшибки.НомерВРеестреСРО);
		
		
		НайденныеСтрокиДерева = ДеревоТаблицаОшибок.Строки.НайтиСтроки(Новый Структура("КПК", КПК));
		
		
		Для Каждого СтрокаДерева ИЗ НайденныеСтрокиДерева Цикл 
			
			
			
			КПК = СтрокаДерева.КПК;
			НомерВРеестреСРО = XMLСтрока(СтрокаДерева.НомерВРеестреСРО);
			
			НайденныеСтроки = СтрокаДерева.Строки.НайтиСтроки(Новый Структура("КПК", КПК));
			
			Если НайденныеСтроки.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;	
			
			МассивСтрокТЗ = ТЗДляРассылки.НайтиСтроки(Новый Структура("КПК", КПК));
			
			ИсходящийНомер = "";
			
			Если МассивСтрокТЗ.Количество() > 0 Тогда
				ИсходящийНомер = МассивСтрокТЗ[0].ИсходящийНомер;				
			КонецЕсли;                                           		
			
			СтрокаОшибки = НайденныеСтроки[0];
			
			//Если НЕ СтрокаОшибки.Флаг Тогда 
			//	Продолжить;
			//КонецЕсли; 	   		
			
			ТабличныйДокумент = Новый ТабличныйДокумент;
			
			
			ОбластьШапка = Макет.ПолучитьОбласть("Шапка");		
			ОбластьСтрокаОшибки = Макет.ПолучитьОбласть("СтрокаОшибки");
			
			
			Если БлокТриггеров = 2 И ВторичныйВидФормы = 2 Тогда
				ОбластьОбщийБлок_1 = Макет.ПолучитьОбласть("ОбщийБлок_Форма2");  	
			Иначе	
				Если ВидПечатнойФормы = 1 ИЛИ ВторичныйВидФормы = 3 Тогда
					ОбластьОбщийБлок_1 = Макет.ПолучитьОбласть("ОбщийБлок_1");  	
				Иначе	
					Если ВторичныйВидФормы <> 3 Тогда
						ОбластьОбщийБлок_1 = Макет.ПолучитьОбласть("ОбщийБлок_ФНиКС_КС");    
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			
			Если ВторичныйВидФормы = 3 Тогда
				ОбластьПодвал2 = Макет.ПолучитьОбласть("Подвал2"); 
				ОбластьПодвал3 = Макет.ПолучитьОбласть("Подвал3");      
				ОбластьПодвал4 = Макет.ПолучитьОбласть("Подвал4");
			Иначе
				
				ОбластьПодвал1 = Макет.ПолучитьОбласть("Подвал1");      
				ОбластьПодвал2 = Макет.ПолучитьОбласть("Подвал2"); 
				
				Если БлокТриггеров = 2 Тогда
					ОбластьПодвал3 = Макет.ПолучитьОбласть("Подвал3");      
					ОбластьПодвал4 = Макет.ПолучитьОбласть("Подвал4");
				КонецЕсли;
			КонецЕсли;
			ИнформацияПоРуководителю = ПолучитьИнформациюПОКПК(ИсходящаяДата, КПК);
			
			Если ИнформацияПоРуководителю.ДательныйПадеж = "" Тогда
				ФИОРуководителяДательныйПадежИнициалы = "";
			Иначе				
				ФИОРуководителяДательныйПадежИнициалы = ПолучитьФИОРуководителяИнициалы(ИнформацияПоРуководителю.ДательныйПадеж);
			КонецЕсли;	
			
			Если ВторичныйВидФормы <> 3 Тогда
				
				
				Если ИнформацияПоРуководителю.ИменительныйПадеж = "" Тогда
					
					ИмяОтчествоРуководителя = "";	
					Если  ИнформацияПоРуководителю.Свойство("ФизЛицо") Тогда
						Если СокрЛП(ИнформацияПоРуководителю.ФизЛицо) <> "" тогда 
							ИмяОтчествоРуководителя = СокрЛП(ИнформацияПоРуководителю.ФизЛицо.ФИОПолностью);							
						КонецЕсли;
					КонецЕсли;
				Иначе	 			
					ИмяОтчествоРуководителя = ПолучитьИмяОтчествоРуководителя(ИнформацияПоРуководителю.ИменительныйПадеж);
				КонецЕсли;	 
			КонецЕсли;
			
			ОбластьШапка.Параметры.ИсхНомер =  ИсходящийНомер;
			ОбластьШапка.Параметры.ИсхДата =  Формат(ИсходящаяДата, "ДЛФ=Д");                          		
			
			ОбластьШапка.Параметры.КПККраткоеНаименование = СокрЛП(КПК.НаименованиеКраткое);
			ОбластьШапка.Параметры.ИННКПК = СокрЛП(КПК.ИНН);
			ОбластьШапка.Параметры.НомерВРеестреСРО = НомерВРеестреСРО; 			
			ОбластьШапка.Параметры.ФИОруководителяВРодПадеже =  ФИОРуководителяДательныйПадежИнициалы;// дательный падеж  				
			
			Если ВторичныйВидФормы <> 3 Тогда
				
				ОбластьШапка.Параметры.ИмяОтчествоРуководителя = ИмяОтчествоРуководителя; 			
				ОбластьШапка.Параметры.Обращение = "Уважаемый"; 
			КонецЕсли; 
			
			Попытка
				
				ОбластьШапка.Параметры.Обращение = ?(ИнформацияПоРуководителю.ФизЛицо.Пол = Перечисления.Пол.Мужской, "Уважаемый", "Уважаемая"); 	
			Исключение
				
			КонецПопытки; 		
			
			ПредставлениеПериодаОтчетности = ПолучитьПредставлениеПериода();
			
			
			
			
			
			Если БлокТриггеров = 1 Тогда 
				
				//	Если ВторичныйВидФормы = 1 Тогда
				ОбластьШапка.Параметры.НомерДатаЦБ = НомерДатаЦБ;
				
				ТекНомерДатаСРО = "";
				Если ФлВыводитьНомерДатуПротоколаСРО Тогда 
					ТекНомерДатаСРО = " и решения Контрольного комитета СРО «Кооперативные Финансы»(Протокол " + НомерДатаСРО + ") ";    
				КонецЕсли;
				ОбластьШапка.Параметры.НомерДатаСРО = ТекНомерДатаСРО;    

				ОбластьШапка.Параметры.ПредставлениеПериодаОтчетности = ПредставлениеПериодаОтчетности;  
				//Иначе
				//	ОбластьШапка.Параметры.ТекстШапки = "          На основании запроса Банка России № Т128-99-2/17606 от 05.06.2020 и решения Контрольного комитета СРО «Кооперативные Финансы» (Протокол №29-2020 от 09.06.2020 г.), в первичном отчете о деятельности  за " + Строка(ПредставлениеПериодаОтчетности) + ", были выявлены следующие расхождения:"
				//КонецЕсли;
			ИначеЕсли ВторичныйВидФормы = 2 Тогда  				
				
				Если ФлВыводитьНомерДатуПротоколаСРО Тогда
					ПредставлениеНомерДатаСРО = "и решения Контрольного комитета СРО «Кооперативные Финансы» (Протокол " + Строка(НомерДатаСРО);
				Иначе
					ПредставлениеНомерДатаСРО = "";
				КонецЕсли; 				
				
				ОбластьШапка.Параметры.ТекстШапки = "          На основании письма Банка России " + СокрЛП(НомерДатаЦБ) + ПредставлениеНомерДатаСРО + " о наличии расхождений в отчете о деятельности за " + Строка(ПредставлениеПериодаОтчетности) + ", необходимо устранить нарушение контрольных соотношений:";
				
				
			ИНачеЕсли ВторичныйВидФормы = 3 Тогда
				ОбластьШапка.Параметры.ТекстШапки = "          На основании предписания Банка России " +  СокрЛП(НомерДатаЦБ) + ", в отчете о деятельности кредитного кооператива за " + Строка(ПредставлениеПериодаОтчетности) + ", были выявлены следующие расхождения:";
				
				
				
			КонецЕсли;
			
			
			// В Зависимости от вида печатной формы будем устанавливать текст
			
			// Выводим индивидуальныеБлоки
			// ВидПечатнойФормы
			// 0 - ФН и КС
			// 1 - ФН
			// 2 - КС
			
			
			Если ВторичныйВидФормы <> 3 Тогда  
				ОбластьИндивидБлок = Макет.ПолучитьОбласть("ФНиКС_ФН"); 
			КонецЕсли;
			
			Если БлокТриггеров = 1 Тогда
				Если ВидПечатнойФормы = 0 Тогда
					ПризнакиНарушения = "порядка расчета финансовых нормативов и признаки нарушения контрольных соотношений:";   
					
				ИначеЕсли ВидПечатнойФормы = 1 Тогда
					ПризнакиНарушения = "порядка расчета финансовых нормативов.";		
					
				ИначеЕсли ВидПечатнойФормы = 2 Тогда
					ПризнакиНарушения = "контрольных соотношений:";				
					ОбластьИндивидБлок = Макет.ПолучитьОбласть("КС");  	
					
				КонецЕсли;  	
			КонецЕсли;
			
			
			ТаблицаВключаемые = Новый ТаблицаЗначений;
			ТаблицаВключаемые.Колонки.Добавить("ТриггерНачальный", Новый ОписаниеТипов("Число"));
			ТаблицаВключаемые.Колонки.Добавить("ТриггерОкончательный", Новый ОписаниеТипов("Число"));
			
			ТаблицаИсключаемые = ТаблицаВключаемые.Скопировать();		
			
			Если БлокТриггеров = 1 Тогда
				
				Если ВидПечатнойФормы = 0 Тогда
					
					ТриггерНачальный = 1000000 * 4 + 1000 * 97 + 80;
					ТриггерОкончательный = 1000000 * 5 + 1000 * 1 + 95;  			
					
					СтрокаТаблицы = ТаблицаВключаемые.Добавить();
					СтрокаТаблицы.ТриггерНачальный = ТриггерНачальный;
					СтрокаТаблицы.ТриггерОкончательный = ТриггерОкончательный;
					
				ИначеЕсли ВидПечатнойФормы = 1 Тогда
					ТриггерНачальный = 1000000 * 4 + 1000 * 97 + 80;
					ТриггерОкончательный = 1000000 * 4 + 1000 * 99 + 80;  	
					
					СтрокаТаблицы = ТаблицаВключаемые.Добавить();
					СтрокаТаблицы.ТриггерНачальный = ТриггерНачальный;
					СтрокаТаблицы.ТриггерОкончательный = ТриггерОкончательный;
					
					
				ИначеЕсли ВидПечатнойФормы = 2 Тогда
					
					//// Включаем все, но потом исключим
					//ТриггерНачальный = 1000000 * 4 + 1000 * 97 + 80;
					//ТриггерОкончательный = 1000000 * 5 + 1000 * 1 + 95;  			
					//
					//СтрокаТаблицы = ТаблицаВключаемые.Добавить();
					//СтрокаТаблицы.ТриггерНачальный = ТриггерНачальный;
					//СтрокаТаблицы.ТриггерОкончательный = ТриггерОкончательный;
					
					// Исключаем  04.99.49-04.99.80
					ТриггерНачальный = 1000000 * 4 + 1000 * 99 + 49;
					ТриггерОкончательный = 1000000 * 4 + 1000 * 99 + 80;  			
					
					СтрокаТаблицы = ТаблицаИсключаемые.Добавить();
					СтрокаТаблицы.ТриггерНачальный = ТриггерНачальный;
					СтрокаТаблицы.ТриггерОкончательный = ТриггерОкончательный;   				
					
					//ТриггерНачальный = 1000000 * 4 + 1000 * 97 + 80;
					//ТриггерОкончательный = 1000000 * 4 + 1000 * 99 + 40;  	 					
				КонецЕсли;  	
				
			Иначе
				
				//	Если НачалоПериодаОтчета < Дата(2020, 4, 1) Тогда
				
				// 05.03.04.01 - 05.03.04.211				
				ТриггерНачальный = 1000000000 * 5 + 1000000 * 3 + 1000 * 4 + 1;
				ТриггерОкончательный = 1000000000 * 5 + 1000000 * 3 + 1000 * 4 + 304; // 211; 
				
				СтрокаТаблицы = ТаблицаВключаемые.Добавить();
				СтрокаТаблицы.ТриггерНачальный = ТриггерНачальный;
				СтрокаТаблицы.ТриггерОкончательный = ТриггерОкончательный;
				
				// 1.1 - 5.5
				ТриггерНачальный = 1000 * 1 + 1;
				ТриггерОкончательный = 1000 * 5 + 5;
				
				СтрокаТаблицы = ТаблицаВключаемые.Добавить();
				СтрокаТаблицы.ТриггерНачальный = ТриггерНачальный;
				СтрокаТаблицы.ТриггерОкончательный = ТриггерОкончательный;
				
				// 08.04.02.01 - 08.04.02.03      
				ТриггерНачальный = 1000000000 * 8 + 1000000 * 4 + 1000 * 2 + 1;
				ТриггерОкончательный = 1000000000 * 8 + 1000000 * 4 + 1000 * 2 + 3;   
				
				СтрокаТаблицы = ТаблицаВключаемые.Добавить();
				СтрокаТаблицы.ТриггерНачальный = ТриггерНачальный;
				СтрокаТаблицы.ТриггерОкончательный = ТриггерОкончательный;
				
				// 08.04.2001
				ТриггерНачальный = 1000000 * 8 + 1000 * 4 + 2001;    
				
				СтрокаТаблицы = ТаблицаВключаемые.Добавить();
				СтрокаТаблицы.ТриггерНачальный = ТриггерНачальный;
				СтрокаТаблицы.ТриггерОкончательный = ТриггерНачальный;
				
				//	КонецЕсли;
				
				//Если БлокТриггеров = 2 Тогда
				//05.03.04.01 			
				//05.03.04.211  		
				
				//
				//1.1
				//5.5
				//
				//08.04.2001
				
				
			КонецЕсли;
			
			//НаименованиеКПКВПадеже = СокрЛП(КПК.НаименованиеКраткое);
			//
			//Если СтрНайти(НаименованиеКПКВПадеже, "КПКГ") > 0 ИЛИ СтрНайти(НаименованиеКПКВПадеже, "КПК")
			//	 ИЛИ СтрНайти(НаименованиеКПКВПадеже, "НО КПК") ИЛИ СтрНайти(НаименованиеКПКВПадеже, "НО КПКГ") Тогда  
			//	 
			//	НаименованиеКПКВПадеже = Стрзаменить(НаименованиеКПКВПадеже, "НО КПКГ", "Некоммерческой организацией кредитный потребительский кооператив граждан");
			//	НаименованиеКПКВПадеже = Стрзаменить(НаименованиеКПКВПадеже, "НО КПК", "Некоммерческой организацией кредитный потребительский кооператив");
			//	НаименованиеКПКВПадеже = Стрзаменить(НаименованиеКПКВПадеже, "КПКГ", "Кредитным потребительским кооперативом граждан");
			//	НаименованиеКПКВПадеже = Стрзаменить(НаименованиеКПКВПадеже, "КПК", "Кредитным потребительским кооперативом");       			
			//КонецЕсли;
			
			
			Если БлокТриггеров = 1 Тогда
				ОбластьШапка.Параметры.ПризнакиНарушения = ПризнакиНарушения;
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьШапка);
			
			// Выводим ошибки
			//ТриггерНачальный = 49780;
			//ТриггерОкончательный = 49980;  	 		
			
			
			// триггеры, в которых меняем условие
			ТриггерДляУсловияНачальный = 1000000 * 4 + 1000 * 99 + 49;
			ТриггерДляУсловияОкончательный = 1000000 * 4 + 1000 * 99 + 64;  	
			
			ВыводимДокумент = Ложь;
			
			ОписаниеОшибки = "";
			
			Для каждого СтрокаОшибкидерева ИЗ СтрокаДерева.Строки Цикл   
				
				Если СокрЛП(СтрокаОшибкидерева.КодОшибки) = "" Тогда
					Продолжить;
				КонецЕсли; 
				
				//
				ОписаниеУсловия = СокрЛП(СтрокаОшибкидерева.ОписаниеУсловия);
				
				Если СокрЛП(СтрокаОшибкидерева.КодОшибки) <> "-" Тогда
					МассивПодстрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрокаОшибкидерева.КодОшибки, ".");
					
					Если МассивПодстрок.Количество() < 2 Тогда			
						Продолжить;
					КонецЕсли;
					
					Если БлокТриггеров = 1 Тогда   		
						
						Если МассивПодстрок.Количество() < 3 И Лев(МассивПодстрок[0], 1) <> "А" Тогда
							Продолжить;
						КонецЕсли;
						
						
						Если Лев(МассивПодстрок[0], 1) = "А" Тогда
							ТриггерТекущий = "А";
							Исключаем = Истина;

						Иначе	
							ТриггерТекущий =  1000000 * Число(МассивПодстрок[0]) + 1000 * Число(МассивПодстрок[1]) + Число(МассивПодстрок[2]);
							
							Исключаем = Ложь;
							
							// Отбор по кодам
							Если ТаблицаВключаемые.Количество() > 0 Тогда
								
								Для Каждого СтрокаТаблицы ИЗ ТаблицаВключаемые Цикл
									
									Если ТриггерТекущий < СтрокаТаблицы.ТриггерНачальный ИЛИ ТриггерТекущий > СтрокаТаблицы.ТриггерОкончательный Тогда
										Исключаем = Истина;
										Прервать;
									КонецЕсли; 	
								КонецЦикла;
							КонецЕсли;
							
							Если ТаблицаИсключаемые.Количество() > 0 Тогда
								Для Каждого СтрокаТаблицы ИЗ ТаблицаИсключаемые Цикл
									
									Если ТриггерТекущий >= СтрокаТаблицы.ТриггерНачальный И ТриггерТекущий <= СтрокаТаблицы.ТриггерОкончательный Тогда
										Исключаем = Истина;
										Прервать;
									КонецЕсли; 	
								КонецЦикла;   
							КонецЕсли;
						КонецЕсли;

						
						Если Исключаем = Истина  И НЕ ВключатьВЗапросНеПопадающиеТриггеры Тогда
							Если ТриггерТекущий = "А" И (ВидПечатнойФормы = 0 ИЛИ ВидПечатнойФормы = 2) Тогда
							Иначе	
								Продолжить;
							КонецЕсли;
						КонецЕсли;
						
						Если ТриггерТекущий <> "А" И ТриггерТекущий >= ТриггерДляУсловияНачальный И ТриггерТекущий <= ТриггерДляУсловияОкончательный Тогда
							ОписаниеУсловия = СтрЗаменить(ОписаниеУсловия, "не совпадает с расчетным", "выходит за рамки установленного нормативного значения");
						КонецЕсли;       					
					Иначе
						
						Если Лев(МассивПодстрок[0], 1) = "А" Тогда
							Продолжить;
						КонецЕсли;     
						
						Если МассивПодстрок.Количество() = 2 тогда						
							ТриггерТекущий =  1000 * Число(МассивПодстрок[0]) + Число(МассивПодстрок[1]);
							
						ИначеЕсли МассивПодстрок.Количество() = 3 тогда    						
							ТриггерТекущий =  1000000 * Число(МассивПодстрок[0]) + 1000 * Число(МассивПодстрок[1]) + Число(МассивПодстрок[2]);
							
						ИначеЕсли МассивПодстрок.Количество() = 4 тогда    						
							ТриггерТекущий =  1000000000 * Число(МассивПодстрок[0]) +  1000000 * Число(МассивПодстрок[1]) + 1000 * Число(МассивПодстрок[2]) + Число(МассивПодстрок[3]);
						КонецЕсли;  
						
						Исключаем = Истина;
						
						// Отбор по кодам
						
						
						Для Каждого СтрокаТаблицы ИЗ ТаблицаВключаемые Цикл
							
							Если ТриггерТекущий >= СтрокаТаблицы.ТриггерНачальный И ТриггерТекущий <= СтрокаТаблицы.ТриггерОкончательный Тогда
								Исключаем = Ложь;
								Прервать;
							КонецЕсли; 	
						КонецЦикла;
						
						Для Каждого СтрокаТаблицы ИЗ ТаблицаИсключаемые Цикл
							
							Если ТриггерТекущий >= СтрокаТаблицы.ТриггерНачальный И ТриггерТекущий <= СтрокаТаблицы.ТриггерОкончательный Тогда
								Исключаем = Истина;
								Прервать;
							КонецЕсли; 	
						КонецЦикла; 
						
						//Если Исключаем = Истина И НЕ ВключатьВЗапросНеПопадающиеТриггеры Тогда
						//	Продолжить;
						//КонецЕсли;    
						//
					КонецЕсли;
					
					
					ОписаниеУсловия = СтрЗаменить(СокрЛП(СтрокаОшибкидерева.ОписаниеУсловия),  "не свпадает", "не совпадает");
					
				КонецЕсли;     
				
				Сообщить(СтрокаОшибкидерева.КодОшибки);
				
				Если ВключатьВЗапросНеПопадающиеТриггеры Тогда
					ОписаниеУсловия = СокрЛП(СтрЗаменить(ОписаниеУсловия, "(" + СтрокаОшибкидерева.КодОшибки + ")", "" ));
					ОписаниеУсловия = СокрЛП(СтрЗаменить(ОписаниеУсловия, СтрокаОшибкидерева.КодОшибки, "" ));			
					
					ТекОписаниеОшибки = ?(СтрокаОшибкидерева.КодОшибки = "-", "", СтрокаОшибкидерева.КодОшибки) + " " + ОписаниеУсловия;
					ОписаниеОшибки = ОписаниеОшибки + ?(ОписаниеОшибки="", "", Символы.ПС) + ТекОписаниеОшибки;
				Иначе
					ОписаниеОшибки = СокрЛП(СтрЗаменить(ОписаниеУсловия, СокрЛП(СтрокаОшибкидерева.КодОшибки), ""));
					ОписаниеОшибки = СокрЛП(СтрокаОшибкидерева.КодОшибки) + " " + ОписаниеОшибки;		
				КонецЕсли;
				
				ОбластьСтрокаОшибки.Параметры.ОписаниеОшибки = ОписаниеОшибки; // + " есть ошибка";  
				ТабличныйДокумент.Вывести(ОбластьСтрокаОшибки);   
				
				ВыводимДокумент = Истина;
			КонецЦикла; 
			
			Если (ВыводимДокумент = Ложь И СтрокаДерева.Строки.Количество() = 0) 
				ИЛИ ОписаниеОшибки = "" Тогда
				ВыводимДокумент = Истина;      			
			КонецЕсли;
			
			Если ВыводимДокумент = Ложь Тогда
				продолжить;
			КонецЕсли;
			
			// Выводим общий блок 1 			
			
			ОбластьОбщийБлок_1.Параметры.ДатаОтветаВСРО = Формат(ДатаОтветаВСРО, "ДЛФ=Д");  	
			
			Если БлокТриггеров = 2 И ВторичныйВидФормы = 2 Тогда
				ОбластьОбщийБлок_1.Параметры.ПредставлениеПериодаОтчетности = ПредставлениеПериодаОтчетности;  	
			КонецЕсли;             				
			
			ТабличныйДокумент.Вывести(ОбластьОбщийБлок_1);             		 
			Если ВторичныйВидФормы <> 3 Тогда
				
				Если БлокТриггеров = 1 Тогда
					ОбластьИндивидБлок.Параметры.ПредставлениеПериодаОтчетности = ПредставлениеПериодаОтчетности;
					ОбластьИндивидБлок.Параметры.НачалоПериодаОтчетаНачалоГода = Формат(НачалоГода(НачалоПериодаОтчета), "ДЛФ=Д");
					ОбластьИндивидБлок.Параметры.ОкончаниеПериодаОтчета = Формат(ОкончаниеПериодаОтчета, "ДЛФ=Д");
					ОбластьИндивидБлок.Параметры.ГодОтчетнойДаты = XMLСтрока(Формат(ОкончаниеПериодаОтчета, "ДФ=""гггг""")) + " г.";
					
					ТабличныйДокумент.Вывести(ОбластьИндивидБлок); 
				КонецЕсли;   
			КонецЕсли;
			
			//ОбластьШапка.Параметры.КПККраткоеНаименование = СокрЛП(КПК.НаименованиеКраткое);
			
			// выводим подвал   		
			
			Если БлокТриггеров = 1 Тогда
				ОбластьПодвал1.Параметры.ПредставлениеПериодаОтчетности = ПредставлениеПериодаОтчетности;  
				ОбластьПодвал1.Параметры.КодОКУД = "0420820";
				ТабличныйДокумент.Вывести(ОбластьПодвал1); 
			КонецЕсли;
			
			//ОбластьПодвал.Параметры.ПредставлениеСледующегоПериодаОтчетности = ПолучитьПредставлениеПериода(ДобавитьМесяц(ПериодОтчетности, 3));
			
			//
			
			МассивОбластей = Новый Массив;
			МассивОбластей.Добавить(ОбластьПодвал2);
			Если НЕ ТабличныйДокумент.ПроверитьВывод(МассивОбластей) Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			Если БлокТриггеров = 1 Тогда
				ОбластьПодвал2.Параметры.Исполнитель = СРО_ЗагрузкаОтчетности.ПолучитьФИОИнициалы(Исполнитель);
				
				ДобНомер = СокрЛП(Исполнитель.Телефон_ДобавочныйНомер);
				ОбластьПодвал2.Параметры.ДобНомер = ?(ДобНомер="", "", ", доб." + ДобНомер);		
				
				КраткоеНаименованиеОрганизации = "";
				
				ТекущаяОрганизация = Константы.ОсновнаяОрганизация.Получить();
				
				Если ТекущаяОрганизация <> Справочники.Организации.ПустаяСсылка() Тогда
					КраткоеНаименованиеОрганизации = СокрЛП(ТекущаяОрганизация.НаименованиеСокращенное);		
				КонецЕсли;                                                                              		
				
				ОбластьПодвал2.Параметры.КраткоеНаименованиеОрганизации = КраткоеНаименованиеОрганизации;
				
				ТабличныйДокумент.Вывести(ОбластьПодвал2); 
			Иначе
				
				//Если ВторичныйВидФормы = 3 Тогда
				//	
				//	ТабличныйДокумент.Вывести(ОбластьПодвал2); 
				//	
				//	КраткоеНаименованиеОрганизации = "";
				//	
				//	ТекущаяОрганизация = Константы.ОсновнаяОрганизация.Получить();
				//	
				//	Если ТекущаяОрганизация <> Справочники.Организации.ПустаяСсылка() Тогда
				//		КраткоеНаименованиеОрганизации = СокрЛП(ТекущаяОрганизация.НаименованиеСокращенное);		
				//	КонецЕсли;                                                                              		
				//	
				//	ОбластьПодвал3.Параметры.КраткоеНаименованиеОрганизации = КраткоеНаименованиеОрганизации;
				//	
				//	ТабличныйДокумент.Вывести(ОбластьПодвал3);
				//	
				//	ТабличныйДокумент.Вывести(ОбластьПодвал4); 
				//	
				//	
				//Иначе
				КраткоеНаименованиеОрганизации = "";
				
				ТекущаяОрганизация = Константы.ОсновнаяОрганизация.Получить();
				
				Если ТекущаяОрганизация <> Справочники.Организации.ПустаяСсылка() Тогда
					КраткоеНаименованиеОрганизации = СокрЛП(ТекущаяОрганизация.НаименованиеСокращенное);		
				КонецЕсли;                                                                              		
				
				ОбластьПодвал3.Параметры.КраткоеНаименованиеОрганизации = КраткоеНаименованиеОрганизации;
				
				
				ОбластьПодвал4.Параметры.Исполнитель = СРО_ЗагрузкаОтчетности.ПолучитьФИОИнициалы(Исполнитель);
				
				ДобНомер = СокрЛП(Исполнитель.Телефон_ДобавочныйНомер);
				ОбластьПодвал4.Параметры.ДобНомер = ?(ДобНомер="", "", ", доб." + ДобНомер);		
				
				//Иначе
				//	
				//	
				//КонецЕсли;
				
			КонецЕсли;
			
			
			Если БлокТриггеров = 2 или ВторичныйВидФормы = 3 Тогда
				
				
				ТабличныйДокумент.Вывести(ОбластьПодвал3); 
			КонецЕсли;
			
			// Сохраняем файл 	
			
			Если БлокТриггеров = 2 или ВторичныйВидФормы = 3 Тогда
				ТабличныйДокумент.Вывести(ОбластьПодвал4); 
			КонецЕсли;
			
			Если ВыводитьВPDF Тогда		
				ИмяФайлаPDF = СРО_КаталогДляСохраненияДокументовРассылки + "\" + НомерВРеестреСРО + "_" + Строка(ИсходящийНомер) + "_" + СтрЗаменить(ПредставлениеПериода(НачалоПериодаОтчета, КонецДня(ОкончаниеПериодаОтчета)), " г.", "") + ".pdf";
				ТабличныйДокумент.Записать(ИмяФайлаPDF, ТипФайлаТабличногоДокумента.PDF);      	
			КонецЕсли;
			
			Если ВыводитьВDocx Тогда
				ИмяФайлаDOCX = СРО_КаталогДляСохраненияДокументовРассылки + "\" + НомерВРеестреСРО + "_" + Строка(ИсходящийНомер) + "_" + СтрЗаменить(ПредставлениеПериода(НачалоПериодаОтчета, КонецДня(ОкончаниеПериодаОтчета)), " г.", "") + ".docx";
				ТабличныйДокумент.Записать(ИмяФайлаDOCX, ТипФайлаТабличногоДокумента.DOCX);      	
			КонецЕсли;	
			
			
			
			
			
		КонецЦикла;
		
	КонецЦикла;
	
	
	//СформироватьДокументыДляРассылкиНаСервере();
	//// Вставить содержимое обработчика.
КонецПроцедуры

&НаСервере
Функция ЕстьОтмеченные()
	
	Для Каждого ТекСтрока Из ТаблицаДляРассылки Цикл
		
		Если ТекСтрока.Флаг Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура СформироватьДокументыДляРассылки(Команда)
	
	
	Если НЕ ЕстьОтмеченные() Тогда		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Нет отмеченных для формирования";		
		Сообщение.Сообщить();
		
		Возврат;		
	КонецЕсли;
	

	ЕстьНезаполненныеНомера = Ложь;
	

	Для Каждого ТекСтрока Из ТаблицаДляРассылки Цикл    
		
		Если НЕ ТекСтрока.Флаг Тогда
			Продолжить;
		КонецЕсли;     			
		
		Если ТекСтрока.ИсходящийНомер = 0 Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "Есть строки с неуказанным исходящим номером";
			Возврат;
		КонецЕсли;
		
	КонецЦикла;
	
	СформироватьДокументыДляРассылкиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИсходящиеНомера(Команда)
	
	Если НачальныйИсходящийНомер = 0 Тогда 
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не установлен начальный исходящий номер";
		Сообщение.Поле = "НачальныйИсходящийНомер";
		Сообщение.Сообщить();
		
		Возврат;		
	КонецЕсли;
	
	ПоследнийИсходящийНомер = НачальныйИсходящийНомер; 
	
	ВремНачальныйИсходящийНомер = Неопределено;
	Для Каждого ТекСтрока Из ТаблицаДляРассылки Цикл
		
		Если НЕ ТекСтрока.Флаг Тогда
			Продолжить;
		КонецЕсли;
		
		Если ВремНачальныйИсходящийНомер = Неопределено Тогда 
			ВремНачальныйИсходящийНомер = НачальныйИсходящийНомер;
		Иначе 	
			ВремНачальныйИсходящийНомер = ВремНачальныйИсходящийНомер + 1;
		КонецЕсли;		
		
		ТекСтрока.ИсходящийНомер = ВремНачальныйИсходящийНомер;			
	КонецЦикла;
	
	ПоследнийИсходящийНомер = ВремНачальныйИсходящийНомер;
	
	
КонецПроцедуры

&НаКлиенте
Процедура СРО_КаталоДляСохраненияДокументовРассылкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбора.Каталог = СРО_КаталогДляСохраненияДокументовРассылки;
	ДиалогВыбора.Заголовок = "Выберете каталог для формирования документов";
	ДиалогВыбора.МножественныйВыбор = Ложь;
	
	Если ДиалогВыбора.Выбрать() Тогда
		СРО_КаталогДляСохраненияДокументовРассылки = ДиалогВыбора.Каталог;  
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	Константы.СРО_КаталогДляСохраненияДокументовРассылки.Установить(СРО_КаталогДляСохраненияДокументовРассылки);	
	
	Константы.СРО_ПоследнийИсходящийНомерДокументаДляРассылки.Установить(ПоследнийИсходящийНомер);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ПриЗакрытииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОтметитьПоСпискуКПКНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьПоСпискуКПК(Команда)
	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ТаблицаДляРассылки", ТаблицаДляРассылки);
	
	//ТабличныйДокумент.Показать();
	//ОткрытьФорму("ВнешнийОтчет.ПроверкаОтчетностиСРассылкойПисем.Форма.ФормаОтбораПоСписку", ДопПараметры, ЭтаФорма);   
	
	ОткрытьФорму("Отчет.СРО_ПроверкаОтчетностиСРассылкойПисем.Форма.ФормаОтбораПоСписку", ДопПараметры, ЭтаФорма);   

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Для Каждого ЭлементМассив ИЗ ВыбранноеЗначение Цикл
		
		НайденныеСтроки = ТаблицаДляРассылки.НайтиСтроки(Новый Структура("КПК", ЭлементМассив));
		
		Если НайденныеСтроки.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НайденнаяСтрока = НайденныеСтроки[0];		
		НайденнаяСтрока.Флаг = Истина;
		
	КонецЦикла;
	
	//Вставить содержимое обработчика
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВидимостьРеквизитов()
	
	Элементы.ВторичныйВидФормы.Видимость = БлокТриггеров = 2;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВыводитьВPDF = Истина;
	БлокТриггеров = 1;
	ВторичныйВидФормы = 1;
	
	ОбновитьВидимостьРеквизитов();

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНомерВРеестреСРОНаСервере(КПК)
	
	Возврат СокрЛП(КПК.НомерВРеестреСРО);
	
КонецФункции


&НаСервере
Процедура ДобавитьСтрокуСПустойОшибкой(КПК)   	
	
	ТекТаблицаОшибок = РеквизитФормыВЗначение("ТаблицаОшибок");
	
	Если ТекТаблицаОшибок.Строки.Найти(КПК, "КПК") = Неопределено Тогда
		НоваяСтрока = ТекТаблицаОшибок.Строки.Добавить();
		НоваяСтрока.КПК = КПК;
		НоваяСтрока.НомерВРеестреСРО = СокрЛП(КПК.НомерВРеестреСРО);
		
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ТекТаблицаОшибок, "ТаблицаОшибок");
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДляРассылкиКПКПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТаблицаДляРассылки.ТекущиеДанные;  
	КПК = ТекущиеДанные.КПК;
	ТекущиеДанные.НомерВРеестреСРО = СокрЛП(ПолучитьНомерВРеестреСРОНаСервере(КПК));
	
	// Добавляем при необходимости строку с пустой ошибкой в таблицу ошибок
	ДобавитьСтрокуСПустойОшибкой(КПК);
	
КонецПроцедуры

&НаКлиенте
Процедура БлокТриггеровПриИзменении(Элемент)
	ОбновитьВидимостьРеквизитов();
КонецПроцедуры
