class Point {
    int x;
    int y;

    Point(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public boolean equals(Object o) {
    	if (!(o instanceof Point)) return false;
    	Point q = (Point)o;
    	return x == q.x && y == q.y;
    }
}