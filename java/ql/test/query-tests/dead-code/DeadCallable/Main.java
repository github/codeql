public class Main { // $ Alert
	private static String ss = "a";
	private static String ss2 = "b";
	private final String is = "a";
	private final String is2 = "b";
	
	private void unused() { // $ Alert
		indirectlyUnused();
	}
	
	private void indirectlyUnused() {} // $ Alert

	private void foo() { bar(); } // $ Alert
	private void bar() { foo(); } // $ Alert

	public static void main(String[] args) {}
}
