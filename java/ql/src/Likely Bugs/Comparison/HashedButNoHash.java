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

    // Implement hashCode so that equivalent points (with the same values of x and y) have the
    // same hash code
    public int hashCode() {
        int hash = 7;
        hash = 31*hash + x;
        hash = 31*hash + y;
        return hash;
    }
}
