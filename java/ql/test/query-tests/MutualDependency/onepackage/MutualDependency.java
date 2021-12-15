package onepackage;

public class MutualDependency {
	static int m = A.a;
	// allow intra-package dependencies
	static class A {
		static int a = m;
	}
	// disallow inter-package dependencies
	public static class B {
		public static int b = otherpackage.OtherClass.c;
	}
}
