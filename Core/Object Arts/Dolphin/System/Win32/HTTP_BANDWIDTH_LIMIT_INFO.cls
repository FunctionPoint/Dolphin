﻿"Filed out from Dolphin Smalltalk 7"!

HttpQosSetting subclass: #HTTP_BANDWIDTH_LIMIT_INFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_MaxBandwidth'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_BANDWIDTH_LIMIT_INFO guid: (GUID fromString: '{197b6874-68bb-4a22-b2fa-9e02210f4cd9}')!
HTTP_BANDWIDTH_LIMIT_INFO addClassConstant: '_OffsetOf_MaxBandwidth' value: 16r4!
HTTP_BANDWIDTH_LIMIT_INFO comment: '<HTTP_BANDWIDTH_LIMIT_INFO> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_BANDWIDTH_LIMIT_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Used to set or query the bandwidth throttling limit.This structure must be used when setting or querying the HttpServerBandwidthProperty on a URL Group or server session."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(197b6874-68bb-4a22-b2fa-9e02210f4cd9), helpstring("Used to set or query the bandwidth throttling limit.This structure must be used when setting or querying the HttpServerBandwidthProperty on a URL Group or server session.")]
struct tagHTTP_BANDWIDTH_LIMIT_INFO {
	[nonbrowsable, helpstring("Specifies whether the MaxBandwidth property is present.")] HTTP_PROPERTY_FLAGS;
	[helpstring("The maximum allowed bandwidth rate in bytesper second. Setting the value to HTTP_LIMIT_INFINITE allows unlimited bandwidth rate. The value cannot be smaller than HTTP_MIN_ALLOWED_BANDWIDTH_THROTTLING_RATE.")] ULONG MaxBandwidth;
} HTTP_BANDWIDTH_LIMIT_INFO;
'!
!HTTP_BANDWIDTH_LIMIT_INFO categoriesForClass!WinHttpServer-Structs! !
!HTTP_BANDWIDTH_LIMIT_INFO methodsFor!

MaxBandwidth
	"Answer the <Integer> value of the receiver's 'MaxBandwidth' field."

	^bytes dwordAtOffset: _OffsetOf_MaxBandwidth!

MaxBandwidth: anInteger
	"Set the receiver's 'MaxBandwidth' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_MaxBandwidth put: anInteger!

value
	^self Present ifTrue: [self MaxBandwidth]!

value: anInteger
	anInteger
		ifNil: 
			[self
				Present: false;
				MaxBandwidth: 0]
		ifNotNil: 
			[self
				Present: true;
				MaxBandwidth: anInteger]! !
!HTTP_BANDWIDTH_LIMIT_INFO categoriesFor: #MaxBandwidth!**compiled accessors**!public! !
!HTTP_BANDWIDTH_LIMIT_INFO categoriesFor: #MaxBandwidth:!**compiled accessors**!public! !
!HTTP_BANDWIDTH_LIMIT_INFO categoriesFor: #value!accessing!public! !
!HTTP_BANDWIDTH_LIMIT_INFO categoriesFor: #value:!accessing!public! !

!HTTP_BANDWIDTH_LIMIT_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_BANDWIDTH_LIMIT_INFO structure.

	HTTP_BANDWIDTH_LIMIT_INFO compileDefinition

		typedef [uuid(197b6874-68bb-4a22-b2fa-9e02210f4cd9), helpstring('Used to set or query the bandwidth throttling limit.This structure must be used when setting or querying the HttpServerBandwidthProperty on a URL Group or server session.')]
		struct tagHTTP_BANDWIDTH_LIMIT_INFO {
			[nonbrowsable, helpstring('Specifies whether the MaxBandwidth property is present.')] HTTP_PROPERTY_FLAGS;
			[helpstring('The maximum allowed bandwidth rate in bytesper second. Setting the value to HTTP_LIMIT_INFINITE allows unlimited bandwidth rate. The value cannot be smaller than HTTP_MIN_ALLOWED_BANDWIDTH_THROTTLING_RATE.')] ULONG MaxBandwidth;
		} HTTP_BANDWIDTH_LIMIT_INFO;
"

	super defineFields.
	self
		defineField: #MaxBandwidth type: DWORDField new offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#Present #MaxBandwidth)!

maxBandwidth: anInteger
	^self new value: anInteger!

qosType
	^HttpQosSettingTypeBandwidth! !
!HTTP_BANDWIDTH_LIMIT_INFO class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!HTTP_BANDWIDTH_LIMIT_INFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!HTTP_BANDWIDTH_LIMIT_INFO class categoriesFor: #maxBandwidth:!public! !
!HTTP_BANDWIDTH_LIMIT_INFO class categoriesFor: #qosType!constants!public! !

