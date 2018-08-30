public class ReflectionTest {

	public static class ParentClass {
		// Not live
		private int notInheritedField;
		// Live because it is accessed through ChildClass
		public int inheritedField;
		// Not live because it is shadowed by the child
		public int shadowedField;
	}

	public static class ChildClass extends ParentClass {
		// Live field, accessed directly
		private int notInheritedField;
		// Live field, accessed directly
		public int shadowedField;
	}

	public static void main(String[] args) {
		// Ensure the two classes are live, otherwise we might hide some results
		new ParentClass();
		new ChildClass();

		ChildClass.class.getDeclaredField("notInheritedField");
		ChildClass.class.getField("inheritedField");
		ChildClass.class.getField("shadowedField");
	}
}
