class YX {
    public void iUseY(Y y) {
        y.doStuff();
    }

    public Y soDoY() {
        return new Y();
    }
}

class ZX {
    public Z iUseZ(Z z1, Z z2) {
        return z1.combine(z2);
    }
}