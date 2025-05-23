#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма, Неопределено - Форма отчета или форма настроек отчета.
//       Неопределено когда вызов без контекста.
//   КлючВарианта - Строка, Неопределено - Имя предопределенного
//       или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов без контекста.
//   Настройки - Структура -
//       
//       * ФормироватьСразу - Булево - Значение по умолчанию для флажка "Формировать сразу".
//           Когда флажок включен, то отчет будет формироваться:
//             - После открытия;
//             - После выбора пользовательских настроек;
//             - После выбора другого варианта отчета.
//       
//       * ВыводитьСуммуВыделенныхЯчеек - Булево - Если Истина, то в отчете будет выводиться поле автосуммы.
//       
//       * СоответствиеПериодичностиПараметров - Соответствие - Ограничение списка выбора полей "СтандартныйПериод".
//           ** Ключ - ПараметрКомпоновкиДанных - Имя параметра отчета, к которому применятся ограничения.
//           ** Значение - ПеречислениеСсылка.ДоступныеПериодыОтчета - Ограничение периода отчета "снизу".
//       
//       * Печать - Структура - Параметры печати табличного документа "по умолчанию".
//           ** ПолеСверху - Число - Отступ сверху при печати (в миллиметрах).
//           ** ПолеСлева  - Число - Отступ слева  при печати (в миллиметрах).
//           ** ПолеСнизу  - Число - Отступ снизу  при печати (в миллиметрах).
//           ** ПолеСправа - Число - Отступ справа при печати (в миллиметрах).
//           ** ОриентацияСтраницы - ОриентацияСтраницы - "Портрет" или "Ландшафт".
//           ** АвтоМасштаб - Булево - Автоматически подгонять масштаб под размер страницы.
//           ** МасштабПечати - Число - Масштаб изображения (в процентах).
//       
//       * События - Структура - События, для которых определены обработчики в модуле объекта отчета.
//           
//           ** ПриСозданииНаСервере - Булево - Если Истина, то в модуле объекта отчета
//               следует определить обработчик события по шаблону:
//               
//               // Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//               //
//               // Параметры:
//               //   Форма - УправляемаяФорма - Форма отчета.
//               //   Отказ - Передается из параметров обработчика "как есть".
//               //   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//               //
//               // См. также:
//               //   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//               //
//               // Пример 1 - Добавление команды с обработчиком в ОтчетыКлиентПереопределяемый.ОбработчикКоманды:
//               //	Команда = Форма.Команды.Добавить("МояОсобеннаяКоманда");
//               //	Команда.Действие  = "Подключаемый_Команда";
//               //	Команда.Заголовок = НСтр("ru = 'Моя команда...'");
//               //	
//               //	Кнопка = Форма.Элементы.Добавить(Команда.Имя, Тип("КнопкаФормы"), Форма.Элементы.<ИмяПодменю>);
//               //	Кнопка.ИмяКоманды = Команда.Имя;
//               //	
//               //	Форма.ПостоянныеКоманды.Добавить(КомандаСоздать.Имя);
//               //
//               Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
//               	// Обработка события.
//               КонецПроцедуры
//           
//           ** ПередЗагрузкойВариантаНаСервере - Булево - Если Истина, то в модуле объекта отчета
//               следует определить обработчик события по шаблону:
//               
//               // Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//               //
//               // Параметры:
//               //   Форма - УправляемаяФорма - Форма отчета.
//               //   НовыеНастройкиКД - НастройкиКомпоновкиДанных - Настройки для загрузки в компоновщик настроек.
//               //
//               // См. также:
//               //   "Расширение управляемой формы для отчета.ПриЗагрузкеВариантаНаСервере" в синтакс-помощнике.
//               //
//               Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
//               	// Обработка события.
//               КонецПроцедуры
//           
//           ** ПриЗагрузкеВариантаНаСервере - Булево - Если Истина, то в модуле объекта отчета
//               следует определить обработчик события по шаблону:
//               
//               // Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//               //
//               // Параметры:
//               //   Форма - УправляемаяФорма - Форма отчета.
//               //   НовыеНастройкиКД - НастройкиКомпоновкиДанных - Настройки для загрузки в компоновщик настроек.
//               //
//               // См. также:
//               //   "Расширение управляемой формы для отчета.ПриЗагрузкеВариантаНаСервере" в синтакс-помощнике.
//               //
//               Процедура ПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
//               	// Обработка события.
//               КонецПроцедуры
//           
//           ** ПриЗагрузкеПользовательскихНастроекНаСервере - Булево - Если Истина, то в модуле объекта отчета
//               следует определить обработчик события по шаблону:
//               
//               // Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//               //
//               // Параметры:
//               //   Форма - УправляемаяФорма - Форма отчета.
//               //   НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных -
//               //       Пользовательские настройки для загрузки в компоновщик настроек.
//               //
//               // См. также:
//               //   "Расширение управляемой формы для отчета.ПриЗагрузкеПользовательскихНастроекНаСервере"
//               //    в синтакс-помощнике.
//               //
//               Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт
//               	// Обработка события.
//               КонецПроцедуры
//           
//           ** ПередЗаполнениемПанелиБыстрыхНастроек - Булево - Если Истина, то в модуле объекта отчета
//               следует определить обработчик события по шаблону:
//               
//               // Вызывается до перезаполнения панели настроек формы отчета.
//               //
//               // Параметры:
//               //   Форма - УправляемаяФорма - Форма отчета.
//               //   ПараметрыЗаполнения - Структура - Параметры, которые будут загружены в отчет.
//               //
//               Процедура ПередЗаполнениемПанелиБыстрыхНастроек(Форма, ПараметрыЗаполнения) Экспорт
//               	// Обработка события.
//               КонецПроцедуры
//           
//           ** ПослеЗаполненияПанелиБыстрыхНастроек - Булево - Если Истина, то в модуле объекта отчета
//               следует определить обработчик события по шаблону:
//               
//               // Вызывается после перезаполнения панели настроек формы отчета.
//               //
//               // Параметры:
//               //   Форма - УправляемаяФорма - Форма отчета.
//               //   ПараметрыЗаполнения - Структура - Параметры, которые будут загружены в отчет.
//               //
//               Процедура ПослеЗаполненияПанелиБыстрыхНастроек(Форма, ПараметрыЗаполнения) Экспорт
//               	// Обработка события.
//               КонецПроцедуры
//           
//           ** КонтекстныйВызовСервера - Булево - Если Истина, то в модуле объекта отчета
//               следует определить обработчик события по шаблону:
//               
//               // Обработчик контекстного вызова сервера.
//               //   Позволяет выполнить контекстный вызов сервера когда это требуется из клиентского общего модуля.
//               //   Например, из ОтчетыКлиентПереопределяемый.ОбработчикКоманды().
//               //
//               // Параметры:
//               //   Форма  - УправляемаяФорма
//               //   Ключ      - Строка    - Ключ операции, которую необходимо выполнить в контекстном вызове.
//               //   Параметры - Структура - Параметры вызова сервера.
//               //   Результат - Структура - Результат работы сервера, возвращается на клиент.
//               //
//               // См. также:
//               //   ОбщаяФорма.ФормаОтчета.ВыполнитьКонтекстныйВызовСервера().
//               //
//               Процедура КонтекстныйВызовСервера(Форма, Ключ, Параметры, Результат) Экспорт
//               	// Обработка события.
//               КонецПроцедуры
//           
//           ** ПриОпределенииПараметровВыбора - Булево - Если Истина, то в модуле объекта отчета
//               следует определить обработчик события по шаблону:
//               
//               // Вызывается в форме отчета перед выводом настройки.
//               //   Подробнее - см. ОтчетыПереопределяемый.ПриОпределенииПараметровВыбора().
//               //
//               Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
//               	// Обработка события.
//               КонецПроцедуры
//           
//           ** ДополнитьСвязиОбъектовМетаданных - Булево - Если Истина, то в модуле объекта отчета
//               следует определить обработчик события по шаблону:
//               
//               // Дополнительные связи настроек этого отчета.
//               //   Подробнее - см. ОтчетыПереопределяемый.ДополнитьСвязиОбъектовМетаданных().
//               //
//               Процедура ДополнитьСвязиОбъектовМетаданных(СвязиОбъектовМетаданных) Экспорт
//               	// Обработка события.
//               КонецПроцедуры
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПередЗагрузкойВариантаНаСервере       = Истина;
	Настройки.События.ПриОпределенииПараметровВыбора        = Истина;
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик    = Истина;
	
