enum MY_ENUM {
    A = 0x1, // $ nonFunctionalNrOfBounds
    B = 0x2, // $ nonFunctionalNrOfBounds
    C = 0x4, // $ nonFunctionalNrOfBounds
    D = 0x8, // $ nonFunctionalNrOfBounds
    E = 0x10, // $ nonFunctionalNrOfBounds
    F = 0x20, // $ nonFunctionalNrOfBounds
    G = 0x40, // $ nonFunctionalNrOfBounds
    H = 0x80, // $ nonFunctionalNrOfBounds
    I = 0x100, // $ nonFunctionalNrOfBounds
    J = 0x200, // $ nonFunctionalNrOfBounds
    L = 0x400, // $ nonFunctionalNrOfBounds
    M = 0x800, // $ nonFunctionalNrOfBounds
    N = 0x1000, // $ nonFunctionalNrOfBounds
    O = 0x2000, // $ nonFunctionalNrOfBounds
    P = 0x4000, // $ nonFunctionalNrOfBounds
    Q = 0x8000, // $ nonFunctionalNrOfBounds
    R = 0x10000, // $ nonFunctionalNrOfBounds
    S = 0x20000, // $ nonFunctionalNrOfBounds
    T = 0x40000, // $ nonFunctionalNrOfBounds
    U = 0x80000, // $ nonFunctionalNrOfBounds
    V = 0x100000, // $ nonFunctionalNrOfBounds
    W = 0x200000, // $ nonFunctionalNrOfBounds
    X = 0x400000, // $ nonFunctionalNrOfBounds
    Y = 0x800000, // $ nonFunctionalNrOfBounds
    Z = 0x1000000, // $ nonFunctionalNrOfBounds
    AA = 0x2000000, // $ nonFunctionalNrOfBounds
    AB = 0x4000000, // $ nonFunctionalNrOfBounds
    AC = 0x8000000, // $ nonFunctionalNrOfBounds
    AD = 0x10000000, // $ nonFunctionalNrOfBounds
    AE = 0x20000000 // $ nonFunctionalNrOfBounds
};

typedef unsigned int MY_ENUM_FLAGS;

MY_ENUM_FLAGS check_and_subs(MY_ENUM_FLAGS x)
{

    #define CHECK_AND_SUB(flag) if ((x & flag) == flag) { x -= flag; }
    CHECK_AND_SUB(A); // $ nonFunctionalNrOfBounds
    CHECK_AND_SUB(B); // $ nonFunctionalNrOfBounds
    CHECK_AND_SUB(C); // $ nonFunctionalNrOfBounds
    CHECK_AND_SUB(D); // $ nonFunctionalNrOfBounds
    CHECK_AND_SUB(E); // $ nonFunctionalNrOfBounds
    CHECK_AND_SUB(F); // $ nonFunctionalNrOfBounds
    CHECK_AND_SUB(G); // $ nonFunctionalNrOfBounds
    // CHECK_AND_SUB(H);
    // CHECK_AND_SUB(I);
    // CHECK_AND_SUB(J);
    // CHECK_AND_SUB(L);
    // CHECK_AND_SUB(M);
    // CHECK_AND_SUB(N);
    // CHECK_AND_SUB(O);
    // CHECK_AND_SUB(P);
    // CHECK_AND_SUB(Q);
    // CHECK_AND_SUB(R);
    // CHECK_AND_SUB(S);
    // CHECK_AND_SUB(T);
    // CHECK_AND_SUB(U);
    // CHECK_AND_SUB(V);
    // CHECK_AND_SUB(W);
    // CHECK_AND_SUB(X);
    // CHECK_AND_SUB(Y);
    // CHECK_AND_SUB(Z);
    // CHECK_AND_SUB(AA);
    // CHECK_AND_SUB(AB);
    // CHECK_AND_SUB(AC);
    // CHECK_AND_SUB(AD);
    // CHECK_AND_SUB(AE);
    #undef CHECK_AND_SUB
    
    return x; // $ nonFunctionalNrOfBounds
}