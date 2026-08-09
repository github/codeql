public class Test {
	@Deprecated
	void m() {}
	
	@Deprecated
	void n() {
		// OK
		m();
	}
	
	{
		// NOT OK
		m(); // $ Alert
	}
	
	public static void main(String[] args) {
		// NOT OK
		new Test().n(); // $ Alert
	}
}
