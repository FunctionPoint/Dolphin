﻿"Filed out from Dolphin Smalltalk 7"!

GdiplusImageTests subclass: #GdiplusBitmapTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusBitmapTest guid: (GUID fromString: '{fa986dbc-acca-46d6-98c9-d51feb7d04d6}')!
GdiplusBitmapTest comment: ''!
!GdiplusBitmapTest categoriesForClass!Unclassified! !
!GdiplusBitmapTest methodsFor!

setUp
	super setUp.
	model := GdiplusBitmap fromFile: self fileResource pafFish32x32png!

testAsByteArrayRoundTripBmp
	| bytes bitmap |
	model := GdiplusBitmap fromFile: self fileResource pafRgb0000FF_100x100bmp.
	bytes := model asByteArray: 'image/bmp'.
	bitmap := GdiplusBitmap fromByteArray: bytes.
	self assert: bytes equals: (bitmap asByteArray: 'image/bmp')!

testFromBitmap
	| bmp recreated |
	bmp := Bitmap fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model := GdiplusBitmap fromBitmap: bmp.
	self assert: model isPersistent.
	self assert: model extent equals: 100 @ 100.
	"assert what?"
	self assertPersistedValid!

testFromFile
	model := GdiplusBitmap fromFile: self fileResource pafRgb0000FF_100x100bmp.
	self assert: model extent equals: 100 @ 100.
	self assertPersistedValid!

testFromIcon
	model := GdiplusBitmap fromIcon: self icon.
	self assert: model isPersistent.
	"mmm ... how does it choose the icon format to use?"
	self assert: model extent equals: 32 @ 32.
	self assertPersistedValid!

testFromIconXP
	model := GdiplusBitmap fromIcon: (Icon fromFile: self fileResource pafWinXP32x32ico).
	model handle.
	"SW: Why did I have 48@48 ?"
	self assert: model extent equals: 32 @ 32.
	self assertPersistedValid!

testFromWidthHeight
	model := GdiplusBitmap width: 100 height: 100.
	self assert: model isPersistent.
	self assert: model extent equals: 100 @ 100.
	"assert what?"
	self assertPersistedValid!

testGetPixel
	| bmp |
	bmp := Bitmap fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model := GdiplusBitmap fromBitmap: bmp.
	self assert: (model pixelAt: 50 @ 50) equals: ARGB blue!

testPixelAfterSave
	| bitmap baseFile extensions supportsAlpha toFile image |
	bitmap := GdiplusBitmap extent: 100 @ 100.
	self assert: (bitmap pixelAt: 1 @ 1) equals: (ARGB fromArray: #(0 0 0 0)).
	baseFile := bitmap class fileResource fileLocator localFileSpecFor: 'testPixelAfterSave'.
	extensions := #('bmp' 'jpeg' 'gif' 'tiff' 'png').
	supportsAlpha := #(false false false true true).
	extensions with: supportsAlpha
		do: 
			[:ext :supported |
			toFile := File path: baseFile extension: ext.
			bitmap saveToFile: toFile.
			image := GdiplusBitmap fromFile: toFile.
			self assert: (image pixelAt: 1 @ 1) = (ARGB fromArray: #(0 0 0 0)) equals: supported]! !
!GdiplusBitmapTest categoriesFor: #setUp!public!setup! !
!GdiplusBitmapTest categoriesFor: #testAsByteArrayRoundTripBmp!public!unit tests! !
!GdiplusBitmapTest categoriesFor: #testFromBitmap!public!unit tests! !
!GdiplusBitmapTest categoriesFor: #testFromFile!public!unit tests! !
!GdiplusBitmapTest categoriesFor: #testFromIcon!public!unit tests! !
!GdiplusBitmapTest categoriesFor: #testFromIconXP!public!unit tests! !
!GdiplusBitmapTest categoriesFor: #testFromWidthHeight!public!unit tests! !
!GdiplusBitmapTest categoriesFor: #testGetPixel!public!unit tests! !
!GdiplusBitmapTest categoriesFor: #testPixelAfterSave!public!unit tests! !

