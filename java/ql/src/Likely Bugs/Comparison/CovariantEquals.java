class BadPoint {
    int x;
    int y;

    BadPoint(int x, int y) {
        this.x = x;
        this.y = y;
    }

    // overloaded equals method -- should be avoided
    public boolean equals(BadPoint q) {
        return x == q.x && y == q.y;
    }
}

BadPoint p = new BadPoint(1, 2);
Object q = new BadPoint(1, 2);
boolean badEquals = p.equals(q); // evaluates to false

class GoodPoint {
    int x;
    int y;

    GoodPoint(int x, int y) {
        this.x = x;
        this.y = y;
    }

    // correctly overrides Object.equals(Object)
    public boolean equals(Object obj) {
        if (obj != null && getClass() == obj.getClass()) {
            GoodPoint q = (GoodPoint)obj;
            return x == q.x && y == q.y;
        }
        return false;
    }
}

GoodPoint r = new GoodPoint(1, 2);
Object s = new GoodPoint(1, 2);
boolean goodEquals = r.equals(s); // evaluates to true
