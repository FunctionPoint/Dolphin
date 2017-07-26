"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_REQUEST_TOKEN_BINDING_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_REQUEST_TOKEN_BINDING_INFO guid: (GUID fromString: '{9a86eb3d-22ee-4cc3-980d-f3427eecdb0c}')!
HTTP_REQUEST_TOKEN_BINDING_INFO comment: '<HTTP_REQUEST_TOKEN_BINDING_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_REQUEST_TOKEN_BINDING_INFO'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(9a86eb3d-22ee-4cc3-980d-f3427eecdb0c)]
struct tagHTTP_REQUEST_TOKEN_BINDING_INFO {
	UCHAR* TokenBinding;
	ULONG TokenBindingSize;
	UCHAR* TlsUnique;
	ULONG TlsUniqueSize;
	LPWSTR KeyType;
} HTTP_REQUEST_TOKEN_BINDING_INFO;
'!
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesForClass!Win32-Structs! !
!HTTP_REQUEST_TOKEN_BINDING_INFO methodsFor!

KeyType
	"Answer the <UnicodeString> value of the receiver's 'KeyType' field."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #KeyType))!

KeyType: anUnicodeString
	"Set the receiver's 'KeyType' field to the value of the argument, anUnicodeString"

	bytes uintPtrAtOffset: ##(self offsetOf: #KeyType) put: anUnicodeString yourAddress!

TlsUnique
	"Answer the <BYTE> value of the receiver's 'TlsUnique' field."

	^BYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #TlsUnique))!

TlsUnique: aBYTE
	"Set the receiver's 'TlsUnique' field to the value of the argument, aBYTE"

	bytes uintPtrAtOffset: ##(self offsetOf: #TlsUnique) put: aBYTE yourAddress!

TlsUniqueSize
	"Answer the <Integer> value of the receiver's 'TlsUniqueSize' field."

	^bytes dwordAtOffset: ##(self offsetOf: #TlsUniqueSize)!

TlsUniqueSize: anInteger
	"Set the receiver's 'TlsUniqueSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #TlsUniqueSize) put: anInteger!

TokenBinding
	"Answer the <BYTE> value of the receiver's 'TokenBinding' field."

	^BYTE fromAddress: (bytes intPtrAtOffset: 0)!

TokenBinding: aBYTE
	"Set the receiver's 'TokenBinding' field to the value of the argument, aBYTE"

	bytes uintPtrAtOffset: 0 put: aBYTE yourAddress!

TokenBindingSize
	"Answer the <Integer> value of the receiver's 'TokenBindingSize' field."

	^bytes dwordAtOffset: ##(self offsetOf: #TokenBindingSize)!

TokenBindingSize: anInteger
	"Set the receiver's 'TokenBindingSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #TokenBindingSize) put: anInteger! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #KeyType!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #KeyType:!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #TlsUnique!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #TlsUnique:!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #TlsUniqueSize!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #TlsUniqueSize:!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #TokenBinding!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #TokenBinding:!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #TokenBindingSize!**compiled accessors**!public! !
!HTTP_REQUEST_TOKEN_BINDING_INFO categoriesFor: #TokenBindingSize:!**compiled accessors**!public! !

!HTTP_REQUEST_TOKEN_BINDING_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_REQUEST_TOKEN_BINDING_INFO structure.

	HTTP_REQUEST_TOKEN_BINDING_INFO compileDefinition

		typedef [uuid(9a86eb3d-22ee-4cc3-980d-f3427eecdb0c)]
		struct tagHTTP_REQUEST_TOKEN_BINDING_INFO {
			UCHAR* TokenBinding;
			ULONG TokenBindingSize;
			UCHAR* TlsUnique;
			ULONG TlsUniqueSize;
			LPWSTR KeyType;
		} HTTP_REQUEST_TOKEN_BINDING_INFO;
"

	self
		defineField: #TokenBinding type: (PointerField type: BYTE) offset: 0;
		defineField: #TokenBindingSize type: DWORDField new offset: 4;
		defineField: #TlsUnique type: (PointerField type: BYTE) offset: 8;
		defineField: #TlsUniqueSize type: DWORDField new offset: 12;
		defineField: #KeyType type: (PointerField type: UnicodeString) offset: 16.
	self byteSize: 20! !
!HTTP_REQUEST_TOKEN_BINDING_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !
