using System;

class AssignOp {   
    static void Main() {
        int a = 1;
        int c = 1;
        
        c += a; 
        c -= a;
        c *= a; 
        c /= a;
        c %= a; 
        c <<= 2; 
        c >>= 2; 
        c &= 2; 
        c ^= 2; 
        c |= 2;
    }
}
