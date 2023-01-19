using System;

[assembly: MyGenericAttribute<int>()]
[module: MyGeneric2<object, object>()]

public class MyGenericAttribute<T> : Attribute { }
public class MyGeneric2Attribute<T, U> : Attribute { }

public class TestGenericAttribute
{

    [MyGenericAttribute<int>()]
    public void M1() { }

    [MyGeneric<string>()]
    public void M2() { }

    [MyGeneric2<int, string>()]
    public void M3() { }

    [return: MyGeneric<object>()]
    public int M4() { return 0; }
}