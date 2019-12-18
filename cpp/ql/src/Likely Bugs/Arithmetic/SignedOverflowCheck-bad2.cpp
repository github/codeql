bool bar(unsigned short n1, unsigned short delta) {
    // NB: Comparison is always false
    return n1 + delta < n1; // GOOD (but misleading)
}
