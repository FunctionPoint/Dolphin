﻿"Filed out from Dolphin Smalltalk 7"!

ValueDialog subclass: #AXTypeLibraryPrompter
	instanceVariableNames: 'typeLibs path guidPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AXTypeLibraryPrompter guid: (GUID fromString: '{4febe003-3945-11d3-9fe6-00a0cc3e4a32}')!
AXTypeLibraryPrompter comment: 'AXTypeLibraryPrompter is a <valueDialogPresenter> that can be used to prompt for a COM component type library to install into the image. Its displays a list of all the registered type libraries (including those already installed) and also gives the user an opportunity to load a type library directly from a DLL, OCX, EXE, or TLB file. The subject <valueModel> is filled with an instance of AXTypeLibrary representing the chosen library when the dialogue is confirmed.

Note that the prompter takes care not to actually load the type libraries until the user chooses one.

Example:
	AXTypeLibraryPrompter showModal "Display it"

Instance Variables:
	typeLibs		<ListPresenter> displaying a list of <AXTypeLibRegistration>s.
	path		<TextPresenter> displaying the path to the chosen type library.

'!
!AXTypeLibraryPrompter categoriesForClass!MVP-Presenters! !
!AXTypeLibraryPrompter methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	typeLibs := self add: ListPresenter new name: 'typeLibs'.
	path := self add: TextPresenter new name: 'libraryPath'.
	guidPresenter := self add: TextPresenter new name: 'guid'.

!

createSchematicWiring
	"Create the trigger wiring for the receiver"
	
	super createSchematicWiring.
	typeLibs when: #actionPerformed send: #onTypeLibraryChosen to: self.
	typeLibs when: #selectionChanged send: #onTypeLibrarySelected to: self!

ok
	"Close the receiver and apply the changes cached in the receiver back to the model"

	| reg |
	reg := typeLibs selectionOrNil.
	self value: (reg isNil ifFalse: [AXTypeLibraryAnalyzer fromRegistration: reg]).
	super ok!

onTypeLibraryChosen
	"Private - A type library has been chosen by the user double-clicking an entry in the list.
	This is the same as the OK command, but we need to test that #ok command is actually
	enabled."

	self view onCommand: (CommandDescription command: #ok)!

onTypeLibrarySelected
	"Private - A type library has been selected. Refresh the information about
	it, including the list of available interfaces."

	| reg |
	path clear.
	guidPresenter clear.
	(reg := typeLibs selectionOrNil) notNil 
		ifTrue: 
			[
			[| guid |
			guid := reg libid.
			path value: (ITypeLib 
						queryPath: guid
						major: reg majorVersion
						minor: reg minorVersion
						locale: 0).
			guidPresenter value: guid] 
					on: HRESULTError
					do: 
						[:e | 
						e beep.
						path value: ('Unable to load type library <1p>:<n><2s>' expandMacrosWith: reg description
									with: e messageText)]]!

onViewOpened
	"Private - Received when the receiver's view is been connected. Refresh the
	list of current type libraries"

	super onViewOpened.
	self refresh.
	typeLibs setFocus
!

openTypeLib
	"Browse the file system for a type library to open."

	| typelib |
	typelib := AXTypeLibraryAnalyzer open.
	typelib notNil ifTrue: [
		self value: typelib.
		super ok]

!

queryCommand: query
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery>, query."

	| cmd |
	cmd := query commandSymbol.
	
	cmd == #ok ifTrue: [
		query isEnabled: (guidPresenter value isKindOf: GUID).
		^true].

	^super queryCommand: query.
!

refresh
	"Private - Refresh the list of current AXTypeLibraryAnalyzers in the image"

	| registrations currentTypeLibs |

	currentTypeLibs := AXTypeLibraryAnalyzer allTypeLibs collect: [:each | each registration ].
	registrations := AXTypeLibraryAnalyzer typeLibRegistrations.
	registrations := registrations difference: currentTypeLibs.
	typeLibs list: registrations asSortedCollection.
	self onTypeLibrarySelected
! !
!AXTypeLibraryPrompter categoriesFor: #createComponents!initializing!public! !
!AXTypeLibraryPrompter categoriesFor: #createSchematicWiring!initializing!public! !
!AXTypeLibraryPrompter categoriesFor: #ok!commands!public! !
!AXTypeLibraryPrompter categoriesFor: #onTypeLibraryChosen!event handling!private! !
!AXTypeLibraryPrompter categoriesFor: #onTypeLibrarySelected!event handling!private! !
!AXTypeLibraryPrompter categoriesFor: #onViewOpened!event handling!private! !
!AXTypeLibraryPrompter categoriesFor: #openTypeLib!commands!public! !
!AXTypeLibraryPrompter categoriesFor: #queryCommand:!commands!private! !
!AXTypeLibraryPrompter categoriesFor: #refresh!commands!private! !

