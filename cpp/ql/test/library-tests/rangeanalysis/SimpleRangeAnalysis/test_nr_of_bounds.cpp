enum MY_ENUM {
    A = 0x1,
    B = 0x2,
    C = 0x4,
    D = 0x8,
    E = 0x10,
    F = 0x20,
    G = 0x40,
    H = 0x80,
    I = 0x100,
    J = 0x200,
    L = 0x400,
    M = 0x800,
    N = 0x1000,
    O = 0x2000,
    P = 0x4000,
    Q = 0x8000,
    R = 0x10000,
    S = 0x20000,
    T = 0x40000,
    U = 0x80000,
    V = 0x100000,
    W = 0x200000,
    X = 0x400000,
    Y = 0x800000,
    Z = 0x1000000,
    AA = 0x2000000,
    AB = 0x4000000,
    AC = 0x8000000,
    AD = 0x10000000,
    AE = 0x20000000
};

typedef unsigned int MY_ENUM_FLAGS;

MY_ENUM_FLAGS check_and_subs(MY_ENUM_FLAGS x)
{

    #define CHECK_AND_SUB(flag) if ((x & flag) == flag) { x -= flag; }
    CHECK_AND_SUB(A);
    CHECK_AND_SUB(B);
    CHECK_AND_SUB(C);
    CHECK_AND_SUB(D);
    CHECK_AND_SUB(E);
    CHECK_AND_SUB(F);
    CHECK_AND_SUB(G);
    CHECK_AND_SUB(H);
    CHECK_AND_SUB(I);
    CHECK_AND_SUB(J);
    CHECK_AND_SUB(L);
    CHECK_AND_SUB(M);
    CHECK_AND_SUB(N);
    CHECK_AND_SUB(O);
    CHECK_AND_SUB(P);
    CHECK_AND_SUB(Q);
    CHECK_AND_SUB(R);
    CHECK_AND_SUB(S);
    CHECK_AND_SUB(T);
    CHECK_AND_SUB(U);
    CHECK_AND_SUB(V);
    CHECK_AND_SUB(W);
    CHECK_AND_SUB(X);
    CHECK_AND_SUB(Y);
    CHECK_AND_SUB(Z);
    CHECK_AND_SUB(AA);
    CHECK_AND_SUB(AB);
    CHECK_AND_SUB(AC);
    CHECK_AND_SUB(AD);
    CHECK_AND_SUB(AE);
    #undef CHECK_AND_SUB
    
    return x;
}