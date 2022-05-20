public class ReflectionTest {
	public static class TestObject1 {
		public TestObject1() { }
	}

	public static class TestObject2 {
		public TestObject2() { }
	}

	public static class TestObject3 {
		public TestObject3() { }
	}

	public static class TestObject4 {
		public TestObject4() { }
	}

	public static class TestObject4a extends TestObject4 {
		public TestObject4a() { }
	}

	public static void main(String[] args) throws InstantiationException, IllegalAccessException, ClassNotFoundException {
		// Get class by name
		Class.forName("ReflectionTest$TestObject1").newInstance();
		// Use classloader
		ReflectionTest.class.getClassLoader().loadClass("ReflectionTest$TestObject2").newInstance();
		// Store in variable, load from that
		Class<?> clazz = Class.forName("ReflectionTest$TestObject3");
		clazz.newInstance();
		/*
		 * We cannot determine the class by looking at a String literal, so we should look to the
		 * type - in this case Class<? extends TestObject4>. We should therefore identify both
		 * TestObject4 and TestObject4a as live.
		 */
		getClass4().newInstance();
	}

	public static Class<? extends TestObject4> getClass4() {
		return TestObject4.class;
	}
}
