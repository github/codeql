bool baz(int n1, int delta) {
    return (unsigned)n1 + delta < n1; // GOOD
}
