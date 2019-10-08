bool bar(unsigned short n1, unsigned short delta) {
    return n1 + delta < n1; // BAD
}
