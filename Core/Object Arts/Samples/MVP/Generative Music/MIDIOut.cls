﻿"Filed out from Dolphin Smalltalk 7"!

Object subclass: #MIDIOut
	instanceVariableNames: 'handle'
	classVariableNames: ''
	poolDictionaries: 'MidiConstants'
	classInstanceVariableNames: ''!
MIDIOut guid: (GUID fromString: '{feb23957-1be7-48db-9eef-924631f6e9a9}')!
MIDIOut comment: ''!
!MIDIOut categoriesForClass!Kernel-Objects! !
!MIDIOut methodsFor!

channel: ch msg: msg with: p1 with: p2 
	| dword |
	dword := ByteArray 
				with: (msg << 4 bitOr: ch & 16rF)
				with: p1
				with: p2
				with: 0.
	^WinMMLibrary default midiOutShortMsgHmo: handle dwMsg: dword!

close
	^WinMMLibrary default midiOutCloseHmo: handle!

controller: controllerID value: anInteger 
	^self 
		channel: 0
		msg: MidiControlChange
		with: controllerID
		with: anInteger!

keyDown: noteNum velocity: velocity 
	^self 
		keyDown: noteNum
		velocity: velocity
		channel: 0!

keyDown: noteNum velocity: velocity channel: channel 
	^self 
		channel: channel
		msg: MidiChannelNoteOn
		with: noteNum
		with: velocity!

keyUp: noteNum 
	^self keyUp: noteNum channel: 0!

keyUp: noteNum channel: channel 
	^self 
		channel: channel
		msg: MidiChannelNoteOff
		with: noteNum
		with: 0!

openDeviceID: deviceID 
	handle := DWORDBytes new.
	^WinMMLibrary default 
		midiOutOpenLphmo: handle
		uDeviceID: deviceID
		dwCallback: nil
		dwCallbackInstance: nil
		dwFlags: nil!

voice: voiceID channel: channel 
	^self 
		channel: channel
		msg: MidiProgramChange
		with: voiceID
		with: channel! !
!MIDIOut categoriesFor: #channel:msg:with:with:!public! !
!MIDIOut categoriesFor: #close!public! !
!MIDIOut categoriesFor: #controller:value:!public! !
!MIDIOut categoriesFor: #keyDown:velocity:!public! !
!MIDIOut categoriesFor: #keyDown:velocity:channel:!public! !
!MIDIOut categoriesFor: #keyUp:!public! !
!MIDIOut categoriesFor: #keyUp:channel:!public! !
!MIDIOut categoriesFor: #openDeviceID:!public! !
!MIDIOut categoriesFor: #voice:channel:!public! !

