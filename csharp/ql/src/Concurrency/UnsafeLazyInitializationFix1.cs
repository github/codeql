string name;

public string Name
{
    get
    {
        lock (mutex)    // GOOD: Thread-safe
        {
            if (name == null)
                name = LoadNameFromDatabase();
            return name;
        }
    }
}
