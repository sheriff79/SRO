#Область ПрограммныйИнтерфейс

// Открывает форму указанного отчета. 
//
// Параметры:
//   ФормаВладелец - УправляемаяФорма, Неопределено - форма, из которой открывается отчет.
//   Вариант - СправочникСсылка.ВариантыОтчетов, СправочникСсылка.ДополнительныеОтчетыИОбработки - вариант 
//       отчета, форму которого требуется открыть. Если передан тип СправочникСсылка.ДополнительныеОтчетыИОбработки, 
//       то открывается дополнительный отчет, подключенный к программе. 
//   ДополнительныеПараметры - Структура - служебный параметр, не предназначен для использования.
//
Процедура ОткрытьФормуОтчета(Знач ФормаВладелец, Знач Вариант, Знач ДополнительныеПараметры = Неопределено) Экспорт
	Тип = ТипЗнч(Вариант);
	Если Тип = Тип("Структура") Тогда
		ПараметрыОткрытия = Вариант;
	ИначеЕсли Тип = Тип("СправочникСсылка.ВариантыОтчетов") 
		Или Тип = ВариантыОтчетовКлиентСервер.ТипСсылкиДополнительногоОтчета() Тогда
		ПараметрыОткрытия = Новый Структура("Ключ", Вариант);
		Если ДополнительныеПараметры <> Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ПараметрыОткрытия, ДополнительныеПараметры, Истина);
		КонецЕсли;
		ОткрытьФорму("Справочник.ВариантыОтчетов.ФормаОбъекта", ПараметрыОткрытия, Неопределено, Истина);
		Возврат;
	Иначе
		ПараметрыОткрытия = Новый Структура("Ссылка, Отчет, ТипОтчета, ИмяОтчета, КлючВарианта, КлючЗамеров");
		Если ТипЗнч(ФормаВладелец) = Тип("УправляемаяФорма") Тогда
			ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, ФормаВладелец);
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ПараметрыОткрытия, Вариант);
	КонецЕсли;
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(ПараметрыОткрытия, ДополнительныеПараметры, Истина);
	КонецЕсли;
	
	ВариантыОтчетовКлиентСервер.ДополнитьСтруктуруКлючом(ПараметрыОткрытия, "ВыполнятьЗамеры", Ложь);
	
	ПараметрыОткрытия.ТипОтчета = ВариантыОтчетовКлиентСервер.ТипОтчетаСтрокой(ПараметрыОткрытия.ТипОтчета, ПараметрыОткрытия.Отчет);
	Если Не ЗначениеЗаполнено(ПараметрыОткрытия.ТипОтчета) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не определен тип отчета в %1'"), "ВариантыОтчетовКлиент.ОткрытьФормуОтчета");
	КонецЕсли;
	
	Если ПараметрыОткрытия.ТипОтчета = "Внутренний" Или ПараметрыОткрытия.ТипОтчета = "Расширение" Тогда
		Вид = "Отчет";
		КлючЗамеров = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыОткрытия, "КлючЗамеров");
		Если ЗначениеЗаполнено(КлючЗамеров) Тогда
			ПараметрыКлиента = ПараметрыКлиента();
			Если ПараметрыКлиента.ВыполнятьЗамеры Тогда
				ПараметрыОткрытия.ВыполнятьЗамеры = Истина;
				ПараметрыОткрытия.Вставить("ИмяОперации", КлючЗамеров + ".Открытие");
				ПараметрыОткрытия.Вставить("КомментарийОперации", ПараметрыКлиента.ПрефиксЗамеров);
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ПараметрыОткрытия.ТипОтчета = "Дополнительный" Тогда
		Вид = "ВнешнийОтчет";
		Если Не ПараметрыОткрытия.Свойство("Подключен") Тогда
			ВариантыОтчетовВызовСервера.ПриПодключенииОтчета(ПараметрыОткрытия);
		КонецЕсли;
		Если Не ПараметрыОткрытия.Подключен Тогда
			Возврат;
		КонецЕсли;
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Вариант внешнего отчета можно открыть только из формы отчета.'"));
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПараметрыОткрытия.ИмяОтчета) Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не определено имя отчета в %1'"), "ВариантыОтчетовКлиент.ОткрытьФормуОтчета");
	КонецЕсли;
	
	ПолноеИмяОтчета = Вид + "." + ПараметрыОткрытия.ИмяОтчета;
	
	КлючУникальности = ОтчетыКлиентСервер.КлючУникальности(ПолноеИмяОтчета, ПараметрыОткрытия.КлючВарианта);
	ПараметрыОткрытия.Вставить("КлючПараметровПечати",        КлючУникальности);
	ПараметрыОткрытия.Вставить("КлючСохраненияПоложенияОкна", КлючУникальности);
	
	Если ПараметрыОткрытия.ВыполнятьЗамеры Тогда
		ВариантыОтчетовКлиентСервер.ДополнитьСтруктуруКлючом(ПараметрыОткрытия, "КомментарийОперации");
		МодульОценкаПроизводительностиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиент");
		ИдентификаторЗамера = МодульОценкаПроизводительностиКлиент.НачатьЗамерВремени(
			Ложь,
			ПараметрыОткрытия.ИмяОперации);
		МодульОценкаПроизводительностиКлиент.УстановитьКомментарийЗамера(ИдентификаторЗамера, ПараметрыОткрытия.КомментарийОперации);
	КонецЕсли;
	
	ОткрытьФорму(ПолноеИмяОтчета + ".Форма", ПараметрыОткрытия, Неопределено, Истина);
	
	Если ПараметрыОткрытия.ВыполнятьЗамеры Тогда
		МодульОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(ИдентификаторЗамера);
	КонецЕсли;
