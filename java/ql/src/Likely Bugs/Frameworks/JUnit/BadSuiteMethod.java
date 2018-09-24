public class BadSuiteMethod extends TestCase {
	// BAD: JUnit 3.8 does not detect the following method as a 'suite' method.
	// The method should be public, static, and return 'junit.framework.Test' 
	// or one of its subtypes.
	static Test suite() {
		TestSuite suite = new TestSuite();
		suite.addTest(new MyTests("testEquals"));
		suite.addTest(new MyTests("testNotEquals"));
		return suite;
	}
}

public class CorrectSuiteMethod extends TestCase {
	// GOOD: JUnit 3.8 correctly detects the following method as a 'suite' method.
	public static Test suite() {
		TestSuite suite = new TestSuite();
		suite.addTest(new MyTests("testEquals"));
		suite.addTest(new MyTests("testNotEquals"));
		return suite;
	}
}