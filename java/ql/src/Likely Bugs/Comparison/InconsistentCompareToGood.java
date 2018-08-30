public class InconsistentCompareToFix implements Comparable<InconsistentCompareToFix> {
	private int i = 0;
	public InconsistentCompareToFix(int i) {
		this.i = i;
	}
	
	public int compareTo(InconsistentCompareToFix rhs) {
		return i - rhs.i;
	}

	public boolean equals(InconsistentCompareToFix rhs) {
		return i == rhs.i;
	}
}