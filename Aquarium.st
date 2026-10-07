"Aquarium, a Squeak game by Evgeni Dragoev, 2007. MIT License, see License.txt.

The latest code, of the Subversion commit of 30 March 2008 (the last edit 10 March 2007),
salvaged on 7 October 2026: the classes Fish and ControlPanel, with two changes for Squeak 5,
which work in Squeak 3.9 too: borderWidth: and borderColor: in place of setBorderWidth:borderColor:,
and Fish>>color: answering before the fish has its morph, as Squeak 5 sends color: from initialize.

Start it with: ControlPanel new. It needs mcmFish.morph in the folder of the image."!

TransformationMorph subclass: #Fish
	instanceVariableNames: 'fishID fishMorph direction xStep yStep fishProcess original flipped originalDirection'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Aquarium'!

Object subclass: #ControlPanel
	instanceVariableNames: 'panel fish1 fish2 buttonGrow1 buttonDiet1 buttonRotL1 buttonFlip1 buttonRotR1 buttonMove1 buttonStop1 buttonGrow2 buttonDiet2 buttonRotL2 buttonFlip2 buttonRotR2 buttonMove2 buttonStop2 buttonQuit textInfo'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Aquarium'!

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 1/31/2007 18:11'!
handlesMouseOver: evt
	^ true.! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 1/31/2007 20:45'!
keyboardFocusChange: aBoolean
	aBoolean
		ifTrue: [Transcript show: 'Got Focus'; cr]
		ifFalse: [Transcript show: 'Lost Focus'; cr].! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 1/31/2007 20:30'!
