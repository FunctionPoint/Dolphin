﻿"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusFontFamilyInitializer
	instanceVariableNames: ''
	classVariableNames: 'GenericSansSerif GenericSerif'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusFontFamilyInitializer guid: (GUID fromString: '{c09d8c09-5f28-11d7-b609-00e0987e8081}')!
GdiplusFontFamilyInitializer isAbstract: true!
GdiplusFontFamilyInitializer comment: ''!
!GdiplusFontFamilyInitializer categoriesForClass!Unclassified! !
!GdiplusFontFamilyInitializer methodsFor!

gdiplusConstructorErrorDescription
	^'Error creating FontFamily'! !
!GdiplusFontFamilyInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

!GdiplusFontFamilyInitializer class methodsFor!

genericSansSerif
	^GenericSansSerif ifNil: [GenericSansSerif := GdiplusFontFamilyGenericSansSerifInitializer basicNew]!

genericSerif
	^GenericSerif ifNil: [GenericSerif := GdiplusFontFamilyGenericSerifInitializer basicNew]!

name: aString fontCollection: aFontCollection
	^GdiplusFontFamilyFromNameInitializer basicNew name: aString fontCollection: aFontCollection!

new
	^self shouldNotImplement!

onPreStripImage
	"Private -  Allow the receiver and subclasses to be stripped by clearing lazy initialized class variables
	which hold sub-instance of the receiver."

	GenericSansSerif := GenericSerif := nil! !
!GdiplusFontFamilyInitializer class categoriesFor: #genericSansSerif!instance creation!public! !
!GdiplusFontFamilyInitializer class categoriesFor: #genericSerif!instance creation!public! !
!GdiplusFontFamilyInitializer class categoriesFor: #name:fontCollection:!instance creation!public! !
!GdiplusFontFamilyInitializer class categoriesFor: #new!instance creation!public! !
!GdiplusFontFamilyInitializer class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !

