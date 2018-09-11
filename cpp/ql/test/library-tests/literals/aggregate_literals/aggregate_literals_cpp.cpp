struct StructWithBitfields {
    void Method();

    unsigned int a : 12;

    static int s;  // Static member variables aren't initialized

    unsigned int b : 5;
    unsigned int : 15;  // Unnamed bitfields aren't initialized
    unsigned int c : 7;
};

union UnionWithMethods {
    void Method();

    static int s;

    double d;
    int x;
};

void Init(int x, int y, int z) {
    StructWithBitfields s1 = { x, y, z };
    StructWithBitfields s2 = { x, y };  // s2.c is value initialized
    StructWithBitfields s3 = {};        // s3   is value initialized
    UnionWithMethods u1 = { x };
    UnionWithMethods u2 = {};
}
