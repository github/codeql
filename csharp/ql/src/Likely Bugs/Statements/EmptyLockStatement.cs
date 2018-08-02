class EmptyLockStatement
{
    private static readonly object locker = new object();
    private static Thread threadX;
    private static Thread threadY;
    private static int value;

    static void Main(string[] args)
    {
        threadX = new Thread(X);
        threadY = new Thread(Y);
        threadX.Start();

        threadX.Join();
        while (threadY.ThreadState == ThreadState.Unstarted) ;
        threadY.Join();
    }

    static void X()
    {
        lock (locker)
        {
            threadY.Start();
            value = 1;
        }
    }

    static void Y()
    {
        lock (locker) { }
        Console.WriteLine(value);
    }
}
