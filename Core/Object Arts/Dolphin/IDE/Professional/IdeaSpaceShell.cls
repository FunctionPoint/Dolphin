﻿"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #IdeaSpaceShell
	instanceVariableNames: 'cardsPresenter backgroundPresenter defaultMenuBar cardHistory filename'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
IdeaSpaceShell guid: (GUID fromString: '{402cf4f5-0b2e-4533-9664-c99fe1bf84fa}')!
IdeaSpaceShell comment: ''!
!IdeaSpaceShell categoriesForClass!MVP-Presenters! !
!IdeaSpaceShell methodsFor!

absorbCard: card 
	card view setParent: cardsPresenter view.
	card view 
		setWindowPosAfter: HWND_BOTTOM asParameter
		x: 0
		y: 0
		width: 0
		height: 0
		flags: SWP_NOSIZE | SWP_NOMOVE | SWP_NOACTIVATE.
	cardsPresenter view ensureTabsAtBack.
	cardsPresenter add: card.
	card view basicMenu: nil.
	self configureCardForIdeaSpace: card!

addIdeaCardTools: aSmalltalkToolShell 
	| existingToolbar newToolbar cardToolbar |
	existingToolbar := aSmalltalkToolShell view viewNamed: 'toolbar' ifNone: [^self].
	newToolbar := Toolbar new.
	newToolbar backcolor: nil; hasDivider: false.
	existingToolbar parentView addSubView: newToolbar.
	newToolbar arrangement: #north.
	newToolbar layoutManager: BorderLayout new.
	existingToolbar setParent: newToolbar.
	existingToolbar arrangement: #center.
	cardToolbar := ReferenceView resourceIdentifier: self ideaCardToolbarId.
	newToolbar addSubView: cardToolbar.
	cardToolbar backcolor: nil.
	cardToolbar arrangement: #east!

addShellDecorations: aShell 
	| shellView |
	shellView := aShell view.
	(shellView 
		baseStyleMask: ##(WS_THICKFRAME | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX | WS_MAXIMIZEBOX)
		set: true
		recreateIfChanged: true) ifTrue: [shellView frameChanged]!

allAdditionalAccelerators
	| answer |
	answer := OrderedCollection withAll: self additionalAccelerators.
	self subPresenters do: 
			[:each | 
			each == cardsPresenter 
				ifFalse: 
					[answer addAll: each additionalAccelerators.
					each allSubPresentersDo: [:eachSub | answer addAll: eachSub additionalAccelerators]]].
	self currentCard ifNotNil: [:tool | answer addAll: tool allAdditionalAccelerators].
	^answer!

basicCaption
	^'Idea Space'!

breakoutCard: cardToBreakout 
	| last |
	cardToBreakout hide.
	cardToBreakout parentPresenter: nil.
	cardToBreakout view setParent: View desktop.
	last := self removeCard: cardToBreakout.
	self removeIdeaCardTools: cardToBreakout.
	self addShellDecorations: cardToBreakout.
	cardToBreakout show.
	self restorePreviousCard: last!

breakoutCurrentCard
	"Break the current card out onto the desktop"

	self removeCardMenubarAndAccelerators.
	self breakoutCard: self currentCard!

cardHistoryBack
	self historyBack!

cardHistoryForward
	^self historyForward!

cards
	"Answer the cards held by the receiver"

	"Go through the managed views of the card presenter rather than using #subPresenters to ensure
	that the cards are in the correct order"

	^cardsPresenter view managedSubViews collect: [:each | each presenter]!

cardsPresenter
	^cardsPresenter!

closeCard
	"Close the current card after first giving it an opportunity to refuse the close. 
	Answer true if the close is allowed."

	^self closeCard: self currentCard!

closeCard: cardToRemove 
	"Close cardToRemove after first giving it an opportunity to refuse the close.
	Answer true if the close is allowed."

	cardToRemove view queryClose ifFalse: [^false].
	self destroyCard: cardToRemove.
	^true!

