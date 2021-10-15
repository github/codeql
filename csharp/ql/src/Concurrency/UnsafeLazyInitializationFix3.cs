Lazy<string> name;    // GOOD: Thread-safe

public Person()
{
    name = new Lazy<string>(LoadNameFromDatabase);
}

public string Name => name.Value;
