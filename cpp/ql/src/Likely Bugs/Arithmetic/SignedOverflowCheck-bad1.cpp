bool foo(int n1, unsigned short delta) {
    return n1 + delta < n1; // BAD
}
