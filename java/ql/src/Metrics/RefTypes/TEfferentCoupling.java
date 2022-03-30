class X {
    public void iUseY(Y y) {
        y.doStuff();
    }

    public Y soDoY() {
        return new Y();
    }

    public Z iUseZ(Z z1, Z z2) {
        return z1.combine(z2);
    }
}