class Test {
	{
		// OK: calls PrintStream.println(char[])
		System.out.println(new char[] { 'H', 'i' });
		// NOT OK: calls PrintStream.println(Object)
		System.out.println(new byte[0]);
	}
}