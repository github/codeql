
public class ExternalDeadCodeCycle {

	/**
	 * This class should be marked as being only used from a dead code cycle, because the dead-code
	 * cycle is external to the class.
	 */
	public static class DeadClass {
		public static void deadMethod() {
		}
	}

	public static void cyclicDeadMethodA() {
		DeadClass.deadMethod();
		cyclicDeadMethodB();
	}

	public static void cyclicDeadMethodB() {
		cyclicDeadMethodA();
	}

	public static void main(String[] args) {
		// Make outer class live.
	}
}
