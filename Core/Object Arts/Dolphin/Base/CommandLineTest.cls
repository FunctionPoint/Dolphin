﻿"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #CommandLineTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CommandLineTest guid: (GUID fromString: '{3a8a3bc5-3ef6-46c1-933b-754c6b06457e}')!
CommandLineTest comment: ''!
!CommandLineTest categoriesForClass!SUnit! !
!CommandLineTest methodsFor!

test_getOpt_01
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine optionChar |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7').
	optionChar := commandLine getOpt: 'abc:'.
	self assertIsNil: optionChar	"No options provided"!

test_getOpt_02
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine x |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' '-b').
	self
		assert: (x := commandLine getOpt: 'abc:') identicalTo: $a;
		assertIsNil: commandLine optArg;
		assert: (commandLine getOpt: 'abc:') identicalTo: $b;
		assertIsNil: commandLine optArg;
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: #('DPRO.img7');
		yourself!

test_getOpt_03
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-ab').
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $a;
		assertIsNil: commandLine optArg;
		assert: (commandLine getOpt: 'abc:') identicalTo: $b;
		assertIsNil: commandLine optArg;
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: #('DPRO.img7');
		yourself!

test_getOpt_04
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-c' 'foo').
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $c;
		assert: commandLine optArg equals: 'foo';
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: #('DPRO.img7');
		yourself!

test_getOpt_05
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-cfoo').
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $c;
		assert: commandLine optArg equals: 'foo';
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: #('DPRO.img7');
		yourself!

test_getOpt_06
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' 'arg1').
	self
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: #('DPRO.img7' 'arg1');
		yourself!

test_getOpt_07
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' 'arg1').
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $a;
		assertIsNil: commandLine optArg;
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: #('DPRO.img7' 'arg1');
		yourself!

test_getOpt_08
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-c' 'foo' 'arg1').
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $c;
		assert: commandLine optArg equals: 'foo';
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: #('DPRO.img7' 'arg1');
		yourself!

test_getOpt_09
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' '--' '-b').
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $a;
		assertIsNil: commandLine optArg;
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: #('DPRO.img7' '-b');
		yourself!

test_getOpt_10
	"http://www.gnu.org/software/libc/manual/html_node/Example-of-Getopt.html"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' '-').
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $a;
		assertIsNil: commandLine optArg;
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: #('DPRO.img7' '-');
		yourself!

test_getOpt_11
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html
	Unexected option"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-x').
	self
		assert: (commandLine getOpt: 'abc:') identicalTo: $?;
		assert: commandLine optOpt equals: $x;
		assertIsNil: commandLine optArg;
		assertIsNil: (commandLine getOpt: 'abc:');
		should: [commandLine arguments] raise: CommandLineError;
		yourself!

test_getOpt_12
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html
	Missing required option argument"

	| commandLine x |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-c').
	self
		assert: (x := commandLine getOpt: 'abc:') identicalTo: $?;
		assert: commandLine optOpt equals: $c;
		assertIsNil: commandLine optArg;
		assertIsNil: (commandLine getOpt: 'abc:');
		should: [commandLine arguments] raise: CommandLineError;
		yourself!

test_getOpt_13
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html
	Missing optional option argument"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-c').
	self
		assert: (commandLine getOpt: 'abc::') identicalTo: $c;
		assertIsNil: commandLine optOpt;
		assertIsNil: commandLine optArg;
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: #('DPRO.img7');
		yourself!

test_getOpt_14
	"http://www.gnu.org/software/libc/manual/html_node/Using-Getopt.html
	Double dash indicates to treat remainder as arguments, not options"

	| commandLine |
	commandLine := CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--' '-a' '-b' '-c').
	self
		assertIsNil: (commandLine getOpt: 'abc:');
		assert: commandLine arguments equals: #('DPRO.img7' '-a' '-b' '-c');
		yourself!

testAccessors
	| commandLine options arguments |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-a' '-b' '-c' 'foo' 'bar'))
				options: 'abc:';
				yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self
		assert: options class identicalTo: Dictionary;
		assert: options keys asSortedCollection asArray equals: #($a $b $c);
		assertIsNil: (options at: $a);
		assertIsNil: (options at: $b);
		assert: (options at: $c) equals: 'foo';
		assert: arguments equals: #('DPRO.img7' 'bar');
		yourself!

testBlockNoArgument

	| foundFoo |
	foundFoo := false.
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' 'bar'))
		addOption: 'foo' whenPresentDo: [foundFoo := true];
		processOptions.
	self assert: foundFoo.
!

testBlockOptionalArgumentAbsent
	| fooValue barValue |
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' '--bar'))
		addOptionAllowingArgument: 'foo' whenPresentDo: [:value | fooValue := value];
		addOptionAllowingArgument: 'bar' whenPresentDo: [:value | barValue := value];
		processOptions.
	self
		assertIsNil: fooValue;
		assertIsNil: barValue;
		yourself!

