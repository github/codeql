x.f() & 0x0A != 0;   // NOT OK
x.f() & (0x0A != 0); // OK
x.f()  &  0x0A != 0; // OK
x.f() & 0x0A!=0;     // OK

x !== y & 1;         // NOT OK

x > 0 & x < 10;      // OK

a&b==c;          // NOT OK
