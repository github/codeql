public int ErrorCount
{
    get
    {
        return count;
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
