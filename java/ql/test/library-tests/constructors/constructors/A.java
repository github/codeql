package constructors;

public class A {
	A() {
		this(42);
	}
	
	A(int i) { }
	
	public static void main(String[] args) {
		new A();
	}

	final static String STATIC = "static string";
	final String INSTANCE = "instance string";

	{
		System.out.println("<obinit>");
	}

	static {
		System.out.println("<clinit>");
	}
}
