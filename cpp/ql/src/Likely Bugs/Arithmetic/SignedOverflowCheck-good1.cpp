#include <limits.h>
bool foo(int n1, unsigned short delta) {
    return n1 > INT_MAX - delta; // GOOD
}
