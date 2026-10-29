class ThreadSafe
{
    private readonly Object mutex = new Object();

    int value = 0;

    public void Inc()
    {
        lock (mutex)   // Correct
        {
            ++value;
        }
    }
}
