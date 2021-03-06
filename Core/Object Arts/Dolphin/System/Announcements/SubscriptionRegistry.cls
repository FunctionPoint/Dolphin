﻿"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SubscriptionRegistry
	instanceVariableNames: 'subscriptions monitor'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SubscriptionRegistry guid: (GUID fromString: '{a785d939-edab-48ad-b4a7-0bf0a69ec5f3}')!
SubscriptionRegistry comment: 'The subscription registry is a threadsafe storage for the subscriptions to an Announcer.

In Pharo, subscriptionsFor: protocol is not implemented.
This is because Announcer does not provide public access to its registery for encapsulation reasons.
(We do not want access to the announcer from action blocks to break encapsulation to other subscribers)'!
!SubscriptionRegistry categoriesForClass!Announcements-Core! !
!SubscriptionRegistry methodsFor!

add: subscription
	^ self protected: [
		subscriptions add: subscription  ]
!

deliver: anAnnouncement
	|  interestedSubscriptions |
	
	"using a copy, so subscribers can unsubscribe from announcer "
	
	subscriptions isEmpty ifTrue: [ ^ self ].
	self protected: [ 
		interestedSubscriptions := self subscriptionsHandling: anAnnouncement ].
	self deliver: anAnnouncement to: interestedSubscriptions!

deliver: anAnnouncement to: subs
	^ self deliver: anAnnouncement to: subs startingAt: 1!

deliver: anAnnouncement to: subs startingAt: startIndex
	
	startIndex to: subs size do: [ :index| | subscription |
		subscription := subs at: index.
		[ subscription deliver: anAnnouncement ] 
			"Ensure delivery to remaining announcements"
			ifCurtailed: [
				self deliver: anAnnouncement to: subs startingAt: index + 1 ]]!

glmSubscriptions
	^ subscriptions!

initialize
	monitor := Semaphore forMutualExclusion.
	self reset
!

numberOfSubscriptions
	^ subscriptions size!

protected: aBlock
	^ monitor critical: [ aBlock value ]!

remove: subscription
	^ self protected: [
		subscriptions remove: subscription ifAbsent: nil ]

!

removeSubscriber: subscriber
	
	^ self protected: [
		subscriptions removeAllSuchThat: [:subscription | subscription subscriber == subscriber ]]

!

replace: subscription with: newOne

	" Note that it will signal an error if subscription is not there "
	self protected: [
		subscriptions remove: subscription.
		subscriptions add: newOne 
	].
	^ newOne!

reset
	"subscriber -> subscriptions"
	
	subscriptions := IdentitySet new
	


!

subscriptionsHandling: anAnnouncement
	^ Array streamContents: [ :s|
			subscriptions do: [:each| 
				(each handlesAnnouncement: anAnnouncement)
					ifTrue: [ s nextPut: each ]]]!

subscriptionsOf: aSubscriber do: aBlock
	| copy |
	
	self protected: [ copy := subscriptions copy ].
	
	copy do: 
		[:subscription | 
			subscription subscriber == aSubscriber 
				ifTrue: [ aBlock value: subscription ]	]
! !
!SubscriptionRegistry categoriesFor: #add:!add/remove!public! !
!SubscriptionRegistry categoriesFor: #deliver:!announcing!public! !
!SubscriptionRegistry categoriesFor: #deliver:to:!private! !
!SubscriptionRegistry categoriesFor: #deliver:to:startingAt:!private! !
!SubscriptionRegistry categoriesFor: #glmSubscriptions!*glamour/tests/core!public! !
!SubscriptionRegistry categoriesFor: #initialize!initialization!public! !
!SubscriptionRegistry categoriesFor: #numberOfSubscriptions!accessing!public! !
!SubscriptionRegistry categoriesFor: #protected:!private! !
!SubscriptionRegistry categoriesFor: #remove:!add/remove!public! !
!SubscriptionRegistry categoriesFor: #removeSubscriber:!add/remove!public! !
!SubscriptionRegistry categoriesFor: #replace:with:!add/remove!public! !
!SubscriptionRegistry categoriesFor: #reset!initialize/release!public! !
!SubscriptionRegistry categoriesFor: #subscriptionsHandling:!accessing!public! !
!SubscriptionRegistry categoriesFor: #subscriptionsOf:do:!iterating!public! !

!SubscriptionRegistry class methodsFor!

new	
	^super new initialize! !
!SubscriptionRegistry class categoriesFor: #new!public! !

