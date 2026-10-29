public int ErrorCount
{
    get
    {
        lock (mutex)
        {
            return count;
        }
    }

    set
    {
        lock (mutex)
        {
            count = value;
            if (count > 0) GenerateDiagnostics();
        }
    }
}
