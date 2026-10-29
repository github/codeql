volatile string name;    // GOOD: Thread-safe

public string Name
{
    get
    {
        if (name == null)
        {
            lock (mutex)
            {
                if (name == null)
                    name = LoadNameFromDatabase();
            }
        }
        return name;
    }
}
