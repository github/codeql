// semmle-extractor-options: --separate-compilation /out:test.dll

class C
{
    object M1() { M3(); return null; }
    void M3() { }
}