testBlockOptionalArgumentPresent
	| fooValue |
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' 'bar'))
		addOptionAllowingArgument: 'foo' whenPresentDo: [:value | fooValue := value];
		processOptions.
	self assert: fooValue equals: 'bar'!

testBlockRequiredArgumentPresent
	| fooValue |
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' 'bar'))
		addOptionRequiringArgument: 'foo' whenPresentDo: [:value | fooValue := value];
		processOptions.
	self assert: fooValue equals: 'bar'!

testLongAmbiguousOption

	| commandLine |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--a'))
		addOption: 'aa';
		addOption: 'ab';
		yourself.
	self 
		should: [commandLine options]
			raise: CommandLineError;
		should: [commandLine arguments]
			raise: CommandLineError;
		yourself.
!

testLongEquals
	| commandLine options arguments |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo=bar'))
				addOptionRequiringArgument: 'foo';
				yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self
		assert: options class identicalTo: Dictionary;
		assert: options keys asSortedCollection asArray equals: #('foo');
		assert: (options at: 'foo') equals: 'bar';
		assert: arguments equals: #('DPRO.img7');
		yourself!

testLongMissingRequiredArgument

	| commandLine |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo'))
		addOptionRequiringArgument: 'foo';
		yourself.
	self 
		should: [commandLine options]
			raise: CommandLineError;
		should: [commandLine arguments]
			raise: CommandLineError;
		yourself.
!

testLongNoArgument
	| commandLine options arguments |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' 'bar'))
				addOption: 'foo';
				yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self
		assert: options class identicalTo: Dictionary;
		assert: options keys asSortedCollection asArray equals: #('foo');
		assertIsNil: (options at: 'foo');
		assert: arguments equals: #('DPRO.img7' 'bar');
		yourself!

testLongOptionalArgumentAbsent
	| commandLine options arguments |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' '--bar'))
				addOptionAllowingArgument: 'foo';
				addOptionAllowingArgument: 'bar';
				yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self
		assert: options class identicalTo: Dictionary;
		assert: options keys asSortedCollection asArray equals: #('bar' 'foo');
		assertIsNil: (options at: 'bar');
		assertIsNil: (options at: 'foo');
		assert: arguments equals: #('DPRO.img7');
		yourself!

testLongOptionalArgumentPresent
	| commandLine options arguments |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' 'bar'))
				addOptionAllowingArgument: 'foo';
				yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self
		assert: options class identicalTo: Dictionary;
		assert: options keys asSortedCollection asArray equals: #('foo');
		assert: (options at: 'foo') equals: 'bar';
		assert: arguments equals: #('DPRO.img7');
		yourself!

testLongRequiredArgumentPresent
	| commandLine options arguments |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' 'bar'))
				addOptionRequiringArgument: 'foo';
				yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self
		assert: options class identicalTo: Dictionary;
		assert: options keys asSortedCollection asArray equals: #('foo');
		assert: (options at: 'foo') equals: 'bar';
		assert: arguments equals: #('DPRO.img7');
		yourself!

testLongUnexpectedArgument

	| commandLine |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo=bar'))
		addOption: 'foo';
		yourself.
	self 
		should: [commandLine options]
			raise: CommandLineError;
		should: [commandLine arguments]
			raise: CommandLineError;
		yourself.
!

testLongUnexpectedOption

	| commandLine |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--bar'))
		addOptionRequiringArgument: 'foo';
		yourself.
	self 
		should: [commandLine options]
			raise: CommandLineError;
		should: [commandLine arguments]
			raise: CommandLineError;
		yourself.
!

testMissingRequiredArgument

	| commandLine |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-c'))
		options: 'abc:';
		yourself.
	self 
		should: [commandLine options]
			raise: CommandLineError;
		should: [commandLine arguments]
			raise: CommandLineError;
		yourself.
!

testPartialLong
	| commandLine options arguments |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--fo' 'bar'))
				addOptionRequiringArgument: 'foo';
				yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self
		assert: options class identicalTo: Dictionary;
		assert: options keys asSortedCollection asArray equals: #('foo');
		assert: (options at: 'foo') equals: 'bar';
		assert: arguments equals: #('DPRO.img7');
		yourself!

testRepeatBlockOptionalArgumentAbsent
	| fooCount barCount |
	fooCount := 0.
	barCount := 0.
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' '--bar' '--foo'))
		addOptionAllowingArgument: 'foo' whenPresentDo: [:value | fooCount := fooCount + 1];
		addOptionAllowingArgument: 'bar' whenPresentDo: [:value | barCount := barCount + 1];
		processOptions.
	self
		assert: fooCount equals: 2;
		assert: barCount equals: 1;
		yourself!

