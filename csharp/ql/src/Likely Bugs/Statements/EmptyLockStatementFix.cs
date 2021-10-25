class EmptyLockStatementFix
{
    private static Thread threadX;
    private static Thread threadY;
    private static int value;
    private static EventWaitHandle waitHandle = new AutoResetEvent(false);

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
        threadY.Start();
        value = 1;
        waitHandle.Set();
    }

    static void Y()
    {
        waitHandle.WaitOne();
        Console.WriteLine(value);
    }
}
