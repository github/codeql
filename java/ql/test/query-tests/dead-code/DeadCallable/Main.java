public class Main {
	private static String ss = "a";
	private static String ss2 = "b";
	private final String is = "a";
	private final String is2 = "b";
	
	private void unused() {
		indirectlyUnused();
	}
	
	private void indirectlyUnused() {}

	private void foo() { bar(); }
	private void bar() { foo(); }

	public static void main(String[] args) {}
}