!AXTypeLibraryPrompter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 165 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 21 743 578 689 81 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 115 1 0 0 98 1 0 0 155 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 7 nil nil nil 960 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.PushButton) 34 20 nil 960 34 2 8 1140924416 1 1088 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 7 nil nil nil 1088 nil 8 1915188384 1180998 4 ##(Smalltalk.CommandDescription) #openTypeLib 8 '&Open...' 1 1 nil nil false nil nil nil 738 138 144 34 3 802 #createAt:extent: 34 2 578 535 507 578 141 51 1088 802 #isEnabled: 8 #(false) 1088 802 #text: 34 1 8 '&Open...' 1088 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 1 0 0 253 0 0 0 81 1 0 0 22 1 0 0] 8 #() 944 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedViewRight -139 1538 #fixedParentRight -13 1538 #fixedViewBottom -49 1538 #fixedParentBottom -165 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850946 1 1616 nil nil nil 7 nil nil nil 1616 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 577 578 111 51 1616 802 #text: 34 1 8 '&Location:' 1616 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 1 0 0 55 0 0 0 57 1 0 0] 8 #() 944 nil 27 1506 1538 #fixedParentLeft 1 1538 #fixedViewLeft 111 1584 -49 1600 -95 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850944 1 1984 nil nil nil 7 nil nil nil 1984 nil 8 1915124368 1698 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 131 657 578 561 41 1984 802 #text: 34 1 8 'GUID of selected library here...' 1984 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 72 1 0 0 89 1 0 0 92 1 0 0] 8 #() 944 nil 27 1506 1952 131 1968 561 1584 -39 1600 -25 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850944 1 2304 nil nil nil 7 nil nil nil 2304 nil 8 1915124368 1698 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 131 577 578 561 61 2304 802 #text: 34 1 8 'Path of selected library here...on two lines if necessary to get the whole path to fit.' 2304 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 65 0 0 0 32 1 0 0 89 1 0 0 62 1 0 0] 8 #() 944 nil 27 1506 1952 131 1968 561 1584 -59 1600 -85 410 ##(Smalltalk.StaticText) 34 16 nil 960 34 2 8 1140850946 1 2624 nil nil nil 7 nil nil nil 2624 nil 8 1915124368 1698 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 657 578 111 41 2624 802 #text: 34 1 8 '&GUID:' 2624 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 72 1 0 0 55 0 0 0 92 1 0 0] 8 #() 944 nil 27 1506 1952 1 1968 111 1584 -39 1600 -25 410 ##(Smalltalk.ListView) 34 30 nil 960 34 2 8 1140953165 1025 2944 590662 2 ##(Smalltalk.ListModel) 138 144 928 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1168 nil 7 nil nil nil 2944 nil 8 1915211424 459270 ##(Smalltalk.Message) #description 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 2 920646 5 ##(Smalltalk.ListViewColumn) 8 'Library' 565 #left ##(Smalltalk.BasicListAbstract) 3106 #<= 8 #() 3106 #description 8 #() nil 2944 nil 3 nil nil 3218 8 'Version' 105 #left ##(Smalltalk.BasicListAbstract) 3106 #<= 8 #() 3106 #versionString 3312 nil 2944 nil 1 nil nil #report 928 nil 131137 nil 34 4 nil nil 578 1 1 nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 1 578 685 487 2944 802 #text: 34 1 8 'Library' 2944 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 86 1 0 0 243 0 0 0] 8 #() 944 nil 27 1506 1952 1 1568 -3 1538 #fixedParentTop 1 1600 -235 170 192 34 6 2944 8 'typeLibs' 1984 8 'guid' 2304 8 'libraryPath' nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 21 21 578 689 723 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 115 1 0 0] 34 6 2944 1088 1616 2304 2624 1984 944 nil 27 170 192 928 590342 ##(Smalltalk.Rectangle) 578 21 21 578 21 21 nil nil nil nil 14471 nil nil 578 1201 1191 578 721 591 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2011052416 738 138 144 34 3 802 #createAt:extent: 34 2 578 3839 21 578 761 921 416 802 #text: 34 1 8 'Registered Components' 416 802 #updateMenuBar 928 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 251 8 0 0 214 1 0 0] 34 2 960 640 944 nil 27 )! !
!AXTypeLibraryPrompter class categoriesFor: #resource_Default_view!public!resources-views! !

