class Point {
	private double x, y;
	
	public Point(double x, double y) {
		this.x = x;
		this.y = y;
	}
	
	@Override
	public String toString() {
		StringBuffer res = new StringBuffer('(');
		res.append(x);
		res.append(", ");
		res.append(y);
		res.append(')');
		return res.toString();
	}
}
