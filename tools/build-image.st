"Builds Aquarium.image, as in the packages: run a copy of a fresh Squeak 6.0 image,
named Aquarium.image, with this script, Aquarium.st and mcmFish.morph beside it.
It closes the welcome windows, loads the game, opens it, and saves the image."
| log report |
log := WriteStream on: String new.
report := [FileStream forceNewFileNamed: 'report.txt' do: [:f | f nextPutAll: log contents]].
[(Delay forSeconds: 3) wait.
 Project current addDeferredUIMessage: [
	[[World submorphs do: [:m |
		(m isSystemWindow or: [m class name = #PreferenceWizardMorph]) ifTrue: [m delete]].
	  (FileStream readOnlyFileNamed: 'Aquarium.st') fileIn.
	  ControlPanel new.
	  log nextPutAll: 'built'; cr]
		on: Warning do: [:w | log nextPutAll: 'WARNING: ', w messageText asString; cr. w resume]]
		on: Error do: [:e | log nextPutAll: 'ERROR: ', e description; cr].
	report value.
	Smalltalk snapshot: true andQuit: true]] fork.
