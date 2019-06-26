using System;
using System.Collections.Generic;

#nullable enable

class MyClass
{
    // Nullable fields
    MyClass? A;
    MyClass B;
    
    // Nullable properties
    MyClass? C => null;
    MyClass D => this;

    // Nullable indexers
    MyClass? this[int i] => null;
    MyClass this[string i] => this;
    MyClass this[MyClass? i] => this;

    // Nullable arrays
    MyClass?[] G1;
    MyClass?[]? G2;
    MyClass?[] G3;
    MyClass?[][] H;
    MyClass[]? ArrayFn1(MyClass[]?[] x) => throw null;
    MyClass?[] ArrayFn2(MyClass?[][] x) => throw null;
    
    // Methods
    MyClass? M() => null;
    MyClass N() => this;
    void O(MyClass a, MyClass?b) { }
    
    // Local variables
    void Locals()
    {
        MyClass a = new MyClass();
        MyClass? b = null;
        ref MyClass c = ref b;
        ref MyClass? d = ref b;
    }

    // Delegates
    delegate MyClass? Del1();

    // Events
    delegate MyClass? Del(MyClass x);
    event Del? P;
        
    // Nullable method type parameters
    object Q<T>(T t) where T: MyClass? => null;

    // Nullable type parameters
    class Generic<T1, T2, T3, T4> where T1: class? where T2: MyClass? where T3: class where T4: MyClass
    {
    }

    // Nullable type arguments
    Generic<MyClass?, MyClass, IDisposable, MyClass> items2;
    
    void GenericFn<T>(T x)
    {
    }

    MyStruct CallF()
    {
        MyClass? x = null;
        GenericFn(x);
        Q(x);
        return default(MyStruct);
    }
}

class NullableRefTypes
{
    void TestSuppressNullableWarningExpr()
    {
        string? x = "source";
        string y = x!;
        y = x!!;
        x = null;
        y = x!;
    }

    void FunctionInNullableContext()
    {
        string? x = "source";
        var y = x ?? null;
        string z = x;  // Warning
        Console.WriteLine(x);
    }
}

class RefTypes
{
    // Combination with other type annotations
    ref MyClass? ReturnsRef1(ref MyClass r) => ref r;
    ref MyClass ReturnsRef2(ref MyClass? r) => ref r;
    ref readonly MyClass? ReturnsRef3(in MyClass? r) => ref r;
    ref readonly MyClass? ReturnsRef4(in MyClass r) => ref r;
    ref readonly MyClass ReturnsRef5(in MyClass r) => ref r;
    ref readonly MyClass ReturnsRef6(in MyClass? r) => ref r;

    void Parameters1(ref MyClass p1, out MyClass? p2) => throw null;

    MyClass? Property;
    ref MyClass RefProperty => ref Property!;
}

class ToStringWithTypes
{
    MyStruct? a;
    MyStruct[]? b;
    MyStruct?[] c;
    MyStruct?[]? d;

    MyClass? e;
    MyClass?[] f;
    MyClass[]? g;
    MyClass?[]? h;

    MyClass[,,]?[,][] i;
    MyClass[,,][,][] j;
    MyClass[,,,][][,][,,] k;
    MyClass?[,,,][][,]?[,,] l;
}

#nullable disable

class ToStringWithTypes2
{
    MyStruct? a;
    MyStruct[]? b;
    MyStruct?[] c;
    MyStruct?[]? d;

    MyClass? e;
    MyClass?[] f;
    MyClass[]? g;
    MyClass?[]? h;

    MyClass[,,]?[,][] i;
    MyClass[,,][,][] j;
    MyClass[,,,][][,][,,] k;
    MyClass?[,,,][][,]?[,,] l;
}

class DisabledNullability
{
    MyClass f1;
    MyClass P => new MyClass();
    MyClass Fn(MyClass p)
    {
        MyClass a = p;
        return a;
    }
}

struct MyStruct
{
}
