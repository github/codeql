class AlsoGood {
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
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		return checkEquality(this, obj);
	}

	private static boolean checkEquality(AlsoGood thiz, Object obj) {
		if (thiz.getClass() != obj.getClass())
			return false;
		AlsoGood that = (AlsoGood)obj;
		if (thiz.data != that.data)
			return false;
		return true;
	}
}

class Good2 extends Good2Super<Object> {
	private int data;
	@Override
	public int getData() { return data; }

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + getData();
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		return checkEquality(obj);
	}
}

abstract class Good2Super<T>  {
	protected abstract int getData();

	protected boolean checkEquality(Object obj) {
		if (this.getClass() != obj.getClass())
			return false;
		Good2Super that = (Good2Super)obj;
		if (this.getData() != that.getData())
			return false;
		return true;
	}
}
