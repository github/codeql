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
		m();
	}
	
	public static void main(String[] args) {
		// NOT OK
		new Test().n();
	}
}