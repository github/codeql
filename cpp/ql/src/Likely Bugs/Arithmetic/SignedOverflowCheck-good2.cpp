bool bar(unsigned short n1, unsigned short delta) {
    return (unsigned short)(n1 + delta) < n1; // GOOD
}
