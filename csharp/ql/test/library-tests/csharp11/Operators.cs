
public class MyClass
{
    public void M1()
    {
        var x1 = 1;
        var x2 = x1 >>> 2;

        var y1 = -2;
        var y2 = y1 >>> 3;

        var z = -4;
        z >>>= 5;
    }
}

public class MyOperatorClass
{
    public static MyOperatorClass operator >>>(MyOperatorClass a, MyOperatorClass b) { return null; }
}