configureCardForIdeaSpace: cardToConfigure 
	"Configure cardToConfigure for use within this IdeaSpace."

	cardToConfigure 
		when: #captionChanged
		send: #onCardCaptionChanged
		to: self.
	self removeShellDecorations: cardToConfigure.
	self removeSizeGrip: cardToConfigure.
	self addIdeaCardTools: cardToConfigure.
	(cardToConfigure view)
		arrangement: cardToConfigure;
		ensureVisible.
	^cardToConfigure!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	cardsPresenter := self add: Presenter new name: 'cards'.
	backgroundPresenter := self add: ImagePresenter new name: 'backgroundImage'!

createSchematicWiring
	"Private - Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self tabs 
		when: #middleButtonReleased:
		send: #onTabsMiddleButtonClicked:
		to: self.
	self 
		when: #closeRequested:
		send: #onCloseRequested:
		to: self!

currentCard
	"Answer the current card presenter on view in the receiver"

	^cardsPresenter view currentCard ifNotNil: [:currentCardView | currentCardView presenter]!

currentCardIndex
	self hasCurrentCard ifFalse: [^0].
	^self cards indexOf: self currentCard!

currentCardIndex: anInteger 
	anInteger = 0 ifTrue: [^self].
	(self cards at: anInteger) ensureVisible!

defaultHelpId
	^10852!

destroyCard: cardToRemove 
	"Destroy cardToRemove giving it no opportunity to refuse"

	| last |
	last := self removeCard: cardToRemove.
	self restorePreviousCard: last	!

filename
	"Answers the name of the file associated with the receiver or nil
	if there is none"

	^filename!

filename: aStringOrNil
	"Sets the name of the file associated with the receiver"

	filename := nil.
	(aStringOrNil notNil and: [ aStringOrNil notEmpty ])
		ifTrue: [ filename := aStringOrNil ].
	self updateCaption!

hasContents
	^self cards notEmpty or: [self hasFilename]!

hasCurrentCard
	^cardsPresenter view currentCard notNil!

hasFilename
	"Answers true if the receiver has an associated file"

	^filename notNil
!

historySkip: anInteger 
	cardHistory skip: anInteger.
	cardHistory current ensureVisible!

ideaCardToolbarId
	^ResourceIdentifier class: Toolbar name: 'Idea space card tools'!

initialize
	super initialize.
	cardHistory := HistoryList new.
	cardHistory searchPolicy: SearchPolicy identity!

installCardMenubarAndAccelerators
	self view menuBar: self currentCard view menuBar!

isCurrentCardFirst
	^self hasCurrentCard and: [self cards first = self currentCard]!

isCurrentCardLast
	^self hasCurrentCard and: [self cards last = self currentCard]!

isIdeaSpaceCard
	^false!

loadErrorDescriptionFrom: anException 
	(anException isKindOf: CompilerNotification) 
		ifTrue: [^'<1d> in line <2d>' expandMacrosWith: anException errorMessage with: anException line].
	^anException description!

loadIdeaSpace
	"Private - Loads the receiver from its associated template file (if any)"

	Cursor wait showWhile: 
			[| stream |
			stream := FileStream read: self filename.
			[self view noRedrawDo: [self configureFromSavedStateString: stream contents]]
				on: CompilerNotification , Error
				do: 
					[:x |
					self view enableRedraw.
					MessageBox
						errorMsg: ('There was a problem loading the IdeaSpace template: "<1d>". 

The error reported was: "<2d>". 

As as result the new IdeaSpace may only be partially complete. Please bear in mind that you
can only reload an IdeaSpace into an equivalent image to the one that was used to save the
original template. Missing Packages, Classes or Methods may give rise to errors.'
								expandMacrosWith: (File splitFilenameFrom: self filename)
								with: (self loadErrorDescriptionFrom: x))
						caption: 'Problem Loading IdeaSpace'].
			stream close]!

moveCardLeft
	| cardView nextSibling |
	cardView := self currentCard view.
	nextSibling := cardView previousSiblingView.
	nextSibling notNil ifTrue: [nextSibling := nextSibling previousSiblingView].
	nextSibling notNil ifTrue: [cardView zOrderAfter: nextSibling] ifFalse: [cardView zOrderTop]!

