// BAD: This test case class does not have any valid JUnit 3.8 test methods.
public class TestCaseNoTests38 extends TestCase {
	// This is not a test case because it does not start with 'test'.
	public void simpleTest() {
		//...
	}

	// This is not a test case because it takes two parameters.
	public void testNotEquals(int i, int j) {
		assertEquals(i != j, true);
	}

	// This is recognized as a test, but causes JUnit to fail
	// when run because it is not public.
	void testEquals() {
		//...
	}
}

// GOOD: This test case class correctly declares test methods.
public class MyTests extends TestCase {
	public void testEquals() {
		assertEquals(1, 1);
	}
	public void testNotEquals() {
		assertFalse(1 == 2);
	}
}