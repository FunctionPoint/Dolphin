﻿"Filed out from Dolphin Smalltalk 7"!

Locale subclass: #WindowsLocale
	instanceVariableNames: 'lcid info'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WindowsLocale guid: (GUID fromString: '{72672414-3e98-4af9-a1af-684456e4529d}')!
WindowsLocale comment: ''!
!WindowsLocale categoriesForClass!Unclassified! !
!WindowsLocale methodsFor!

amDesignator
	"Answer the <String> used in the receiver locale to designate AM (morning)."

	^self getStringInfo: LOCALE_SAM!

asParameter
	"Answer the receiver in a form suitable for passing to an external
	function call (the Win32 representation of a Locale, is the LCID)."

	^lcid!

buildDayNamesMap
	| map |
	map := LookupTable new: 14.
	1 to: 7
		do: 
			[:i |
			| longName shortName |
			longName := self dayOfWeekName: i.
			shortName := self dayOfWeekAbbreviation: i.
			map
				at: longName asLowercase put: i;
				at: shortName asLowercase put: i].
	^map!

buildMonthNamesMap
	| map |
	map := LookupTable new: 24.
	1 to: 12
		do: 
			[:i |
			| longName shortName |
			longName := self monthName: i.
			shortName := self monthAbbreviation: i.
			map
				at: longName asLowercase put: i;
				at: shortName asLowercase put: i].
	^map!

calendarId
	^self getIntegerInfo: LOCALE_ICALENDARTYPE!

code
	"Answer the RFC4646 locale code (aka tag) for this locale."

	^self getStringInfo: LOCALE_SNAME!

currency
	"Answer the currency symbol <String> used in the receiver locale, e.g. '£' in 2057/en-GB."

	^self getStringInfo: LOCALE_SCURRENCY!