moveCardRight
	| cardView nextSibling |
	cardView := self currentCard view.
	nextSibling := cardView nextSiblingView.
	nextSibling notNil ifTrue: [cardView zOrderAfter: nextSibling]!

newEmbeddedCardOfClass: toolClass 
	^(self view noRedrawDo: 
			[| card |
			card := toolClass createIn: cardsPresenter.
			self configureCardForIdeaSpace: card.
			self updateCaption.
			card]) 
		show!

onCardCaptionChanged
	self updateCaption.
	cardsPresenter view updateTabs!

onCardChanged
	self installCardMenubarAndAccelerators.
	self updateCaption.
	cardHistory visit: self currentCard view!

onCloseRequested: aBooleanValue 
	"Private - A request to close the view onto the receiver as occurred.
	Prompt to save any outstanding changed"

	self cards isEmpty ifTrue: [^aBooleanValue value].
	(MessageBox confirm: 'Are you sure you wish to close this IdeaSpace?') 
		ifTrue: [aBooleanValue value: (self cards allSatisfy: [:each | each view queryClose])]
		ifFalse: [aBooleanValue value: false].
	^aBooleanValue value!

onIdleEntered
	"Private - There are no messages in the input queue and the input state is
	about to go idle. Reflect back to the view so that it can update
	any visible UI elements such as toolbar buttons."

	self cards do: [:each | each onIdleEntered].
	^super onIdleEntered
!

onTabsMiddleButtonClicked: aMouseEvent 
	(self tabs itemFromPoint: aMouseEvent position) 
		ifNotNil: [:clicked | self closeCard: (self cards at: clicked)]!

onViewOpened
	super onViewOpened.
	self registerForCardEvents.
	self setWatermark.
	defaultMenuBar := self view menuBar.
!

openIdeaSpace
	"Prompt for a template filename and open the contents inside the receiver if it is empty. Otherwise
	create a new IdeaSpace to hold the contents of the file."

	| openFilename |
	self hasContents ifTrue: [^self model openIdeaSpace].
	openFilename := self class getFilename.
	openFilename isNil ifTrue: [^nil].
	^self openOn: openFilename!

openOn: openFilename 
	self
		filename: openFilename;
		loadIdeaSpace!

