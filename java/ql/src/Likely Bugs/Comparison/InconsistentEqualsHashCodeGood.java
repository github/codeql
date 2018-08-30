public class InconsistentEqualsHashCodeFix {
	private int i = 0;
	public InconsistentEqualsHashCodeFix(int i) {
		this.i = i;
	}

	@Override
	public int hashCode() {
		return i;
	}

	@Override
	public boolean equals(Object obj) {
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		InconsistentEqualsHashCodeFix that = (InconsistentEqualsHashCodeFix) obj;
		return this.i == that.i;
	}
}