КонецПроцедуры

// См. ОтчетыПереопределяемый.ПриОпределенииПараметровВыбора.
Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
	
	Если СвойстваНастройки.Тип = "ЗначениеПараметраНастроек" Тогда
		ИмяПараметра = Строка(СвойстваНастройки.ПолеКД);
		Если ИмяПараметра = "ПараметрыДанных.ТипОбъектаМетаданных" Тогда
			СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
			СвойстваНастройки.ЗначенияДляВыбора = Отчеты.УниверсальныйОтчет.ДоступныеТипыОбъектовМетаданных();
		ИначеЕсли ИмяПараметра = "ПараметрыДанных.ПолноеИмяОбъектаМетаданных" Тогда
			СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
			СвойстваНастройки.ЗначенияДляВыбора = Отчеты.УниверсальныйОтчет.ДоступныеОбъектыМетаданных(КомпоновщикНастроек.Настройки);
		ИначеЕсли ИмяПараметра = "ПараметрыДанных.ИмяТаблицы" Тогда
			СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
			СвойстваНастройки.ЗначенияДляВыбора = Отчеты.УниверсальныйОтчет.ДоступныеТаблицы(КомпоновщикНастроек.Настройки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
// См. "Расширение управляемой формы для отчета.ПередЗагрузкойВариантаНаСервере" в синтакс-помощнике.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных - Настройки для загрузки в компоновщик настроек.
//
Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	// Для платформы
	НовыйКлючСхемы = Неопределено;
	НоваяСхема = Неопределено;
	
	ЭтоЗагруженнаяСхема = Ложь;
	
	Если ТипЗнч(НовыеНастройкиКД) = Тип("НастройкиКомпоновкиДанных") Или НовыеНастройкиКД = Неопределено Тогда
		Если НовыеНастройкиКД = Неопределено Тогда
			ДопСвойстваНастроек = ЭтотОбъект.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
		Иначе
			ДопСвойстваНастроек = НовыеНастройкиКД.ДополнительныеСвойства;
		КонецЕсли;
		ЗагруженнаяСхема = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДопСвойстваНастроек, "СхемаКомпоновкиДанных");
		Если ТипЗнч(ЗагруженнаяСхема) = Тип("ДвоичныеДанные") Тогда
			ЭтоЗагруженнаяСхема = Истина;
			НовыйКлючСхемы = ХешДвоичныхДанных(ЗагруженнаяСхема);
			НоваяСхема = Отчеты.УниверсальныйОтчет.ИзвлечьСхемуИзДвоичныхДанных(ЗагруженнаяСхема);
		КонецЕсли;
	КонецЕсли;
	
	Если ЭтоЗагруженнаяСхема Тогда
		КлючСхемы = НовыйКлючСхемы;
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Форма, НоваяСхема, КлючСхемы);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения схемы компоновки.
//   Например, если схема отчета зависит от ключа варианта или параметров отчета.
//   Чтобы изменения схемы вступили в силу следует вызывать метод ОтчетыСервер.ПодключитьСхему().
//
// Параметры:
//   Контекст - Произвольный - 
//       Параметры контекста, в котором используется отчет.
//       Используется для передачи в параметрах метода ОтчетыСервер.ПодключитьСхему().
//   КлючСхемы - Строка -
//       Идентификатор текущей схемы компоновщика настроек.
//       По умолчанию не заполнен (это означает что компоновщик инициализирован на основании основной схемы).
//       Используется для оптимизации, чтобы переинициализировать компоновщик как можно реже).
//       Может не использоваться если переинициализация выполняется безусловно.
//   КлючВарианта - Строка, Неопределено -
//       Имя предопределенного или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов для варианта расшифровки или без контекста.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных, Неопределено -
//       Настройки варианта отчета, которые будут загружены в компоновщик настроек после его инициализации.
//       Неопределено когда настройки варианта не надо загружать (уже загружены ранее).
//   НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных, Неопределено -
//       Пользовательские настройки, которые будут загружены в компоновщик настроек после его инициализации.
//       Неопределено когда пользовательские настройки не надо загружать (уже загружены ранее).
//
// Пример:
//  // Компоновщик отчета инициализируется на основании схемы из общих макетов:
//	Если КлючСхемы <> "1" Тогда
//		КлючСхемы = "1";
//		СхемаКД = ПолучитьОбщийМакет("МояОбщаяСхемаКомпоновки");
//		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКД, КлючСхемы);
//	КонецЕсли;
//
//  // Схема зависит от значения параметра, выведенного в пользовательские настройки отчета:
//	Если ТипЗнч(НовыеПользовательскиеНастройкиКД) = Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
//		ПолноеИмяОбъектаМетаданных = "";
//		Для Каждого ЭлементКД Из НовыеПользовательскиеНастройкиКД.Элементы Цикл
//			Если ТипЗнч(ЭлементКД) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
//				ИмяПараметра = Строка(ЭлементКД.Параметр);
//				Если ИмяПараметра = "ОбъектМетаданных" Тогда
//					ПолноеИмяОбъектаМетаданных = ЭлементКД.Значение;
//				КонецЕсли;
//			КонецЕсли;
//		КонецЦикла;
//		Если КлючСхемы <> ПолноеИмяОбъектаМетаданных Тогда
//			КлючСхемы = ПолноеИмяОбъектаМетаданных;
//			СхемаКД = Новый СхемаКомпоновкиДанных;
//			// Наполнение схемы...
//			ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКД, КлючСхемы);
//		КонецЕсли;
//	КонецЕсли;
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	НовыйКлючСхемы = Неопределено;
	НоваяСхема = Неопределено;
	
	ЭтоЗагруженнаяСхема = Ложь;
	
	Если ТипЗнч(НовыеНастройкиКД) = Тип("НастройкиКомпоновкиДанных") Или НовыеНастройкиКД = Неопределено Тогда
		Если НовыеНастройкиКД = Неопределено Тогда
			КлючВарианта = "Основной";
			НовыеНастройкиКД = ЭтотОбъект.КомпоновщикНастроек.Настройки;
			ДопСвойстваНастроек = ЭтотОбъект.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
		Иначе
			ДопСвойстваНастроек = НовыеНастройкиКД.ДополнительныеСвойства;
		КонецЕсли;
		ЗагруженнаяСхема = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДопСвойстваНастроек, "СхемаКомпоновкиДанных");
		Если ТипЗнч(ЗагруженнаяСхема) = Тип("ДвоичныеДанные") Тогда
			ЭтоЗагруженнаяСхема = Истина;
			НовыйКлючСхемы = ХешДвоичныхДанных(ЗагруженнаяСхема);
			Если НовыйКлючСхемы <> КлючСхемы Тогда
				НоваяСхема = Отчеты.УниверсальныйОтчет.ИзвлечьСхемуИзДвоичныхДанных(ЗагруженнаяСхема);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если НовыйКлючСхемы = Неопределено Тогда// Не загруженная схема.
		
		Если ТипЗнч(НовыеНастройкиКД) = Тип("НастройкиКомпоновкиДанных") Тогда
			НастройкиКД = НовыеНастройкиКД;
		Иначе
			НастройкиКД = КомпоновщикНастроек.Настройки;
		КонецЕсли;
		
		ПараметрыОтчета = Отчеты.УниверсальныйОтчет.ПараметрыОтчета(НастройкиКД, НовыеПользовательскиеНастройкиКД);
		
		НовыйКлючСхемы = ПараметрыОтчета.ТипОбъектаМетаданных
			+ "/" + ПараметрыОтчета.ПолноеИмяОбъектаМетаданных
			+ "/" + ПараметрыОтчета.ИмяТаблицы;
		НовыйКлючСхемы = ОбщегоНазначения.СократитьСтрокуКонтрольнойСуммой(НовыйКлючСхемы, 100);
		
		Если НовыйКлючСхемы <> КлючСхемы Или ПараметрыОтчета.ОчиститьСтруктуру Тогда
			КлючСхемы = "";
			НоваяСхема = Отчеты.УниверсальныйОтчет.ПолучитьТиповуюСхему(ПараметрыОтчета, НастройкиКД, НовыеПользовательскиеНастройкиКД);
		КонецЕсли;
		
	КонецЕсли;
	
	Если НовыйКлючСхемы <> Неопределено И КлючСхемы <> НовыйКлючСхемы Тогда
		КлючСхемы = НовыйКлючСхемы;
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, НоваяСхема, КлючСхемы);
		Если ЭтоЗагруженнаяСхема Тогда
			Отчеты.УниверсальныйОтчет.НастройкиКДПоУмолчаниюЗагруженнойСхемы(ЭтотОбъект, ЗагруженнаяСхема, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
		Иначе
			Отчеты.УниверсальныйОтчет.НастройкиКДПоУмолчаниюТиповойСхемы(ЭтотОбъект, ПараметрыОтчета, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
		КонецЕсли;
		
		Если ТипЗнч(Контекст) = Тип("УправляемаяФорма") Тогда
			// Вызов переопределяемого модуля.
			ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере(Контекст, НовыеНастройкиКД);
			ПередЗагрузкойВариантаНаСервере(Контекст, НовыеНастройкиКД);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает хеш-сумму двоичных данных.
//
// Параметры:
//   ДвоичныеДанные - ДвоичныеДанные - Данные, от которых считается хеш-сумма.
//
Функция ХешДвоичныхДанных(ДвоичныеДанные)
	ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешированиеДанных.Добавить(ДвоичныеДанные);
	Возврат СтрЗаменить(ХешированиеДанных.ХешСумма, " ", "") + "_" + Формат(ДвоичныеДанные.Размер(), "ЧГ=");
КонецФункции

#КонецОбласти

#КонецЕсли
