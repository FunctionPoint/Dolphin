﻿"Filed out from Dolphin Smalltalk 7"!

LayoutManager subclass: #CardLayout
	instanceVariableNames: 'names currentCard'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CardLayout guid: (GUID fromString: '{87b4c647-026e-11d3-9fd7-00a0cc3e4a32}')!
CardLayout comment: 'CardLayout implements a specialised <layoutManager> to layout <view> objects within a <cardView>. It arranges the contained views so that they stack on top of one another in z-order sequence. Only one of the views, the so-called current card, is allowed to be visible at any one time.

The arrangement aspects of the managed views are used as a descriptive names for the cards. The containing <cardView> may make use of these names as it sees fit. For example, a CardContainer uses these as the names for the tabs that it displays.

Instance Variables:
	names		<OrderedCollection> of names for each of the managed views.
	currentCard 	<view> that is currently visible in the container.

'!
!CardLayout categoriesForClass!MVP-Layout Managers-Specialized! !
!CardLayout methodsFor!

arrangementOf: aView 
	"Answer the arrangement parameter of aView in the receiver"

	names do: [:each | each value == aView ifTrue: [^each key]].
	^nil!

arrangementOf: aView put: anObject
	"Set the arrangement parameter of aView in the receiver to be anObject."

	| previous |

	"If the view has already an arrangement, we need to remove it."
	previous := names detect: [:each | each value==aView] ifNone: [].
	previous notNil ifTrue: [ names remove: previous ].

	"Now, we can add the new arrangement"
	names add: (anObject -> aView).

!

cards
	"Private - Answer an OrderedCollection of views that are managed by the 
	receiver. These views are in the z-order sequence of the ContainerView
	that manages them"

	| views container |
	views := self cardViews asOrderedCollection.
	views isEmpty ifTrue: [^OrderedCollection new].
	container := views first parentView.
	^container managedSubViews select: [:each | views includes: each]!

cardViews
	"Answers the Set of views that are managed by the receiver"

	| views |
	views := names collect: [:each | each value].
	^views asSet!

currentCard
	"Answer the current card or nil if there is none"

	^currentCard!

cycleNextCard
	"Select the next card in z order sequence after the current card.
	Cycle round to the first card in the sequence where necessary.
	Answers the card selected"

	self nextCard isNil ifTrue: [ self firstCard ].
	^self currentCard
	!

cyclePreviousCard
	"Select the previous card in z order sequence before the current card.
	Cycle round to the last card in the sequence where necessary.
	Answers the card selected"

	self previousCard isNil ifTrue: [ self lastCard ].
	^self currentCard
	!

firstCard
	"Show the card which is first in the z-order sequence of the 
	associated container. It is an error to ask for the first card
	when there is none. Answers the view that is the first card."
	
	| card |
	card := self cards first.
	self showCard: card.
	^card!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	names := OrderedCollection new.!

lastCard
	"Show the card which is last in the z-order sequence of the 
	associated container. It is an error to ask for the first card
	when there is none. Answers the view that is the last card."
	
	| card |
	card := self cards last.
	self showCard: card.
	^card!

layoutContainer: aCompositeView context: aLayoutContext 
	"Private - Update the <LayoutContext> argument with rectangles for the sub-views of its the
	specified container view, laying out those sub-views according to the rules and
	configuration of the particular layout manager."

	| rect |
	rect := (0 @ 0 extent: (aLayoutContext clientExtentOf: aCompositeView)) 
				insetBy: (aCompositeView actualInsets: aLayoutContext).
	aCompositeView managedSubViewsDo: [:view | aLayoutContext setView: view rectangle: rect]!

nextCard
	"Show the card which is next in the z-order sequence of the associated container after the
	current card that is visible. Answers the view that is the next card, or nil if there is
	none"

	| index cards |
	cards := self cards.
	index := (cards indexOf: currentCard) + 1.
	^index <= cards size 
		ifTrue: 
			[| card |
			card := cards at: index.
			self showCard: card.
			card]!

preferredLayoutExtentOf: aCompositeView context: aLayoutContext 
	"Answer a <Point> specifying the preferred extent for the <CompositeView> argument when
	laying out in the context of the specified <LayoutContext>."

	"Implementation Note: The preferred extent is the maximum extent required by any card in
	both dimensions"

	| max insets |
	max := 0 @ 0.
	aCompositeView managedSubViewsDo: 
			[:each | 
			| extent |
			extent := aLayoutContext extentOf: each.
			max
				x: (max x max: extent x);
				y: (max y max: extent y)].
	insets := aCompositeView actualInsets: aLayoutContext.
	^max + insets origin + insets corner!

previousCard
	"Show the card which is previous in the z-order sequence of the associated container before
	the current card that is visible. Answers the view that is the previous card, or nil if
	there is none"

	| index cards |
	cards := self cards.
	index := (cards indexOf: currentCard ifAbsent: [2]) - 1.
	^index > 0 
		ifTrue: 
			[| card |
			card := cards at: index.
			self showCard: card.
			card]!

removeSubView: aView
	"Remove aView from the collection of views which have been explicitly
	arranged by the receiver.
	Answer aView."

	aView==currentCard ifTrue: [ currentCard := nil ].
	names copy do: [:assoc |
		assoc value == aView ifTrue: [ names remove: assoc ]].
	^aView
!

showCard: aView
	"Show the card, aView and make this the current card. This is after hiding the existing current card"

	self assert: [names anySatisfy: [:each | each value == aView]].
	currentCard == aView
		ifFalse: 
			[aView show.
			currentCard notNil ifTrue: [currentCard hide].
			currentCard := aView.
			self trigger: #currentCardChanged].
	^self!

showCardWithArrangement: anObject
	"Show the card identified by an arrangement of anObject and make this the current card.
	Signals a NotFound exception if a matching view does not exist in the
	receiver. Answer the view that corresponds to anObject"
	
	| view |
	view := (names detect: [ :each | each key = anObject ]) value.
	self showCard: view.
	^view! !
!CardLayout categoriesFor: #arrangementOf:!accessing!public! !
!CardLayout categoriesFor: #arrangementOf:put:!accessing!public! !
!CardLayout categoriesFor: #cards!accessing!private! !
!CardLayout categoriesFor: #cardViews!accessing!private! !
!CardLayout categoriesFor: #currentCard!accessing!public! !
!CardLayout categoriesFor: #cycleNextCard!operations!public! !
!CardLayout categoriesFor: #cyclePreviousCard!operations!public! !
!CardLayout categoriesFor: #firstCard!operations!public! !
!CardLayout categoriesFor: #initialize!initializing!private! !
!CardLayout categoriesFor: #lastCard!operations!public! !
!CardLayout categoriesFor: #layoutContainer:context:!geometry!private! !
!CardLayout categoriesFor: #nextCard!operations!public! !
!CardLayout categoriesFor: #preferredLayoutExtentOf:context:!public! !
!CardLayout categoriesFor: #previousCard!operations!public! !
!CardLayout categoriesFor: #removeSubView:!public!removing! !
!CardLayout categoriesFor: #showCard:!operations!public! !
!CardLayout categoriesFor: #showCardWithArrangement:!operations!public! !

