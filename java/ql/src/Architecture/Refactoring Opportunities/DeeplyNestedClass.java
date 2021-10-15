class X1 {
	private int i;

	public X1(int i) {
		this.i = i;
	}

	public Y1 makeY1(float j) {
		return new Y1(j);
	}

	class Y1 {
		private float j;

		public Y1(float j) {
			this.j = j;
		}

		public Z1 makeZ1(double k) {
			return new Z1(k);
		}

		// Violation
		class Z1 {
			private double k;

			public Z1(double k) {
				this.k = k;
			}

			public void foo() {
				System.out.println(i * j * k);
			}
		}
	}
}
public class DeeplyNestedClass {
	public static void main(String[] args) {
		new X1(23).makeY1(9.0f).makeZ1(84.0).foo();
	}
}