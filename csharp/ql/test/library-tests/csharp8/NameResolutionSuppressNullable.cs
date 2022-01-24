using System;
using System.Collections.Generic;
using System.Threading;

class MyClass2
{
    private static WaitCallback? s_signalMethod;
    private static WaitCallback SignalMethod => EnsureInitialized(ref s_signalMethod, () => new WaitCallback(M1!));

    public static T EnsureInitialized<T>(ref T target, System.Func<T> valueFactory) where T : class { return target = valueFactory(); }

    static void M1(object state)
    {
    }
}
