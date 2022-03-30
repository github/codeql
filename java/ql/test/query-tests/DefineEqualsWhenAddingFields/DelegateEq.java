
public class DelegateEq {
	abstract class Super {
		@Override
		public boolean equals(Object obj) {
			if (this == obj) {
				return true;
			}
			if (obj == null || getClass() != obj.getClass()) {
				return false;
			}
			return doEquals((Super)obj);
		}
		abstract boolean doEquals(Super sup);
	}
	class Sub extends Super {
		int i; // OK
		@Override
		boolean doEquals(Super sup) {
			return this.i == ((Sub)sup).i;
		}
	}
}
