public class InconsistentCompareTo implements Comparable<InconsistentCompareTo> {
	private int i = 0;
	public InconsistentCompareTo(int i) {
		this.i = i;
	}
	
	public int compareTo(InconsistentCompareTo rhs) {
		return i - rhs.i;
	}
}