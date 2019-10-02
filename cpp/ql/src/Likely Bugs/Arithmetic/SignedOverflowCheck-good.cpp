bool bar(int n1, unsigned int delta) {
    return n1 + delta < n1; // GOOD
}
