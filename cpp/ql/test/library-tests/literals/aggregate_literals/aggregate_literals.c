struct someStruct { 
    int i; 
    int j; 
}; 

struct someOtherStruct {
    int a;
    int b;
};

union someUnion {
    int n;
    double d;
};

void f(int x, int y) { 
    struct someStruct sInit1 = { 
        .i = x + x, 
        .j = y - y, 
    }; 

    struct someStruct sInit2 = { x + x, y - y }; 

    struct someStruct ss[] = {{x + x, y - y}, {x * x, y / y}}; 

    struct someStruct sInit3 = { x };

//    struct someStruct sInit4 = { .j = y };  Currently fails. Initializes 'i' with 'y' as well.

    int aInit1[2] = { x, y };

    int aInit2[2] = { x };

//    int aInit3[2] = { [1] = y };  Currently fails. Initializes [0] with 'y' as well.

    union someUnion uInit1 = { x };
//    union someUnion uInit2 = { .n = x };  Currently fails. Initializes .d with 'x' as well.
//    union someUnion uInit3 = { .d = 5.0 };  Currently fails. Initializes .n with '5.0' as well.
}
