public class InconsistentEqualsHashCode {
	private int i = 0;
	public InconsistentEqualsHashCode(int i) {
		this.i = i;
	}

	public int hashCode() {
		return i;
	}
}