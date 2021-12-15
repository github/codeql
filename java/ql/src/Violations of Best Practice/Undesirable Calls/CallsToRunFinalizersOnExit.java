void main() {
	// ...
	// BAD: Call to 'runFinalizersOnExit' forces execution of all finalizers on termination of 
	// the runtime, which can cause live objects to transition to an invalid state.
	// Avoid using this method (and finalizers in general).
	System.runFinalizersOnExit(true);
	// ...
}