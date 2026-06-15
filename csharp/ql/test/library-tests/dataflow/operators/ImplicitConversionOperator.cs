using System;

public class TestImplicitConversionOperator
{
    static void Sink(object o) { }
    static void TaintArgument(ArraySegment<byte> segment) { }

    public void M1()
    {
        byte[] bytes = new byte[1];
        TaintArgument(bytes);
        Sink(bytes);
    }
}
