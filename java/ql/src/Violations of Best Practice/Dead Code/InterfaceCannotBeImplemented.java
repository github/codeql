interface I {
    int clone();
}

class C implements I {
    public int clone() {
        return 23;
    }
}