///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура ПросклонятьПредставлениеПоВсемПадежам(Представление, Склонения, ЭтоФИО = Ложь, Пол = Неопределено, ПоказыватьСообщения = Ложь) Экспорт
	
	СтруктураСклонений = СклонениеПредставленийОбъектов.ПросклонятьПредставлениеПоВсемПадежам(Представление, ЭтоФИО, Пол, ПоказыватьСообщения);		
	Склонения = Новый ФиксированнаяСтруктура(СтруктураСклонений);

КонецПроцедуры

Функция ЕстьПравоДоступаКОбъекту(Ссылка) Экспорт
	
	Возврат СклонениеПредставленийОбъектов.ЕстьПравоДоступаКОбъекту(Ссылка);
	
КонецФункции
	
#КонецОбласти