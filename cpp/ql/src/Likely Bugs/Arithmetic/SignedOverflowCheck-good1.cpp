bool baf(unsigned short n1, unsigned short delta) {
    return n1 + (unsigned)delta < n1; // GOOD
}
