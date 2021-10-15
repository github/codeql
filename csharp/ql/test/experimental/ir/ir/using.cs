using System;

class UsingStmt 
{
    public class MyDisposable : IDisposable
    {
        public MyDisposable() { }
        public void DoSomething() { }
        public void Dispose() { }
    }

    static void Main()
    {
        using (var o1 = new MyDisposable()) 
        {
            o1.DoSomething();
        }

        var o2 = new MyDisposable();
        using (o2)
        {
            o2.DoSomething();
        }

        using var o3 = new MyDisposable();
        o3.DoSomething();
    }
}
