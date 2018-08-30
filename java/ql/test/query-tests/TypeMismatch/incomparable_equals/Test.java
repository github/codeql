package incomparable_equals;

public class Test {
	private void assertTrue(boolean b) {
		if(!b)
			throw new AssertionError();
	}
	
	void test() {
		assert !new Integer(1).equals("1");
		assertTrue(!new StringBuffer().equals(""));
	}
}