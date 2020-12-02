int ParamsAndLocals(int x)
{
    int y;

    // y is an lvalue, as is the result of the assignment. x is a load.
    y = x + 1;

    // y is a load.
    return y;
}

int Dereference(int* p, int *q)
{
    // *p is an lvalue, as is the result of the assignment.
    // p, q, and *q are loads.
    *p = *q;

    int x = 5;

    // x is an lvalue.
    // *&x is a load.
    return *&x;
}

int& References(int& r)
{
    // The reference r is a load, as is the result of dereferencing the
    // reference r.
    int x = r;

    // The result of dereferencing the reference r is an lvalue.
    // The reference r is a load.
    int* p = &r;

    // The result of deferencing the reference r is an lvalue, as is the result
    // of the assignment.
    // The reference r is a load.
    r = 5;  

    // The result of dereferencing the reference r is an lvalue.
    // The reference r is a load.
    return r;
}

int&& GetRValueRef();
void CallRValueRef(int&& rr);

int&& RValueReferences(int&& rr)
{
    // The result of dereferencing the reference returned by GetRValueRef() is
    // an xvalue.
    CallRValueRef(GetRValueRef());

    // The result of dereferencing the reference rr is an lvalue, as is the
    // result of the assignment.
    // The reference rr is a load.
    rr = 5;

    // The result of the static cast is an xvalue. The result of dereferencing
    // the reference rr is an lvalue.
    // The reference rr is a load.
    return static_cast<int&&>(rr);
}

struct S 
{
    int MemberFunction();
};

int CallMemberFunction(S& s)
{
    // The result of dereferencing the reference s is an lvalue.
    // The reference s is a load.
    return s.MemberFunction();
}

int Func();
void AddressOfFunc()
{
    // Func is a load due to the function-to-function-pointer conversions.
    int (*p)() = Func;
}

struct T
{
    int x;
    int y;
    int MemberFunc(float);
};

void FieldAccesses()
{
    T t;
    // t, t.x, and the assignment are all lvalues.
    t.x = 0;
    // t is an lvalue.
    // t.x is a load.
    int a = t.x;
}

void StringLiterals()
{
    // All string literals are lvalues
    "String";
    const char* p = "String";
    const char (&a)[7] = "String";
    // The array access is a load
    char c = "String"[1];
}

void Crement()
{
    int x = 0;
    // x is an lvalue.
    x++;
    // x is an lvalue.
    x--;
    // x is an lvalue, as is the result of ++x.
    ++x;
    // x is an lvalue, as is the result of --x.
    --x;
}

void CompoundAssignment()
{
    int x = 0;

    // x is an lvalue, as is the result of x += 1
    x += 1;
    // x is an lvalue, as is the result of x -= 1
    x -= 1;
    // x is an lvalue, as is the result of x *= 1
    x *= 1;
    // x is an lvalue, as is the result of x /= 1
    x /= 1;
    // x is an lvalue, as is the result of x %= 1
    x %= 1;
    // x is an lvalue, as is the result of x <<= 1
    x <<= 1;
    // x is an lvalue, as is the result of x >>= 1
    x >>= 1;
    // x is an lvalue, as is the result of x |= 1
    x |= 1;
    // x is an lvalue, as is the result of x &= 1
    x &= 1;
    // x is an lvalue, as is the result of x ^= 1
    x ^= 1;
}

void PointerToMemberLiteral()
{
    // All pointer-to-member literals are prvalues
    int T::* pmd = &T::x;
    int (T::* pmf)(float) = &T::MemberFunc;
}
