// semmle-extractor-options: --separate-compilation /out:test.dll

class C
{
    D M1() { M3(); return null; }
    void M3() { }
}

class D
{
}
