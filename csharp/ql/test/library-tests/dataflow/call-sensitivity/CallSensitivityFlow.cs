public class A
{
    public static void Sink(object o)
    {
    }

    public object FlowThrough(object o, bool cond)
    {
        if (cond)
        {
            return o;
        }
        else
        {
            return null;
        }
    }

    public void CallSinkIfTrue(object o, bool cond)
    {
        if (cond)
        {
            Sink(o);
        }
    }

    public void CallSinkIfFalse(object o, bool cond)
    {
        if (!cond)
        {
            Sink(o);
        }
    }

    public void CallSinkFromLoop(object o, bool cond)
    {
        while (cond)
        {
            Sink(o);
        }
    }

    public void LocalCallSensitivity(object o, bool c)
    {
        object o1 = o;
        object o2 = null;
        if (c)
        {
            object tmp = o1;
            o2 = 1 == 1 ? (tmp) : (tmp);
        }
        object o3 = o2;
        Sink(o3);
    }

    public void LocalCallSensitivity2(object o, bool b, bool c)
    {
        object o1 = o;
        object o2 = null;
        if (b || c)
        {
            object tmp = o1;
            o2 = 1 == 1 ? (tmp) : (tmp);
        }
        object o3 = o2;
        Sink(o3);
    }

    public void M1()
    {
        // should not exhibit flow
        CallSinkIfTrue(new object(), false);
        CallSinkIfFalse(new object(), true);
        CallSinkFromLoop(new object(), false);
        LocalCallSensitivity(new object(), false);
        Sink(FlowThrough(new object(), false));
        // should exhibit flow
        CallSinkIfTrue(new object(), true);
        CallSinkIfFalse(new object(), false);
        CallSinkFromLoop(new object(), true);
        LocalCallSensitivity(new object(), true);
        LocalCallSensitivity2(new object(), true, true);
        LocalCallSensitivity2(new object(), false, true);
        LocalCallSensitivity2(new object(), true, false);
        Sink(FlowThrough(new object(), true));
        // expected false positive
        LocalCallSensitivity2(new object(), false, false);
    }

    public void M2()
    {
        bool t = true;
        bool f = false;
        // should not exhibit flow
        CallSinkIfTrue(new object(), f);
        CallSinkIfFalse(new object(), t);
        CallSinkFromLoop(new object(), f);
        LocalCallSensitivity(new object(), f);
        Sink(FlowThrough(new object(), f));
        // should exhibit flow
        CallSinkIfTrue(new object(), t);
        CallSinkIfFalse(new object(), f);
        CallSinkFromLoop(new object(), t);
        LocalCallSensitivity(new object(), t);
        Sink(FlowThrough(new object(), t));
    }

    public void M3(InterfaceA b)
    {
        bool t = true;
        bool f = false;
        // should not exhibit flow
        b.CallSinkIfTrue(new object(), f);
        b.CallSinkIfFalse(new object(), t);
        b.LocalCallSensitivity(new object(), f);
        // should exhibit flow
        b.CallSinkIfTrue(new object(), t);
        b.CallSinkIfFalse(new object(), f);
        b.LocalCallSensitivity(new object(), t);
    }

    class B : InterfaceA
    {
        public void CallSinkIfTrue(object o, bool cond)
        {
            if (cond)
            {
                Sink(o);
            }
        }


        public void CallSinkIfFalse(object o, bool cond)
        {
            if (!cond)
            {
                Sink(o);
            }
        }


        public void LocalCallSensitivity(object o, bool c)
        {
            object o1 = o;
            object o2 = null;
            if (c)
            {
                object tmp = o1;
                o2 = 1 == 1 ? (tmp) : (tmp);
            }
            object o3 = o2;
            Sink(o3);
        }
    }
}

public class A2
{

    public static void Sink(object o)
    {
    }

    public void M()
    {

    }

    public void Callsite(InterfaceB intF)
    {
        B b = new B();
        // in both possible implementations of foo, this callsite is relevant
        // in IntA, it improves virtual dispatch,
        // and in IntB, it improves the dataflow analysis.
        intF.Foo(b, new object(), false);
    }

    private class B : A2
    {
        public void M()
        {

        }
    }

    private class IntA : InterfaceB
    {

        public void Foo(A2 obj, object o, bool cond)
        {
            obj.M();
            Sink(o);
        }
    }

    private class IntB : InterfaceB
    {

        public void Foo(A2 obj, object o, bool cond)
        {
            if (cond)
            {
                Sink(o);
            }
        }
    }

}

public interface InterfaceA
{
    void CallSinkIfTrue(object o, bool cond);
    void CallSinkIfFalse(object o, bool cond);
    void LocalCallSensitivity(object o, bool c);
}

public interface InterfaceB
{
    void Foo(A2 a, object o, bool cond);
}