queryCommand: aCommandQuery 
	| selector |
	selector := aCommandQuery commandSymbol.
	#moveCardLeft == selector 
		ifTrue: 
			[aCommandQuery isEnabled: self isCurrentCardFirst not.
			^true].
	#moveCardRight == selector 
		ifTrue: 
			[aCommandQuery isEnabled: self isCurrentCardLast not.
			^true].
	#cardHistoryBack == selector 
		ifTrue: 
			[aCommandQuery isEnabled: cardHistory hasPast.
			^true].
	#cardHistoryForward == selector 
		ifTrue: 
			[aCommandQuery isEnabled: cardHistory hasFuture.
			^true].
	#breakoutCurrentCard == selector 
		ifTrue: 
			[aCommandQuery isEnabled: self hasCurrentCard.
			^true].
	(#(#dragToolToIdeaSpace #addToNewIdeaSpace) includes: selector) 
		ifTrue: 
			[aCommandQuery isEnabled: false.
			^true].
	#revertIdeaSpace == selector 
		ifTrue: 
			[aCommandQuery isEnabled: self hasFilename.
			^true].
	^super queryCommand: aCommandQuery!

registerForCardEvents
	cardsPresenter view 
		when: #currentCardChanged
		send: #onCardChanged
		to: self!

removeCard: cardToRemove 
	| last |
	last := self removeHistoryForCard: cardToRemove.
	self removeCardMenubarAndAccelerators.
	cardsPresenter remove: cardToRemove.
	^last!

removeCardMenubarAndAccelerators
	self view menuBar: defaultMenuBar!

removeHistoryForCard: cardToRemove 
	cardHistory remove: cardToRemove view.
	^cardHistory isEmpty ifFalse: [cardHistory current]!

removeIdeaCardTools: aSmalltalkToolShell 
	| originalToolbar replacementToolbar |
	originalToolbar := aSmalltalkToolShell view viewNamed: 'toolbar' ifNone: [^self].
	replacementToolbar := originalToolbar parentView.
	originalToolbar setParent: replacementToolbar parentView.
	replacementToolbar destroy.
	originalToolbar arrangement: #north!

removeShellDecorations: aShell 
	| shellView |
	shellView := aShell view.
	(shellView 
		baseStyleMask: ##(WS_THICKFRAME | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX | WS_MAXIMIZEBOX)
		set: false
		recreateIfChanged: false) ifTrue: [shellView frameChanged]!

removeSizeGrip: aSmalltalkToolShell 
	(aSmalltalkToolShell view viewNamed: 'statusbar' ifNone: [^self]) hasSizeGrip: false!

restorePreviousCard: last 
	last isNil 
		ifTrue: 
			[self cards notEmpty 
				ifTrue: 
					[self currentCard isNil ifTrue: [self cards last ensureVisible].
					self currentCard ensureVisible]
				ifFalse: 
					[backgroundPresenter ensureVisible.
					self updateCaption]]
		ifFalse: 
			[self currentCard isNil ifTrue: [self cards last ensureVisible].
			last == self currentCard view 
				ifFalse: 
					["Closing the card moved to the previous sibling card, which
					 was not the last visited. Need to skip back and pop off
					 this visit"
					self historyBack.
					cardHistory clearFuture]]!

revertIdeaSpace
	self exit ifFalse: [^self].
	self class openOn: self filename!

saveIdeaSpace
	| saved |
	saved := false.
	
	[self hasFilename 
		ifTrue: 
			[| stream |
			stream := FileStream write: self filename text: true.
			[self saveStateOn: stream] ensure: [stream close].
			saved := true]
		ifFalse: [saved := self saveIdeaSpaceAs]] 
			on: FileException
			do: 
				[:e | 
				MessageBox errorMsg: 'Unable to save file ' , e file name printString
					caption: 'Error - ' , e messageText].
	^saved!

saveIdeaSpaceAs
	| proceed newFilename |
	newFilename := (FileSaveDialog on: self filename asValue)
				fileTypes: self class fileTypes;
				defaultExtension: self class defaultFileExtension;
				caption: 'Save IdeaSpace As...';
				showModal.
	(proceed := newFilename notNil and: 
					[(File exists: newFilename) not or: 
							[MessageBox 
								confirm: ('<1s><n>This file already exists, are you sure you would like to overwrite it?' 
										expandMacrosWith: newFilename)
								caption: SessionManager current applicationName]]) 
		ifTrue: 
			["Install the new filename"
			self
				filename: newFilename;
				saveIdeaSpace].
	^proceed!

saveStateOn: aWriteStream 
	"Private - Write the source of a monadic block that will configure an instance of the receiver's class
	to match the state current receiver, to aWriteStream. The block expects a fresh instance of
	the receiver's class as it's parameter"

	| cardsToSave currentCardIndexInCardsToSave |
	aWriteStream nextPutAll: '[:anIdeaSpace | | '.
	cardsToSave := self cards select: [:each | each canSaveState].
	(cardsToSave collect: [:each | each class name]) asSet do: 
			[:each | 
			aWriteStream
				space;
				nextPut: $a;
				nextPutAll: each].
	aWriteStream
		space;
		nextPut: $|;
		cr.
	cardsToSave do: 
			[:each | 
			aWriteStream
				nextPutAll: ('"Create and configure a <1s>"' expandMacrosWith: each class name);
				cr;
				nextPut: $a;
				nextPutAll: each class name;
				nextPutAll: ' := ';
				nextPutAll: 'anIdeaSpace newEmbeddedCardOfClass: ';
				nextPutAll: each class name;
				nextPut: $.;
				cr.
			each saveStateOn: aWriteStream.
			aWriteStream
				space;
				nextPutAll: 'value: ';
				nextPut: $a;
				nextPutAll: each class name;
				nextPut: $.;
				cr;
				cr].
	currentCardIndexInCardsToSave := cardsToSave indexOf: self currentCard.
	aWriteStream
		nextPutAll: ('anIdeaSpace currentCardIndex: <1d>' expandMacrosWith: currentCardIndexInCardsToSave);
		cr.
	aWriteStream nextPut: $]!

