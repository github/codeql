class Super {
	protected int myInt = 1;
	
	public boolean equals(Object other) {
		if (other == null)
			return false;
		if (other.getClass() != getClass())
			return false;
		if (myInt != ((Super)other).myInt)
			return false;
		return true;
	}
	
	public int hashCode() {
		return myInt;
	}
}

class NoEquals extends Super {
	// BAD
	public int hashCode() {
		return myInt+1;
	}
}

class NoHashCode extends Super {
	// BAD
	public boolean equals(Object other) {
		return true;
	}
}

class RefiningEquals extends Super {
	protected long myLong = 1;

	// OK: a finer equals than the supertype equals, so the hash code is still valid
	public boolean equals(Object other) {
		return (super.equals(other) && myLong == ((RefiningEquals)other).myLong);
	}
}