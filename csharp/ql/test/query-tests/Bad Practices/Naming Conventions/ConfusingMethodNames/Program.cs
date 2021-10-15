class C1
{
    int F() => 0;       // BAD: Confusing
    int f() => 0;
    int G() => 0;       // GOOD: Same name
    int G(int x) => x;
}

class C2
{
    int f() => 0;       // GOOD
    int G() => 0;       // GOOD
    int G(int x) => x;  // GOOD
}
