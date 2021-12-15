class StringComparison {
	
	private static final String CONST = "foo";
	
	public void test(String param) {
		String variable = "hello";
		variable = param;
		String variable2 = "world";
		variable2 += "it's me";
		// OK
		if("" == "a")
			return;
		// OK
		if("" == param.intern())
			return;
		// OK
		if("" == CONST)
			return;
		// OK
		if("".equals(variable))
			return;
		// NOT OK
		if("" == variable)
			return;
		// NOT OK
		if("" == param)
			return;
		// NOT OK
		if("" == variable2)
			return;
	}
}
