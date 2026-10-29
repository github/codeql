string name;

public string Name
{
    get
    {
        // BAD: Not thread-safe
        if (name == null)
            name = LoadNameFromDatabase();
        return name;
    }
}
