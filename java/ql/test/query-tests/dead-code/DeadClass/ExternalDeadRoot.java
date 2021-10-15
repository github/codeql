
public class ExternalDeadRoot {

	/**
	 * This class should be marked as only being used by the "outerDeadRoot()". The
	 * "innerDeadRoot()" should not be reported as a dead root, as it is internal to the class.
	 */
	public static class DeadClass {
		public static void innerDeadRoot() {
		}

		public static void innerDeadMethod() {
		}
	}

	public static void outerDeadRoot() {
		DeadClass.innerDeadMethod();
	}

	public static void main(String[] args) {
		// Make outer class live.
	}
}
