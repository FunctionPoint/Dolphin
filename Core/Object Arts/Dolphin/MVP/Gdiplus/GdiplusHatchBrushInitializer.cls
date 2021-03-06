﻿"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusHatchBrushInitializer
	instanceVariableNames: 'style forecolor backcolor'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusHatchBrushInitializer guid: (GUID fromString: '{1a1a5ea5-6151-11d7-b609-00e0987e8081}')!
GdiplusHatchBrushInitializer comment: ''!
!GdiplusHatchBrushInitializer categoriesForClass!Unclassified! !
!GdiplusHatchBrushInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library
				gdipCreateHatchBrush: style
				forecol: forecolor asParameter
				backcol: backcolor asParameter
				brush: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating HatchBrush'!

style: aNumber forecolor: foreColor backcolor: backColor
	style := aNumber.
	forecolor := foreColor asARGB.
	backcolor := backColor asARGB! !
!GdiplusHatchBrushInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!GdiplusHatchBrushInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!GdiplusHatchBrushInitializer categoriesFor: #style:forecolor:backcolor:!initializing!private! !

!GdiplusHatchBrushInitializer class methodsFor!

style: aNumber forecolor: foreARGB backcolor: backARGB
	^self new 
		style: aNumber
		forecolor: foreARGB
		backcolor: backARGB! !
!GdiplusHatchBrushInitializer class categoriesFor: #style:forecolor:backcolor:!instance creation!public! !

