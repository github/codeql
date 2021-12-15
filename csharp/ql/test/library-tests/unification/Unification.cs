interface I1 { }

struct S1 { }
struct S2 { }

class C0 { }
class C1<T1> { }
class C2<T2> : C1<T2>, I1 where T2 : struct { }
class C3<T3> where T3 : class { }
class C4<T4> where T4 : C1<C0> { }
class C5<T5> where T5 : C1<S1>, I1 { }
class C6<T6a, T6b, T6c, T6d> where T6a : C1<T6d> where T6b : T6a, I1 where T6c : C3<T6b> where T6d : struct { }

class ConstructSomeTypes
{
    C1<S1> f1;
    C2<S1> f2;
    C3<C1<S1>> f3;
    C3<C2<S1>> f4;
    C4<C1<C0>> f5;
    C5<C2<S1>> f6;
    C6<C1<S1>, C2<S1>, C3<C2<S1>>, S1> f7;

    void M<Tm>(C6<C2<S2>, Tm, C3<Tm>, S2> x, C6<C2<S2>, C2<S2>, C3<C2<S2>>, S2> y) where Tm : C2<S2> { }
}

class Tuples<T8, T9>
{
    static (T8, int) t1;
    static (string, int) t2;
    static (string, T9) t3;
    static (T8, T9) t4;
    static (T8 a, T9 b) t5 = t4;
}

class Nested<T10>
{
    class NestedA<T11> { }
    class NestedB
    {
        public class NestedC<T12> { }
    }

    Nested<int>.NestedA<string> x1;
    Nested<string>.NestedA<int> x2;
    Nested<int>.NestedB x3;
    Nested<string>.NestedB x4;
    Nested<int>.NestedB.NestedC<bool> x5;
    Nested<string>.NestedB.NestedC<decimal> x6;
}
