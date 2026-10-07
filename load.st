"Loads the Aquarium into any Squeak (5.3 or later; 3.9 too) and starts it.
Put Aquarium.st and mcmFish.morph beside the image, then evaluate:"

(FileStream readOnlyFileNamed: 'Aquarium.st') fileIn.
ControlPanel new.
