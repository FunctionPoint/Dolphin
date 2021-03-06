﻿"Filed out from Dolphin Smalltalk 7"!

HashedCollectionPresenter subclass: #DictionaryPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DictionaryPresenter guid: (GUID fromString: '{8337cb38-a2d9-47dc-95f6-b262e86adca6}')!
DictionaryPresenter comment: ''!
!DictionaryPresenter categoriesForClass!MVP-Presenters! !
!DictionaryPresenter methodsFor!

defaultAddItem
	"Private - Prompts to add an item to the receiver. Used if no addItemBlock has been specified"

	| pair result |
	pair := Association new.
	
	[(KeyValuePrompter 
		createOn: pair
		prompt: 'Enter key and value expressions:'
		caption: 'Add Field...') showModal 
		notNil and: 
				[| error |
				error := nil.
				result := 
						[| key value |
						key := Compiler evaluate: pair key.
						value := Compiler evaluate: pair value.
						self value newAssociation: key value: value] 
								on: Compiler errorClass , Error
								do: 
									[:ex | 
									error := ex.
									ex return: nil].
				error notNil and: 
						[| mb |
						mb := MessageBox new.
						mb buttonStyle: #yesNo.
						mb caption: 'Error evaluating expression...'.
						(mb errorMsg: ('<1d><n><n>Try again?' expandMacrosWith: error)) == #yes]]] 
			whileTrue.
	^result!

elements
	^self value associations 
		asSortedCollection: [:x :y | x key displayString < y key displayString]!

removeElement: anAssociation
	self value: ((self value)
				removeKey: anAssociation key;
				yourself)! !
!DictionaryPresenter categoriesFor: #defaultAddItem!helpers!private! !
!DictionaryPresenter categoriesFor: #elements!accessing!public! !
!DictionaryPresenter categoriesFor: #removeElement:!private!removing! !

!DictionaryPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^Dictionary new asValue! !
!DictionaryPresenter class categoriesFor: #defaultModel!models!public! !

