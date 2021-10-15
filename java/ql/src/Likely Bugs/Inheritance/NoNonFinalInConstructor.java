public class Super {
	public Super() {
		init();
	}
	
	public void init() {
	}
}

public class Sub extends Super {
	String s;
	int length;

	public Sub(String s) {
		this.s = s==null ? "" : s;
	}
	
	@Override
	public void init() {
		length = s.length();
	}
}