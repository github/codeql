/**
 * This class should be marked as entirely unused.
 */
public class InternalDeadCodeCycle { // $ Alert

	public void foo() {
		bar();
	}

	public void bar() {
		foo();
	}
}