КонецПроцедуры

// Открывает панель отчетов. Для использования из модулей общих команд.
//
// Параметры:
//   ПутьКПодсистеме - Строка - Имя раздела или путь к подсистеме, для которой открывается панель отчетов.
//       Задается в формате: "ИмяРаздела[.ИмяВложеннойПодсистемы1][.ИмяВложеннойПодсистемы2][...]".
//       Раздел должен быть описан в ВариантыОтчетовПереопределяемый.ОпределитьРазделыСВариантамиОтчетов.
//   ПараметрыВыполненияКоманды - ПараметрыВыполненияКоманды - параметры обработчика общей команды.
//
Процедура ПоказатьПанельОтчетов(ПутьКПодсистеме, ПараметрыВыполненияКоманды) Экспорт
	ФормаПараметры = Новый Структура("ПутьКПодсистеме", ПутьКПодсистеме);
	
	ФормаОкно = ?(ПараметрыВыполненияКоманды = Неопределено, Неопределено, ПараметрыВыполненияКоманды.Окно);
	ФормаСсылка = ?(ПараметрыВыполненияКоманды = Неопределено, Неопределено, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
	ПараметрыКлиента = ПараметрыКлиента();
	//+ВА
	Если ПараметрыКлиента.ВыполнятьЗамеры Тогда
		МодульОценкаПроизводительностиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиент");
		ИдентификаторЗамера = МодульОценкаПроизводительностиКлиент.НачатьЗамерВремени(
			Ложь,
			"ПанельОтчетов.Открытие");
		МодульОценкаПроизводительностиКлиент.УстановитьКомментарийЗамера(ИдентификаторЗамера, ПараметрыКлиента.ПрефиксЗамеров + "; " + ПутьКПодсистеме);
	КонецЕсли;
	//-ВА
	
	ОткрытьФорму("ОбщаяФорма.ПанельОтчетов", ФормаПараметры, , ПутьКПодсистеме, ФормаОкно, ФормаСсылка);
	
	Если ПараметрыКлиента.ВыполнятьЗамеры Тогда
		МодульОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(ИдентификаторЗамера);
	КонецЕсли;
КонецПроцедуры

// Открывает диалог настройки размещения нескольких вариантов в разделах.
//
// Параметры:
//   Варианты - Массив - перемещаемые варианты отчетов (СправочникСсылка.ВариантыОтчетов).
//   Владелец - УправляемаяФорма - для блокирования окна владельца.
//
Процедура ОткрытьДиалогРазмещенияВариантовВРазделах(Варианты, Владелец = Неопределено) Экспорт
	
	Если ТипЗнч(Варианты) <> Тип("Массив") Или Варианты.Количество() < 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите варианты отчетов, которые необходимо разместить в разделах.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура("Варианты", Варианты);
	ОткрытьФорму("Справочник.ВариантыОтчетов.Форма.РазмещениеВРазделах", ПараметрыОткрытия, Владелец);
	
КонецПроцедуры

// Открывает диалог диалог сброса пользовательских настроек выбранных вариантов отчетов.
//
// Параметры:
//   Варианты - Массив - обрабатываемые варианты отчетов (СправочникСсылка.ВариантыОтчетов).
//   Владелец - УправляемаяФорма - для блокирования окна владельца.
//
Процедура ОткрытьДиалогСбросаНастроекПользователей(Варианты, Владелец = Неопределено) Экспорт
	
	Если ТипЗнч(Варианты) <> Тип("Массив") Или Варианты.Количество() < 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите варианты отчетов, для которых необходимо сбросить пользовательские настройки.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Варианты", Варианты);
	ОткрытьФорму("Справочник.ВариантыОтчетов.Форма.СбросПользовательскихНастроек", ПараметрыОткрытия, Владелец);
	
КонецПроцедуры

// Открывает диалог диалог сброса настроек размещения выбранных вариантов отчетов программы.
//
// Параметры:
//   Варианты - Массив - обрабатываемые варианты отчетов (СправочникСсылка.ВариантыОтчетов).
//   Владелец - УправляемаяФорма - для блокирования окна владельца.
//
Процедура ОткрытьДиалогСбросаНастроекРазмещения(Варианты, Владелец = Неопределено) Экспорт
	
	Если ТипЗнч(Варианты) <> Тип("Массив") ИЛИ Варианты.Количество() < 1 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Выберите варианты отчетов программы, для которых необходимо сбросить настройки размещения.'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Варианты", Варианты);
	ОткрытьФорму("Справочник.ВариантыОтчетов.Форма.СбросНастроекРазмещения", ПараметрыОткрытия, Владелец);
	
КонецПроцедуры

// Оповещает открытые панели отчетов, формы списков и элементов о изменениях.
//
// Параметры:
//   Параметр - Произвольный - могут быть переданы любые необходимые данные.
//   Источник - Произвольный - источник события. Например, можно передать другую форму.
//
Процедура ОбновитьОткрытыеФормы(Параметр = Неопределено, Источник = Неопределено) Экспорт
	
	Оповестить(ВариантыОтчетовКлиентСервер.ИмяСобытияИзменениеВарианта(), Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Открывает карточку варианта отчета с настройками размещения в программе.
//
// Параметры:
//   Вариант - СправочникСсылка.ВариантыОтчетов - Ссылка варианта отчета.
//
Процедура ПоказатьНастройкиОтчета(Вариант) Экспорт
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказатьКарточку", Истина);
	ПараметрыФормы.Вставить("Ключ", Вариант);
	ОткрытьФорму("Справочник.ВариантыОтчетов.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура обслуживает событие реквизита ДеревоПодсистем в формах редактирования.
Процедура ДеревоПодсистемИспользованиеПриИзменении(Форма, Элемент) Экспорт
	СтрокаДерева = Форма.Элементы.ДеревоПодсистем.ТекущиеДанные;
	Если СтрокаДерева = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Пропуск корневой строки
	Если СтрокаДерева.Приоритет = "" Тогда
		СтрокаДерева.Использование = 0;
		Возврат;
	КонецЕсли;
	
	Если СтрокаДерева.Использование = 2 Тогда
		СтрокаДерева.Использование = 0;
	КонецЕсли;
	
	СтрокаДерева.Модифицированность = Истина;
КонецПроцедуры

// Процедура обслуживает событие реквизита ДеревоПодсистем в формах редактирования.
Процедура ДеревоПодсистемВажностьПриИзменении(Форма, Элемент) Экспорт
	СтрокаДерева = Форма.Элементы.ДеревоПодсистем.ТекущиеДанные;
	Если СтрокаДерева = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	// Пропуск корневой строки
	Если СтрокаДерева.Приоритет = "" Тогда
		СтрокаДерева.Важность = "";
		Возврат;
	КонецЕсли;
	
	Если СтрокаДерева.Важность <> "" Тогда
		СтрокаДерева.Использование = 1;
	КонецЕсли;
	
	СтрокаДерева.Модифицированность = Истина;
КонецПроцедуры

// Аналог ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста, работающий за 1 вызов.
//   В отличие от ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария позволяет устанавливать свой заголовок
//   и работает с реквизитами таблиц.
//
Процедура РедактироватьМногострочныйТекст(ФормаИлиОбработчик, ТекстРедактирования, ВладелецРеквизита, ИмяРеквизита, Знач Заголовок = "") Экспорт
	
	Если ПустаяСтрока(Заголовок) Тогда
		Заголовок = НСтр("ru = 'Комментарий'");
	КонецЕсли;
	
	ПараметрыИсточника = Новый Структура;
	ПараметрыИсточника.Вставить("ФормаИлиОбработчик", ФормаИлиОбработчик);
	ПараметрыИсточника.Вставить("ВладелецРеквизита",  ВладелецРеквизита);
	ПараметрыИсточника.Вставить("ИмяРеквизита",       ИмяРеквизита);
	Обработчик = Новый ОписаниеОповещения("РедактироватьМногострочныйТекстЗавершение", ЭтотОбъект, ПараметрыИсточника);
	
	ПоказатьВводСтроки(Обработчик, ТекстРедактирования, Заголовок, , Истина);
	
КонецПроцедуры

// Обработчик результата работы процедуры РедактироватьМногострочныйТекст.
Процедура РедактироватьМногострочныйТекстЗавершение(Текст, ПараметрыИсточника) Экспорт
	
	Если ТипЗнч(ПараметрыИсточника.ФормаИлиОбработчик) = Тип("УправляемаяФорма") Тогда
		Форма      = ПараметрыИсточника.ФормаИлиОбработчик;
		Обработчик = Неопределено;
	Иначе
		Форма      = Неопределено;
		Обработчик = ПараметрыИсточника.ФормаИлиОбработчик;
	КонецЕсли;
	
	Если Текст <> Неопределено Тогда
		
		Если ТипЗнч(ПараметрыИсточника.ВладелецРеквизита) = Тип("ДанныеФормыЭлементДерева")
			Или ТипЗнч(ПараметрыИсточника.ВладелецРеквизита) = Тип("ДанныеФормыЭлементКоллекции") Тогда
			ЗаполнитьЗначенияСвойств(ПараметрыИсточника.ВладелецРеквизита, Новый Структура(ПараметрыИсточника.ИмяРеквизита, Текст));
		Иначе
			ПараметрыИсточника.ВладелецРеквизита[ПараметрыИсточника.ИмяРеквизита] = Текст;
		КонецЕсли;
		
		Если Форма <> Неопределено Тогда
			Если Не Форма.Модифицированность Тогда
				Форма.Модифицированность = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Обработчик <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Обработчик, Текст);
	КонецЕсли;
	
КонецПроцедуры

Функция ПараметрыКлиента()
	Возврат ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(
		СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске(),
		"ВариантыОтчетов");
КонецФункции

#КонецОбласти
