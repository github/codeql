
struct S {
   S() : x() { static_cast<const int>(x); }
   int x;
} s;

