public class InternalDeadCodeCycle {

	public void foo() {
		bar();
	}

	public void bar() {
		foo();
	}

	public static void main(String[] args) {
		// Ensure the class is live, otherwise the dead methods will not be reported.
	}
}
