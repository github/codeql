class Test {
	public static void main(String[] args) {
		// Relative paths
		Runtime.getRuntime().exec("make");
		Runtime.getRuntime().exec("m");
		Runtime.getRuntime().exec(new String[] { "make" });
		Runtime.getRuntime().exec("c:make");
		Runtime.getRuntime().exec("make " + args[0]);

		// Absolute paths
		Runtime.getRuntime().exec("/usr/bin/make");
		Runtime.getRuntime().exec("bin/make");
		Runtime.getRuntime().exec("\\Program Files\\Gnu Make\\Bin\\Make.exe");
		Runtime.getRuntime().exec(new String[] { "/usr/bin/make" });
		Runtime.getRuntime().exec("c:\\make");
		Runtime.getRuntime().exec("/usr/bin/make " + args[0]);
	}
}
