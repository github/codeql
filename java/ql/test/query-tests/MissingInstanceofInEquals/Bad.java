class Bad {
	private int data;

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + data;
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		Bad other = (Bad) obj;
		if (data != other.data)
			return false;
		return true;
	}
}