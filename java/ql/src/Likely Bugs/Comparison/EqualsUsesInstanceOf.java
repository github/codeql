class BadPoint {
    int x;
    int y;

    BadPoint(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public boolean equals(Object o) {
        if(!(o instanceof BadPoint))
            return false;
        BadPoint q = (BadPoint)o;
        return x == q.x && y == q.y;
    }
}

class BadPointExt extends BadPoint {
    String s;

    BadPointExt(int x, int y, String s) {
        super(x, y);
        this.s = s;
    }

    // violates symmetry of equals contract
    public boolean equals(Object o) {
        if(!(o instanceof BadPointExt)) return false;
        BadPointExt q = (BadPointExt)o;
        return super.equals(o) && (q.s==null ? s==null : q.s.equals(s));
    }
}

class GoodPoint {
    int x;
    int y;

    GoodPoint(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public boolean equals(Object o) {
        if (o != null && getClass() == o.getClass()) {
            GoodPoint q = (GoodPoint)o;
            return x == q.x && y == q.y;
        }
        return false;
    }
}

class GoodPointExt extends GoodPoint {
    String s;

    GoodPointExt(int x, int y, String s) {
        super(x, y);
        this.s = s;
    }

    public boolean equals(Object o) {
        if (o != null && getClass() == o.getClass()) {
            GoodPointExt q = (GoodPointExt)o;
            return super.equals(o) && (q.s==null ? s==null : q.s.equals(s));
        }
        return false;
    }
}

BadPoint p = new BadPoint(1, 2);
BadPointExt q = new BadPointExt(1, 2, "info");