mouseEnter: evt
"	evt hand keyboardFocus: self. "! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 1/31/2007 20:33'!
mouseLeave: evt
"	evt hand releaseKeyboardFocus: self. "! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 1/31/2007 10:46'!
changeDirection	
	originalDirection
			ifTrue: [
					self xStep: (#(3  3  3  3  2  1  0 -1 -2 -3 -3 -3 -3 -3 -3 -3 -2 -1  0  1  2  3  3  3) at: direction).
					self yStep: (#(0  1  2  3  3  3  3  3  3  3  2  1  0 -1 -2 -3 -3 -3 -3 -3 -3 -3 -2 -1) at: direction)]
			ifFalse: [
					self xStep: (#(-3 -3 -3 -3 -2 -1  0  1  2  3  3  3  3  3  3  3  2  1  0 -1 -2 -3 -3 -3) at: direction).
					self yStep: (#( 0 -1 -2 -3 -3 -3 -3 -3 -3 -3 -2 -1  0  1  2  3  3  3  3  3  3  3  2  1) at: direction)].! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 1/31/2007 21:52'!
color: aColor
	"Squeak 5 sends color: from initialize, before the fish has its morph"
	fishMorph ifNil: [^ super color: aColor].
	fishMorph color: aColor.
	(fishMorph submorphs at: 2) color: aColor.
	(fishMorph submorphs at: 3) color: aColor.! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 1/30/2007 19:08'!
direction
	^ direction.! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 1/31/2007 17:48'!
handlesKeyboard: evt
	^ true.! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 1/28/2007 12:55'!
morph
	^ fishMorph! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 1/29/2007 15:57'!
save	
	fishMorph prepareToBeSaved.
	fishMorph saveOnFile.! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 1/28/2007 19:58'!
step: aPoint
	xStep := aPoint x.
	yStep := aPoint y.! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 1/28/2007 20:43'!
xStep
	^ xStep.! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 1/30/2007 14:11'!
xStep: aNumber
	xStep := aNumber.! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 1/28/2007 20:43'!
yStep
	^ yStep.! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 1/30/2007 14:11'!
yStep: aNumber
	yStep := aNumber.! !

!Fish methodsFor: 'private' stamp: 'ed 1/31/2007 19:58'!
saveOriginalAndFlippedVertices
	| index |

	index := 1.
	original := Dictionary new.
	flipped := Dictionary new.

	original at: index put: (fishMorph vertices).
	flipped at: index put: (fishMorph vertices * (Array new: fishMorph vertices size withAll: -1@1)).
	fishMorph submorphs do: [:sub |
		sub class = TextMorph ifFalse: [
			index := index + 1.
			original at: index put: (sub vertices).
			flipped at: index put: (sub vertices * (Array new: sub vertices size withAll: -1@1)).
		].
	].! !

!Fish methodsFor: 'scripting' stamp: 'ed 1/31/2007 19:57'!
flip
	| index |
	original isNil ifTrue: [self saveOriginalAndFlippedVertices].

	index := 1.
	originalDirection
			ifTrue: [fishMorph setVertices: (flipped at: 1)]
			ifFalse: [fishMorph setVertices: (original at: 1)].
	fishMorph submorphs do: [:sub |
		sub class = TextMorph ifFalse: [
			index := index + 1.
			originalDirection
					ifTrue: [sub setVertices: (flipped at: index)]
					ifFalse: [sub setVertices: (original at: index)].
		].
	].
	originalDirection := originalDirection not.
	xStep := xStep negated.
	yStep := yStep negated.! !

!Fish methodsFor: 'nil' stamp: 'ed 2/1/2007 17:43'!
fishProcess
	^ fishProcess.! !

!Fish methodsFor: 'scripting' stamp: 'ed 2/1/2007 17:52'!
stop
	fishProcess suspend.! !

!Fish methodsFor: 'scripting' stamp: 'ed 2/1/2007 17:52'!
move
	fishProcess isSuspended
			ifTrue: [fishProcess resume].! !

!Fish methodsFor: 'nil' stamp: 'ed 2/1/2007 18:06'!
fishID: aNumber
	fishID := aNumber.! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 3/9/2007 15:25'!
grow
	self scale: self scale * 1.05.! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 3/9/2007 16:15'!
diet
	self scale: self scale * 0.95.! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 3/9/2007 19:48'!
keyDown: anEvent
	fishID = 2 ifTrue: [
		anEvent keyCharacter = $j
				ifTrue: [self rotateCounterClockWise].
		anEvent keyCharacter = $J
				ifTrue: [self rotateCounterClockWise].
		anEvent keyCharacter = $k
				ifTrue: [self flip].
		anEvent keyCharacter = $K
				ifTrue: [self flip].
		anEvent keyCharacter = $l
				ifTrue: [self rotateClockWise].
		anEvent keyCharacter = $L
				ifTrue: [self rotateClockWise].
	].! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 3/10/2007 12:00'!
rotateClockWise
	direction := direction + 1.
	direction = 25
			ifTrue: [direction := 1].
	self rotationDegrees: (direction - 1) * 15.
	self changeDirection.! !

!Fish methodsFor: 'as yet unclassified' stamp: 'ed 3/10/2007 12:01'!
rotateCounterClockWise
	direction := direction - 1.
	direction = 0
			ifTrue: [direction := 24].
	self rotationDegrees: (direction - 1) * 15.
	self changeDirection.! !

!Fish methodsFor: 'initialize' stamp: 'ed 3/11/2007 09:46'!
initialize: morphFile
	fishMorph := (FileStream readOnlyFileNamed: morphFile) fileInObjectAndCode.
	fishMorph dropEnabled: false.
	(fishMorph submorphs at: 1) dropEnabled: false.
	self asFlexOf: fishMorph.
	direction := 1.
	originalDirection := true.
	xStep := 3.
	yStep := 0.
	self openInWorld.
	fishProcess := [[
		(World bounds containsPoint: ((self topLeft + self bottomRight) / 2) + (xStep@yStep))
				ifTrue: [self position: self position + (xStep@yStep)]
				ifFalse: [self position: self position - (xStep@yStep). self flip].
				(Delay forMilliseconds: 15) wait.
				fishID = 2
						ifTrue: [ActiveHand ifNotNil: [ActiveHand newKeyboardFocus: self]].
				true.
		] whileTrue.
	] forkAt: Processor userInterruptPriority.! !

!ControlPanel methodsFor: 'nil' stamp: 'ed 2/1/2007 17:41'!
fish1
	^ fish1.! !

!ControlPanel methodsFor: 'as yet unclassified' stamp: 'ed 2/1/2007 17:41'!
fish2
	^ fish2.! !

!ControlPanel methodsFor: 'as yet unclassified' stamp: 'ed 3/9/2007 19:45'!
initialize
	" ScreenController new fullScreenOn. "
	panel := RectangleMorph new openInWorld.
	panel color: ((Color palePeach) alpha: 0.5).
	panel extent: 430@115.
	panel useRoundedCorners.
	panel borderWidth: 2; borderColor: (Color r: 0.0 g: 0.419 b: 0.935).

	textInfo := TextMorph new.
	textInfo string: 'j     k     l' fontName: 'BitstreamVeraMono' size: 16.
	textInfo position: 130@60.
	textInfo width: 120.

	buttonGrow1 := SimpleButtonMorph new
			label: 'Grow';
			position: 10@10;
			useRoundedCorners;
			color: (Color r: 1.0 g: 1.0 b: 0.7);
			yourself.

	buttonGrow2 := SimpleButtonMorph new
			label: 'Grow';
			position: 10@80;
			useRoundedCorners;
			color: Color paleBlue;
			yourself.

	buttonDiet1 := SimpleButtonMorph new
			label: 'Diet';
			position: 60@10;
			useRoundedCorners;
			color: (Color r: 1.0 g: 1.0 b: 0.7);
			yourself.

	buttonDiet2 := SimpleButtonMorph new
			label: 'Diet';
			position: 60@80;
			useRoundedCorners;
			color: Color paleBlue;
			yourself.

	buttonRotL1 := SimpleButtonMorph new
			label: '<<--';
			position: 110@10;
			useRoundedCorners;
			color: (Color r: 1.0 g: 1.0 b: 0.7);
			yourself.

	buttonRotL2 := SimpleButtonMorph new
			label: '<<--';
			position: 110@80;
			useRoundedCorners;
			color: Color paleBlue;
			yourself.

	buttonFlip1 := SimpleButtonMorph new
			label: 'Flip';
			position: 160@10;
			useRoundedCorners;
			color: (Color r: 1.0 g: 1.0 b: 0.7);
			yourself.

	buttonFlip2 := SimpleButtonMorph new
			label: 'Flip';
			position: 160@80;
			useRoundedCorners;
			color: Color paleBlue;
			yourself.

	buttonRotR1 := SimpleButtonMorph new
			label: '-->>';
			position: 210@10;
			useRoundedCorners;
			color: (Color r: 1.0 g: 1.0 b: 0.7);
			yourself.

	buttonRotR2 := SimpleButtonMorph new
			label: '-->>';
			position: 210@80;
			useRoundedCorners;
			color: Color paleBlue;
			yourself.
	
	buttonMove1 := SimpleButtonMorph new
			label: 'Move';
			position: 260@10;
			useRoundedCorners;
			color: (Color r: 1.0 g: 1.0 b: 0.7);
			yourself.

	buttonMove2 := SimpleButtonMorph new
			label: 'Move';
			position: 260@80;
			useRoundedCorners;
			color: Color paleBlue;
			yourself.

	buttonStop1 := SimpleButtonMorph new
			label: 'Stop';
			position: 310@10;
			useRoundedCorners;
			color: (Color r: 1.0 g: 1.0 b: 0.7);
			yourself.

	buttonStop2 := SimpleButtonMorph new
			label: 'Stop';
			position: 310@80;
			useRoundedCorners;
			color: Color paleBlue;
			yourself.

	buttonQuit := SimpleButtonMorph new
			label: 'Quit';
			position: 370@80;
			useRoundedCorners;
			color: Color paleRed;
			yourself.

	panel
			addMorph: textInfo;
			addMorph: buttonGrow1;
			addMorph: buttonGrow2;
			addMorph: buttonDiet1;
			addMorph: buttonDiet2;
			addMorph: buttonRotL1;
			addMorph: buttonRotL2;
			addMorph: buttonFlip1;
			addMorph: buttonFlip2;
			addMorph: buttonRotR1;
			addMorph: buttonRotR2;
			addMorph: buttonMove1;
			addMorph: buttonMove2;
			addMorph: buttonStop1;
			addMorph: buttonStop2;
			addMorph: buttonQuit;
			yourself.

	panel position: 500@300.
	
	fish1 := Fish new initialize: 'mcmFish.morph'.
	fish1 fishID: 1.
	fish1 position: 100@200.
	fish1 color: (Color r: 1.0 g: 1.0 b: 0.7).
	
	fish2 := Fish new initialize: 'mcmFish.morph'.
	fish2 fishID: 2.
	fish2 position: 300@400.

	buttonGrow1 target: fish1; actionSelector: #grow.
	buttonGrow2 target: fish2; actionSelector: #grow.
	buttonDiet1 target: fish1; actionSelector: #diet.
	buttonDiet2 target: fish2; actionSelector: #diet.
	buttonRotL1 target: fish1; actionSelector: #rotateCounterClockWise.
	buttonRotL2 target: fish2; actionSelector: #rotateCounterClockWise.
	buttonFlip1 target: fish1; actionSelector: #flip.
	buttonFlip2 target: fish2; actionSelector: #flip.
	buttonRotR1 target: fish1; actionSelector: #rotateClockWise.
	buttonRotR2 target: fish2; actionSelector: #rotateClockWise.
	buttonMove1 target: fish1; actionSelector: #move.
	buttonMove2 target: fish2; actionSelector: #move.
	buttonStop1 target: fish1; actionSelector: #stop.
	buttonStop2 target: fish2; actionSelector: #stop.
	buttonQuit target: (SmalltalkImage current); actionSelector: #snapshot:andQuit:; arguments: #(false true).! !