setWatermark
	backgroundPresenter value: self watermarkBitmap!

tabs
	^cardsPresenter view tabs!

updateCaption
	self caption: (self hasCurrentCard ifTrue: [self currentCard caption] ifFalse: [self basicCaption])!

watermarkBitmap
	| bitmap |
	bitmap := Bitmap fromFile: 'Resources\IdeaSpaceBackdrop.bmp'
				usingLocator: FileLocator installRelative.
	^bitmap createWatermarkAlphaPercent: 60 backcolor: backgroundPresenter view backcolor! !
!IdeaSpaceShell categoriesFor: #absorbCard:!private! !
!IdeaSpaceShell categoriesFor: #addIdeaCardTools:!helpers!private! !
!IdeaSpaceShell categoriesFor: #addShellDecorations:!helpers!private! !
!IdeaSpaceShell categoriesFor: #allAdditionalAccelerators!constants!private! !
!IdeaSpaceShell categoriesFor: #basicCaption!constants!public! !
!IdeaSpaceShell categoriesFor: #breakoutCard:!private! !
!IdeaSpaceShell categoriesFor: #breakoutCurrentCard!public! !
!IdeaSpaceShell categoriesFor: #cardHistoryBack!commands!private! !
!IdeaSpaceShell categoriesFor: #cardHistoryForward!commands!private! !
!IdeaSpaceShell categoriesFor: #cards!accessing!public! !
!IdeaSpaceShell categoriesFor: #cardsPresenter!public! !
!IdeaSpaceShell categoriesFor: #closeCard!commands!public! !
!IdeaSpaceShell categoriesFor: #closeCard:!commands!public! !
!IdeaSpaceShell categoriesFor: #configureCardForIdeaSpace:!private! !
!IdeaSpaceShell categoriesFor: #createComponents!initializing!private! !
!IdeaSpaceShell categoriesFor: #createSchematicWiring!initializing!private! !
!IdeaSpaceShell categoriesFor: #currentCard!accessing!public! !
!IdeaSpaceShell categoriesFor: #currentCardIndex!public! !
!IdeaSpaceShell categoriesFor: #currentCardIndex:!public! !
!IdeaSpaceShell categoriesFor: #defaultHelpId!constants!public! !
!IdeaSpaceShell categoriesFor: #destroyCard:!commands!public! !
!IdeaSpaceShell categoriesFor: #filename!accessing!public! !
!IdeaSpaceShell categoriesFor: #filename:!accessing!public! !
!IdeaSpaceShell categoriesFor: #hasContents!public! !
!IdeaSpaceShell categoriesFor: #hasCurrentCard!public!testing! !
!IdeaSpaceShell categoriesFor: #hasFilename!public!testing! !
!IdeaSpaceShell categoriesFor: #historySkip:!helpers!public! !
!IdeaSpaceShell categoriesFor: #ideaCardToolbarId!Constants!private! !
!IdeaSpaceShell categoriesFor: #initialize!initializing!private! !
!IdeaSpaceShell categoriesFor: #installCardMenubarAndAccelerators!helpers!private! !
!IdeaSpaceShell categoriesFor: #isCurrentCardFirst!public!testing! !
!IdeaSpaceShell categoriesFor: #isCurrentCardLast!public!testing! !
!IdeaSpaceShell categoriesFor: #isIdeaSpaceCard!public!testing! !
!IdeaSpaceShell categoriesFor: #loadErrorDescriptionFrom:!private! !
!IdeaSpaceShell categoriesFor: #loadIdeaSpace!commands!private! !
!IdeaSpaceShell categoriesFor: #moveCardLeft!commands!public! !
!IdeaSpaceShell categoriesFor: #moveCardRight!commands!public! !
!IdeaSpaceShell categoriesFor: #newEmbeddedCardOfClass:!helpers!private! !
!IdeaSpaceShell categoriesFor: #onCardCaptionChanged!event handling!private! !
!IdeaSpaceShell categoriesFor: #onCardChanged!event handling!private! !
!IdeaSpaceShell categoriesFor: #onCloseRequested:!event handling!private! !
!IdeaSpaceShell categoriesFor: #onIdleEntered!event handling!private! !
!IdeaSpaceShell categoriesFor: #onTabsMiddleButtonClicked:!event handling!private! !
!IdeaSpaceShell categoriesFor: #onViewOpened!event handling!private! !
!IdeaSpaceShell categoriesFor: #openIdeaSpace!public! !
!IdeaSpaceShell categoriesFor: #openOn:!private! !
!IdeaSpaceShell categoriesFor: #queryCommand:!commands!private! !
!IdeaSpaceShell categoriesFor: #registerForCardEvents!helpers!private! !
!IdeaSpaceShell categoriesFor: #removeCard:!commands!private! !
!IdeaSpaceShell categoriesFor: #removeCardMenubarAndAccelerators!helpers!private! !
!IdeaSpaceShell categoriesFor: #removeHistoryForCard:!commands!private! !
!IdeaSpaceShell categoriesFor: #removeIdeaCardTools:!helpers!private! !
!IdeaSpaceShell categoriesFor: #removeShellDecorations:!helpers!private! !
!IdeaSpaceShell categoriesFor: #removeSizeGrip:!helpers!private! !
!IdeaSpaceShell categoriesFor: #restorePreviousCard:!commands!private! !
!IdeaSpaceShell categoriesFor: #revertIdeaSpace!public! !
!IdeaSpaceShell categoriesFor: #saveIdeaSpace!commands!operations!public! !
!IdeaSpaceShell categoriesFor: #saveIdeaSpaceAs!commands!operations!public! !
!IdeaSpaceShell categoriesFor: #saveStateOn:!private!saved state! !
!IdeaSpaceShell categoriesFor: #setWatermark!operations!private! !
!IdeaSpaceShell categoriesFor: #tabs!accessing!private! !
!IdeaSpaceShell categoriesFor: #updateCaption!helpers!private! !
!IdeaSpaceShell categoriesFor: #watermarkBitmap!constants!private! !

