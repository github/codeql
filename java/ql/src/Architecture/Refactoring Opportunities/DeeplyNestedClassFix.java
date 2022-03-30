class X2 {
	private int i;

	public X2(int i) {
		this.i = i;
	}

	public Y2 makeY2(float j) {
		return new Y2(i, j);
	}
}

class Y2 {
	private int i;
	private float j;

	public Y2(int i, float j) {
		this.i = i;
		this.j = j;
	}

	public Z2 makeZ2(double k) {
		return new Z2(i, j, k);
	}
}

class Z2 {
	private int i;
	private float j;
	private double k;

	public Z2(int i, float j, double k) {
		this.i = i;
		this.j = j;
		this.k = k;
	}

	public void foo() {
		System.out.println(i * j * k);
	}
}

public class NotNestedClass {
	public static void main(String[] args) {
		new X2(23).makeY2(9.0f).makeZ2(84.0).foo();
	}
}