testRepeatBlockOptionalArgumentPresent
	| fooValue |
	fooValue := ''.
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '--foo' 'bar' '--foo' 'BAR'))
		addOptionAllowingArgument: 'foo' whenPresentDo: [:value | fooValue := fooValue , value];
		processOptions.
	self assert: fooValue equals: 'barBAR'!

testRepeatShortBlockNoArgument
	| fooCount |
	fooCount := 0.
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-f' 'bar' '-f'))
		addOption: $f whenPresentDo: [fooCount := fooCount + 1];
		processOptions.
	self assert: fooCount equals: 2!

testShortBlockNoArgument

	| foundFoo |
	foundFoo := false.
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-f' 'bar'))
		addOption: $f whenPresentDo: [foundFoo := true];
		processOptions.
	self assert: foundFoo.
!

testShortBlockOptionalArgumentAbsent
	| fooValue barValue |
	fooValue := Object new.
	barValue := Object new.
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-f' '-b'))
		addOptionAllowingArgument: $f whenPresentDo: [:value | fooValue := value];
		addOptionAllowingArgument: $b whenPresentDo: [:value | barValue := value];
		processOptions.
	self
		assertIsNil: fooValue;
		assertIsNil: barValue;
		yourself!

testShortBlockRequiredArgumentPresent
	| fooValue |
	(CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-f' 'bar'))
		addOptionRequiringArgument: $f whenPresentDo: [:value | fooValue := value];
		processOptions.
	self assert: fooValue equals: 'bar'!

testSlashPrefix
	| commandLine options arguments |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '/a' '/b' '/c' 'foo' 'bar'))
				options: 'abc:';
				yourself.
	options := commandLine options.
	arguments := commandLine arguments.
	self
		assert: options class identicalTo: Dictionary;
		assert: options keys asSortedCollection asArray equals: #($a $b $c);
		assertIsNil: (options at: $a);
		assertIsNil: (options at: $b);
		assert: (options at: $c) equals: 'foo';
		assert: arguments equals: #('DPRO.img7' 'bar');
		yourself!

testUnrecognizedOption

	| commandLine |
	commandLine := (CommandLine argv: #('Dolphin7.exe' 'DPRO.img7' '-d'))
		options: 'abc:';
		yourself.
	self 
		should: [commandLine options]
			raise: CommandLineError;
		should: [commandLine arguments]
			raise: CommandLineError;
		yourself.
! !
!CommandLineTest categoriesFor: #test_getOpt_01!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_02!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_03!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_04!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_05!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_06!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_07!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_08!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_09!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_10!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_11!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_12!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_13!getopt protocol!public! !
!CommandLineTest categoriesFor: #test_getOpt_14!getopt protocol!public! !
!CommandLineTest categoriesFor: #testAccessors!public! !
!CommandLineTest categoriesFor: #testBlockNoArgument!block!public! !
!CommandLineTest categoriesFor: #testBlockOptionalArgumentAbsent!block!public! !
!CommandLineTest categoriesFor: #testBlockOptionalArgumentPresent!block!public! !
!CommandLineTest categoriesFor: #testBlockRequiredArgumentPresent!block!public! !
!CommandLineTest categoriesFor: #testLongAmbiguousOption!errors!public! !
!CommandLineTest categoriesFor: #testLongEquals!long tests!public! !
!CommandLineTest categoriesFor: #testLongMissingRequiredArgument!errors!public! !
!CommandLineTest categoriesFor: #testLongNoArgument!long tests!public! !
!CommandLineTest categoriesFor: #testLongOptionalArgumentAbsent!long tests!public! !
!CommandLineTest categoriesFor: #testLongOptionalArgumentPresent!long tests!public! !
!CommandLineTest categoriesFor: #testLongRequiredArgumentPresent!long tests!public! !
!CommandLineTest categoriesFor: #testLongUnexpectedArgument!errors!public! !
!CommandLineTest categoriesFor: #testLongUnexpectedOption!errors!public! !
!CommandLineTest categoriesFor: #testMissingRequiredArgument!errors!public! !
!CommandLineTest categoriesFor: #testPartialLong!long tests!public! !
!CommandLineTest categoriesFor: #testRepeatBlockOptionalArgumentAbsent!block!public! !
!CommandLineTest categoriesFor: #testRepeatBlockOptionalArgumentPresent!block!public! !
!CommandLineTest categoriesFor: #testRepeatShortBlockNoArgument!block!public! !
!CommandLineTest categoriesFor: #testShortBlockNoArgument!block!public! !
!CommandLineTest categoriesFor: #testShortBlockOptionalArgumentAbsent!block!public! !
!CommandLineTest categoriesFor: #testShortBlockRequiredArgumentPresent!block!public! !
!CommandLineTest categoriesFor: #testSlashPrefix!public! !
!CommandLineTest categoriesFor: #testUnrecognizedOption!errors!public! !

