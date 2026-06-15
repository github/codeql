using System;
using System.Collections.Generic;

public class TestClass
{
    public void M1<T1>(T1 x) where T1 : class { }

    public void M2<T2>(T2 x) where T2 : struct { }

    public void M3<T3>(T3 x) where T3 : unmanaged { }

    public void M4<T4>(T4 x) where T4 : new() { }

    public void M5<T5>(T5 x) where T5 : notnull { }

    public void M6<T6>(T6 x) where T6 : IList<object> { }

    public void M7<T7>(T7 x) where T7 : allows ref struct { }
}
