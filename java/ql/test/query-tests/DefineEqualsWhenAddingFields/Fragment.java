
public class Fragment {
	private int field;

	// Enforce reference equality
	@Override
	final public boolean equals(Object o) {
		return super.equals(o);
	}

	@Override
	public final int hashCode() {
		return super.hashCode();
	}
}