dayOfWeek: aString
	"Answer the 1-based <integer> index in a week, of the day named by the <String> argument, aString.
	Note that Monday is always 1, and Sunday always 7 (but see #firstDayOfWeek)"

	^(info at: #dayNamesMap ifAbsentPut: [self buildDayNamesMap]) at: aString asLowercase!

dayOfWeekAbbreviation: anInteger
	"Answer a <String> that is the localised abbreviated name for the day of the week whose index is the <integer> argument, where Sunday is 1 and Saturday is 7."

	^self getStringInfo: LOCALE_SABBREVDAYNAME1 + ((anInteger + 5) \\ 7)!

dayOfWeekName: anInteger
	"Answer a <String> that is the localised short name of the day whose index is the <integer> argument, where Sunday is 1 and Saturday is 7."

	^self getStringInfo: LOCALE_SDAYNAME1 + ((anInteger + 5) \\ 7)
!

dayOfWeekShortAbbreviation: anInteger
	"Answer a <String> that is the localised shortest abbreviated name for the day of the week whose index is the <integer> argument, where Sunday is 1 and Saturday is 7."

	^self getStringInfo: LOCALE_SSHORTESTDAYNAME1 + ((anInteger + 5) \\ 7)!

decimalPlaces
	"Answer the decimal <integer> number of decimal places to used in the receiver locale in the representation of numbers with a fractional part."

	^self getIntegerInfo: LOCALE_IDIGITS!

decimalSeparator
	"Answer the decimal separator <String> used in the receiver locale in the representation of numbers with a fractional part."

	^self getStringInfo: LOCALE_SDECIMAL!

displayName
	"The name of the locale in its native language."

	^self getStringInfo: LOCALE_SNATIVEDISPLAYNAME!

displayOn: aStream
	"Append a displayable representation of the receiver to aStream."

	aStream nextPutAll: self name!

durationFormat
	"Answer the format <String> used in this Locale (by default) for displaying a <Duration>.
	See Locale>>#durationFormat for details of the available formats characters."

	^'-', (self getStringInfo: LOCALE_SDURATION)!

englishDisplayName
	"The <String> name of the locale in English."

	^self getStringInfo: LOCALE_SENGLISHDISPLAYNAME!

firstDayOfWeek
	"Answer an <Integer> in the range 1..7 identifying the first day of the week, where 1 is Monday and 7 is Sunday."

	^(self getIntegerInfo: LOCALE_IFIRSTDAYOFWEEK) + 1!

getCalendarInfoInteger: anInteger
	"Private - Get the specified <integer> calendar information from Windows."

	| buf lib size |
	lib := self nlsLib.
	buf := DWORDBytes new.
	size := lib
		getCalendarInfo: lcid
		calendar: self calendarId
		calType: (anInteger bitOr: CAL_RETURN_NUMBER)
		lpCalData: nil
		cchData: 0
		lpValue: buf.
	size == 2 ifFalse: [^lib systemError].
	^buf value!

getCalendarInfoString: anIntegerLcType
	"Private - Get the specified <Utf8String> calendar information from Windows."

	| buf lib size |
	lib := self nlsLib.
	size := lib getCalendarInfo: lcid calendar: self calendarId calType: anIntegerLcType lpCalData: nil cchData: 0 lpValue: nil.
	size == 0 ifTrue: [^lib systemError].
	"Strings allocate extra space for null automatically"
	buf := Utf16String newFixed: size - 1.
	lib getCalendarInfo: lcid calendar: self calendarId calType: anIntegerLcType lpCalData: buf cchData: size lpValue: nil.
	^buf asUtf8String!

getDateFormats: aBoolean
	"Private - Answer a collection of the date formats for the specified locale, with short
	or long formats according to the argument, aBoolean."

	| enum formats |
	formats := Array writeStream: 4.
	enum := ExternalCallback block: 
					[:format |
					formats nextPut: format.
					true]
				descriptor: (ExternalDescriptor returnType: 'bool' argumentTypes: 'lpwstr').
	(self nlsLib
		enumDateFormats: enum asParameter
		locale: self asParameter
		dwFlags: (aBoolean ifTrue: [DATE_LONGDATE] ifFalse: [DATE_SHORTDATE]))
			ifFalse: [self nlsLib systemError].
	enum free.
	^formats contents!

getIntegerInfo: anIntegerLcType
	"Private - Get the specified <integer> locale information from Windows, caching for subsequent use."

	^info at: anIntegerLcType ifAbsentPut: [self getLocaleInfoInteger: anIntegerLcType]!

getLocaleInfoInteger: anIntegerLcType
	| buf |
	buf := DWORDBytes new.
	(self nlsLib
		getLocaleInfo: lcid
		lCType: (anIntegerLcType bitOr: LOCALE_RETURN_NUMBER)
		lpLCData: buf
		cchData: 4) == 0
		ifTrue: [self nlsLib systemError].
	^buf value!

getLocaleInfoString: anIntegerLcType
	"Private - Get the specified <Utf8String> locale information from Windows."

	| buf lib size |
	lib := self nlsLib.
	size := lib
				getLocaleInfo: lcid
				lCType: anIntegerLcType
				lpLCData: nil
				cchData: 0.
	size == 0 ifTrue: [^lib systemError].
	"Strings allocate extra space for null automatically"
	buf := Utf16String newFixed: size - 1.
	lib
		getLocaleInfo: lcid
		lCType: anIntegerLcType
		lpLCData: buf
		cchData: size.
	^buf asUtf8String!

getStringInfo: anIntegerLcType
	"Private - Answer a locale specific date String of the specified type for the receiver's locale."

	^info at: anIntegerLcType ifAbsentPut: [self getLocaleInfoString: anIntegerLcType]!

getTimeFormats
	| formats enum |
	formats := Array writeStream: 4.
	enum := ExternalCallback block: 
					[:format |
					formats nextPut: format.
					true]
				descriptor: (ExternalDescriptor returnType: 'bool' argumentTypes: 'lpwstr').
	(self nlsLib
		enumTimeFormats: enum asParameter
		locale: self asParameter
		dwFlags: 0) ifFalse: [self nlsLib systemError].
	enum free.
	^formats contents!

hasLeadingZero
	"Answer whether a leading zero is prepended to a displayed number in this locale if it has only a fractional.
	So for example if this is true then 0.5 is displayed as '0.5', but if false as '.5'."

	^(self getIntegerInfo: LOCALE_ILZERO) asBoolean!

indexOfMonth: aString
	"Answer the 1-based <integer> index in a year (i.e. 1..12) of the month named by the <String> argument, asString, which is expected to be the full locale specific name of a month, or its abbreviated form, in upper or lower case."

	^(info at: #monthNamesMap ifAbsentPut: [self buildMonthNamesMap]) at: aString asLowercase!

infinity
	"Answer the <String> representation for positive infinity in this locale (e.g the '∞' symbol)"

	^self getStringInfo: LOCALE_SPOSINFINITY!

lastTwoDigitYear
	"Answer the <integer> year that is the end of the 100 year interval into which 2-digit years are interpreted.
	For example if this is 2049, then 49 is interpreter as 2049, and 50 as 1950."

	^self getCalendarInfoInteger: CAL_ITWODIGITYEARMAX!

lcid
	"Answer the <integer> Windows Locale Id."

	^lcid!

lcid: anLCID
	"Private - Set the receiver's Win32 LCID which identifies the locale the
	receiver is representing. Answer the receiver."

	lcid := anLCID.
	info := IdentityDictionary new!

listSeparator
	"Answer the String used in the receiver locale to separate items in lists, typically a comma."

	^self getStringInfo: LOCALE_SLIST!

longDateFormat
	"Answer the long date format for the receiver locale."

	^self getStringInfo: LOCALE_SLONGDATE!

longDateFormats
	"Answer a collection of the long date formats for the receiver locale."

	^info at: #longDateFormats ifAbsentPut: [self getDateFormats: true]!

longTimeFormat
	"Answer the long time format for the receiver locale."

	^self getStringInfo: LOCALE_STIMEFORMAT!

monthAbbreviation: anInteger
	"Answer a String that is the localised short name of the month whose index is the argument, anInteger, where January is 1 and December is 12."

	^self getStringInfo: LOCALE_SABBREVMONTHNAME1 +  anInteger - 1!

monthName: anInteger
	"Answer a String that is the localised long name of the month whose index is the 
	argument, anInteger, where January is 1 and December is 12."

	^self getStringInfo: LOCALE_SMONTHNAME1 + anInteger - 1!

name
	"Answer the <String> name of the Locale in the current UI language of the host system."

	^self getStringInfo: LOCALE_SLOCALIZEDDISPLAYNAME!

nameOfDay: anInteger
	"Answer a String that is the localised full name of the day whose index is the argument, anInteger, where Monday is always 1 and Sunday is always 7."

	^self getStringInfo: LOCALE_SDAYNAME1 + anInteger - 1!

nan
	"Answer the <String> used to represen <Float> not-a-number values in this locale."

	^self getStringInfo: LOCALE_SNAN!

nativeDigits
	"Answer a <String> which is the digit characters for zero through nine."

	^self getStringInfo: LOCALE_SNATIVEDIGITS!

negativeInfinity
	"Answer the <String> used to represent numeric negative infinity in this locale."

	^self getStringInfo: LOCALE_SNEGINFINITY!

negativeNumberMode
	"Answer a <String> which is the symbol used to denote negative numbers in this locale."

	^self getIntegerInfo: LOCALE_INEGNUMBER!

negativeSign
	^self getStringInfo: LOCALE_SNEGATIVESIGN!

nlsLib
	"Private - Answer the library responsible for locale support."

	^KernelLibrary default!

numberGrouping
	"Answer a <string> which describes the way in which number digits should be grouped in the receiver locale. The format string consists of a series of integers specifying from left to right how many digits of the number should be formed into a group before the next group (if needed), each group being separated by the 'thousands' separator for the locale. There can be up to 9 characters in the string. If the last character is zero, then the preceding group specification is repeated.
	Some examples from MSDN:
		3;0		e.g. 1,234,567,890 (i.e. the traditional thousands grouping used in some locales such as en-US)
		3;2;0		e.g. 1,23,45,67,890
		3		e.g. 1234567,890
		3;2		e.g. 12345,67,890
	"

	^self getStringInfo: LOCALE_SGROUPING!

percentSymbol
	"Answer a <String> containing the percent symbol for this local."

	^self getStringInfo: LOCALE_SPERCENT!

pmDesignator
	"Answer the character used in the receiver locale to designate PM (afternoon)."

	^self getStringInfo: LOCALE_SPM!

printOn: aStream
	"Append a debug representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(; print: self code; nextPut: $)!

shortAmDesignator
	"Answer the short <String> used in the receiver locale to designate AM (morning)."

	^info at: LOCALE_SSHORTESTAM
		ifAbsentPut: 
			[VMLibrary default isWindows10OrGreater
				ifTrue: [self getLocaleInfoString: LOCALE_SSHORTESTAM]
				ifFalse: 
					["Might be a wide character"
					self amDesignator readStream next: 1]]!

shortDateFormat
	"Answer the short date format for the receiver locale."

	^self getStringInfo: LOCALE_SSHORTDATE!

shortDateFormats
	"Answer a collection of the short date formats for this locale."

	^info at: #shortDateFormats ifAbsentPut: [self getDateFormats: false]!

shortPmDesignator
	"Answer the short <String> used in the receiver locale to designate PM (afternoon)."

	^info at: LOCALE_SSHORTESTPM
		ifAbsentPut: 
			[VMLibrary default isWindows10OrGreater
				ifTrue: [self getLocaleInfoString: LOCALE_SSHORTESTPM]
				ifFalse: 
					["Might be a wide character"
					self pmDesignator readStream next: 1]]!

shortTimeFormat
	"Answer the short time format for the receiver locale."

	^self getStringInfo: LOCALE_SSHORTTIME!

tag
	"Answer the RFC4646 language aka tag for this locale."

	^self getStringInfo: LOCALE_SNAME!

thousandSeparator
	"Answer the thousands separator String used in the receiver locale."

	^self getStringInfo: LOCALE_STHOUSAND!

timeFormats
	"Answer a collection of the time formats for the specified locale."

	^info at: #timeFormats ifAbsentPut: [self getTimeFormats]!

yearMonthFormat
	"Answer the year/month date format for the receiver locale."

	^self getStringInfo: LOCALE_SYEARMONTH! !
!WindowsLocale categoriesFor: #amDesignator!constants!public! !
!WindowsLocale categoriesFor: #asParameter!converting!public! !
!WindowsLocale categoriesFor: #buildDayNamesMap!helpers!private! !
!WindowsLocale categoriesFor: #buildMonthNamesMap!helpers!private! !
!WindowsLocale categoriesFor: #calendarId!constants!public! !
!WindowsLocale categoriesFor: #code!constants!public! !
!WindowsLocale categoriesFor: #currency!constants!public! !
!WindowsLocale categoriesFor: #dayOfWeek:!mapping!public! !
!WindowsLocale categoriesFor: #dayOfWeekAbbreviation:!constants!public! !
!WindowsLocale categoriesFor: #dayOfWeekName:!constants!public! !
!WindowsLocale categoriesFor: #dayOfWeekShortAbbreviation:!constants!public! !
!WindowsLocale categoriesFor: #decimalPlaces!constants!public! !
!WindowsLocale categoriesFor: #decimalSeparator!constants!public! !
!WindowsLocale categoriesFor: #displayName!displaying!public! !
!WindowsLocale categoriesFor: #displayOn:!displaying!public! !
!WindowsLocale categoriesFor: #durationFormat!constants!public! !
!WindowsLocale categoriesFor: #englishDisplayName!displaying!public! !
!WindowsLocale categoriesFor: #firstDayOfWeek!constants!public! !
!WindowsLocale categoriesFor: #getCalendarInfoInteger:!helpers!private! !
!WindowsLocale categoriesFor: #getCalendarInfoString:!helpers!private! !
!WindowsLocale categoriesFor: #getDateFormats:!helpers!private! !
!WindowsLocale categoriesFor: #getIntegerInfo:!helpers!private! !
!WindowsLocale categoriesFor: #getLocaleInfoInteger:!helpers!private! !
!WindowsLocale categoriesFor: #getLocaleInfoString:!helpers!private! !
!WindowsLocale categoriesFor: #getStringInfo:!helpers!private! !
!WindowsLocale categoriesFor: #getTimeFormats!helpers!private! !
!WindowsLocale categoriesFor: #hasLeadingZero!constants!public! !
!WindowsLocale categoriesFor: #indexOfMonth:!enquiries!public! !
!WindowsLocale categoriesFor: #infinity!constants!public! !
!WindowsLocale categoriesFor: #lastTwoDigitYear!constants!public! !
!WindowsLocale categoriesFor: #lcid!accessing!public! !
!WindowsLocale categoriesFor: #lcid:!initializing!private! !
!WindowsLocale categoriesFor: #listSeparator!constants!public! !
!WindowsLocale categoriesFor: #longDateFormat!constants!public! !
!WindowsLocale categoriesFor: #longDateFormats!constants!public! !
!WindowsLocale categoriesFor: #longTimeFormat!constants!public! !
!WindowsLocale categoriesFor: #monthAbbreviation:!constants!public! !
!WindowsLocale categoriesFor: #monthName:!enquiries!public! !
!WindowsLocale categoriesFor: #name!constants!public! !
!WindowsLocale categoriesFor: #nameOfDay:!enquiries!public! !
!WindowsLocale categoriesFor: #nan!constants!public! !
!WindowsLocale categoriesFor: #nativeDigits!constants!public! !
!WindowsLocale categoriesFor: #negativeInfinity!constants!public! !
!WindowsLocale categoriesFor: #negativeNumberMode!constants!public! !
!WindowsLocale categoriesFor: #negativeSign!constants!public! !
!WindowsLocale categoriesFor: #nlsLib!constants!private! !
!WindowsLocale categoriesFor: #numberGrouping!constants!public! !
!WindowsLocale categoriesFor: #percentSymbol!constants!public! !
!WindowsLocale categoriesFor: #pmDesignator!constants!public! !
!WindowsLocale categoriesFor: #printOn:!development!printing!public! !
!WindowsLocale categoriesFor: #shortAmDesignator!constants!public! !
!WindowsLocale categoriesFor: #shortDateFormat!constants!public! !
!WindowsLocale categoriesFor: #shortDateFormats!constants!public! !
!WindowsLocale categoriesFor: #shortPmDesignator!constants!public! !
!WindowsLocale categoriesFor: #shortTimeFormat!constants!public! !
!WindowsLocale categoriesFor: #tag!constants!public! !
!WindowsLocale categoriesFor: #thousandSeparator!constants!public! !
!WindowsLocale categoriesFor: #timeFormats!constants!public! !
!WindowsLocale categoriesFor: #yearMonthFormat!constants!public! !

!WindowsLocale class methodsFor!

systemLocales: anInteger 
	"Private - Answer a collection of system locales, depending on the flags argument, anInteger."

	| enum locales |
	locales := OrderedCollection new: 30.
	enum := ExternalCallback block: 
					[:locale | 
					locales addLast: locale.
					true]
				descriptor: (ExternalDescriptor returnType: 'bool' argumentTypes: 'lpwstr').
	KernelLibrary default enumSystemLocales: enum asParameter dwFlags: anInteger.
	enum free.
	^locales collect: [:s | self lcid: (Integer readFrom: s asUppercase readStream radix: 16)]! !
!WindowsLocale class categoriesFor: #systemLocales:!enquiries!private! !

