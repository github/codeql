public class MissedTernaryOpportunity {
	private static int myAbs1(int x) {
		// Violation
		if(x >= 0)
			return x;
		else
			return -x;
	}

	private static int myAbs2(int x) {
		// Better
		return x >= 0 ? x : -x;
	}

	public static void main(String[] args) {
		int i = 23;

		// Violation
		String s1;
		if(i == 23)
			s1 = "Foo";
		else
			s1 = "Bar";
		System.out.println(s1);

		// Better
		String s2 = i == 23 ? "Foo" : "Bar";
		System.out.println(s2);
	}
}