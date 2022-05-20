public class DubiousDowncastOfThis {
	private static class BadBase {
		private Derived d;

		public BadBase(Derived d) {
			if(d != null && this instanceof Derived)
				this.d = (Derived)this;		// violation
			else
				this.d = d;
		}
	}

	private static class Derived extends BadBase {
		public Derived() {
			super(null);
		}
	}

	public static void main(String[] args) {}
}