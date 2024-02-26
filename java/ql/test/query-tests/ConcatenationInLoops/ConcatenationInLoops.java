public class ConcatenationInLoops {
	private String cs = "";

	public static void main(String[] args) {
		// Random r = 42;
		long start = System.currentTimeMillis();
		String s = "";
		for (int i = 0; i < 65536; i++)
			s += 42;  // $ loopConcat=s 
		System.out.println(System.currentTimeMillis() - start);  // This prints roughly 4500.

		// r = 42;
		start = System.currentTimeMillis();
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < 65536; i++)
			sb.append(42);//r.nextInt(2));
		s = sb.toString();
		System.out.println(System.currentTimeMillis() - start);  // This prints 5.


		String s2 = "";
		for (int i = 0; i < 65536; i++)
			if (i > 10) {
				s += 42; // Will only be executed once.
				break;
			}

		String s3 = "";
		for (int i = 0; i < 65536; i++)
			for (int j = 0; i < 65536; i++)
				if (j > 10) {
					s += 42; // $ loopConcat=s
					break;
				}
	}

	public void test(int bound) {
		if (bound > 0) {
			cs += "a";   // $ loopConcat=cs
			test(bound - 1);
		} 
	}
}