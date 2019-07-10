import csharp

class Locatable extends Element {
	
}

class ArrayInitWithMod extends ArrayInitializer {
	predicate isInitialized(int entry) {
		entry in [0..this.getNumberOfElements() - 1]
	}
	
	predicate isValueInitialized(int entry) {
		isInitialized(entry) and
		not exists()
	}
}