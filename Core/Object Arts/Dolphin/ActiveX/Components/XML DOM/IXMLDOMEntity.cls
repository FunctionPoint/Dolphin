﻿"Filed out from Dolphin Smalltalk 7"!

IXMLDOMNode subclass: #IXMLDOMEntity
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSXMLConstants'
	classInstanceVariableNames: ''!
IXMLDOMEntity guid: (IID fromString: '{2933BF8D-7B36-11D2-B20E-00C04F983E60}')!
IXMLDOMEntity comment: '<IXMLDOMEntity> is a wrapper class for the COM interface ''MSXML.IXMLDOMEntity'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

This is a specialized DOM node to represent parsed or unparsed entities in the XML document.'!
!IXMLDOMEntity categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!IXMLDOMEntity methodsFor!

get_notationName: name
	"Private - Get the value of the 'notationName' property of the receiver.

		HRESULT __stdcall notationName(
			[out, retval]BSTR* name);"

	<virtual stdcall: hresult 46 bstr*>
	^self invalidCall: _failureCode!

get_publicId: publicId
	"Private - Get the value of the 'publicId' property of the receiver.

		HRESULT __stdcall publicId(
			[out, retval]VARIANT* publicId);"

	<virtual stdcall: hresult 44 variant*>
	^self invalidCall: _failureCode!

get_systemId: systemId
	"Private - Get the value of the 'systemId' property of the receiver.

		HRESULT __stdcall systemId(
			[out, retval]VARIANT* systemId);"

	<virtual stdcall: hresult 45 variant*>
	^self invalidCall: _failureCode!

key
	"Answer the <readableString> name of the receiver."

	^self nodeName!

key: arg1 
	"This is part of the protocol <association>, but is not supported by DOM entities (the key
	is considered fixed)."

	^self shouldNotImplement!

notationName
	"Answer the <bstr> value of the 'notationName' property of the receiver.
	Helpstring: the name of the notation"

	| answer |
	answer := BSTR new.
	self get_notationName: answer.
	^answer asObject
!

publicId
	"Answer the <variant> value of the 'publicId' property of the receiver.
	Helpstring: the public ID"

	| answer |
	answer := VARIANT new.
	self get_publicId: answer.
	^answer asObject
!

systemId
	"Answer the <variant> value of the 'systemId' property of the receiver.
	Helpstring: the system ID"

	| answer |
	answer := VARIANT new.
	self get_systemId: answer.
	^answer asObject
!

value
	| publicId stream systemId |
	publicId := self publicId.
	stream := String writeStream.
	publicId notEmpty 
		ifTrue: 
			[stream
				nextPutAll: 'PUBLIC ';
				nextPut: $";
				nextPutAll: publicId;
				nextPut: $"]
		ifFalse: [stream nextPutAll: 'SYSTEM'].
	systemId := self systemId.
	systemId notEmpty 
		ifTrue: 
			[stream
				space;
				nextPut: $";
				nextPutAll: systemId;
				nextPut: $"].
	^stream contents!

value: arg1 
	"This is part of the protocol <association>, but is not supported by DOM entities (the value
	is fixed)."

	^self shouldNotImplement! !
!IXMLDOMEntity categoriesFor: #get_notationName:!**auto generated**!COM Interfaces-IXMLDOMEntity!private! !
!IXMLDOMEntity categoriesFor: #get_publicId:!**auto generated**!COM Interfaces-IXMLDOMEntity!private! !
!IXMLDOMEntity categoriesFor: #get_systemId:!**auto generated**!COM Interfaces-IXMLDOMEntity!private! !
!IXMLDOMEntity categoriesFor: #key!accessing!public! !
!IXMLDOMEntity categoriesFor: #key:!accessing!public! !
!IXMLDOMEntity categoriesFor: #notationName!**auto generated**!properties!public! !
!IXMLDOMEntity categoriesFor: #publicId!**auto generated**!properties!public! !
!IXMLDOMEntity categoriesFor: #systemId!**auto generated**!properties!public! !
!IXMLDOMEntity categoriesFor: #value!accessing!public! !
!IXMLDOMEntity categoriesFor: #value:!accessing!public! !

IXMLDOMEntity methodProtocol: #association attributes: #(#ansi #readOnly) selectors: #(#key #key: #value #value:)!

!IXMLDOMEntity class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMEntity'
		IXMLDOMEntity defineTemplate"

	self
		defineFunction: #get_publicId:
			argumentTypes: 'variant*';
		defineFunction: #get_systemId:
			argumentTypes: 'variant*';
		defineFunction: #get_notationName:
			argumentTypes: 'bstr*'
! !
!IXMLDOMEntity class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

