package return_value_ignored;

interface I {
	I setI(int i);
}

public class Test implements I {
	private int i;
	
	public Test(int i) {
		this.i = i;
	}
	
	public int getI() {
		return i;
	}
	
	public Test setI(int i) {
		this.i = i;
		return this;
	}
	
	public static void main(String[] args) {
		Test test1 = new Test(23);
		Test test2 = new Test(42);
		Test test3 = new Test(56);
		
		// test getter; should flag last call
		int foo;
		foo = test1.getI();
		foo = test2.getI();
		foo = test3.getI();
		foo = test1.getI();
		foo = test2.getI();
		foo = test3.getI();
		foo = test1.getI();
		foo = test2.getI();
		foo = test3.getI();
		foo = test1.getI();
		foo = test2.getI();
		test3.getI();
		
		// test setter; shouldn't flag last call
		Test test;
		test = test1.setI(24);
		test = test2.setI(43);
		test = test3.setI(57);
		test = test1.setI(24);
		test = test2.setI(43);
		test = test3.setI(57);
		test = test1.setI(24);
		test = test2.setI(43);
		test = test3.setI(57);
		test = test1.setI(24);
		test = test2.setI(43);
		test3.setI(57);
		
		// same for call through interface
		I i1 = test1;
		I i2 = test2;
		I i3 = test3;
		I i;
		i = i1.setI(24);
		i = i2.setI(43);
		i = i3.setI(57);
		i = i1.setI(24);
		i = i2.setI(43);
		i = i3.setI(57);
		i = i1.setI(24);
		i = i2.setI(43);
		i = i3.setI(57);
		i = i1.setI(24);
		i = i2.setI(43);
		i3.setI(57);
		
		// should flag last call to String.trim
		String s = "Hi! ", t;
		t = s.trim();
		t = s.trim();
		t = s.trim();
		t = s.trim();
		t = s.trim();
		t = s.trim();
		t = s.trim();
		t = s.trim();
		t = s.trim();
		t = s.trim();
		t = s.trim();
		s.trim();
	}
}
