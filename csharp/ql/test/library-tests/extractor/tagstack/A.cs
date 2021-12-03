// semmle-extractor-options: --separate-compilation /out:test.dll

class C
{
    object M1() { M2(); M2(); return null; }
    void M2() { }
}