!IdeaSpaceShell class methodsFor!

defaultAdditionalAccelerators
	^#(#(#nextCard 'ALT+RIGHT') #(#previousCard 'ALT+LEFT') #(#closeCard 'Ctrl+F4'))!

defaultFileExtension
	"Answer a default extension that will be used for files saved from
	the receiver"

	^'st'!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Idea Space'!

fileTypes
	"Private - Answer an Array of file types that can be associated with this
	class of document."

	| domain |
	domain := self defaultModel.
	^(OrderedCollection new)
		add: domain ideaSpaceFilesType;
		add: domain smalltalkFilesType;
		add: FileDialog allFilesType;
		asArray!

getFilename
	^(FileOpenDialog new)
		fileTypes: self fileTypes;
		defaultExtension: self defaultFileExtension;
		showModal!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver.

		self initialize.
	"

	Smalltalk developmentSystem
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.

!

open
	"Answers an instance of the receiver open on a filename that has been
	prompted for. If 'Cancel' is pressed in the file open dialog then
	answer nil"

	| openFilename |
	openFilename := self getFilename.
	openFilename isNil ifTrue: [^nil].
	^self openOn: openFilename!

openOn: openFilename 
	^(self show)
		openOn: openFilename;
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 5 nil nil nil 528 655878 ##(Smalltalk.CardLayout) 138 144 34 2 721414 ##(Smalltalk.Association) 5 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 688 nil nil nil 5 nil nil nil 688 498 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 688 34 2 8 1140853580 131073 768 nil nil nil 517 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 768 786694 ##(Smalltalk.ColorDefault) 8 4278190080 8 1915204752 170 192 34 6 410 ##(Smalltalk.ReferenceView) 34 14 nil 768 34 2 8 1140916224 131073 1040 nil nil nil 5 nil nil nil 1040 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 914 71 1 914 641 59 1040 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 0 0 0 0 99 1 0 0 29 0 0 0] 8 #() 914 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 768 34 2 8 1140850688 131073 1376 nil nil nil 5 nil nil nil 1376 1106 ##(Smalltalk.Toolbar) #resource_Image_tools nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 914 1 1 914 71 59 1376 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 35 0 0 0 29 0 0 0] 1328 1344 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 768 34 2 8 1140850688 131073 1616 nil nil nil 5 nil nil nil 1616 1106 ##(Smalltalk.Toolbar) #resource_Search_tools nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 914 711 1 914 445 59 1616 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 99 1 0 0 0 0 0 0 65 2 0 0 29 0 0 0] 1328 1344 nil 27 8 'searchTools' 170 192 1328 138 144 1328 nil nil 1 nil 914 41 41 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1138 138 144 34 2 1202 #createAt:extent: 34 2 914 1 1 914 1169 59 768 1202 #updateSizePosted 1328 768 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 29 0 0 0] 34 3 1376 1040 1616 1344 nil 27 nil nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 688 34 2 8 1140850944 1 2112 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 2242 #hash 8 #() nil 721158 ##(Smalltalk.SystemColor) 31 nil 5 nil nil nil 2112 nil 8 4294902281 852486 ##(Smalltalk.NullConverter) nil nil nil nil #centered 1 nil nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 914 1 59 914 1169 625 2112 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 29 0 0 0 72 2 0 0 85 1 0 0] 8 #() 1344 nil 27 170 192 34 4 2112 8 'backgroundImage' 768 8 'toolbar' nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 914 1 1 914 1169 683 688 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 2 768 2112 1344 nil 27 658 7 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 2800 nil nil nil 5 nil nil nil 2800 498 1 1 nil nil nil nil 410 ##(Smalltalk.CardContainer) 34 16 nil 2800 34 2 8 1140850688 131073 2880 nil nil nil 21 265030 4 ##(Smalltalk.Menu) nil true 34 2 2946 nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1025 1180998 4 ##(Smalltalk.CommandDescription) 2242 #tabOrientation: 8 #(#top) 8 '&Top' 1 1 nil nil nil 3026 1025 3058 2242 #tabOrientation: 8 #(#bottom) 8 '&Bottom' 1 1 nil nil nil 3026 1025 3058 2242 #tabOrientation: 8 #(#left) 8 '&Left' 1 1 nil nil nil 3026 1025 3058 2242 #tabOrientation: 8 #(#right) 8 '&Right' 1 1 nil nil nil 8 '&Orientation' nil 134217729 nil nil nil nil nil 2946 nil true 34 5 3026 1025 3058 2242 #viewMode: 8 #(#noIcons) 8 '&No Icons' 1 1 nil nil nil 3026 1025 3058 2242 #viewMode: 8 #(#smallIcons) 8 '&Small Icons' 1 1 nil nil nil 3026 1025 3058 2242 #viewMode: 8 #(#mediumIcons) 8 'Medium Icons' 1 1 nil nil nil 3026 1025 3058 2242 #viewMode: 8 #(#largeIcons) 8 '&Large Icons' 1 1 nil nil nil 3026 1 3058 2242 #viewMode: 8 #(#tileIcons) 8 'Tile Icons' 1 1 nil nil nil 8 '&View' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2880 594 138 144 1328 nil 170 192 1328 nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 2880 34 2 8 1140916736 1 3904 590662 2 ##(Smalltalk.ListModel) 138 144 1328 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 17 nil nil nil 3904 nil 8 1915274640 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 ##(Smalltalk.ListControlView) #defaultGetTextBlock 575230339 8 #[30 105 226 0 106] #displayString 4080 7 257 nil 4066 0 nil 4098 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 4144 7 257 nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #mediumIcons nil nil nil nil nil 1138 138 144 34 2 1202 #createAt:extent: 34 2 914 1 1 914 1169 683 3904 1202 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 3904 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 8 #() 1344 nil 27 1138 138 144 34 2 1202 #createAt:extent: 34 2 914 1 1 914 1169 683 2880 1202 #contextMenu: 34 1 2960 2880 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 1 3904 1344 nil 27 170 192 34 2 2880 8 'cards' nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 914 1 1 914 1169 683 2800 1282 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 1 2880 1344 nil 27 688 170 192 34 2 688 8 'background' nil 1138 138 144 34 1 1202 #createAt:extent: 34 2 914 1 1 914 1169 683 528 1282 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 34 2 688 2800 1344 nil 27 170 192 1328 nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 4 2946 nil true 34 8 3026 1 3058 #fileNew 8 '&New Workspace' 9373 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'NewWorkspace.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 3026 1 3058 #fileOpen 8 '&Open Workspace...' 9375 1 5170 nil true 5216 8 'OpenWorkspace.ico' 5264 nil nil 3026 1 3058 #fileFileIn 8 '&File In...' 1 1 5170 nil true 5216 8 'FileIn.ico' 5264 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3026 1 3058 #saveImage 8 'Sa&ve Image' 1 1 5170 nil true 5216 8 'Snapshot.ico' 5264 nil nil 3026 1 3058 #smalltalkExit 8 'E&xit Dolphin' 1 1 5170 nil true 5216 8 'PowerSwitch.ico' 5264 nil nil 5458 4097 3026 1 3058 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 44059 nil nil 2946 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 44061 nil nil 2946 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 44063 nil nil 2946 nil true 34 15 3026 1 3058 #helpContents 8 '&Contents' 1025 1 5170 nil true 5216 8 'Help.ico' 5264 nil nil 3026 1 3058 #help 8 'On this &Tool' 1249 1 nil nil nil 3026 1 3058 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5458 4097 3026 1 3058 #learnSmalltalk 8 'Learn Smalltalk' 1 1 5714 $\x1F393 nil 262406 ##(Smalltalk.ARGB) 8 4292695180 786694 ##(Smalltalk.IndexedColor) 33554471 nil nil 1 nil nil nil nil 5458 4097 3026 1 3058 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3026 1 3058 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3026 1 3058 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5458 4097 3026 1 3058 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 5170 nil true 5216 8 '!!APPLICATION' 5264 nil nil 3026 1 3058 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3026 1 3058 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5458 4097 3026 1 3058 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 5714 $\x1F42C nil nil 196934 1 ##(Smalltalk.RGB) 17741887 nil nil 1 nil nil nil nil 8 '&Help' nil 134217729 nil nil 44087 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 1138 138 144 34 3 1202 #createAt:extent: 34 2 914 417 417 914 1201 801 416 1202 #text: 34 1 8 'Dolphin Idea Space' 416 1202 #updateMenuBar 1328 416 1282 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 208 0 0 0 208 0 0 0 40 3 0 0 96 2 0 0] 34 1 528 1344 nil 27 )!

toolsFolderHelpId
	^10599! !
!IdeaSpaceShell class categoriesFor: #defaultAdditionalAccelerators!constants!public! !
!IdeaSpaceShell class categoriesFor: #defaultFileExtension!constants!public! !
!IdeaSpaceShell class categoriesFor: #displayOn:!displaying!public! !
!IdeaSpaceShell class categoriesFor: #fileTypes!constants!private! !
!IdeaSpaceShell class categoriesFor: #getFilename!instance creation!private! !
!IdeaSpaceShell class categoriesFor: #icon!constants!public! !
!IdeaSpaceShell class categoriesFor: #initialize!initializing!private! !
!IdeaSpaceShell class categoriesFor: #open!instance creation!public! !
!IdeaSpaceShell class categoriesFor: #openOn:!instance creation!public! !
!IdeaSpaceShell class categoriesFor: #resource_Default_view!public!resources-views! !
!IdeaSpaceShell class categoriesFor: #toolsFolderHelpId!constants!public! !

